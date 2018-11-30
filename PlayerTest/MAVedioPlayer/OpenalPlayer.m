//
//  OpenalPlayer.m
//  PlayerTest
//
//  Created by 玉洋 on 2018/11/30.
//  Copyright © 2018 baiyang. All rights reserved.
//

#import "OpenalPlayer.h"

@interface OpenalPlayer ()
{
    ALCdevice  * m_Devicde;          //device句柄
    ALCcontext * m_Context;         //device context
    ALuint       m_outSourceId;           //source id 负责播放
    NSLock     * lock;
    float        rate;
}

@end

@implementation OpenalPlayer

- (int)setup
{
    int ret = 0;
    lock = [[NSLock alloc] init];
    rate = 1.0;
    m_Devicde = alcOpenDevice(NULL);
    if (m_Devicde)
    {
        m_Context = alcCreateContext(m_Devicde, NULL);
        alcMakeContextCurrent(m_Context);
    } else {
        ret = -1;
    }
    
    alGenSources(1, &m_outSourceId);
    alSpeedOfSound(1.0);
    alDopplerVelocity(1.0);
    alDopplerFactor(1.0);
    alSourcef(m_outSourceId, AL_PITCH, 1.0f);
    alSourcef(m_outSourceId, AL_GAIN, 1.0f);
    alSourcef(m_outSourceId, AL_LOOPING, AL_FALSE);
    alSourcef(m_outSourceId, AL_SOURCE_TYPE, AL_STREAMING);
    
    return ret;
    
}

//- (int)updataQueueBuffer
//{
//    
//}

@end
