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
@property (nonatomic, assign) int sampleRate;
@property (nonatomic, assign) int sampleSize;
@property (nonatomic, assign) int channel;

@end

NS_ASSUME_NONNULL_END
