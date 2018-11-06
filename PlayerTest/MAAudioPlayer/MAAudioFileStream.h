//
//  MCAudioFileStream.h
//  PlayerTest
//
//  Created by 玉洋 on 2018/11/5.
//  Copyright © 2018 baiyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "MCParsedAudioData.h"

NS_ASSUME_NONNULL_BEGIN

@class MAAudioFileStream;
@protocol MAAudioFileStreamDelegate <NSObject>
@required
- (void)audioFileStream:(MAAudioFileStream *)audioFileStream audioDataParsed:(NSArray *)audioData;
@optional
- (void)audioFileStreamReadyToProducePackets:(MAAudioFileStream *)audioFileStream;
@end

@interface MAAudioFileStream : NSObject

@property (nonatomic,assign,readonly) AudioFileTypeID fileType;
@property (nonatomic,assign,readonly) unsigned long long fileSize;
@property (nonatomic,assign,readonly) UInt32 maxPacketSize;
@property (nonatomic,assign,readonly) NSTimeInterval duration;
@property (nonatomic,assign,readonly) UInt32 bitRate;

- (instancetype)initWithFileType:(AudioFileTypeID)fileType fileSize:(unsigned long long)fileSize error:(NSError * _Nullable __autoreleasing *)error;

- (BOOL)parseData:(NSData *)data error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
