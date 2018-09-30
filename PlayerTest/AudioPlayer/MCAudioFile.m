//
//  MCAudioFile.m
//  PlayerTest
//
//  Created by 玉洋 on 2018/9/30.
//  Copyright © 2018年 baiyang. All rights reserved.
//

#import "MCAudioFile.h"
#import <AudioToolbox/AudioToolbox.h>



@interface MCAudioFile()
{
    SInt64 _packetOffset;
    NSFileHandle *_fileHandler;
    SInt64 _dataOffset;
    NSTimeInterval _packetDuration;
    AudioFileID _audioFileID;
}


@end

@implementation MCAudioFile

- (instancetype)initWithFilePath:(NSString *)filePath fileType:(id)fileType
{
    self = [super init];
    if (self) {
        _filePath = filePath;
        _fileType = fileType;
        
        _fileHandler = [NSFileHandle fileHandleForReadingAtPath:_filePath];
        _fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:_filePath error:nil] fileSize];
        if (_fileHandler && _fileSize > 0)
        {
//            if ([self ])
        } else {
            [_fileHandler closeFile];
        }
    }
    return self;
}

#pragma mark - audiofile
- (BOOL)_openAudioFile
{
    OSStatus status = AudioFileOpenWithCallbacks((__bridge void*)self, MCAudioFileReadCallBack, NULL, MCAudioFileGetSizeCallBack, NULL, _fileType, &_audioFileID);
    if (status != noErr) {
        _audioFileID = NULL;
        return NO;
    }
    return YES;
}

- (void)_closeAudioFile
{
    if (self.available)
    {
        AudioFileClose(_audioFileID);
        _audioFileID = NULL;
    }
}

- (void)_calculateDuration
{
    if (_format.mSampleRate > 0)
    {
        _packetDuration = _format.mFramesPerPacket / _format.mSampleRate;
    }
}

- (UInt32)availableDataLengthAtOffset:(SInt64)inPosition maxLength:(UInt32)requestCount
{
    if ((inPosition + requestCount) > _fileSize)
    {
        if (inPosition > _fileSize)
        {
            return 0;
        }
        else
        {
            return (UInt32)(_fileSize - inPosition);
        }
    }
    else
    {
        return requestCount;
    }
}

- (NSData *)dataAtOffset:(SInt64)inPosition length:(UInt32)length
{
    [_fileHandler seekToFileOffset:inPosition];
    return [_fileHandler readDataOfLength:length];
}

- (void)_fetchFormatInfo
{
    UInt32 formatListSize;
    OSStatus status = AudioFileGetProperty(_audioFileID, kAudioFilePropertyFormatList, &formatListSize, NULL);
    if (status == noErr)
    {
        BOOL found = NO;
        AudioFormatListItem* formatList = malloc(formatListSize);
        OSStatus status = AudioFileGetProperty(_audioFileID, kAudioFilePropertyFormatList, &formatListSize, formatList);
        if (status != noErr)
        {
            UInt32 supportedFormatsSize;
            status = AudioFormatGetPropertyInfo(kAudioFormatProperty_DecodeFormatIDs, 0, NULL, &supportedFormatsSize);
            if (status != noErr)
            {
                free(formatList);
                [self _closeAudioFile];
                return;
            }
            
            UInt32 supportedFormatCount = supportedFormatsSize / sizeof(OSType);
            OSType* supportedFormats = (OSType*)malloc(supportedFormatsSize);
            status = AudioFormatGetProperty(kAudioFormatProperty_DecodeFormatIDs, 0, NULL, &supportedFormatsSize, supportedFormats);
            if (status != noErr)
            {
                free(formatList);
                free(supportedFormats);
                [self _closeAudioFile];
                return;
            }
            
            for (int i = 0; i * sizeof(AudioFormatListItem) < formatListSize; i ++)
            {
                AudioStreamBasicDescription format = formatList[i].mASBD;
                for (UInt32 j = 0; j < supportedFormatCount; ++j)
                {
                    if (format.mFormatID == supportedFormats[j])
                    {
                        _format = format;
                        found = YES;
                        break;
                    }
                }
            }
            free(supportedFormats);
        }
        free(formatList);
        
        if (!found)
        {
            [self _closeAudioFile];
            return;
        } else {
            [self _calculateDuration];
        }
    }
    
    //TODO:
    
}

static OSStatus MCAudioFileReadCallBack(void *inClientData, SInt64 inPosition, UInt32 requestCount, void *buffer, UInt32 *actualCount)
{
    MCAudioFile *audioFile = (__bridge MCAudioFile*)inClientData;
    *actualCount = [audioFile availableDataLengthAtOffset:inPosition maxLength:requestCount];
    if (*actualCount > 0) {
        NSData* data = [audioFile dataAtOffset:inPosition length:*actualCount];
        memcpy(buffer, [data bytes], *actualCount);
    }
    return noErr;
}

static SInt64 MCAudioFileGetSizeCallBack(void *inClientData)
{
    MCAudioFile* audioFile = (__bridge MCAudioFile*)inClientData;
    return audioFile.fileSize;
}

@end


