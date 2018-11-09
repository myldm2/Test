//
//  MAAudioOutputQueue.h
//  PlayerTest
//
//  Created by 玉洋 on 2018/11/6.
//  Copyright © 2018 baiyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

NS_ASSUME_NONNULL_BEGIN

@interface MAAudioOutputQueue : NSObject

@property (nonatomic,assign,readonly) AudioStreamBasicDescription format;
@property (nonatomic,assign) float volume;
@property (nonatomic,assign) UInt32 bufferSize;

- (instancetype)initWithFormat:(AudioStreamBasicDescription)format macgicCookie:(NSData *)macgicCookie;

- (BOOL)playData:(NSData *)data packetCount:(UInt32)count packetDescriptions:(AudioStreamPacketDescription *)packetDescriptions isEof:(BOOL)isEof;

- (BOOL)pause;
- (BOOL)resume;

@end

NS_ASSUME_NONNULL_END
