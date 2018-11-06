//
//  MAAudioOutputQueue.h
//  PlayerTest
//
//  Created by 玉洋 on 2018/11/6.
//  Copyright © 2018 baiyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

NS_ASSUME_NONNULL_BEGIN

@interface MAAudioOutputQueue : NSObject

@property (nonatomic,assign,readonly) AudioStreamBasicDescription format;
@property (nonatomic,assign) float volume;
@property (nonatomic,assign) UInt32 bufferSize;

@end

NS_ASSUME_NONNULL_END
