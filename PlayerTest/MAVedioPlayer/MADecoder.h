//
//  MADecoder.h
//  PlayerTest
//
//  Created by 玉洋 on 2018/12/24.
//  Copyright © 2018 baiyang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MADecoder : NSObject

@property (nonatomic,assign) uint64_t duration;  //微秒
//视频流索引
@property (nonatomic,assign)int  videoStreamIndex;
//音频流索引
@property (nonatomic,assign)int  audioStreamIndex;

- (BOOL)openUrl:(const char*)path;

@end

NS_ASSUME_NONNULL_END
