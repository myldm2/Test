//
//  MADecodeOperation.h
//  PlayerTest
//
//  Created by 玉洋 on 2019/1/3.
//  Copyright © 2019 baiyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MADecoder.h"
#import "MAFrameBuffer.h"

NS_ASSUME_NONNULL_BEGIN

@interface MADecodeOperation : NSBlockOperation

@property (nonatomic, strong, readonly) MAFrameBuffer* yuvFrameBuffer;

- (instancetype)initWithDecoder:(MADecoder*)decoder;

@end

NS_ASSUME_NONNULL_END
