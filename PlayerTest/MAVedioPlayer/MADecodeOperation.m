//
//  MADecodeOperation.m
//  PlayerTest
//
//  Created by 玉洋 on 2019/1/3.
//  Copyright © 2019 baiyang. All rights reserved.
//

#import "MADecodeOperation.h"

@interface MADecodeOperation ()
{
    MADecoder* _decoder;
    NSLock* _lock;
    BOOL _pause;
}

@end

@implementation MADecodeOperation

- (instancetype)initWithDecoder:(MADecoder*)decoder
{
    self = [super init];
    if (self) {
        _decoder = decoder;
        _lock = [[NSLock alloc] init];
        _yuvFrameBuffer = [[MAFrameBuffer alloc] initWithMultithreadProtection: YES];
        _pcmFrameBuffer = [[MAFrameBuffer alloc] initWithMultithreadProtection: YES];
        __weak typeof(self) __self = self;
        [self addExecutionBlock:^{
            [__self decode];
        }];
    }
    return self;
}

- (void)decode
{
    while (!self.isCancelled) {
        
        @autoreleasepool {
            
            MAPacket* packet = packet = [[MAPacket alloc] init];
            if ([_decoder read:packet])
            {
                if (packet.packet->stream_index == _decoder.videoStreamIndex)
                {
                    NSArray* frames = [_decoder decodeYUV:packet];
                    for (MAFrame* frame in frames) {
                        
                        MAYUVFrame* yuvFrame = [_decoder yuvToGlData:frame];
                        [_yuvFrameBuffer push:yuvFrame];
//                        NSLog(@"frame.pts:%llu", yuvFrame.pts);
//                        NSLog(@"count:%ld", (long)_yuvFrameBuffer.count);
//                        NSLog(@"show frame pts:%llu", yuvFrame.presentTime);
                        
                        if (_delegate && [_delegate respondsToSelector:@selector(decodeOperation: decodeYUVFrom: to:)])
                        {
                            MAYUVFrame* firstFrame = (MAYUVFrame*)_yuvFrameBuffer.fristFrame;
                            MAYUVFrame* lastFrame = (MAYUVFrame*)_yuvFrameBuffer.lastFrame;
//                            NSLog(@"frame.pts:%llu", firstFrame.pts);
//                            NSLog(@"frame.pts:%@", yuvFrame);
//                            NSLog(@"frame.pts:%@", lastFrame);
//                            NSLog(@"count1:%ld", (long)_yuvFrameBuffer.count);
                            [_delegate decodeOperation:self decodeYUVFrom:firstFrame.presentTime to:lastFrame.presentTime];
                        }
                        
                    }
                } else if (packet.packet->stream_index == _decoder.audioStreamIndex)
                {
                    NSArray* frames = [_decoder decodePCM:packet];
                    for (MAFrame* frame in frames) {
                        
                        MAPCMFrame* pcmFrame = [_decoder toPCMFrameData:frame];
                        [_pcmFrameBuffer push:pcmFrame];
                        
                        if (_delegate && [_delegate respondsToSelector:@selector(decodeOperation: decodeYUVFrom: to:)])
                        {
                            MAPCMFrame* firstFrame = (MAPCMFrame*)_pcmFrameBuffer.fristFrame;
                            MAPCMFrame* lastFrame = (MAPCMFrame*)_pcmFrameBuffer.lastFrame;
                            [_delegate decodeOperation:self decodePCMFrom:firstFrame.presentTime to:lastFrame.presentTime];
                        }
                        
                    }
                }
            } else {
                [NSThread sleepForTimeInterval:0.01];
                continue;
            }
            
        }
    }
}

@end
