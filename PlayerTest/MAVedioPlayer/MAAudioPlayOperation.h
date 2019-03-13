//
//  MAAudioPlayOperation.h
//  PlayerTest
//
//  Created by 玉洋 on 2019/1/28.
//  Copyright © 2019 baiyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAFrameBuffer.h"
#import "MAOpenglView.h"
#import "MAOpenalPlayer.h"
#import "MAPlayCore.h"

NS_ASSUME_NONNULL_BEGIN

@interface MAAudioPlayOperation : NSBlockOperation

- (instancetype)initWithPCMBuffer:(MAFrameBuffer*)pcmBuffer playCore:(MAPlayCore*)playCore;

@end

NS_ASSUME_NONNULL_END
