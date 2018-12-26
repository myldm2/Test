//
//  MAVedioPlayer.m
//  PlayerTest
//
//  Created by 玉洋 on 2018/12/26.
//  Copyright © 2018 baiyang. All rights reserved.
//

#import "MAVedioPlayer.h"
#import "MADecoder.h"
#import <UIKit/UIKit.h>
#import "avcodec.h"
#import "swscale.h"
#import "avformat.h"
#import "swresample.h"
#import "samplefmt.h"
#import "YUV_GL_DATA.h"

@interface MAVedioPlayer ()

@property (nonatomic, strong) MADecoder* decoder;
@property (nonatomic, strong) NSLock* lock;
@property (nonatomic, assign) BOOL isExit;


@end

@implementation MAVedioPlayer

+ (instancetype)sharedPlayer
{
    static dispatch_once_t onceToken;
    static MAVedioPlayer *plyer = nil;
    dispatch_once(&onceToken, ^{
        plyer = [[MAVedioPlayer alloc] init];
    });
    return plyer;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _decoder = [[MADecoder alloc] init];
        _lock = [[NSLock alloc] init];
    }
    return self;
}

- (int)openUrl:(NSString*)url playerView:(UIView*)view
{
    int ret = 0;
    NSError* error;
    if (![_decoder openUrl:url error:&error])
    {
        ret = -1;
    }
    return ret;
}

- (void)play
{
    [self startPlayThread];
}

- (void)startPlayThread
{
    dispatch_queue_t readQueue = dispatch_queue_create("VedioReadQueue.MAPlayer.com", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(readQueue, ^{
        AVPacket* pkt = NULL;
        while (!_isExit) {
            pkt = av_packet_alloc();
            [_decoder read:pkt error:NULL];
        }
    });
}

@end
