//
//  MCParsedAudioData.h
//  PlayerTest
//
//  Created by myldm2 on 2018/9/24.
//  Copyright © 2018年 baiyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreAudio/CoreAudioTypes.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCParsedAudioData : NSObject

@property (nonatomic, readonly) NSData * data;
@property (nonatomic, readonly) AudioStreamPacketDescription packetDescription;

+ (instancetype)parsedAudioDataWithBytes:(const void *)bytes packetDescription:(AudioStreamPacketDescription)packetDescription;

@end

NS_ASSUME_NONNULL_END
