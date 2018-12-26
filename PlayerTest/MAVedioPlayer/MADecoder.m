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

- (void)read:(AVPacket*)pkt error:(NSError**)error
{
    av_packet_unref(pkt);
    if (!_pFormatCtx) {
        return;
    }
    int err = av_read_frame(_pFormatCtx, pkt);
    if (err != 0)
    {
        NSLog(@"1");
//        av_strerror(err, , <#size_t errbuf_size#>)
    } else {
        NSLog(@"2");
    }
}

@end
