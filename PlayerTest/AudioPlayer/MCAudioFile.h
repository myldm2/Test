//
//  MCAudioFile.h
//  PlayerTest
//
//  Created by 玉洋 on 2018/9/30.
//  Copyright © 2018年 baiyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioFile.h>
#import "MCParsedAudioData.h"

NS_ASSUME_NONNULL_BEGIN

@interface MCAudioFile : NSObject

@property (nonatomic,copy,readonly) NSString *filePath;
@property (nonatomic,assign,readonly) AudioFileTypeID fileType;
@property (nonatomic,assign,readonly) BOOL available;
@property (nonatomic,assign,readonly) AudioStreamBasicDescription format;
@property (nonatomic,assign,readonly) unsigned long long fileSize;
@property (nonatomic,assign,readonly) NSTimeInterval duration;
@property (nonatomic,assign,readonly) UInt32 bitRate;
@property (nonatomic,assign,readonly) UInt32 maxPacketSize;
@property (nonatomic,assign,readonly) UInt64 audioDataByteCount;

- (instancetype)initWithFilePath:(NSString *)filePath fileType:(AudioFileTypeID)fileType;
- (NSArray *)parseData:(BOOL *)isEof;
- (NSData *)fetchMagicCookie;
- (void)seekToTime:(NSTimeInterval)time;
- (void)close;

@end

NS_ASSUME_NONNULL_END
