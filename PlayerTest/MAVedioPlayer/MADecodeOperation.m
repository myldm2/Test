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
