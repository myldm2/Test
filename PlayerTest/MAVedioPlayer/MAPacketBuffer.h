//
//  MAPacketBuffer.h
//  PlayerTest
//
//  Created by 玉洋 on 2018/12/29.
//  Copyright © 2018 baiyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAPacket.h"

NS_ASSUME_NONNULL_BEGIN

@interface MAPacketBuffer : NSObject

- (void)push:(MAPacket *)packet;

- (MAPacket *)pop;

@end

NS_ASSUME_NONNULL_END
