//
//  MAFrame.h
//  PlayerTest
//
//  Created by 玉洋 on 2018/12/27.
//  Copyright © 2018 baiyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "avcodec.h"

NS_ASSUME_NONNULL_BEGIN

@interface MAFrame : NSObject

@property (nonatomic, assign, readonly) AVFrame* frame;
@property (nonatomic, assign) uint64_t presentTime;

@end

NS_ASSUME_NONNULL_END
