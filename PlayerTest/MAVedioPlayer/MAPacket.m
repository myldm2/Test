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

- (void)dealloc
{
    if (_packet)
    {
        av_packet_free(&_packet);
        _packet = NULL;
    }
}

@end
