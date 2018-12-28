//
//  MAOpenglView.h
//  PlayerTest
//
//  Created by 玉洋 on 2018/12/28.
//  Copyright © 2018 baiyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <OpenGLES/EAGL.h>
#include <sys/time.h>
#import "YUV_GL_DATA.h"
#import "MAYUVFrame.h"

NS_ASSUME_NONNULL_BEGIN

@interface MAOpenglView : UIView

- (void)displayYUV420pData:(MAYUVFrame *) frame;
- (void)setVideoSize:(GLuint)width height:(GLuint)height;
- (void)clearFrame;

@end

NS_ASSUME_NONNULL_END
