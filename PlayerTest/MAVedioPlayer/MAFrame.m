//
//  MAFrame.m
//  PlayerTest
//
//  Created by 玉洋 on 2018/12/27.
//  Copyright © 2018 baiyang. All rights reserved.
//

#import "MAFrame.h"

@implementation MAFrame

- (instancetype)init
{
    self = [super init];
    if (self) {
        _frame = av_frame_alloc();
    }
    return self;
}

- (void)dealloc
{
    if (_frame)
    {
        av_frame_free(&_frame);
        _frame = NULL;
    }
}

@end
