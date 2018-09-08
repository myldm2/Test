//
//  MovieObject.m
//  PlayerTest
//
//  Created by baiyang on 2018/2/27.
//  Copyright © 2018年 baiyang. All rights reserved.
//

#import "MovieObject.h"
#include <libavcodec/avcodec.h>
#include <libavformat/avformat.h>
#include <libswscale/swscale.h>

@interface MovieObject ()

@property (nonatomic, copy) NSString *cruutenPath;

@end

@implementation MovieObject
{
    AVFormatContext     *_formatCtx;
    AVCodecContext      *_codecCtx;
    AVFrame             *_frame;
    AVStream            *_stream;
    AVPacket            _packet;
    AVPicture           _picture;
    int                 _videoStream;
    double              _fps;
    BOOL                _isReleaseResources;
}

- (instancetype)initWithVideo:(NSString *)moviePath {
    
    if (!(self=[super init])) return nil;
    if ([self initializeResources:[moviePath UTF8String]]) {
        self.cruutenPath = [moviePath copy];
        return self;
    } else {
        return nil;
    }
}

- (BOOL)initializeResources:(const char *)filePath {
    _isReleaseResources = NO;
    AVCodec* pCodec;
    // 注册所有解码器
    avcodec_register_all();
    av_register_all();
    avformat_network_init();
    //打开视频文件
    if (avformat_open_input(&_formatCtx, filePath, NULL, NULL) != 0) {
        NSLog(@"打开文件失败");
        goto initError;
    }
    //检查数据流
    if (avformat_find_stream_info(_formatCtx, NULL) < 0)
    {
        NSLog(@"检查数据流失败");
        goto initError;
    }
    //根据数据流，找到第一个视频流
    _videoStream = av_find_best_stream(_formatCtx, AVMEDIA_TYPE_VIDEO, -1, -1, &pCodec, 0);
    if (_videoStream < 0)
    {
        NSLog(@"没有找到第一个视频流");
        goto initError;
    }
    //获取视频流的编解码上下文的指针
    _stream = _formatCtx->streams[_videoStream];
    _codecCtx = _stream->codec;
#if DEBUG
    //打印视频流的详细信息
    av_dump_format(_formatCtx, _videoStream, filePath, 0);
#endif
    if (_stream->avg_frame_rate.den && _stream->avg_frame_rate.num) {
        _fps = av_q2d(_stream->avg_frame_rate);
    } else
    {
        _fps = 30;
    }
    //查找解码器
    pCodec = avcodec_find_decoder(_codecCtx->codec_id);
    if (pCodec == NULL)
    {
        NSLog(@"没有找到解码器");
        goto initError;
    }
    //打开解码器
    if (avcodec_open2(_codecCtx, pCodec, NULL) < 0) {
        NSLog(@"打开解码器失败");
        goto initError;
    }
    //分配视频帧
    _frame = av_frame_alloc();
    _outputWidth = _codecCtx->width;
    _outputHeight = _codecCtx->height;
    
    return YES;
initError:
    return NO;
}

- (void)seekTime:(double)seconds
{
    AVRational timeBase = _formatCtx->streams[_videoStream]->time_base;
    int64_t targetFrame = (int64_t)(timeBase.den / timeBase.num * seconds);
    avformat_seek_file(_formatCtx, _videoStream, 0, targetFrame, targetFrame, AVSEEK_FLAG_FRAME);
    avcodec_flush_buffers(_codecCtx);
}

- (BOOL)stepFrame
{
    int frameFinished = 0;
    while (!frameFinished && av_read_frame(_formatCtx, &_packet) >= 0) {
        if (_packet.stream_index == _videoStream) {
            avcodec_decode_video2(_codecCtx, _frame, &frameFinished, &_packet);
        }
    }
    if (frameFinished == 0 && _isReleaseResources == NO) {
        [self releaseResources];
    }
    return frameFinished != 0;
}

- (void)replaceTheResources:(NSString *)moviePath
{
    if (!_isReleaseResources) {
        [self releaseResources];
    }
    self.cruutenPath = [moviePath copy];
    [self initializeResources:[self.cruutenPath UTF8String]];
}

- (void)redialPaly {
    [self initializeResources:[self.cruutenPath UTF8String]];
}
#pragma mark ------------------------------------
#pragma mark  重写属性访问方法
-(void)setOutputWidth:(int)newValue {
    if (_outputWidth == newValue) return;
    _outputWidth = newValue;
}
-(void)setOutputHeight:(int)newValue {
    if (_outputHeight == newValue) return;
    _outputHeight = newValue;
}
-(UIImage *)currentImage {
    if (!_frame->data[0]) return nil;
    return [self imageFromAVPicture:nil width:nil height:nil];
}
-(double)duration {
    return (double)_formatCtx->duration / AV_TIME_BASE;
}
- (double)currentTime {
    AVRational timeBase = _formatCtx->streams[_videoStream]->time_base;
    return _packet.pts * (double)timeBase.num / timeBase.den;
}
- (int)sourceWidth {
    return _codecCtx->width;
}
- (int)sourceHeight {
    return _codecCtx->height;
}
#pragma mark --------------------------
#pragma mark - 内部方法
- (UIImage *)imageFromAVPicture:(NSData**)outData width:(GLsizei*)width height:(GLsizei*)height
{
    avpicture_free(&_picture);
    avpicture_alloc(&_picture, AV_PIX_FMT_RGB24, _outputWidth, _outputHeight);
    struct SwsContext * imgConvertCtx = sws_getContext(_frame->width,
                                                       _frame->height,
                                                       AV_PIX_FMT_YUV420P,
                                                       _outputWidth,
                                                       _outputHeight,
                                                       AV_PIX_FMT_RGB24,
                                                       SWS_FAST_BILINEAR,
                                                       NULL,
                                                       NULL,
                                                       NULL);
    if(imgConvertCtx == nil) return nil;
    sws_scale(imgConvertCtx,
              _frame->data,
              _frame->linesize,
              0,
              _frame->height,
              _picture.data,
              _picture.linesize);
    sws_freeContext(imgConvertCtx);
    
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CFDataRef data = CFDataCreate(kCFAllocatorDefault,
                                  _picture.data[0],
                                  _picture.linesize[0] * _outputHeight);
    
    NSData *my_nsdata = (__bridge NSData*)data;
    *outData = my_nsdata;
    *width = _outputWidth;
    *height = _outputHeight;
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData(data);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGImageRef cgImage = CGImageCreate(_outputWidth,
                                       _outputHeight,
                                       8,
                                       24,
                                       _picture.linesize[0],
                                       colorSpace,
                                       bitmapInfo,
                                       provider,
                                       NULL,
                                       NO,
                                       kCGRenderingIntentDefault);
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    CGColorSpaceRelease(colorSpace);
    CGDataProviderRelease(provider);
    CFRelease(data);
    
    return image;
}

#pragma mark --------------------------
#pragma mark - 释放资源
- (void)releaseResources {
    NSLog(@"释放资源");
    //    SJLogFunc
    _isReleaseResources = YES;
    // 释放RGB
    avpicture_free(&_picture);
    // 释放frame
    av_packet_unref(&_packet);
    // 释放YUV frame
    av_free(_frame);
    // 关闭解码器
    if (_codecCtx) avcodec_close(_codecCtx);
    // 关闭文件
    if (_formatCtx) avformat_close_input(&_formatCtx);
    avformat_network_deinit();
    
    _formatCtx = nil;
    _codecCtx = nil;
}

@end
