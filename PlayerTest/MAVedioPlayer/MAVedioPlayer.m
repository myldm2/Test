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
#import "MAFrameBuffer.h"
#import "MAOpenalPlayer.h"
#import "MAVedioPlayOperation.h"

@interface MAVedioPlayer () <MATimerDelegate, MADecodeOperationDelegate>
{
    MAOpenglView* _gl;
    uint64_t _timeIndex;
}

@property (nonatomic, strong) MADecoder* decoder;
@property (nonatomic, strong) NSLock* lock;
@property (nonatomic, assign) BOOL isExit;

@property (nonatomic, strong) MADecodeOperation* decodeOperation;
@property (nonatomic, strong) NSOperationQueue* decodeQueue;

@property (nonatomic, strong) MAVedioPlayOperation* playOperation;
@property (nonatomic, strong) NSOperationQueue* playQueue;

@property (nonatomic, strong) CADisplayLink* displayLink;
@property (nonatomic, strong) MATimer* timer;
@property (nonatomic, strong) MAFrameBuffer* yuvFrameBuffer;
@property (nonatomic, strong) MAFrameBuffer* pcmFrameBuffer;
@property (nonatomic, strong) MAOpenalPlayer* audioPlayer;



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
        _decodeQueue = [[NSOperationQueue alloc] init];
        _yuvFrameBuffer = [[MAFrameBuffer alloc] initWithMultithreadProtection:YES];
        _pcmFrameBuffer = [[MAFrameBuffer alloc] initWithMultithreadProtection:YES];
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
    
     _decoder = [[MADecoder alloc] init];
    
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
    
    if (!_audioPlayer)
    {
        _audioPlayer = [[MAOpenalPlayer alloc]init];
        [_audioPlayer initOpenAL];
//        [_audioPlayer playSound];
    }
    

    [self startDecodeQueue];
    
//    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayAction:)];
//    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
//    if (!_timer)
//    {
//        _timer = [[MATimer alloc] init];
//        _timer.delegate = self;
//    }
//
//
//    [_timer play];
    
    
//    [NSTimer scheduledTimerWithTimeInterval:0.01 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        [self startPlayThread];
//    }];
    
    [self startPlayThread];
}

- (void)startDecodeQueue
{
    if (!_decodeOperation)
    {
        _decodeOperation = [[MADecodeOperation alloc] initWithDecoder: _decoder];
        _decodeOperation.delegate = self;
    }
    if (!_decodeQueue)
    {
        _decodeQueue = [[NSOperationQueue alloc] init];
    }
    [_decodeQueue addOperation:_decodeOperation];
}


- (void)startPlayThread
{
//    MAYUVFrame* yuvFrame = (MAYUVFrame*)[_decodeOperation.yuvFrameBuffer pop];
//    if (yuvFrame) {
//        [_gl displayYUV420pData:yuvFrame];
//    }
    
    if (!_playOperation)
    {
        _playOperation = [[MAVedioPlayOperation alloc] initWithYUVBuffer:_yuvFrameBuffer PCMBuffer:_pcmFrameBuffer glView:_gl alPlayer:_audioPlayer];
    }
    if (!_playQueue)
    {
        _playQueue = [[NSOperationQueue alloc] init];
    }
    [_playQueue addOperation:_playOperation];
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
    
    [_audioPlayer stopSound];
    [_audioPlayer cleanUpOpenAL];
    _audioPlayer = nil;
}

- (BOOL)timerBetween:(uint64_t)time1 and:(uint64_t)time2
{
//    static uint64_t frame = 0;
//    frame ++ ;
//    NSLog(@"mayinglun log: pts:%llu  second:%f  frame:%lld", time2, time2 * 1.0 / AV_TIME_BASE, frame);
    
    BOOL success = NO;
    
//    MAYUVFrame* yuvLastFrame = (MAYUVFrame*)[_yuvFrameBuffer lastFrame];
//    MAPCMFrame* pcmLastFrame = (MAPCMFrame*)[_pcmFrameBuffer lastFrame];
//
//    if ((yuvLastFrame.presentTime > pcmLastFrame.presentTime - 900)&& pcmLastFrame.presentTime > 500) {
//        return success;
//    }
    
//    MAYUVFrame* yuvFirstFrame = (MAYUVFrame*)[_yuvFrameBuffer fristFrame];
//    MAPCMFrame* pcmFirstFrame = (MAPCMFrame*)[_pcmFrameBuffer fristFrame];
//    while (yuvFirstFrame && pcmFirstFrame) {
//        if (yuvFirstFrame.presentTime >= time2) {
//            success = YES;
//            break;
//        } else if (yuvFirstFrame.presentTime < time1) {
//            [_yuvFrameBuffer pop];
//            yuvFirstFrame = (MAYUVFrame*)_yuvFrameBuffer.fristFrame;
//            continue;
//        } else {
//            MAYUVFrame* yuvFrame = (MAYUVFrame*)[_yuvFrameBuffer pop];
//            if (yuvFrame) {
//                [_gl displayYUV420pData:yuvFrame];
//                yuvFirstFrame = (MAYUVFrame*)[_yuvFrameBuffer fristFrame];
//                success = YES;
//            }
//        }
//    }
    
//    if (_audioPlayer.m_numqueued > 10 && _audioPlayer.m_numqueued < 35) {
//        return NO;
//    }else
//
//    MAPCMFrame* pcmFirstFrame = (MAPCMFrame*)[_pcmFrameBuffer fristFrame];
//    while (pcmFirstFrame) {
//        pcmFirstFrame = (MAPCMFrame*)[_pcmFrameBuffer pop];
//        [_audioPlayer playFrame:pcmFirstFrame];
//        pcmFirstFrame = (MAPCMFrame*)[_pcmFrameBuffer fristFrame];
//        success = YES;
//    }
    
    NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    
    MAYUVFrame* yuvFirstFrame = (MAYUVFrame*)[_yuvFrameBuffer fristFrame];
    while (yuvFirstFrame) {
        if (yuvFirstFrame.presentTime >= time2) {
            success = YES;
            break;
        } else if (yuvFirstFrame.presentTime < time1) {
            [_yuvFrameBuffer pop];
            yuvFirstFrame = (MAYUVFrame*)_yuvFrameBuffer.fristFrame;
            continue;
        } else {
            MAYUVFrame* yuvFrame = (MAYUVFrame*)[_yuvFrameBuffer pop];
            if (yuvFrame) {
                NSLog(@"vedio:%llu", yuvFrame.presentTime);
                [_gl displayYUV420pData:yuvFrame];
                yuvFirstFrame = (MAYUVFrame*)[_yuvFrameBuffer fristFrame];
                success = YES;
            }
        }
    }
    
    MAPCMFrame* pcmFirstFrame = (MAPCMFrame*)[_pcmFrameBuffer fristFrame];
    while (pcmFirstFrame && [_audioPlayer m_numqueue] < 15)
    {
        if (pcmFirstFrame.presentTime >= time1) {
            MAPCMFrame* pcmFrame = (MAPCMFrame*)[_pcmFrameBuffer pop];
            if (pcmFrame) {
                NSLog(@"audio:%llu", pcmFrame.presentTime);
                [_audioPlayer playFrame:pcmFrame];
                pcmFirstFrame = (MAPCMFrame*)[_pcmFrameBuffer fristFrame];
                success = YES;
            }
        }
    }
    
    
//    time2 = time2 + 4 * AV_TIME_BASE;
//    MAPCMFrame* pcmFirstFrame = (MAPCMFrame*)[_pcmFrameBuffer fristFrame];
//    while (pcmFirstFrame) {
//        if (pcmFirstFrame.presentTime >= time2) {
//            success = YES;
//            break;
//        } else if (pcmFirstFrame.presentTime < time1) {
//            [_pcmFrameBuffer pop];
//            pcmFirstFrame = (MAPCMFrame*)_pcmFrameBuffer.fristFrame;
//            continue;
//        } else {
//            MAPCMFrame* pcmFrame = (MAPCMFrame*)[_pcmFrameBuffer pop];
//            if (pcmFrame) {
//                NSLog(@"audio:%llu", pcmFrame.presentTime);
//                [_audioPlayer playFrame:pcmFrame];
////                NSLog(@"mayinglun log:m_numqueued:%d", _audioPlayer.m_numqueued);
//                pcmFirstFrame = (MAPCMFrame*)[_pcmFrameBuffer fristFrame];
//                success = YES;
//            } else
//            {
//                break;
//            }
//        }
//    }
    
    NSLog(@"<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
    
    return success;
}

- (void)decodeOperation:(MADecodeOperation*)operation decodeYUVFrom:(uint64_t)start to:(uint64_t)end
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray* frames = [_decodeOperation.yuvFrameBuffer popAll];
        [_yuvFrameBuffer pushFrames:frames];
    });
}

- (void)decodeOperation:(MADecodeOperation*)operation decodePCMFrom:(uint64_t)start to:(uint64_t)end
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray* frames = [_decodeOperation.pcmFrameBuffer popAll];
        [_pcmFrameBuffer pushFrames:frames];
    });
    
//    if (_audioPlayer.m_numqueued > 10 && _audioPlayer.m_numqueued < 35) {
//        [NSThread sleepForTimeInterval:0.01];
//    }else if (_audioPlayer.m_numqueued > 35){
//        [NSThread sleepForTimeInterval:0.025];
//    }
//    dispatch_async(dispatch_get_main_queue(), ^{
//        MAPCMFrame* pcmFirstFrame = (MAPCMFrame*)[operation.pcmFrameBuffer fristFrame];
//        while (pcmFirstFrame) {
//            pcmFirstFrame = (MAPCMFrame*)[operation.pcmFrameBuffer pop];
//            [_audioPlayer playFrame:pcmFirstFrame];
//            pcmFirstFrame = (MAPCMFrame*)[operation.pcmFrameBuffer fristFrame];
//        }
//    });
}

@end
