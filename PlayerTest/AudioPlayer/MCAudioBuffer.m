//
//  MCAudioBuffer.m
//  PlayerTest
//
//  Created by 玉洋 on 2018/10/4.
//  Copyright © 2018年 baiyang. All rights reserved.
//

#import "MCAudioBuffer.h"

@interface MCAudioBuffer ()
{
    NSMutableArray* _bufferBlockArray;
    UInt32 _bufferdSize;
}

@end

@implementation MCAudioBuffer

+ (instancetype)buffer
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _bufferBlockArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (BOOL)hasData
{
    return _bufferBlockArray.count > 0;
}

- (UInt32)bufferedSize
{
    return _bufferdSize;
}

- (void)enqueueFromDataArray:(NSArray *)dataArray
{
    for (MCParsedAudioData* data in dataArray)
    {
        [self enqueueData:data];
    }
}

- (void)enqueueData:(MCParsedAudioData *)data
{
    if ([data isKindOfClass:[MCParsedAudioData class]])
    {
        [_bufferBlockArray addObject:data];
        _bufferdSize += data.data.length;
    }
}

- (NSData*)dequeueDataWithSize:(UInt32)requestSize packetCount:(UInt32 *)packetCount descriptions:(AudioStreamPacketDescription **)descriptions
{
    if (requestSize == 0 && _bufferBlockArray.count == 0)
    {
        return nil;
    }
    
    SInt64 size = requestSize;
    int i = 0;
    for (i = 0; i < _bufferBlockArray.count; ++ i)
    {
        MCParsedAudioData* block = _bufferBlockArray[i];
        SInt64 datalength = [block.data length];
        if (size > datalength)
        {
            size -= datalength;
        } else {
            if (size < datalength) {
                i --;
            }
            break;
        }
    }
    
    if (i < 0)
    {
        return nil;
    }
    
    UInt32 count = (i >= _bufferBlockArray.count) ? (UInt32)_bufferBlockArray.count : (i + 1);
    *packetCount = count;
    if (count == 0)
    {
        return nil;
    }
    
    if (descriptions != NULL)
    {
        *descriptions = (AudioStreamPacketDescription*)malloc(sizeof(AudioStreamPacketDescription) * count);
    }
    NSMutableData* retData = [[NSMutableData alloc] init];
    for (int j = 0; j < count; ++j) {
        MCParsedAudioData* block = _bufferBlockArray[j];
        if (descriptions != NULL)
        {
            AudioStreamPacketDescription desc = block.packetDescription;
            desc.mStartOffset = [retData length];
            (*descriptions)[j] = desc;
            NSLog(@"mayinglun log offset:%u %u", (unsigned int)desc.mStartOffset, (unsigned int)desc.mDataByteSize);
        }
        [retData appendData:block.data];
    }
    NSRange removeRange = NSMakeRange(0, count);
    [_bufferBlockArray removeObjectsInRange:removeRange];
    
    _bufferdSize -= retData.length;
    
    return retData;
}

- (void)clean
{
    _bufferdSize = 0;
    [_bufferBlockArray removeAllObjects];
}

- (void)dealloc
{
    [_bufferBlockArray removeAllObjects];
}

@end
