//
//  MATimer.m
//  PlayerTest
//
//  Created by 玉洋 on 2019/1/7.
//  Copyright © 2019 baiyang. All rights reserved.
//

#import "MATimer.h"
#import <QuartzCore/QuartzCore.h>
#import "avcodec.h"

@interface MATimer ()

@property (nonatomic, strong) CADisplayLink* displayLink;

@end

@implementation MATimer

- (instancetype)init
{
    self = [super init];
    if (self) {
        _fps = 60;
        _displayLink = [[CADisplayLink alloc] init];
//        _displayLink.preferredFramesPerSecond = _fps;
    }
    return self;
}

- (void)fire
{
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayAction:)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)displayAction:(CADisplayLink*)displayLink
{
    if (_fps > 0) {
        static uint64_t frame = 0;
        frame ++ ;
        uint64_t timeInterval = AV_TIME_BASE / _fps;
        uint64_t pts = _pts;
        _pts += timeInterval;
        NSLog(@"mayinglun log: pts:%llu  second:%f  frame:%lld", _pts, _pts * 1.0 / AV_TIME_BASE, frame);
        
        if (_delegate && [_delegate respondsToSelector:@selector(timerBetween: and:)])
        {
            [_delegate timerBetween:pts and:_pts];
        }
        
    }
}

@end
