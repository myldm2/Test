//
//  AudioPlayer.m
//  PlayerTest
//
//  Created by 玉洋 on 2018/9/17.
//  Copyright © 2018年 baiyang. All rights reserved.
//

#import "MAAudioPlayer.h"
//#import <AVAudioSession>

@interface MAAudioPlayer()
{
    NSFileHandle* _fileHandler;
    unsigned long long _fileSize;
    BOOL _started;
    NSThread* _thread;
    
}

@end

@implementation MAAudioPlayer

- (instancetype)initWithFilePath:(NSString *)filePath fileType:(AudioFileTypeID)fileType
{
    self = [super init];
    if (self) {
//        _filePath = filePath;
//        _fileType = fileType;
        
//        _fileHandler = [NSFileHandle fileHandleForReadingAtPath:_filePath];
//        _fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:_filePath error:nil] fileSize];
        
    }
    return self;
}

- (void)play
{
    if (!_started)
    {
        _started = YES;
        _thread = [[NSThread alloc] initWithTarget:self selector:@selector(threadMain) object:nil];
        [_thread start];
    }
    else
    {
        //如果是Pause状态就resume
    }
}

- (void)threadMain
{
//    if ([[MCAudioSession sharedInstance] setCategory:kAudioSessionCategory_MediaPlayback error:NULL])
//    {
//        //active audiosession
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(interruptHandler:) name:MCAudioSessionInterruptionNotification object:nil];
//        if ([[MCAudioSession sharedInstance] setActive:YES error:NULL])
//        {
//            //go on
//        }
//    }
}

@end
