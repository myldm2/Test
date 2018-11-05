//
//  MCAudioFileStream.m
//  PlayerTest
//
//  Created by 玉洋 on 2018/11/5.
//  Copyright © 2018 baiyang. All rights reserved.
//

#import "MAAudioFileStream.h"


@interface MAAudioFileStream()
{
    BOOL _discontinuous;
}

@property (nonatomic, assign) AudioFileStreamID audioFileStreamID;

- (void)handleAudioFileStream:(AudioFileStreamID)audioFileStreamID property:(AudioFileStreamPropertyID)propertyID;

@end

@implementation MAAudioFileStream

void audioFileStreamPropertyListener(
                                             void *                            inClientData,
                                             AudioFileStreamID                inAudioFileStream,
                                             AudioFileStreamPropertyID        inPropertyID,
                                             AudioFileStreamPropertyFlags *    ioFlags)
{
    MAAudioFileStream* observer = (__bridge MAAudioFileStream*)inClientData;
    if (observer.audioFileStreamID == inAudioFileStream)
    {
        [observer handleAudioFileStream:inAudioFileStream property:inPropertyID];
    }
    
}

void audioFileStreamPacketsListener(
                                    void *                            inClientData,
                                    UInt32                            inNumberBytes,
                                    UInt32                            inNumberPackets,
                                    const void *                    inInputData,
                                    AudioStreamPacketDescription    *inPacketDescriptions)
{
    
}

- (instancetype)initWithFileType:(AudioFileTypeID)fileType fileSize:(unsigned long long)fileSize error:(NSError * _Nullable __autoreleasing *)error
{
    self = [super init];
    if (self) {
        _discontinuous = NO;
        _fileType = fileType;
        _fileSize = fileSize;
        [self _openAudioFileStreamWithFileTypeHint:_fileType error:error];
    }
    return self;
}

- (BOOL)_openAudioFileStreamWithFileTypeHint:(AudioFileTypeID)fileTypeHint error:(NSError* __autoreleasing *)error
{
    OSStatus status = AudioFileStreamOpen((__bridge void *)self, audioFileStreamPropertyListener, audioFileStreamPacketsListener, fileTypeHint, &_audioFileStreamID);
    if (status != noErr)
    {
        _audioFileStreamID = nil;
        return NO;
    }
    return YES;
}

- (void)handleAudioFileStream:(AudioFileStreamID)audioFileStreamID property:(AudioFileStreamPropertyID)propertyID
{
//    kAudioFileStreamProperty_ReadyToProducePackets            =    'redy',
//    kAudioFileStreamProperty_FileFormat                        =    'ffmt',
//    kAudioFileStreamProperty_DataFormat                        =    'dfmt',
//    kAudioFileStreamProperty_FormatList                        =    'flst',
//    kAudioFileStreamProperty_MagicCookieData                =    'mgic',
//    kAudioFileStreamProperty_AudioDataByteCount                =    'bcnt',
//    kAudioFileStreamProperty_AudioDataPacketCount            =    'pcnt',
//    kAudioFileStreamProperty_MaximumPacketSize                =    'psze',
//    kAudioFileStreamProperty_DataOffset                        =    'doff',
//    kAudioFileStreamProperty_ChannelLayout                    =    'cmap',
//    kAudioFileStreamProperty_PacketToFrame                    =    'pkfr',
//    kAudioFileStreamProperty_FrameToPacket                    =    'frpk',
//    kAudioFileStreamProperty_PacketToByte                    =    'pkby',
//    kAudioFileStreamProperty_ByteToPacket                    =    'bypk',
//    kAudioFileStreamProperty_PacketTableInfo                =    'pnfo',
//    kAudioFileStreamProperty_PacketSizeUpperBound              =    'pkub',
//    kAudioFileStreamProperty_AverageBytesPerPacket            =    'abpp',
//    kAudioFileStreamProperty_BitRate                        =    'brat',
//    kAudioFileStreamProperty_InfoDictionary
    
    if (propertyID == kAudioFileStreamProperty_ReadyToProducePackets) {
        
        UInt32 sizeOfUInt32 = sizeof(_maxPacketSize);
        OSStatus status = AudioFileStreamGetProperty(audioFileStreamID, kAudioFileStreamProperty_PacketSizeUpperBound, &sizeOfUInt32, &_maxPacketSize);
        if (status != noErr || _maxPacketSize == 0)
        {
            status = AudioFileStreamGetProperty(audioFileStreamID, kAudioFileStreamProperty_MaximumPacketSize, &sizeOfUInt32, &_maxPacketSize);
        }
        
    } else if (propertyID == kAudioFileStreamProperty_BitRate) {
        
        UInt32 sizeOfUInt32 = sizeof(UInt32);
        UInt32 bitRate = 0;
        OSStatus status = AudioFileStreamGetProperty(audioFileStreamID, kAudioFileStreamProperty_PacketSizeUpperBound, &sizeOfUInt32, &bitRate);
        if (status != noErr)
        {
            bitRate = 0;
        }
        
    } else if (propertyID == kAudioFileStreamProperty_FormatList) {
        UInt32 dataSize = 0;
        OSStatus status = AudioFileStreamGetPropertyInfo(audioFileStreamID, propertyID, &dataSize, nil);
        if (status == noErr && dataSize > 0)
        {
            return;
        }
        
        AudioFormatListItem* items = malloc(dataSize);
        status = AudioFileStreamGetProperty(audioFileStreamID, propertyID, &dataSize, items);
        if (status == noErr)
        {
            return;
        }
        
        
        status = AudioFileStreamGetPropertyInfo(audioFileStreamID, propertyID, &dataSize, nil);
        if (status == noErr && dataSize > 0)
        {
            return;
        }
        
        UInt32 supportedFormatsSize;
        status = AudioFormatGetPropertyInfo(kAudioFormatProperty_DecodeFormatIDs, 0, NULL, &supportedFormatsSize);
        if (status != noErr)
        {
            return;
        }
        UInt32 supportedFormatCount = supportedFormatsSize / sizeof(AudioFormatID);
        AudioFormatID* supportedFormats = malloc(supportedFormatsSize);
        
        
        
        UInt32 itemSize = sizeof(AudioFormatListItem);
        UInt32 itemCount = dataSize / itemSize;
        NSTimeInterval duration = 0;
        
        for (int i = 0; i < itemCount; i ++)
        {
            AudioFormatListItem item = items[i];
            if (item.mASBD.mSampleRate > 0)
            {
                NSTimeInterval packageDuration = item.mASBD.mFramesPerPacket / item.mASBD.mSampleRate;
                duration += packageDuration;
                NSLog(@"mayinglun log: packageDuration:%f", packageDuration);
            }
        }
            
//        AudioFormatListItem
        
    }
    
}

- (BOOL)parseData:(NSData *)data error:(NSError **)error
{
    OSStatus status = AudioFileStreamParseBytes(_audioFileStreamID,(UInt32)[data length],[data bytes],kAudioFileStreamParseFlag_Discontinuity );
    [self _errorForOSStatus:status error:error];
    return status == noErr;
}

- (void)_errorForOSStatus:(OSStatus)status error:(NSError *__autoreleasing *)outError
{
    if (status != noErr && outError != NULL)
    {
        *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
    }
}

@end
