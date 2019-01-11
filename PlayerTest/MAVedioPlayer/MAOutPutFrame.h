//
//  MAOutPutFrame.h
//  PlayerTest
//
//  Created by 玉洋 on 2019/1/11.
//  Copyright © 2019 baiyang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MAOutPutFrame : NSObject

@property (nonatomic, assign) int64_t pts;
@property (nonatomic, assign) uint64_t presentTime;

@end

NS_ASSUME_NONNULL_END
