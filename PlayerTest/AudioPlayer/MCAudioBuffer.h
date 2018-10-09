//
//  MCAudioBuffer.h
//  PlayerTest
//
//  Created by 玉洋 on 2018/10/4.
//  Copyright © 2018年 baiyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "MCParsedAudioData.h"

NS_ASSUME_NONNULL_BEGIN

@interface MCAudioBuffer : NSObject

+ (instancetype)buffer;

- (void)enqueueData:(MCParsedAudioData *)data;
- (void)enqueueFromDataArray:(NSArray *)dataArray;

- (BOOL)hasData;
- (UInt32)bufferedSize;

//descriptions needs free
- (NSData *)dequeueDataWithSize:(UInt32)requestSize packetCount:(UInt32 *)packetCount descriptions:(AudioStreamPacketDescription **)descriptions;

- (void)clean;

@end

NS_ASSUME_NONNULL_END
