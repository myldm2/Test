//
//  MAAudioOutputQueue.m
//  PlayerTest
//
//  Created by 玉洋 on 2018/11/6.
//  Copyright © 2018 baiyang. All rights reserved.
//

#import "MAAudioOutputQueue.h"
#import <pthread.h>

@interface MAAudioOutputQueue ()
{
    AudioQueueRef _audioQueue;
    NSMutableArray *_buffers;
    NSMutableArray *_reusableBuffers;
}

@end

@implementation MAAudioOutputQueue

- (instancetype)initWithFormat:(AudioStreamBasicDescription)format bufferSize:(UInt32)bufferSize macgicCookie:(NSData *)macgicCookie
{
    self = [super init];
    if (self) {
        _format = format;
        _volume = 1.0f;
        _bufferSize = bufferSize;
        _buffers = [[NSMutableArray alloc] init];
        _reusableBuffers = [[NSMutableArray alloc] init];
//        [self _createAudioOutputQueue:macgicCookie];
//        [self _mutexInit];
    }
    return self;
}

@end
