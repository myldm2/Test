//
//  MAPacket.h
//  PlayerTest
//
//  Created by 玉洋 on 2018/12/26.
//  Copyright © 2018 baiyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "avcodec.h"

NS_ASSUME_NONNULL_BEGIN

@interface MAPacket : NSObject

@property (nonatomic, assign, readonly) AVPacket* packet;

- (BOOL)receivePacketData:(AVPacket*)packet;

- (void)releasePacketData;

@end

NS_ASSUME_NONNULL_END
