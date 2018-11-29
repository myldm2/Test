//
//  OpenGLView.h
//  PlayerTest
//
//  Created by 玉洋 on 2018/11/27.
//  Copyright © 2018 baiyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <OpenGLES/EAGL.h>
#include <sys/time.h>
//#import "YUV_GL_DATA.h"

NS_ASSUME_NONNULL_BEGIN

@interface OpenGLView : UIView

//- (void)displayYUV420pData:(H264YUV_Frame *) frame;
- (void)setVideoSize:(GLuint)width height:(GLuint)height;
- (void)clearFrame;

@end

NS_ASSUME_NONNULL_END
