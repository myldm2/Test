//
//  OpenGLView.m
//  PlayerTest
//
//  Created by 玉洋 on 2018/11/27.
//  Copyright © 2018 baiyang. All rights reserved.
//

#import "OpenGLView.h"

enum AttribEnum
{
    ATTRIB_VERTEX,
    ATTRIB_TEXTURE,
    ATTRIB_COLOR,
};

//YUV数据枚举
enum TextureType
{
    TEXY = 0,
    TEXU,
    TEXV,
    TEXC
};

@implementation OpenGLView

+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

- (BOOL)setup
{
    return true;
}



@end
