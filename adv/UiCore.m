//
//  UiCore.m
//  YYMobile
//
//  Created by 马英伦 on 2017/6/7.
//  Copyright © 2017年 YY.inc. All rights reserved.
//

#import "UiCore.h"
#import "YYViewControllerCenter.h"

@implementation UiCore

- (UIViewController*)mainTabBarController
{
    return [YYViewControllerCenter mainTabBarController];
}

- (UIViewController*)currentRootViewControllerInStack
{
    return [YYViewControllerCenter currentRootViewControllerInStack];
}

- (UIViewController*)currentVisiableRootViewController
{
    return [YYViewControllerCenter currentVisiableRootViewController];
}

- (UIViewController*)currentViewController
{
    return [YYViewControllerCenter currentViewController];
}

- (UIViewController*)currentViewControllerWithTabbar
{
    return [YYViewControllerCenter currentViewControllerWithTabbar];
}



@end
