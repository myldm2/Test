//
//  MAVedioPlayOperation.h
//  PlayerTest
//
//  Created by 玉洋 on 2019/1/25.
//  Copyright © 2019 baiyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAFrameBuffer.h"
#import "MAOpenglView.h"
#import "MAOpenalPlayer.h"
#import "MAPlayCore.h"

NS_ASSUME_NONNULL_BEGIN

@interface MAVedioPlayOperation : NSBlockOperation

- (instancetype)initWithYUVBuffer:(MAFrameBuffer*)yuvBuffer playCore:(MAPlayCore*)playCore;

@end

NS_ASSUME_NONNULL_END
