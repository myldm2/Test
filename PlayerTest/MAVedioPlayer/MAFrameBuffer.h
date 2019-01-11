//
//  MAFrameBuffer.h
//  PlayerTest
//
//  Created by 玉洋 on 2018/12/29.
//  Copyright © 2018 baiyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAPacket.h"
#import "MAYUVFrame.h"

NS_ASSUME_NONNULL_BEGIN

@interface MAFrameBuffer : NSObject

- (instancetype)initWithMultithreadProtection:(BOOL)multithreadProtection;

- (void)push:(MAYUVFrame *)frame;

- (void)pushFrames:(NSArray<MAYUVFrame*> *)frames;

- (MAYUVFrame *)pop;

- (NSArray<MAYUVFrame *> *)popAll;

- (MAYUVFrame*)fristFrame;

- (MAYUVFrame*)lastFrame;

- (NSInteger)count;

@end

NS_ASSUME_NONNULL_END
