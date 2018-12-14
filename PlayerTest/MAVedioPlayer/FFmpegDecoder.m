//
//  FFmpegDecoder.m
//  PlayerTest
//
//  Created by 玉洋 on 2018/12/13.
//  Copyright © 2018 baiyang. All rights reserved.
//

#import "FFmpegDecoder.h"

//定义音频重采样后的参数
#define SAMPLE_SIZE 16
#define SAMPLE_RATE 44100
#define CHANNEL     2

@implementation FFmpegDecoder
{
    char errorBuf[1024];
    NSLock   *lock;
    AVFormatContext   * pFormatCtx;
    AVCodecContext    * pVideoCodecCtx;
    AVCodecContext    * pAudioCodecCtx;
    AVFrame           * pYuv;
    AVFrame           * pPcm;
    AVCodec           * pVideoCodec; //视频解码器
    AVCodec           * pAudioCodec; //音频解码器
    struct SwsContext * pSwsCtx;
    SwrContext        * pSwrCtx;
    char              * rgb;
    UIImage           * tempImage;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initParam];
    }
    return self;
}

- (void)initParam
{
    av_register_all();
    avformat_network_init();
    _pcmDataLength = 0;
    _sampleRate = SAMPLE_RATE;
    _sampleSize = SAMPLE_SIZE;
    _channel = CHANNEL;
    lock = [[NSLock alloc]init];
}

- (double)r2d:(AVRational)r
{
    return r.num == 0 || r.den == 0 ? 0.0 : (double)r.num/(double)r.den;
}

//- (BOOL)OpenUrl:(const char *)path
//{
//    [self Close];
//    [lock lock];
//    int re = avformat_open_input(&pFormatCtx, path, 0, 0);
//    if (re != 0)
//    {
//        [lock unlock];
//        av_strerror(re, errorBuf, sizeof(errorBuf));
//        return false;
//    }
//    _totalMs = (int)(pFormatCtx->duration/AV_TIME_BASE)*1000;
//    avformat_find_stream_info(pFormatCtx, NULL);
//    
//    for (int i = 0; i < pFormatCtx->nb_streams; i ++) {
//        AVStream* stream = pFormatCtx->streams[i];
//        AVCodec* codec = avcodec_find_decoder(stream->codecpar->codec_id);
//        AVCodecContext* codecCtx = avcodec_alloc_context3(codec);
//        avcodec_parameters_to_context(codecCtx, stream->codecpar);
//        
//        if (codecCtx->codec_type == AVMEDIA_TYPE_VIDEO)
//        {
//            printf("video\n");
//            _videoStreamIndex = i;
//            pVideoCodec = codec;
//            pVideoCodecCtx = codecCtx;
//            int err = avcodec_open2(pVideoCodecCtx, pVideoCodec, NULL);
//            if (err != 0)
//            {
//                [lock unlock];
//                
//            }
//        }
//        
//    }
//}

@end
