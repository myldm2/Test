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

- (BOOL)OpenUrl:(const char *)path
{
    [self Close];
    
}

@end
