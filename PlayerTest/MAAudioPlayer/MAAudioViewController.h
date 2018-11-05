//
//  MAAudioViewController.h
//  PlayerTest
//
//  Created by 玉洋 on 2018/11/5.
//  Copyright © 2018 baiyang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MAAudioViewController : UIViewController

@property (nonatomic,readwrite) IBOutlet UIButton *playOrPauseButton;
@property (nonatomic,readwrite) IBOutlet UISlider *progressSlider;

@end

NS_ASSUME_NONNULL_END
