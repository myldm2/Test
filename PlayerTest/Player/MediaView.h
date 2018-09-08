//
//  MediaView.h
//  PlayerTest
//
//  Created by baiyang on 2018/2/27.
//  Copyright © 2018年 baiyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MediaView : UIView

- (void)display:(NSData*)imageData width:(GLsizei)width height:(GLsizei)height;

@end
