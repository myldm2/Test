//
//  MADecoder.m
//  PlayerTest
//
//  Created by 玉洋 on 2018/12/24.
//  Copyright © 2018 baiyang. All rights reserved.
//

#import "MADecoder.h"
#import "avcodec.h"
#import "swscale.h"
#import "avformat.h"
#import "swresample.h"
#import "samplefmt.h"
#import "YUV_GL_DATA.h"

@interface MADecoder ()
{
    NSLock* _lock;
    AVFormatContext   * _pFormatCtx;
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

- (BOOL)openUrl:(const char*)path
{
    [_lock lock];
    av_register_all();
    avformat_network_init();
    int re = avformat_open_input(&_pFormatCtx, path, 0, 0);
    if (re != 0)
    {
        goto error;
    }
    avformat_find_stream_info(_pFormatCtx, NULL);
    
    _duration = _pFormatCtx->duration;
    
    uint64_t min = _duration/60/AV_TIME_BASE;
    uint64_t secondBase = _duration%(AV_TIME_BASE*60);
    uint64_t second = ceil(secondBase*1.0/AV_TIME_BASE);
    
    NSLog(@"视频时长:%d:%.2d", min, second);
    
    for (int i = 0; i < _pFormatCtx->nb_streams; i ++) {
        AVStream* stream = _pFormatCtx->streams[i];
        AVCodec* codec = avcodec_find_decoder(stream->codecpar->codec_id);
        AVCodecContext* codecCtx = avcodec_alloc_context3(codec);
        avcodec_parameters_to_context(codecCtx, stream->codecpar);
        
        if (codecCtx->codec_type == AVMEDIA_TYPE_VIDEO)
        {
            
        }
        
    }
    
    
    
    error:
    [_lock unlock];
    return false;
}

@end
