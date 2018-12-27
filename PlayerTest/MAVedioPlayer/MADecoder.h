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

NS_ASSUME_NONNULL_BEGIN

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

- (void)read:(MAPacket*)pkt error:(NSError**)error;

- (NSArray*)decodeYUV:(MAPacket*)pkt;

- (NSArray*)decodePCM:(MAPacket*)pkt;

- (H264YUV_Frame)yuvToGlData:(MAFrame*)frame :(H264YUV_Frame)yuvFrame;

@end

NS_ASSUME_NONNULL_END
