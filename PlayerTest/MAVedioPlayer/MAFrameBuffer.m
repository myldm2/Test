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
//        dispatch_barrier_async(_queue, ^{
        dispatch_sync(_queue, ^{
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

- (void)pushFrames:(NSArray<MAYUVFrame*> *)frames
{
    if (_multithreadProtection)
    {
//        dispatch_barrier_async(_queue, ^{
        dispatch_sync(_queue, ^{
            [self _pushFrames:frames];
        });
    } else {
        [self _pushFrames:frames];
    }
}

- (void)_pushFrames:(NSArray<MAYUVFrame*> *)frames
{
    [_frames addObjectsFromArray:frames];
}

- (MAYUVFrame *)pop
{
    __block MAYUVFrame *frame;
    if (_multithreadProtection)
    {
//        dispatch_barrier_async(_queue, ^{
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
//        dispatch_barrier_async(_queue, ^{
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
        [_frames removeAllObjects];
    }
    return frames;
}

- (MAYUVFrame*)fristFrame
{
    __block MAYUVFrame *frame;
    if (_multithreadProtection)
    {
        dispatch_sync(_queue, ^{
            frame = [self _fristFrame];
        });
    } else {
        frame = [self _fristFrame];
    }
    return frame;
}

- (MAYUVFrame *)_fristFrame
{
    MAYUVFrame *frame = nil;
    if (_frames.count > 0)
    {
        frame = _frames[0];
    }
    return frame;
}

- (MAYUVFrame*)lastFrame
{
    __block MAYUVFrame *frame;
    if (_multithreadProtection)
    {
        dispatch_sync(_queue, ^{
            frame = [self _lastFrame];
        });
    } else {
        frame = [self _lastFrame];
    }
    return frame;
}

- (MAYUVFrame *)_lastFrame
{
    MAYUVFrame *frame = nil;
    frame = [_frames lastObject];
    return frame;
}

- (NSInteger)count
{
    __block NSInteger count;
    if (_multithreadProtection)
    {
        dispatch_sync(_queue, ^{
            count = [self _count];
        });
    } else {
        count = [self _count];
    }
    return count;
}

- (NSInteger)_count
{
    return _frames.count;
}

@end
