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

@class MADecodeOperation;

@protocol MADecodeOperationDelegate <NSObject>

- (void)decodeOperation:(MADecodeOperation*)operation decodeYUVFrom:(uint64_t)start to:(uint64_t)end;

- (void)decodeOperation:(MADecodeOperation*)operation decodePCMFrom:(uint64_t)start to:(uint64_t)end;

@end

@interface MADecodeOperation : NSBlockOperation

@property (nonatomic, strong, readonly) MAFrameBuffer* yuvFrameBuffer;

@property (nonatomic, strong, readonly) MAFrameBuffer* pcmFrameBuffer;

@property (nonatomic, weak) id<MADecodeOperationDelegate> delegate;

- (instancetype)initWithDecoder:(MADecoder*)decoder;

@end

NS_ASSUME_NONNULL_END
