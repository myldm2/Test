//
//  XPlayer.h
//  PlayerTest
//
//  Created by 玉洋 on 2018/12/17.
//  Copyright © 2018 baiyang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XPlayer : NSObject

+ (instancetype)sharedPlayer;

- (int)openUrl:(NSString *)url andWithPlayView:(UIView*)view;
- (void)play;
- (void)stop;
- (void)pause;
//播放速率
@property (nonatomic ,assign)float  playRate;
//音视频同步参数
@property (nonatomic ,assign)float  syncRate;
@property (nonatomic ,assign)BOOL   isStop;

@end

NS_ASSUME_NONNULL_END
