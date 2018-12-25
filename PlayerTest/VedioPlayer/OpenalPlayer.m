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

- (int)updataQueueBuffer
{
    //f播放状态字段
    ALint stateVaue = 0;
    alGetSourcei(m_outSourceId, AL_BUFFERS_PROCESSED, &_m_numprocessed);
    alGetSourcei(m_outSourceId, AL_BUFFERS_QUEUED, &_m_numqueued);
    alGetSourcei(m_outSourceId, AL_SOURCE_STATE, &stateVaue);
    
    if (stateVaue == AL_STOPPED || stateVaue == AL_PAUSED || stateVaue == AL_INITIAL)
    {
        if (_m_numqueued < _m_numprocessed || _m_numqueued == 0 ||(_m_numqueued == 1 && _m_numprocessed == 1))
        {
            [self stopSound];
            [self cleanUpOpenAL];
            return 0;
        }
        
        if (stateVaue != AL_PLAYING)
        {
            [self playSound];
        }
    }
    
    while (_m_numprocessed --) {
        ALuint buff;
        alSourceUnqueueBuffers(m_outSourceId, 1, &buff);
        alDeleteBuffers(1, &buff);
        _m_IsplayBufferSize ++;
    }
    
    return 1;
}

- (void)cleanUpOpenAL
{
    printf("=======cleanUpOpenAL===\n");
    alDeleteSources(1, &m_outSourceId);
    ALCcontext* context = alcGetCurrentContext();
    if (context)
    {
        alcMakeContextCurrent(NULL);
        alcDestroyContext(context);
        m_Context = NULL;
    }
    alcCloseDevice(m_Devicde);
    m_Devicde = NULL;
}

- (void)playSound
{
    int ret = 0;
    alSourcePlay(m_outSourceId);
    if ((ret = alGetError()) != AL_NO_ERROR)
    {
        printf("error alcMakeContextCurrent %x\n", ret);
    }
}

- (void)stopSound
{
    alSourceStop(m_outSourceId);
}

- (int)openAudioFromQueue:(char *)data andWithDataSize:(int)dataSize andWithSampleRate:(int)aSampleRate andWithAbit:(int)aBit andWithAchannel:(int)aChannel
{
    int ret = 0;
    ALenum format = 0;
    ALuint bufferID = 0;
    if (_m_datasize == 0 && _m_samplerate == 0 && _m_bit == 0 && _m_channel == 0)
    {
        if (dataSize != 0 && aSampleRate != 0 &&
            aBit != 0 &&
            aChannel != 0)
        {
            _m_datasize = dataSize;
            _m_samplerate = aSampleRate;
            _m_bit = aBit;
            _m_channel = aChannel;
            _m_oneframeduration = _m_datasize * 1.0 /(_m_bit/8) /_m_channel /_m_samplerate * 1000;
        }
    }
    
    alGenBuffers(1, &bufferID);
    if ((ret = alGetError()) != AL_NO_ERROR)
    {
        printf("error alGenBuffers %x \n", ret);
    }
    
    if (aBit == 8)
    {
        if (aChannel == 1)
        {
            format = AL_FORMAT_MONO8;
        } else if (aChannel == 2)
        {
            format = AL_FORMAT_STEREO8;
        }
    }
    
    if( aBit == 16 )
    {
        if( aChannel == 1 )
        {
            format = AL_FORMAT_MONO16;
        }
        if( aChannel == 2 )
        {
            format = AL_FORMAT_STEREO16;
        }
    }
    
    alBufferData(bufferID, format, data, dataSize, aSampleRate);
    if((ret = alGetError()) != AL_NO_ERROR)
    {
        printf("error alBufferData %x\n", ret);
    }
    alSourceQueueBuffers(m_outSourceId, 1, &bufferID);
    if((ret = alGetError()) != AL_NO_ERROR)
    {
        printf("error alSourceQueueBuffers %x\n", ret);
    }
    ret = [self updataQueueBuffer];
    bufferID = 0;
    return ret;
    
}

- (void)setM_volume:(float)m_volume
{
    self.m_volume = m_volume;
    alSourcef(m_outSourceId, AL_GAIN, m_volume);
}

- (float)m_volume
{
    return self.m_volume;
}

- (void)setPlayRate:(double)playRate
{
    alSourcef(m_outSourceId, AL_PITCH, playRate);
}

@end
