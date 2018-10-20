//
//  AudioViewController.h
//  PlayerTest
//
//  Created by 玉洋 on 2018/10/14.
//  Copyright © 2018年 baiyang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AudioViewController : UIViewController

@property (nonatomic,readwrite) IBOutlet UIButton *playOrPauseButton;
@property (nonatomic,readwrite) IBOutlet UISlider *progressSlider;

@end

NS_ASSUME_NONNULL_END
