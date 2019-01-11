//
//  MAYUVFrame.h
//  PlayerTest
//
//  Created by 玉洋 on 2018/12/28.
//  Copyright © 2018 baiyang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MAYUVFrame : NSObject

@property (nonatomic, assign) int width;
@property (nonatomic, assign) int height;
@property (nonatomic, strong) NSData* luma;
@property (nonatomic, strong) NSData* chromaB;
@property (nonatomic, strong) NSData* chromaR;
@property (nonatomic, assign) int64_t pts;
@property (nonatomic, assign) uint64_t presentTime;

@end

NS_ASSUME_NONNULL_END
