//
//  MAAudioBuffer.h
//  PlayerTest
//
//  Created by 玉洋 on 2018/11/9.
//  Copyright © 2018 baiyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCParsedAudioData.h"

NS_ASSUME_NONNULL_BEGIN

@interface MAAudioBuffer : NSObject

@property (nonatomic, strong) NSMutableArray<MCParsedAudioData *>* datas;

+ (instancetype)buffer;

- (void)enqueueData:(MCParsedAudioData *)data;

- (NSData*)dequeueCount:(UInt32*)count descriptions:(AudioStreamPacketDescription**)descriptions;

@end

NS_ASSUME_NONNULL_END
