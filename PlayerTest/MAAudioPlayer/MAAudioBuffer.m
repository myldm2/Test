//
//  MAAudioBuffer.m
//  PlayerTest
//
//  Created by 玉洋 on 2018/11/9.
//  Copyright © 2018 baiyang. All rights reserved.
//

#import "MAAudioBuffer.h"

@interface MAAudioBuffer ()

@end

@implementation MAAudioBuffer

+ (instancetype)buffer
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.datas = [NSMutableArray array];
    }
    return self;
}

- (void)enqueueData:(MCParsedAudioData *)data
{
    [self.datas addObject:data];
}

- (NSData*)dequeueCount:(UInt32*)count descriptions:(AudioStreamPacketDescription**)descriptions
{
    NSMutableData* mutableData = [NSMutableData data];
    
    if (descriptions != NULL)
    {
        *descriptions = (AudioStreamPacketDescription*)malloc(sizeof(AudioStreamPacketDescription) * self.datas.count);
    }
    
    UInt32 c = ((*count) < self.datas.count)?(*count):(UInt32)self.datas.count;
    
    for (int i = 0; i < c; i ++) {
        MCParsedAudioData* packet = self.datas[i];
        
        AudioStreamPacketDescription packetDescription = packet.packetDescription;
        packetDescription.mStartOffset = mutableData.length;
        (*descriptions)[i] = packetDescription;
//        descriptions[i].mVariableFramesInPacket = packetDescription.mVariableFramesInPacket;
//        descriptions[i].mDataByteSize = packetDescription.mDataByteSize;
//        offset = (UInt32)mutableData.length;
        
        [mutableData appendData:packet.data];
        
        NSLog(@"mayinglun log offset:%u %u", (unsigned int)packetDescription.mStartOffset, (unsigned int)packetDescription.mDataByteSize);
        
    }
    
    [self.datas removeObjectsInRange:NSMakeRange(0, c)];
    
    NSLog(@"mayinglun log length:%lu", (unsigned long)mutableData.length);
    
    *count = c;
    return [mutableData copy];
}

@end
