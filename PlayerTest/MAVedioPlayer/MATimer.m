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
        _fps = 15;
        _displayLink = [[CADisplayLink alloc] init];
    }
    return self;
}

- (void)play
{
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayAction:)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    _displayLink.preferredFramesPerSecond = _fps;
}

- (void)pause
{
    [_displayLink invalidate];
    _displayLink = nil;
}

- (void)displayAction:(CADisplayLink*)displayLink
{
    if (_fps > 0) {
        uint64_t timeInterval = AV_TIME_BASE / _fps;
        uint64_t ptsStart = _pts;
        uint64_t ptsEnd = _pts + timeInterval;
        if (_delegate && [_delegate respondsToSelector:@selector(timerBetween: and:)])
        {
            if ([_delegate timerBetween:ptsStart and:ptsEnd])
            {
                _pts = ptsEnd;
            }
        }
    }
}

@end
