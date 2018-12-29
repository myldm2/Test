//
//  MAPacket.m
//  PlayerTest
//
//  Created by 玉洋 on 2018/12/26.
//  Copyright © 2018 baiyang. All rights reserved.
//

#import "MAPacket.h"

@implementation MAPacket

- (instancetype)init
{
    self = [super init];
    if (self) {
        _packet = av_packet_alloc();
    }
    return self;
}

- (BOOL)receivePacketData:(AVPacket*)packet
{
    if (packet)
    {
        [self releasePacketData];
        return av_packet_ref(_packet, packet) == 0;
    } else {
        return NO;
    }
}

- (void)releasePacketData
{
    if (_packet)
    {
        av_packet_unref(_packet);
    }
}

- (void)dealloc
{
    if (_packet)
    {
        av_packet_unref(_packet);
        av_packet_free(&_packet);
        _packet = NULL;
    }
}

@end
