//
//  MAFrameBuffer.h
//  PlayerTest
//
//  Created by 玉洋 on 2018/12/29.
//  Copyright © 2018 baiyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAPacket.h"
#import "MAOutPutFrame.h"

NS_ASSUME_NONNULL_BEGIN

@interface MAFrameBuffer : NSObject

- (instancetype)initWithMultithreadProtection:(BOOL)multithreadProtection;

- (void)push:(MAOutPutFrame *)frame;

- (void)pushFrames:(NSArray<MAOutPutFrame*> *)frames;

- (MAOutPutFrame *)pop;

- (NSArray<MAOutPutFrame *> *)popAll;

- (MAOutPutFrame*)fristFrame;

- (MAOutPutFrame*)lastFrame;

- (NSInteger)count;

@end

NS_ASSUME_NONNULL_END
