//
//  MAPCMFrame.m
//  PlayerTest
//
//  Created by 玉洋 on 2019/1/9.
//  Copyright © 2019 baiyang. All rights reserved.
//

#import "MAPCMFrame.h"

@implementation MAPCMFrame

- (NSString *)description
{
    return [NSString stringWithFormat:@"MAPCMFrame data_length:%lu sampleRate:%d sampleSize:%d channel:%d", (unsigned long)self.pcm.length, self.sampleRate, self.sampleSize, self.channel];
}

@end
