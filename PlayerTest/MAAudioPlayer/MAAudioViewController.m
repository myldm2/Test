//
//  MAAudioViewController.m
//  PlayerTest
//
//  Created by 玉洋 on 2018/11/5.
//  Copyright © 2018 baiyang. All rights reserved.
//

#import "MAAudioViewController.h"
#import "MAAudioFileStream.h"

@interface MAAudioViewController ()
{
    MAAudioFileStream *_audioFileStream;
    unsigned long long _fileSize;
    NSFileHandle *_fileHandler;
}


@end

@implementation MAAudioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSError* error = nil;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"QQMusicCache-101786885-13-0" ofType:@"mp3"];
    _fileHandler = [NSFileHandle fileHandleForReadingAtPath:path];
    _fileSize = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil].fileSize;
    
    _audioFileStream = [[MAAudioFileStream alloc] initWithFileType:kAudioFileMP3Type fileSize:_fileSize error:&error];
    if (!error)
    {
//        _failed = NO;
//        _audioFileStream.delegate = self;
        [self loadData];
    }
    
}

- (void)loadData
{
    unsigned long long offset = 0;
    unsigned long long readSize = 1000;
    while (offset < _fileSize) {
        
        @autoreleasepool {
            [_fileHandler seekToFileOffset:offset];
            NSData* data = [_fileHandler readDataOfLength:readSize];
            [_audioFileStream parseData:data error:nil];
            offset = offset + readSize;
        }

    }
}

#pragma mark - action
- (IBAction)playOrPause:(id)sender
{
//    if (_player.isPlayingOrWaiting)
//    {
//        [_player pause];
//    }
//    else
//    {
//        [_player play];
//    }
}

- (IBAction)stop:(id)sender
{
//    [_player stop];
}

- (IBAction)seek:(id)sender
{
//    _player.progress = _player.duration * self.progressSlider.value;
}
@end
