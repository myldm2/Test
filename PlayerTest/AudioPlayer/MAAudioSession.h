//
//  AudioSession.h
//  PlayerTest
//
//  Created by 玉洋 on 2018/9/17.
//  Copyright © 2018年 baiyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

/* route change notification  */
FOUNDATION_EXPORT NSString *const MAAudioSessionRouteChangeNotification;
/* a NSNumber of SInt32
 enum {
 kAudioSessionRouteChangeReason_Unknown = 0,
 kAudioSessionRouteChangeReason_NewDeviceAvailable = 1,
 kAudioSessionRouteChangeReason_OldDeviceUnavailable = 2,
 kAudioSessionRouteChangeReason_CategoryChange = 3,
 kAudioSessionRouteChangeReason_Override = 4,
 kAudioSessionRouteChangeReason_WakeFromSleep = 6,
 kAudioSessionRouteChangeReason_NoSuitableRouteForCategory = 7,
 kAudioSessionRouteChangeReason_RouteConfigurationChange = 8
 };
 */
FOUNDATION_EXPORT NSString *const MAAudioSessionRouteChangeReason;

/* interrupt notification */
FOUNDATION_EXPORT NSString *const MAAudioSessionInterruptionNotification;
/* a NSNumber of kAudioSessionBeginInterruption or kAudioSessionEndInterruption */
FOUNDATION_EXPORT NSString *const MAAudioSessionInterruptionStateKey;
/* Only present for kAudioSessionEndInterruption. a NSNumber of AudioSessionInterruptionType.*/
FOUNDATION_EXPORT NSString *const MAAudioSessionInterruptionTypeKey;

@interface MAAudioSession : NSObject

+ (MAAudioSession*)sharedInstance;

- (BOOL)setActive:(BOOL)active error:(NSError **)outError;
/**
 *  options:
 *  enum {
 *       kAudioSessionSetActiveFlag_NotifyOthersOnDeactivation       = (1 << 0)  //  0x01
 *   };
 *
 */
- (BOOL)setActive:(BOOL)active options:(UInt32)options error:(NSError **)outError;

/**
 *  enum {
 *   kAudioSessionCategory_AmbientSound               = 'ambi',
 *   kAudioSessionCategory_SoloAmbientSound           = 'solo',
 *   kAudioSessionCategory_MediaPlayback              = 'medi',
 *   kAudioSessionCategory_RecordAudio                = 'reca',
 *   kAudioSessionCategory_PlayAndRecord              = 'plar',
 *   kAudioSessionCategory_AudioProcessing            = 'proc'
 *   };
 */
- (BOOL)setCategory:(UInt32)category error:(NSError **)outError;


//+ (BOOL)usingHeadset;
//+ (BOOL)isAirplayActived;

@end
