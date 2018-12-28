//
//  MADecoder.m
//  PlayerTest
//
//  Created by 玉洋 on 2018/12/24.
//  Copyright © 2018 baiyang. All rights reserved.
//

#import "MADecoder.h"


@interface MADecoder ()
{
    NSLock* _lock;
    AVFormatContext   * _pFormatCtx;
    
    AVCodecContext    * _pVideoCodecCtx;
    AVCodecContext    * _pAudioCodecCtx;
    AVFrame           * _pYuv;
    AVFrame           * _pPcm;
    AVCodec           * _pVideoCodec; //视频解码器
    AVCodec           * _pAudioCodec; //音频解码器
    
}

@end

@implementation MADecoder

- (instancetype)init
{
    self = [super init];
    if (self) {
        _lock = [[NSLock alloc] init];
    }
    return self;
}

- (BOOL)openUrl:(NSString*)path error:(NSError**)error
{
    [_lock lock];
    
    char buf[1024] = {0};
    int16_t errorCode = 0;
    
    av_register_all();
    avformat_network_init();
    int re = avformat_open_input(&_pFormatCtx, [path UTF8String], 0, 0);
    if (re != 0)
    {
        errorCode = re;
        av_strerror(re, buf, sizeof(buf));
        printf("avformat open input error:%s", buf);
        goto error;
    }
    avformat_find_stream_info(_pFormatCtx, NULL);
    
    _duration = _pFormatCtx->duration;
    
    uint64_t min = _duration/60/AV_TIME_BASE;
    uint64_t secondBase = _duration%(AV_TIME_BASE*60);
    uint64_t second = ceil(secondBase*1.0/AV_TIME_BASE);
    
    NSLog(@"视频时长:%llu:%.2llu", min, second);
    
    for (int i = 0; i < _pFormatCtx->nb_streams; i ++) {
        AVStream* stream = _pFormatCtx->streams[i];
        AVCodec* codec = avcodec_find_decoder(stream->codecpar->codec_id);
        AVCodecContext* codecCtx = avcodec_alloc_context3(codec);
        avcodec_parameters_to_context(codecCtx, stream->codecpar);
        
        if (codecCtx->codec_type == AVMEDIA_TYPE_VIDEO)
        {
            _videoStreamIndex = i;
            _pVideoCodec = codec;
            _pVideoCodecCtx = codecCtx;
            int err = avcodec_open2(_pVideoCodecCtx, _pVideoCodec, NULL);
            if (err != 0) {
                errorCode = err;
                av_strerror(err, buf, sizeof(buf));
                NSLog(@"open videoCodec error:%s", buf);
                goto error;
            }
        }
        if (codecCtx->codec_type == AVMEDIA_TYPE_AUDIO)
        {
            _audioStreamIndex = i;
            _pAudioCodec = codec;
            _pAudioCodecCtx = codecCtx;
            int err = avcodec_open2(_pAudioCodecCtx, _pAudioCodec, NULL);
            if (err != 0) {
                errorCode = err;
                av_strerror(err, buf, sizeof(buf));
                NSLog(@"open aideoCodec error:%s", buf);
                goto error;
            }
            
            _audioSampleRate = _pAudioCodecCtx->sample_rate;
            _audioChannels = _pAudioCodecCtx->channels;
//            _audioSampleSize = _pAudioCodecCtx->sample_s
            
            NSLog(@"mayinglun log: sample_rate:%d", _audioSampleRate);
            NSLog(@"mayinglun log: sample_rate:%d", _audioChannels);
        }
        
    }

    [_lock unlock];
    return YES;
    
    error:
    {
        NSString* errorDescription = [NSString stringWithUTF8String:buf];
        NSError* err = [NSError errorWithDomain:errorDescription code:errorCode userInfo:nil];
        *error = err;
        [_lock unlock];
        return NO;
    }
}

- (void)read:(MAPacket*)pkt error:(NSError**)error
{
    av_packet_unref(pkt.packet);
    if (!_pFormatCtx) {
        return;
    }
    int err = av_read_frame(_pFormatCtx, pkt.packet);
//    if (err != 0)
//    {
//        NSLog(@"1");
////        av_strerror(err, , <#size_t errbuf_size#>)
//    } else {
//        NSLog(@"==============data===============");
//        NSLog(@"%d", pkt.packet->size);
//    }
}

- (NSArray*)decodeYUV:(MAPacket*)pkt
{
    if (_pFormatCtx && pkt.packet->stream_index == _videoStreamIndex)
    {
        int re = avcodec_send_packet(_pVideoCodecCtx, pkt.packet);
        if (re != 0) {
            return nil;
        }
        NSMutableArray* frames = [NSMutableArray array];
        while (re == 0) {
            MAFrame* frame = [[MAFrame alloc] init];
            re = avcodec_receive_frame(_pVideoCodecCtx, frame.frame);
            if (re == 0) {
                [frames addObject:frame];
                
//                if (!frame.frame || frame.frame->linesize[0] <= 0)
//                {
//                    NSLog(@"mayinglun log: frame 解析失败");
//                } else {
//                    NSLog(@"mayinglun log: frame 解析成功");
//                }
                
            }
        }
        return [frames copy];
    }
    return nil;
}

- (NSArray*)decodePCM:(MAPacket*)pkt
{
    if (_pFormatCtx && pkt.packet->stream_index == _audioStreamIndex)
    {
        int re = avcodec_send_packet(_pAudioCodecCtx, pkt.packet);
        if (re != 0) {
            return nil;
        }
        NSMutableArray* frames = [NSMutableArray array];
        while (re == 0) {
            MAFrame* frame = [[MAFrame alloc] init];
            re = avcodec_receive_frame(_pAudioCodecCtx, frame.frame);
            if (re == 0) {
                [frames addObject:frame];
            }
        }
        return [frames copy];
    }
    return nil;
}

//- (NSArray*)decode:(MAPacket*)pkt
//{
//    if (!_pFormatCtx) {
//        return nil;
//    }
//    if (_pYuv == NULL) {
//        _pYuv = av_frame_alloc();
//    }
//    if (_pPcm == NULL) {
//        _pPcm = av_frame_alloc();
//    }
//    AVCodecContext* pCodecCtx = NULL;
//    AVFrame* tempFrame = NULL;
//    if (pkt.packet->stream_index == _videoStreamIndex) {
//        pCodecCtx = _pVideoCodecCtx;
//        tempFrame = _pYuv;
//    }
//    if (pkt.packet->stream_index == _audioStreamIndex) {
//        pCodecCtx = _pAudioCodecCtx;
//        tempFrame = _pPcm;
//    }
//    if (!pCodecCtx) {
//        return nil;
//    }
//    int re = avcodec_send_packet(pCodecCtx, pkt.packet);
//    if (re != 0) {
//        return nil;
//    }
////    NSMutableArray*
////    while (re != 0) {
////        re = avcodec_receive_frame(pCodecCtx, tempFrame);
////    }
//
//    return nil;
//}

- (MAYUVFrame*)yuvToGlData:(MAFrame*)frame
{
    if (!_pFormatCtx || !frame.frame || frame.frame->linesize[0] <= 0 || frame.frame->width <= 0 || frame.frame->height <= 0) {
        return nil;
    }
    
    MAYUVFrame* yuvFrame = [[MAYUVFrame alloc] init];
    
    //把数据重新封装成opengl需要的格式
    AVFrame* pYuv = frame.frame;
    unsigned int lumaLength= (pYuv->height)*(MIN(pYuv->linesize[0], pYuv->width));
    unsigned int chromBLength=((pYuv->height)/2)*(MIN(pYuv->linesize[1], (pYuv->width)/2));
    unsigned int chromRLength=((pYuv->height)/2)*(MIN(pYuv->linesize[2], (pYuv->width)/2));
    
    yuvFrame.width = pYuv->width;
    yuvFrame.height = pYuv->height;
    
    unsigned char* luma = malloc(lumaLength);
    unsigned char* chromaB = malloc(chromBLength);
    unsigned char* chromaR = malloc(chromRLength);

    //复制
    copyDecodedFrame(pYuv->data[0],luma,pYuv->linesize[0],
                     pYuv->width,pYuv->height);
    copyDecodedFrame(pYuv->data[1], chromaB, pYuv->linesize[1],
                     pYuv->width / 2,pYuv->height / 2);
    copyDecodedFrame(pYuv->data[2], chromaR, pYuv->linesize[2],
                     pYuv->width / 2,pYuv->height / 2);
    
    yuvFrame.luma = [NSData dataWithBytes:luma length:lumaLength];
    yuvFrame.chromaB = [NSData dataWithBytes:chromaB length:chromBLength];
    yuvFrame.chromaR = [NSData dataWithBytes:chromaR length:chromRLength];
    
    free(luma);
    free(chromaB);
    free(chromaR);
    
    return yuvFrame;
    
}

static void copyDecodedFrame(unsigned char *src, unsigned char *dist,int linesize, int width, int height)
{
    width = MIN(linesize, width);
    if (sizeof(dist) == 0) {
        return;
    }
    for (NSUInteger i = 0; i < height; ++i) {
        memcpy(dist, src, width);
        dist += width;
        src += linesize;
    }
}

@end
