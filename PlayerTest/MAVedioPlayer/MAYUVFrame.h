//
//  MAYUVFrame.h
//  PlayerTest
//
//  Created by 玉洋 on 2018/12/28.
//  Copyright © 2018 baiyang. All rights reserved.
//

#import "MAOutPutFrame.h"

NS_ASSUME_NONNULL_BEGIN

@interface MAYUVFrame : MAOutPutFrame

@property (nonatomic, assign) int width;
@property (nonatomic, assign) int height;
@property (nonatomic, strong) NSData* luma;
@property (nonatomic, strong) NSData* chromaB;
@property (nonatomic, strong) NSData* chromaR;

@end

NS_ASSUME_NONNULL_END
