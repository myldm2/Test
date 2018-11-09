//
//  MAAudioViewController.m
//  PlayerTest
//
//  Created by 玉洋 on 2018/11/5.
//  Copyright © 2018 baiyang. All rights reserved.
//

#import "MAAudioViewController.h"
#import "MAAudioFileStream.h"
#import "MAAudioOutputQueue.h"
#import "MCParsedAudioData.h"
#import "MAAudioBuffer.h"

@interface MAAudioViewController () <MAAudioFileStreamDelegate>
{
    MAAudioFileStream *_audioFileStream;
    MAAudioOutputQueue *_audioQueue;
    unsigned long long _fileSize;
    NSFileHandle *_fileHandler;
    MAAudioBuffer *_buffer;
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
    _audioFileStream.delegate = self;
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

- (void)audioFileStream:(MAAudioFileStream *)audioFileStream audioDataParsed:(NSArray *)audioData
{
//    if (_audioQueue == nil) {
//        NSData* magicData = [_audioFileStream fetchMagicCookie];
//        _audioQueue = [[MAAudioOutputQueue alloc] initWithFormat:_audioFileStream.format  macgicCookie:magicData];
//        [_audioQueue resume];
//    }
//
//
//    for (MCParsedAudioData* data in audioData) {
//        AudioStreamPacketDescription packetDescription = data.packetDescription;
//        AudioStreamPacketDescription * packetDescriptions = &packetDescription;
//        [_audioQueue playData:data.data packetCount:1 packetDescriptions:packetDescriptions isEof:true];
//    }
    
    if (_buffer == nil)
    {
        _buffer = [MAAudioBuffer buffer];
    }
    for (MCParsedAudioData* data in audioData) {
        [_buffer enqueueData:data];
    }

    
}

- (void)audioFileStreamReadyToProducePackets:(MAAudioFileStream *)audioFileStream
{
    
}

- (void)audioFileStreamFinishProducePackets:(MAAudioFileStream *)audioFileStream
{
    if (_audioQueue == nil) {
        NSData* magicData = [_audioFileStream fetchMagicCookie];
        _audioQueue = [[MAAudioOutputQueue alloc] initWithFormat:_audioFileStream.format  macgicCookie:magicData];
        [_audioQueue resume];
    }
    
    UInt32 count = (UInt32)_buffer.datas.count;
    
    for (int i = 0; i < count; i ++) {
        UInt32 c = 1;

        AudioStreamPacketDescription* desces = NULL;
        NSData* data = [_buffer dequeueCount:&c descriptions:&desces];

        [_audioQueue playData:data packetCount:c packetDescriptions:desces isEof:false];
    }

    
//    UInt32 c = count;
//    AudioStreamPacketDescription* desces = NULL;
//    NSData* data = [_buffer dequeueCount:&c descriptions:&desces];
//    [_audioQueue playData:data packetCount:c packetDescriptions:desces isEof:true];

    

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
