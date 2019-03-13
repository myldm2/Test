//
//  MAVedioPlayOperation.m
//  PlayerTest
//
//  Created by 玉洋 on 2019/1/25.
//  Copyright © 2019 baiyang. All rights reserved.
//

#import "MAVedioPlayOperation.h"
#import "MAPCMFrame.h"

@interface MAVedioPlayOperation ()
{
    MAFrameBuffer* _yuvBuffer;
    MAFrameBuffer* _yuvQueue;
    MAPlayCore* _playCore;
}

@end

@implementation MAVedioPlayOperation

- (instancetype)initWithYUVBuffer:(MAFrameBuffer*)yuvBuffer playCore:(MAPlayCore*)playCore
{
    self = [super init];
    if (self) {
        _yuvBuffer = yuvBuffer;
        _yuvQueue = [[MAFrameBuffer alloc] initWithMultithreadProtection:false];
        _playCore = playCore;
        __weak typeof(self) __self = self;
        [self addExecutionBlock:^{
            [__self play];
        }];
    }
    return self;
}

- (void)play
{
//    while (!self.isCancelled) {
//
//        if (_yuvQueue.count < 50)
//        {
//            [_yuvQueue pushFrames:[_yuvBuffer popAll]];
//        }
//        if (_pcmQueue.count < 50)
//        {
//            [_pcmQueue pushFrames:[_pcmBuffer popAll]];
//        }
//
//        if (_yuvQueue.count == 0 && _pcmQueue.count == 0)
//        {
//            [NSThread sleepForTimeInterval:0.1];
//            continue;
//        }
//
//        double remaining_time = 0.01;
//        [NSThread sleepForTimeInterval:remaining_time];
//
//        uint64_t time1 = _time;
//        uint64_t time2 = _time + remaining_time * AV_TIME_BASE;
//
//        BOOL success = NO;
//
//        MAYUVFrame* yuvFirstFrame = (MAYUVFrame*)[_yuvQueue fristFrame];
//        while (yuvFirstFrame) {
//            if (yuvFirstFrame.presentTime >= time2) {
//                success = YES;
//                break;
//            } else if (yuvFirstFrame.presentTime < time1) {
//                [_yuvBuffer pop];
//                yuvFirstFrame = (MAYUVFrame*)_yuvQueue.fristFrame;
//                continue;
//            } else {
//                MAYUVFrame* yuvFrame = (MAYUVFrame*)[_yuvQueue pop];
//                if (yuvFrame) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [_glView displayYUV420pData:yuvFrame];
//                    });
//                    yuvFirstFrame = (MAYUVFrame*)[_yuvQueue fristFrame];
//                    success = YES;
//                }
//            }
//        }
//
//        uint64_t vedio_time1 = time1;
//        uint64_t vedio_time2 = time2;
//
//        vedio_time1 = time1;
//        vedio_time2 = time2 + 2 * AV_TIME_BASE;
//
//        MAPCMFrame* pcmFirstFrame = (MAPCMFrame*)[_pcmQueue fristFrame];
//        while (pcmFirstFrame) {
//
//            if ([_alPlayer m_numqueue] < 5)
//            {
//                if (pcmFirstFrame.presentTime >= vedio_time1)
//                {
//                    MAPCMFrame* pcmFrame = (MAPCMFrame*)[_pcmQueue pop];
//                    if (pcmFrame) {
//                        [_alPlayer playFrame:pcmFrame];
//                        pcmFirstFrame = (MAPCMFrame*)[_pcmQueue fristFrame];
//                    }
//                }
//            }
//            else {
//                if (pcmFirstFrame.presentTime >= time2) {
//                    break;
//                }
//                else if (pcmFirstFrame.presentTime < time1) {
//                    [_pcmBuffer pop];
//                    pcmFirstFrame = (MAPCMFrame*)_pcmQueue.fristFrame;
//                    continue;
//                } else {
//                    MAPCMFrame* pcmFrame = (MAPCMFrame*)[_pcmQueue pop];
//                    if (pcmFrame) {
//                        [_alPlayer playFrame:pcmFrame];
//                        pcmFirstFrame = (MAPCMFrame*)[_pcmQueue fristFrame];
//                        vedio_time1 = pcmFirstFrame.presentTime;
//                        vedio_time2 = vedio_time1 + remaining_time * AV_TIME_BASE;
//                    } else
//                    {
//                        break;
//                    }
//                }
//            }
//        }
//
//        if (success) {
//            _time = time2;
//        }
//
//    }
    
    while (!self.isCancelled) {
//
        if (_yuvQueue.count < 50)
        {
            [_yuvQueue pushFrames:[_yuvBuffer popAll]];
        }

        if (_yuvQueue.count == 0)
        {
            [NSThread sleepForTimeInterval:0.1];
            continue;
        }
//
//
//
//        while (_pcmQueue.count > 0) {
//
//            if ([_alPlayer m_numqueue] < 10)
//            {
//                MAPCMFrame* pcmFrame = (MAPCMFrame*)[_pcmQueue pop];
//                if (pcmFrame) {
//                    [_alPlayer playFrame:pcmFrame];
//                    _pcmPts = pcmFrame.pts;
//                }
//            } else
//            {
//                [NSThread sleepForTimeInterval:0.01];
//                break;
//            }
//
//        }
//
//        NSLog(@"%llu", _pcmPts);

        uint64_t time1 = _playCore.pcmPts - 500;
        uint64_t time2 = _playCore.pcmPts + 100;

//        MAYUVFrame* yuvFirstFrame = (MAYUVFrame*)[_yuvQueue fristFrame];
//        while (yuvFirstFrame) {
//
////            NSLog(@"%@  %llu", yuvFirstFrame, yuvFirstFrame.presentTime);
//
//            if (yuvFirstFrame.presentTime >= time2) {
////                NSLog(@"1");
//                break;
//            } else if (yuvFirstFrame.presentTime < time1) {
//                [_yuvQueue pop];
//                yuvFirstFrame = (MAYUVFrame*)_yuvQueue.fristFrame;
////                NSLog(@"2");
//                continue;
//            } else {
//
//                MAYUVFrame* yuvFrame = (MAYUVFrame*)[_yuvQueue pop];
//                if (yuvFrame) {
//                    [_playCore.glView displayYUV420pData:yuvFrame];
////                    dispatch_async(dispatch_get_main_queue(), ^{
////                        [_glView displayYUV420pData:yuvFrame];
////                    });
//                    yuvFirstFrame = (MAYUVFrame*)[_yuvQueue fristFrame];
//                    break;
//                }
//            }
//        }


        MAYUVFrame* yuvFrame = (MAYUVFrame*)[_yuvQueue pop];
        if (yuvFrame) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_playCore.glView displayYUV420pData:yuvFrame];
            });
            [NSThread sleepForTimeInterval:0.001];
        }
    
    }

    
}

@end
