//
//  MAPCMFrame.h
//  PlayerTest
//
//  Created by 玉洋 on 2019/1/9.
//  Copyright © 2019 baiyang. All rights reserved.
//

#import "MAOutPutFrame.h"

NS_ASSUME_NONNULL_BEGIN

@interface MAPCMFrame : MAOutPutFrame

@property (nonatomic, strong) NSData* pcm;
@property (nonatomic, assign) int64_t sampleRate;
@property (nonatomic, assign) int64_t sampleSize;
@property (nonatomic, assign) int64_t channel;

@end

NS_ASSUME_NONNULL_END
