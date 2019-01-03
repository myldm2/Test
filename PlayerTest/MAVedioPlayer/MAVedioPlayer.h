//
//  MAVedioPlayer.h
//  PlayerTest
//
//  Created by 玉洋 on 2018/12/26.
//  Copyright © 2018 baiyang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MAVedioPlayer : NSObject

+ (instancetype)sharedPlayer;

- (int)openUrl:(NSString*)url playerView:(UIView*)view;

- (void)play;

- (void)stop;

@end

NS_ASSUME_NONNULL_END
