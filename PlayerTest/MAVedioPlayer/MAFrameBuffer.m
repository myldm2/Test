//
//  MAFrameBuffer.m
//  PlayerTest
//
//  Created by 玉洋 on 2018/12/29.
//  Copyright © 2018 baiyang. All rights reserved.
//

#import "MAFrameBuffer.h"

@implementation MAFrameBuffer
{
    BOOL _multithreadProtection;
    dispatch_queue_t _queue;
    NSMutableArray* _frames;
}

- (instancetype)initWithMultithreadProtection:(BOOL)multithreadProtection
{
    self = [super init];
    if (self) {
        _multithreadProtection = multithreadProtection;
        _queue = dispatch_queue_create("com.FrameBuffer.syncQueue", DISPATCH_QUEUE_SERIAL);
        _frames = [NSMutableArray array];
    }
    return self;
}

- (void)push:(MAYUVFrame *)frame
{
    if (_multithreadProtection)
    {
        dispatch_barrier_async(_queue, ^{
            [self _push:frame];
        });
    } else {
        [self _push:frame];
    }
}

- (void)_push:(MAYUVFrame *)frame
{
    [_frames addObject: frame];
}

- (MAYUVFrame *)pop
{
    __block MAYUVFrame *frame;
    if (_multithreadProtection)
    {
        dispatch_sync(_queue, ^{
            frame = [self _pop];
        });
    } else {
        frame = [self _pop];
    }
    return frame;
}

- (MAYUVFrame *)_pop
{
    MAYUVFrame *frame = nil;
    if (_frames.count > 0)
    {
        frame = _frames[0];
        [_frames removeObjectAtIndex:0];
    }
    return frame;
}

- (NSArray<MAYUVFrame *> *)popAll
{
    __block NSArray<MAYUVFrame *> * frames;
    if (_multithreadProtection)
    {
        dispatch_sync(_queue, ^{
            frames = [self _popAll];
        });
    } else {
        frames = [self _popAll];
    }
    return frames;
}

- (NSArray<MAYUVFrame *> *)_popAll
{
    NSArray<MAYUVFrame *> * frames;
    if (_frames.count > 0)
    {
        frames = [NSArray arrayWithArray:_frames];
    }
    return frames;
}

@end
