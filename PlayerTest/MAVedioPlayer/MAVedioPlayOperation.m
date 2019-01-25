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
    MAFrameBuffer* _pcmBuffer;
    MAOpenglView* _glView;
    MAOpenalPlayer* _alPlayer;
    uint64_t _time;
}

@end

@implementation MAVedioPlayOperation

- (instancetype)initWithYUVBuffer:(MAFrameBuffer*)yuvBuffer PCMBuffer:(MAFrameBuffer*)pcmBuffer glView:(MAOpenglView*)glView alPlayer:(MAOpenalPlayer*)alPlayer
{
    self = [super init];
    if (self) {
        _yuvBuffer = yuvBuffer;
        _pcmBuffer = pcmBuffer;
        _glView = glView;
        _alPlayer = alPlayer;
        __weak typeof(self) __self = self;
        [self addExecutionBlock:^{
            [__self play];
        }];
    }
    return self;
}

- (void)play
{
    while (!self.isCancelled) {
        
        if (_yuvBuffer.count == 0 || _pcmBuffer.count == 0)
        {
            [NSThread sleepForTimeInterval:0.1];
            continue;
        }
        
        double remaining_time = 0.01;
        [NSThread sleepForTimeInterval:remaining_time];
        
//        if ([_alPlayer m_numqueue] > 15)
//        {
//            continue;
//        }
        
        
            
            

        
        uint64_t time1 = _time;
        uint64_t time2 = _time + remaining_time * AV_TIME_BASE;
        
        NSLog(@"mayinglun log:%lld", _alPlayer.m_numqueued);
        
        BOOL success = NO;
        
        MAPCMFrame* pcmFirstFrame = (MAPCMFrame*)[_pcmBuffer fristFrame];
        while (pcmFirstFrame && _alPlayer.m_numqueued < 35) {
            pcmFirstFrame = (MAPCMFrame*)[_pcmBuffer pop];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_alPlayer playFrame:pcmFirstFrame];
            });
            pcmFirstFrame = (MAPCMFrame*)[_pcmBuffer fristFrame];
            time1 = pcmFirstFrame.presentTime;
            time2 = time1 + remaining_time * AV_TIME_BASE;
            success = YES;
        }
//        else if (_alPlayer.m_numqueued < 35)
//        {
//            MAPCMFrame* pcmFirstFrame = (MAPCMFrame*)[_pcmBuffer fristFrame];
//            while (pcmFirstFrame) {
//                if (pcmFirstFrame.presentTime >= time2) {
//                    success = YES;
//                    break;
//                } else if (pcmFirstFrame.presentTime < time1) {
//                    [_pcmBuffer pop];
//                    pcmFirstFrame = (MAPCMFrame*)_pcmBuffer.fristFrame;
//                    continue;
//                } else {
//                    MAPCMFrame* pcmFrame = (MAPCMFrame*)[_pcmBuffer pop];
//                    if (pcmFrame) {
//                        [_alPlayer playFrame:pcmFrame];
//                        success = YES;
//                    } else
//                    {
//                        break;
//                    }
//                }
//            }
//        }
        
//        MAPCMFrame* pcmFirstFrame = (MAPCMFrame*)[_pcmBuffer fristFrame];
//        while (pcmFirstFrame) {
//            if (pcmFirstFrame.presentTime >= time2) {
//                success = YES;
//                break;
//            } else if (pcmFirstFrame.presentTime < time1) {
//                [_pcmBuffer pop];
//                pcmFirstFrame = (MAPCMFrame*)_pcmBuffer.fristFrame;
//                continue;
//            } else {
//                MAPCMFrame* pcmFrame = (MAPCMFrame*)[_pcmBuffer pop];
//                if (pcmFrame) {
//                    [_alPlayer playFrame:pcmFrame];
//                    success = YES;
//                } else
//                {
//                    break;
//                }
//            }
//        }
        
//        MAYUVFrame* yuvFirstFrame = (MAYUVFrame*)[_yuvBuffer fristFrame];
//        while (yuvFirstFrame) {
//            if (yuvFirstFrame.presentTime >= time2) {
//                success = YES;
//                break;
//            } else if (yuvFirstFrame.presentTime < time1) {
//                [_yuvBuffer pop];
//                yuvFirstFrame = (MAYUVFrame*)_yuvBuffer.fristFrame;
//                continue;
//            } else {
//                MAYUVFrame* yuvFrame = (MAYUVFrame*)[_yuvBuffer pop];
//                if (yuvFrame) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [_glView displayYUV420pData:yuvFrame];
//                    });
//                    yuvFirstFrame = (MAYUVFrame*)[_yuvBuffer fristFrame];
//                    success = YES;
//
//                }
//            }
//        }
        
        if (success) {
            _time = time2;
        }

    }
}

@end
