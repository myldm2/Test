//
//  AudioSession.m
//  PlayerTest
//
//  Created by 玉洋 on 2018/9/17.
//  Copyright © 2018年 baiyang. All rights reserved.
//

#import "MAAudioSession.h"

NSString *const MAAudioSessionRouteChangeNotification = @"MAAudioSessionRouteChangeNotification";
NSString *const MAAudioSessionRouteChangeReason = @"MAAudioSessionRouteChangeReason";
NSString *const MAAudioSessionInterruptionNotification = @"MAAudioSessionInterruptionNotification";
NSString *const MAAudioSessionInterruptionStateKey = @"MAAudioSessionInterruptionStateKey";
NSString *const MAAudioSessionInterruptionTypeKey = @"MAAudioSessionInterruptionTypeKey";

static void MAAudioSessionInterruptionListener(void *inClientData, UInt32 inInterruptionState)
{
    AudioSessionInterruptionType interruptionType = kAudioSessionInterruptionType_ShouldNotResume;
    UInt32 interruptionTypeSize = sizeof(interruptionType);
    AudioSessionGetProperty(kAudioSessionProperty_InterruptionType,
                            &interruptionTypeSize,
                            &interruptionType);
    
    NSDictionary *userInfo = @{MAAudioSessionInterruptionStateKey:@(inInterruptionState),
                               MAAudioSessionInterruptionTypeKey:@(interruptionType)};
    MAAudioSession *audioSession = (__bridge MAAudioSession *)inClientData;
    [[NSNotificationCenter defaultCenter] postNotificationName:MAAudioSessionInterruptionNotification object:audioSession userInfo:userInfo];
}

static void MAAudioSessionRouteChangeListener(void *inClientData, AudioSessionPropertyID inPropertyID, UInt32 inPropertyValueSize, const void *inPropertyValue)
{
    if (inPropertyID != kAudioSessionProperty_AudioRouteChange)
    {
        return;
    }
    CFDictionaryRef routeChangeDictionary = inPropertyValue;
    CFNumberRef routeChangeReasonRef = CFDictionaryGetValue (routeChangeDictionary, CFSTR (kAudioSession_AudioRouteChangeKey_Reason));
    SInt32 routeChangeReason;
    CFNumberGetValue (routeChangeReasonRef, kCFNumberSInt32Type, &routeChangeReason);
    
    NSDictionary *userInfo = @{MAAudioSessionRouteChangeReason:@(routeChangeReason)};
    MAAudioSession *audioSession = (__bridge MAAudioSession *)inClientData;
    [[NSNotificationCenter defaultCenter] postNotificationName:MAAudioSessionRouteChangeNotification object:audioSession userInfo:userInfo];
}

@implementation MAAudioSession

+ (MAAudioSession*)sharedInstance
{
    static dispatch_once_t once;
    static MAAudioSession *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _initializeAudioSession];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)_initializeAudioSession
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategorySoloAmbient error:nil];
    [session setActive:YES error:nil];
}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAudioSessionInterruptionNotification:) name:AVAudioSessionInterruptionNotification object:nil];
    
}

- (void)onAudioSessionInterruptionNotification:(NSNotification*)notify
{
    AVAudioInputNode* node = nil;
}

@end
