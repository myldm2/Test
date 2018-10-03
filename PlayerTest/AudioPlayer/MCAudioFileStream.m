//
//  MCAudioFileStream.m
//  PlayerTest
//
//  Created by 玉洋 on 2018/10/2.
//  Copyright © 2018年 baiyang. All rights reserved.
//

#import "MCAudioFileStream.h"

#define BitRateEstimationMaxPackets 5000
#define BitRateEstimationMinPackets 10

@interface MCAudioFileStream ()
{
    BOOL _discontinuous;
    
    AudioFileStreamID _audioFileStreamID;
    
    SInt64 _dataOffset;
    NSTimeInterval _packetDuration;
    
    UInt64 _processedPacketsCount;
    UInt64 _processedPacketsSizeTotal;
}

@end

@implementation MCAudioFileStream

static void MCAudioFileStreamPropertyListener(void *inClientData,
                                              AudioFileStreamID inAudioFileStream,
                                              AudioFileStreamPropertyID inPropertyID,
                                              UInt32 *ioFlags)
{
    MCAudioFileStream* audioFileStream = (__bridge MCAudioFileStream *)inClientData;
    [audioFileStream handleAudioFileStreamProperty:inPropertyID];
}

static void MCAudioFileStreamPacketsCallBack(void *inClientData,
                                             UInt32 inNumberBytes,
                                             UInt32 inNumberPackets,
                                             const void *inInputData,
                                             AudioStreamPacketDescription *inPacketDescriptions)
{
    MCAudioFileStream *audioFileStream = (__bridge MCAudioFileStream *)inClientData;
//    [audioFileStream handleAudioFileStreamPackets:inInputData
//                                    numberOfBytes:inNumberBytes
//                                  numberOfPackets:inNumberPackets
//                               packetDescriptions:inPacketDescriptions];
}

- (instancetype)initWithFileType:(AudioFileTypeID)fileType fileSize:(unsigned long long)fileSize error:(NSError * _Nullable __autoreleasing *)error
{
    self = [super init];
    if (self) {
        _discontinuous = NO;
        _fileType = fileType;
        _fileSize = fileSize;
        
    }
    return self;
}

- (BOOL)_openAudioFileStreamWithFileTypeHint:(AudioFileTypeID)fileTypeHint error:(NSError* __autoreleasing *)error
{
    OSStatus status = AudioFileStreamOpen((__bridge void*)self, MCAudioFileStreamPropertyListener, MCAudioFileStreamPacketsCallBack, fileTypeHint, &_audioFileStreamID);
    if (status != noErr)
    {
        _audioFileStreamID = NULL;
    }
    [self _errorForOSStatus:status error:error];
    return status == noErr;
}

- (void)handleAudioFileStreamProperty:(AudioFileStreamPropertyID)propertyID
{
    if (propertyID == kAudioFileStreamProperty_ReadyToProducePackets)
    {
        _readyToProducePackets = YES;
        _discontinuous = YES;
        
        UInt32 sizeOfUInt32 = sizeof(_maxPacketSize);
        OSStatus status = AudioFileStreamGetProperty(_audioFileStreamID, kAudioFileStreamProperty_PacketSizeUpperBound, &sizeOfUInt32, &_maxPacketSize);
        if (status != noErr || _maxPacketSize == 0)
        {
            status = AudioFileStreamGetProperty(_audioFileStreamID, kAudioFileStreamProperty_MaximumPacketSize, &sizeOfUInt32, &_maxPacketSize);
        }
        
        if (_delegate && [_delegate respondsToSelector:@selector(audioFileStreamReadyToProducePackets:)])
        {
            [_delegate audioFileStreamReadyToProducePackets:self];
        }
    } else if (propertyID == kAudioFileStreamProperty_DataOffset)
    {
        UInt32 offsetSize = sizeof(_dataOffset);
        AudioFileStreamGetProperty(_audioFileStreamID, kAudioFileStreamProperty_DataOffset, &offsetSize, &_dataOffset);
        _audioDataByteCount = _fileSize - _dataOffset;
        [self calculateDuration];
    } else if (propertyID == kAudioFileStreamProperty_DataFormat)
    {
        UInt32 asbdSize = sizeof(_format);
        AudioFileStreamGetProperty(_audioFileStreamID, kAudioFileStreamProperty_DataFormat, &asbdSize, &_format);
        [self calculatePacketDuration];
    } else if (propertyID == kAudioFileStreamProperty_FormatList)
    {
        Boolean ourWriteable;
        UInt32 formatListSize;
        OSStatus status = AudioFileStreamGetPropertyInfo(_audioFileStreamID, kAudioFileStreamProperty_FormatList, &formatListSize, &ourWriteable);
        if (status == noErr)
        {
            AudioFormatListItem* formatList = malloc(formatListSize);
            OSStatus status = AudioFileStreamGetProperty(_audioFileStreamID, kAudioFileStreamProperty_FormatList, &formatListSize, formatList);
            if (status == noErr)
            {
                UInt32 supportedFormatsSize;
                status = AudioFormatGetPropertyInfo(kAudioFormatProperty_DecodeFormatIDs, 0, NULL, &supportedFormatsSize);
                if (status != noErr)
                {
                    free(formatList);
                    return;
                }
                UInt32 supportedFormatCount = supportedFormatsSize / sizeof(OSType);
                OSType* supportedFormats = (OSType*)malloc(supportedFormatsSize);
                status = AudioFormatGetProperty(kAudioFormatProperty_DecodeFormatIDs, 0, NULL, &supportedFormatsSize, supportedFormats);
                if (status != noErr)
                {
                    free(formatList);
                    free(supportedFormats);
                    return;
                }
                
                for (int i = 0; i * sizeof(AudioFormatListItem) < formatListSize; i += sizeof(AudioFormatListItem))
                {
                    AudioStreamBasicDescription format = formatList[i].mASBD;
                    for (UInt32 j = 0; j < supportedFormatCount; ++j) {
                        if (format.mFormatID == supportedFormats[j])
                        {
                            _format = format;
                            [self calculatePacketDuration];
                            break;
                        }
                    }
                }
                free(supportedFormats);
            }
            free(formatList);
        }
    }
}

- (void)calculateDuration
{
    if (_fileSize > 0 && _bitRate > 0)
    {
        _duration = ((_fileSize - _dataOffset) * 8.0) / _bitRate;
    }
}

- (void)calculatePacketDuration
{
    if (_format.mSampleRate > 0)
    {
        _packetDuration = _format.mFramesPerPacket / _format.mSampleRate;
    }
}

- (void)_errorForOSStatus:(OSStatus)status error:(NSError *__autoreleasing *)outError
{
    if (status != noErr && outError != NULL)
    {
        *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
    }
}

- (void)handleAudioFileStreamPackets:(const void *)packets
                       numberOfBytes:(UInt32)numberOfBytes
                     numberOfPackets:(UInt32)numberOfPackets
                  packetDescriptions:(AudioStreamBasicDescription *)packetDescriptions
{
    
}

@end
