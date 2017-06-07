//
//  IUiCore.h
//  YYMobile
//
//  Created by 马英伦 on 2017/6/7.
//  Copyright © 2017年 YY.inc. All rights reserved.
//

#ifndef IUiCore_h
#define IUiCore_h

@protocol IUiCore <NSObject>

- (UIViewController*)mainTabBarController;
- (UIViewController*)currentRootViewControllerInStack;
- (UIViewController*)currentVisiableRootViewController;
- (UIViewController*)currentViewController;
- (UIViewController*)currentViewControllerWithTabbar;

@end

#endif /* IUiCore_h */
