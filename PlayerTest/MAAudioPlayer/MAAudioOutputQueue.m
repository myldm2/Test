//
//  MAAudioOutputQueue.m
//  PlayerTest
//
//  Created by 玉洋 on 2018/11/6.
//  Copyright © 2018 baiyang. All rights reserved.
//

#import "MAAudioOutputQueue.h"
#import <pthread.h>

const int MAAudioQueueBufferCount = 2;


@interface MAAudioQueueBuffer : NSObject
@property (nonatomic, assign) AudioQueueBufferRef buffer;
@end
@implementation MAAudioQueueBuffer
@end

@interface MAAudioOutputQueue ()
{
    AudioQueueRef _audioQueue;
    NSMutableArray *_buffers;
    NSMutableArray *_reusableBuffers;
    BOOL _started;
    BOOL _isRunning;
    
    pthread_mutex_t _mutex;
    pthread_cond_t _cond;
}

@end

@implementation MAAudioOutputQueue
    
static void MAAudioQueueOutputCallBack(void *inClientData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer)
{
    MAAudioOutputQueue* audioOutputQueue = (__bridge MAAudioOutputQueue *)inClientData;
    [audioOutputQueue handleAudioQueueOutputCallBack:inAQ buffer:inBuffer];
}

- (void)handleAudioQueueOutputCallBack:(AudioQueueRef)audioQueue buffer:(AudioQueueBufferRef)buffer
{
    for (int i = 0; i < _buffers.count; ++ i) {
        if (buffer == [_buffers[i] buffer])
        {
            [_reusableBuffers addObject:_buffers[i]];
            break;
        }
    }
    [self _mutexSignal];
}

static void MAAudioQueuePropertyCallback(void* inUserData, AudioQueueRef inAQ, AudioQueuePropertyID inID)
{
    MAAudioOutputQueue* audioQueue = (__bridge MAAudioOutputQueue *)inUserData;
    [audioQueue handleAudioQueuePropertyCallBack:inAQ property:inID];
}

- (void)handleAudioQueuePropertyCallBack:(AudioQueueRef)audioQueue property:(AudioQueuePropertyID)property
{
    if (property == kAudioQueueProperty_IsRunning)
    {
        UInt32 isRunning  = 0;
        UInt32 size = sizeof(isRunning);
        AudioQueueGetProperty(audioQueue, property, &isRunning, &size);
        _isRunning = isRunning;
    }
}

- (instancetype)initWithFormat:(AudioStreamBasicDescription)format macgicCookie:(NSData *)macgicCookie
{
    self = [super init];
    if (self) {
        _format = format;
        _volume = 1.0f;
//        _bufferSize = bufferSize;
        _buffers = [[NSMutableArray alloc] init];
        _reusableBuffers = [[NSMutableArray alloc] init];
        [self _createAudioOutputQueue:macgicCookie];
        [self _mutexInit];
    }
    return self;
}
    
- (void)_createAudioOutputQueue:(NSData*)magicCookie
{
    OSStatus status = AudioQueueNewOutput(&_format, MAAudioQueueOutputCallBack, (__bridge void *)self, nil, nil, 0, &_audioQueue);
    if (status != noErr) {
        AudioQueueDispose(_audioQueue, YES);
        _audioQueue = NULL;
        return;
    }
    
    status = AudioQueueAddPropertyListener(_audioQueue, kAudioQueueProperty_IsRunning, MAAudioQueuePropertyCallback, (__bridge void *)self);
    if (status != noErr) {
        AudioQueueDispose(_audioQueue, YES);
        _audioQueue = NULL;
        return;
    }
    
//    if (_buffers.count == 0)
//    {
//        for (int i = 0; i < MAAudioQueueBufferCount; ++ i)
//        {
//            AudioQueueBufferRef buffer;
//            status = AudioQueueAllocateBuffer(_audioQueue, _bufferSize, &buffer);
//            if (status != noErr)
//            {
//                AudioQueueDispose(_audioQueue, YES);
//                _audioQueue = NULL;
//                break;
//            }
//            MAAudioQueueBuffer *bufferObj = [[MAAudioQueueBuffer alloc] init];
//            bufferObj.buffer = buffer;
//            [_buffers addObject:bufferObj];
//            [_reusableBuffers addObject:bufferObj];
//        }
//    }
    
    UInt32 property = kAudioQueueHardwareCodecPolicy_PreferSoftware;
    [self setProperty:kAudioQueueProperty_HardwareCodecPolicy dataSize:sizeof(property) data:&property error:NULL];
    
    if (magicCookie)
    {
        [self setProperty:kAudioQueueProperty_MagicCookie dataSize:(UInt32)[magicCookie length] data:[magicCookie bytes] error:nil];
    }
    
    [self setVolumeParameter];
    
}

- (BOOL)playData:(NSData *)data packetCount:(UInt32)count packetDescriptions:(AudioStreamPacketDescription *)packetDescriptions isEof:(BOOL)isEof
{
//    if ([data length] > _bufferSize)
//    {
//        return NO;
//    }
//    if (_reusableBuffers.count == 0)
//    {
//        if (!_started && ![self _start])
//        {
//            return NO;
//        }
//        [self _mutexWait];
//    }
    OSStatus status = noErr;
    
    for (int i = 0; i < count; i ++) {
        
        MAAudioQueueBuffer* bufferObj;
        
        AudioQueueBufferRef buffer;
        status = AudioQueueAllocateBuffer(_audioQueue, (UInt32)[data length], &buffer);
        if (status == noErr)
        {
            bufferObj = [[MAAudioQueueBuffer alloc] init];
            bufferObj.buffer = buffer;
        } else {
            return NO;
        }
        
        memcpy(bufferObj.buffer->mAudioData, [data bytes], [data length]);
        bufferObj.buffer->mAudioDataByteSize = (UInt32)[data length];
        bufferObj.buffer = buffer;
        
        status = AudioQueueEnqueueBuffer(_audioQueue, bufferObj.buffer, count, packetDescriptions);
        
        if (status != noErr)
        {
            return NO;
        }
        
    }
    
    if (status == noErr)
    {
        if (_reusableBuffers.count == 0 || isEof)
        {
            if (!_started && ![self _start])
            {
                return NO;
            }
        }
    }
    
    return status == noErr;
}

- (BOOL)_start
{
    OSStatus status = AudioQueueStart(_audioQueue, NULL);
    _started = status == noErr;
    return _started;
}

- (BOOL)resume
{
    return [self _start];
}

- (BOOL)pause
{
    OSStatus status = AudioQueuePause(_audioQueue);
    _started = NO;
    return status == noErr;
}

- (BOOL)reset
{
    OSStatus status = AudioQueueReset(_audioQueue);
    return status == noErr;
}

- (BOOL)flush
{
    OSStatus status = AudioQueueFlush(_audioQueue);
    return status == noErr;
}

- (void)setVolume:(float)volume
{
    _volume = volume;
    [self setVolumeParameter];
}

- (void)setVolumeParameter
{
    [self setParameter:kAudioQueueParam_Volume value:_volume error:NULL];
}

- (BOOL)setParameter:(AudioQueueParameterID)parameterId value:(AudioQueueParameterValue)value error:(NSError *__autoreleasing *)outError
{
    OSStatus status = AudioQueueSetParameter(_audioQueue, parameterId, value);
    [self _errorForOSStatus:status error:outError];
    return status == noErr;
}

- (BOOL)setProperty:(AudioQueuePropertyID)propertyID dataSize:(UInt32)dataSize data:(const void *)data error:(NSError *__autoreleasing *)outError
{
    OSStatus status = AudioQueueSetProperty(_audioQueue, propertyID, data, dataSize);
    [self _errorForOSStatus:status error:outError];
    return status == noErr;
}

- (void)_errorForOSStatus:(OSStatus)status error:(NSError *__autoreleasing *)outError
{
    if (status != noErr && outError != NULL)
    {
        *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
    }
}

#pragma mark - mutex
- (void)_mutexInit
{
    pthread_mutex_init(&_mutex, NULL);
    pthread_cond_init(&_cond, NULL);
}

- (void)_mutexDestory
{
    pthread_mutex_destroy(&_mutex);
    pthread_cond_destroy(&_cond);
}

- (void)_mutexWait
{
    pthread_mutex_lock(&_mutex);
    pthread_cond_wait(&_cond, &_mutex);
    pthread_mutex_unlock(&_mutex);
}

- (void)_mutexSignal
{
    pthread_mutex_lock(&_mutex);
    pthread_cond_signal(&_cond);
    pthread_mutex_unlock(&_mutex);
}

@end
