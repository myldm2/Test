//
//  MADecoder.h
//  PlayerTest
//
//  Created by 玉洋 on 2018/12/24.
//  Copyright © 2018 baiyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "avcodec.h"
#import "swscale.h"
#import "avformat.h"
#import "swresample.h"
#import "samplefmt.h"
#import "YUV_GL_DATA.h"
#import "MAPacket.h"
#import "MAFrame.h"
#import "MAYUVFrame.h"
#import "MAPCMFrame.h"

NS_ASSUME_NONNULL_BEGIN

#define SAMPLE_SIZE 16
#define SAMPLE_RATE 44100
#define CHANNEL     2

@interface MADecoder : NSObject

@property (nonatomic, assign) uint64_t duration;  //微秒
//视频流索引
@property (nonatomic, assign) int videoStreamIndex;
//音频流索引
@property (nonatomic, assign) int audioStreamIndex;

@property (nonatomic, assign) int audioSampleRate;

@property (nonatomic, assign) int audioSampleSize;

@property (nonatomic, assign) int audioChannels;

- (BOOL)openUrl:(NSString*)path error:(NSError**)error;

- (BOOL)read:(MAPacket*)pkt;

- (NSArray*)decodeYUV:(MAPacket*)pkt;

- (NSArray*)decodePCM:(MAPacket*)pkt;

- (MAYUVFrame*)yuvToGlData:(MAFrame*)frame;

- (MAPCMFrame*)toPCMFrameData:(MAFrame*)frame;

@end

NS_ASSUME_NONNULL_END
