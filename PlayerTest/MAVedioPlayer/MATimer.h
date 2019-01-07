//
//  MATimer.h
//  PlayerTest
//
//  Created by 玉洋 on 2019/1/7.
//  Copyright © 2019 baiyang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MATimerDelegate <NSObject>

- (void)timerBetween:(uint64_t)time1 and:(uint64_t)time2;

@end

@interface MATimer : NSObject

@property (nonatomic, assign) uint64_t fps;
@property (nonatomic, assign, readonly) uint64_t pts;
@property (nonatomic, weak) id<MATimerDelegate> delegate;

- (void)fire;

@end

NS_ASSUME_NONNULL_END
