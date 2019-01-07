//
//  MAVedioPlayer.m
//  PlayerTest
//
//  Created by 玉洋 on 2018/12/26.
//  Copyright © 2018 baiyang. All rights reserved.
//

#import "MAVedioPlayer.h"
#import "MADecoder.h"
#import <UIKit/UIKit.h>
#import "avcodec.h"
#import "swscale.h"
#import "avformat.h"
#import "swresample.h"
#import "samplefmt.h"
#import "YUV_GL_DATA.h"
#import "MAPacket.h"
#import "MAOpenglView.h"
#import "MADecodeOperation.h"
#import "MATimer.h"

@interface MAVedioPlayer ()
{
    MAOpenglView* _gl;
    uint64_t _timeIndex;
}

@property (nonatomic, strong) MADecoder* decoder;
@property (nonatomic, strong) NSLock* lock;
@property (nonatomic, assign) BOOL isExit;
@property (nonatomic, strong) NSMutableArray* packetBuffer;

@property (nonatomic, strong) MADecodeOperation* decodeOperation;
@property (nonatomic, strong) NSOperationQueue* decodeQueue;

@property (nonatomic, strong) CADisplayLink* displayLink;
@property (nonatomic, strong) MATimer* timer;



@end

@implementation MAVedioPlayer

+ (instancetype)sharedPlayer
{
    static dispatch_once_t onceToken;
    static MAVedioPlayer *plyer = nil;
    dispatch_once(&onceToken, ^{
        plyer = [[MAVedioPlayer alloc] init];
    });
    return plyer;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _lock = [[NSLock alloc] init];
        _packetBuffer = [NSMutableArray array];
        _decodeQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (int)openUrl:(NSString*)url playerView:(UIView*)view
{
    int ret = 0;
    
    _gl = [[MAOpenglView alloc]initWithFrame:view.frame];
    if (!_gl) {
        NSLog(@"init gl fail...");
        return NO;
    }
    [_gl setVideoSize:view.frame.size.width height:view.frame.size.height];
    [view addSubview:_gl];
    
    if (!_decoder) {
        _decoder = [[MADecoder alloc] init];
    }
    
    NSError* error;
    if (![_decoder openUrl:url error:&error])
    {
        ret = -1;
    }
    return ret;
}

- (void)play
{
//    [self startPlayThread];

    [self startDecodeQueue];
    
//    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayAction:)];
//    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    _timer = [[MATimer alloc] init];
    [_timer fire];
    
    
    [NSTimer scheduledTimerWithTimeInterval:0.01 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self startPlayThread];
    }];
}

- (void)startDecodeQueue
{
    if (!_decodeOperation)
    {
        _decodeOperation = [[MADecodeOperation alloc] initWithDecoder: _decoder];
    }
    if (!_decodeQueue)
    {
        _decodeQueue = [[NSOperationQueue alloc] init];
    }
    [_decodeQueue addOperation:_decodeOperation];
}


- (void)startPlayThread
{
    
    MAYUVFrame* yuvFrame = [_decodeOperation.yuvFrameBuffer pop];
    if (yuvFrame) {
        [_gl displayYUV420pData:yuvFrame];
    }
    
    
//    MAPacket* packet = packet = [[MAPacket alloc] init];
//
//    if ([_decoder read:packet])
//    {
//        if (packet) {
//            if (packet.packet->stream_index == _decoder.videoStreamIndex)
//            {
//                NSArray* frames = [_decoder decodeYUV:packet];
//                if (frames.count > 0)
//                {
//                    MAYUVFrame* yuvFrame = [_decoder yuvToGlData:frames[0]];
//                    [_gl displayYUV420pData:yuvFrame];
//                }
//
//            }
//        }
//    }
    
    
    

    
    
//    dispatch_queue_t readQueue = dispatch_queue_create("ReadQueue.MAPlayer.com", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_async(readQueue, ^{
//        MAPacket* pkt = nil;
//        while (!_isExit) {
//            [_lock lock];
//            pkt = [[MAPacket alloc] init];
//            [_decoder read:pkt error:NULL];
//            [_packetBuffer addObject:pkt];
//            [_lock unlock];
//
//            if (pkt.packet == NULL) {
//                [NSThread sleepForTimeInterval:0.01];
//                continue;
//            }
//            if (pkt.packet->size <= 0) {
//                [NSThread sleepForTimeInterval:0.01];
//                continue;
//            }
//
//        }
//    });
//
//    dispatch_queue_t playQueue = dispatch_queue_create("PlayQueue.MAPlayer.com", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_async(playQueue, ^{
//
//        while (!_isExit) {
//            if (_packetBuffer.count == 0) {
//                [NSThread sleepForTimeInterval:0.01];
//                NSLog(@"0000000000000000000000");
//                continue;
//            }
//
//            MAYUVFrame* yuvFrame = nil;
//
//            [_lock lock];
//            MAPacket * packet = [_packetBuffer lastObject];
//            [_packetBuffer removeLastObject];
//            if (packet) {
//                if (packet.packet->stream_index == _decoder.videoStreamIndex)
//                {
//                    NSArray* frames = [_decoder decodeYUV:packet];
//                    if (frames.count > 0)
//                    {
//                        yuvFrame = [_decoder yuvToGlData:frames[0]];
////                        if (yuvFrame.width == 0) {
////
////                            continue;
////                        }
//                    }
//
//                }
//            }
//            [_lock unlock];
//
//
//
//            if (yuvFrame)
//            {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    // [self.imageView setImage:image];
//                    // playView.backgroundColor = color;
//                    [gl displayYUV420pData:yuvFrame];
////                    free(yuvFrame.luma.dataBuffer);
////                    free(yuvFrame.chromaB.dataBuffer);
////                    free(yuvFrame.chromaR.dataBuffer);
//
//                });
//                break;
//            }
//
//
//        }
//    });
}

- (void)displayAction:(CADisplayLink*)displayLink
{
    ino64_t timeInterval = AV_TIME_BASE / 60;
    _timeIndex += timeInterval;
    
}

- (void)stop
{
    [_decodeOperation cancel];
    _decodeOperation = nil;
    _decodeQueue = nil;
    _decoder = nil;
}

@end
