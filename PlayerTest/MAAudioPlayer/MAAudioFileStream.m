//
//  MCAudioFileStream.m
//  PlayerTest
//
//  Created by 玉洋 on 2018/11/5.
//  Copyright © 2018 baiyang. All rights reserved.
//

#import "MAAudioFileStream.h"
#define BitRateEstimationMaxPackets 5000
#define BitRateEstimationMinPackets 10

@interface MAAudioFileStream()
{
    BOOL _discontinuous;
    
    SInt64 _dataOffset;
    NSTimeInterval _packetDuration;
    
    UInt64 _processedPacketsCount;
    UInt64 _processedPacketsSizeTotal;
}

@property (nonatomic, assign) AudioStreamBasicDescription format;



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
    [observer handleAudioFileStream:inAudioFileStream property:inPropertyID];
}

void audioFileStreamPacketsListener(
                                    void *                            inClientData,
                                    UInt32                            inNumberBytes,
                                    UInt32                            inNumberPackets,
                                    const void *                    inInputData,
                                    AudioStreamPacketDescription    *inPacketDescriptions)
{
    MAAudioFileStream* observer = (__bridge MAAudioFileStream*)inClientData;
    [observer handleAudioFileStreamPackets:inInputData
                             numberOfBytes:inNumberBytes
                           numberOfPackets:inNumberPackets
                        packetDescriptions:inPacketDescriptions];
    
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
        
    } else if (propertyID == kAudioFileStreamProperty_DataOffset) {
        UInt32 sizeOfSInt64 = sizeof(SInt64);
        SInt64 offset = 0;
        OSStatus status = AudioFileStreamGetProperty(audioFileStreamID, propertyID, &sizeOfSInt64, &offset);
        if (status != noErr)
        {
            offset = 0;
        }
        _dataOffset = offset;
//        SInt64 audioDataByteCount = _fileSize - offset;
//        NSLog(@"mayinglun log audioDataByteCount:%lld", audioDataByteCount);
        
        
    } else if (propertyID == kAudioFileStreamProperty_FormatList) {
        
        BOOL error = false;
        
        UInt32 dataSize = 0;
        OSStatus status = AudioFileStreamGetPropertyInfo(audioFileStreamID, propertyID, &dataSize, nil);
        if (status != noErr)
        {
            error = true;
        }
        
        AudioFormatListItem* items = malloc(dataSize);
        UInt32 itemSize = sizeof(AudioFormatListItem);
        UInt32 itemCount = dataSize / itemSize;
        status = AudioFileStreamGetProperty(audioFileStreamID, propertyID, &dataSize, items);
        if (status != noErr)
        {
            error = true;
        }
        
        
        status = AudioFileStreamGetPropertyInfo(audioFileStreamID, propertyID, &dataSize, nil);
        if (status != noErr)
        {
            error = true;
        }
        
        UInt32 supportedFormatsSize;
        status = AudioFormatGetPropertyInfo(kAudioFormatProperty_DecodeFormatIDs, 0, NULL, &supportedFormatsSize);
        if (status != noErr)
        {
            error = true;
        }
        
        UInt32 supportedFormatCount = supportedFormatsSize / sizeof(AudioFormatID);
        AudioFormatID* supportedFormats = malloc(supportedFormatsSize);
        status = AudioFormatGetProperty(kAudioFormatProperty_DecodeFormatIDs, 0, NULL, &supportedFormatsSize, supportedFormats);
        if (status != noErr)
        {
            error = true;
        }
        
        if (!error) {
            
            for (int i = 0; i < itemCount; i ++)
            {
                AudioFormatListItem item = items[i];
                
                for (int j = 0; j < supportedFormatCount; j ++)
                {
                    AudioFormatID formatID = supportedFormats[j];
                    if (item.mASBD.mFormatID == formatID) {
                        _format = item.mASBD;
                        if (item.mASBD.mSampleRate > 0 && item.mASBD.mFramesPerPacket > 0)
                        {
                            _packetDuration = item.mASBD.mFramesPerPacket / item.mASBD.mSampleRate;
                        }
                        break;
                    }
                }
            }
            
        }
        free(items);
        free(supportedFormats);
        
    }
    
}

- (void)handleAudioFileStreamPackets:(const void *)packets
                       numberOfBytes:(UInt32)numberOfBytes
                     numberOfPackets:(UInt32)numberOfPackets
                  packetDescriptions:(AudioStreamPacketDescription *)packetDescriptions
{
//    UInt32 offet
    for (int i = 0; i < numberOfPackets; i ++) {
        
//        AudioStreamPacketDescription packetDescription = packetDescriptions[i];
//        NSLog(@"AudioStreamPacketDescription:%llu", packetDescription.mDataByteSize);
        
        NSMutableArray *parsedDataArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < numberOfPackets; ++i) {
            SInt64 packetOffset = packetDescriptions[i].mStartOffset;
            MCParsedAudioData* parseData = [MCParsedAudioData parsedAudioDataWithBytes:packets + packetOffset packetDescription:packetDescriptions[i]];
            
            [parsedDataArray addObject:parseData];
            
            if (_processedPacketsCount < BitRateEstimationMaxPackets)
            {
                _processedPacketsSizeTotal += parseData.packetDescription.mDataByteSize;
                _processedPacketsCount += 1;
                [self calculateBitRate];
                [self calculateDuration];
            }
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

- (void)calculateBitRate
{
    if (_packetDuration && _processedPacketsCount > BitRateEstimationMinPackets && _processedPacketsCount <= BitRateEstimationMaxPackets)
    {
        double averagePacketByteSize = _processedPacketsSizeTotal / _processedPacketsCount;
        _bitRate = 8.0 * averagePacketByteSize / _packetDuration;
    }
}

- (BOOL)parseData:(NSData *)data error:(NSError **)error
{
    OSStatus status = AudioFileStreamParseBytes(_audioFileStreamID,(UInt32)[data length],[data bytes], 0);
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
