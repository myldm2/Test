//
//  MAPlayCore.h
//  PlayerTest
//
//  Created by 玉洋 on 2019/3/11.
//  Copyright © 2019 baiyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAFrameBuffer.h"
#import "MAOpenglView.h"
#import "MAOpenalPlayer.h"

NS_ASSUME_NONNULL_BEGIN

@interface MAPlayCore : NSObject

@property (nonatomic, strong) MAOpenglView* glView;
@property (nonatomic, strong) MAOpenalPlayer* alPlayer;
@property (nonatomic, assign) uint64_t pcmPts;
@property (nonatomic, assign) uint64_t yuvPts;

@end

NS_ASSUME_NONNULL_END
