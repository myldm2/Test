//
//  MCAudioFileStream.h
//  PlayerTest
//
//  Created by 玉洋 on 2018/10/2.
//  Copyright © 2018年 baiyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "MCParsedAudioData.h"

NS_ASSUME_NONNULL_BEGIN

@class MCAudioFileStream;
@protocol MCAudioFileStreamDelegate <NSObject>
@required
- (void)audioFileStream:(MCAudioFileStream *)audioFileStream audioDataParsed:(NSArray *)audioData;
@optional
- (void)audioFileStreamReadyToProducePackets:(MCAudioFileStream *)audioFileStream;
@end

@interface MCAudioFileStream : NSObject

@property (nonatomic,assign,readonly) AudioFileTypeID fileType;
@property (nonatomic,assign,readonly) BOOL available;
@property (nonatomic,assign,readonly) BOOL readyToProducePackets;
@property (nonatomic,weak) id<MCAudioFileStreamDelegate> delegate;

@property (nonatomic,assign,readonly) AudioStreamBasicDescription format;
@property (nonatomic,assign,readonly) unsigned long long fileSize;
@property (nonatomic,assign,readonly) NSTimeInterval duration;
@property (nonatomic,assign,readonly) UInt32 bitRate;
@property (nonatomic,assign,readonly) UInt32 maxPacketSize;
@property (nonatomic,assign,readonly) UInt64 audioDataByteCount;

- (instancetype)initWithFileType:(AudioFileTypeID)fileType fileSize:(unsigned long long)fileSize error:(NSError **)error;

- (BOOL)parseData:(NSData *)data error:(NSError **)error;

/**
 *  seek to timeinterval
 *
 *  @param time On input, timeinterval to seek.
 On output, fixed timeinterval.
 *
 *  @return seek byte offset
 */
- (SInt64)seekToTime:(NSTimeInterval *)time;

- (NSData *)fetchMagicCookie;

- (void)close;

@end

NS_ASSUME_NONNULL_END
