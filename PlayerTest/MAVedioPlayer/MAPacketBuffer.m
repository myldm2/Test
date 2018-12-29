//
//  MAPacketBuffer.m
//  PlayerTest
//
//  Created by 玉洋 on 2018/12/29.
//  Copyright © 2018 baiyang. All rights reserved.
//

#import "MAPacketBuffer.h"

@implementation MAPacketBuffer
{
    dispatch_queue_t _queue;
    NSMutableArray* _packets;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _queue = dispatch_queue_create("com.person.syncQueue", DISPATCH_QUEUE_SERIAL);
        _packets = [NSMutableArray array];
    }
    return self;
}

- (void)push:(MAPacket *)packet
{
    dispatch_barrier_async(_queue, ^{
        [_packets addObject: packet];
    });
}

- (MAPacket *)pop
{
    __block MAPacket *packet;
    dispatch_sync(_queue, ^{
        if (_packets.count > 0)
        {
            packet = _packets[0];
            [_packets removeObjectAtIndex:0];
        }
        
    });
    return packet;
}

@end
