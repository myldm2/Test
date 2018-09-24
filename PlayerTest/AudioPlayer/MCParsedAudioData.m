//
//  MCParsedAudioData.m
//  PlayerTest
//
//  Created by myldm2 on 2018/9/24.
//  Copyright © 2018年 baiyang. All rights reserved.
//

#import "MCParsedAudioData.h"

@implementation MCParsedAudioData

+ (instancetype)parsedAudioDataWithBytes:(const void *)bytes
                       packetDescription:(AudioStreamPacketDescription)packetDescription
{
    return [[self alloc] initWithBytes:bytes
                     packetDescription:packetDescription];
}

- (instancetype)initWithBytes:(const void *)bytes packetDescription:(AudioStreamPacketDescription)packetDescription
{
    if (bytes == NULL || packetDescription.mDataByteSize == 0)
    {
        return nil;
    }
    
    self = [super init];
    if (self)
    {
        _data = [NSData dataWithBytes:bytes length:packetDescription.mDataByteSize];
        _packetDescription = packetDescription;
    }
    return self;
}

@end
