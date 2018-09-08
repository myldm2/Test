//
//  TestOne.m
//  PlayerTest
//
//  Created by baiyang on 2018/3/7.
//  Copyright © 2018年 baiyang. All rights reserved.
//

#import "TestOne.h"
#include <libavcodec/avcodec.h>
#include <libavformat/avformat.h>
#include <libswscale/swscale.h>


@implementation TestOne
{
    AVFormatContext *pFormatCtx;
    int             i, videoindex;
    AVCodecContext  *pCodecCtx;
    AVCodec         *pCodec;
    AVFrame *pFrame,*pFrameYUV;
    uint8_t *out_buffer;
    AVPacket *packet;
    int y_size;
    int ret, got_picture;
    struct SwsContext *img_convert_ctx;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString* filePath = @"http://127.0.0.1/0020RBxOlx07in2POMHe010402008Ge60k010.mp4";
//        NSString* filePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
        const char* filepath = [filePath cStringUsingEncoding:NSUTF8StringEncoding];
        
        
        NSString* documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString* yuvPath = [documentsPath stringByAppendingPathComponent:@"test.yuv"];
        NSString* h264Path = [documentsPath stringByAppendingPathComponent:@"test.h264"];
        NSLog(@"documents path:%@", h264Path);
        NSFileManager* fileManager = [NSFileManager defaultManager];
        
        if ([fileManager fileExistsAtPath:yuvPath]) {
            [fileManager removeItemAtPath:yuvPath error:nil];
        }
        if (![fileManager createFileAtPath:yuvPath contents:nil attributes:nil]) {
            NSLog(@"创建文件失败");
        }
        
        if ([fileManager fileExistsAtPath:h264Path]) {
            [fileManager removeItemAtPath:h264Path error:nil];
        }
        if (![fileManager createFileAtPath:h264Path contents:nil attributes:nil]) {
            NSLog(@"创建文件失败");
        }

        NSFileHandle* yuvFileHandle = [NSFileHandle fileHandleForWritingAtPath:yuvPath];
        NSFileHandle* h264FileHandle = [NSFileHandle fileHandleForWritingAtPath:h264Path];
        
        av_register_all();
        avformat_network_init();
        pFormatCtx = avformat_alloc_context();
        
        if(avformat_open_input(&pFormatCtx,filepath,NULL,NULL)!=0){//打开输入的视频文件
            NSLog(@"Couldn't open input stream.\n");
            goto error;
        }
        if(avformat_find_stream_info(pFormatCtx,NULL)<0){//获取视频文件信息
            printf("Couldn't find stream information.\n");
            goto error;
        }
        videoindex = -1;
        for(i=0; i<pFormatCtx->nb_streams; i++)
            if(pFormatCtx->streams[i]->codec->codec_type==AVMEDIA_TYPE_VIDEO){
                videoindex=i;
                break;
            }
        
        if(videoindex==-1){
            NSLog(@"Didn't find a video stream.\n");
            goto error;
        }
        
        pCodecCtx=pFormatCtx->streams[videoindex]->codec;
        pCodec=avcodec_find_decoder(pCodecCtx->codec_id);//查找解码器
        if(pCodec==NULL){
            NSLog(@"Codec not found.\n");
            goto error;
        }
        if(avcodec_open2(pCodecCtx, pCodec,NULL)<0){//打开解码器
            NSLog(@"Could not open codec.\n");
            goto error;
        }
        pFrame=av_frame_alloc();
        pFrameYUV=av_frame_alloc();
        out_buffer=(uint8_t *)av_malloc(avpicture_get_size(AV_PIX_FMT_YUV420P, pCodecCtx->width, pCodecCtx->height));
        avpicture_fill((AVPicture *)pFrameYUV, out_buffer, AV_PIX_FMT_YUV420P, pCodecCtx->width, pCodecCtx->height);
        packet=(AVPacket *)av_malloc(sizeof(AVPacket));
        //Output Info-----------------------------
        printf("--------------- File Information ----------------\n");
        av_dump_format(pFormatCtx,0,filepath,0);
        printf("-------------------------------------------------\n");
        img_convert_ctx = sws_getContext(pCodecCtx->width, pCodecCtx->height, pCodecCtx->pix_fmt,
                                         pCodecCtx->width, pCodecCtx->height, AV_PIX_FMT_YUV420P, SWS_BICUBIC, NULL, NULL, NULL);
        
        while(av_read_frame(pFormatCtx, packet)>=0){//读取一帧压缩数据
            if(packet->stream_index==videoindex){
                
//                fwrite(packet->data,1,packet->size,fp_h264); //把H264数据写入fp_h264文件
                [h264FileHandle writeData:[NSData dataWithBytes:packet->data length:packet->size]];
                
                ret = avcodec_decode_video2(pCodecCtx, pFrame, &got_picture, packet);//解码一帧压缩数据
                if(ret < 0){
                    NSLog(@"Decode Error.\n");
                    goto error;
                }
                if(got_picture){
                    sws_scale(img_convert_ctx, (const uint8_t* const*)pFrame->data, pFrame->linesize, 0, pCodecCtx->height,
                              pFrameYUV->data, pFrameYUV->linesize);
                    
                    y_size=pCodecCtx->width*pCodecCtx->height;
//                    fwrite(pFrameYUV->data[0],1,y_size,fp_yuv);    //Y
//                    fwrite(pFrameYUV->data[1],1,y_size/4,fp_yuv);  //U
//                    fwrite(pFrameYUV->data[2],1,y_size/4,fp_yuv);  //V
                    [yuvFileHandle writeData:[NSData dataWithBytes:pFrameYUV->data[0] length:y_size]];
                    [yuvFileHandle writeData:[NSData dataWithBytes:pFrameYUV->data[1] length:y_size/4]];
                    [yuvFileHandle writeData:[NSData dataWithBytes:pFrameYUV->data[2] length:y_size/4]];
                    NSLog(@"Succeed to decode 1 frame!\n");
                    
                }
            }
            av_free_packet(packet);
        }
        //flush decoder
        /*当av_read_frame()循环退出的时候，实际上解码器中可能还包含剩余的几帧数据。
         因此需要通过“flush_decoder”将这几帧数据输出。
         “flush_decoder”功能简而言之即直接调用avcodec_decode_video2()获得AVFrame，而不再向解码器传递AVPacket。*/
        while (1) {
            ret = avcodec_decode_video2(pCodecCtx, pFrame, &got_picture, packet);
            if (ret < 0)
                break;
            if (!got_picture)
                break;
            sws_scale(img_convert_ctx, (const uint8_t* const*)pFrame->data, pFrame->linesize, 0, pCodecCtx->height,
                      pFrameYUV->data, pFrameYUV->linesize);
            
            int y_size=pCodecCtx->width*pCodecCtx->height;
//            fwrite(pFrameYUV->data[0],1,y_size,fp_yuv);    //Y
//            fwrite(pFrameYUV->data[1],1,y_size/4,fp_yuv);  //U
//            fwrite(pFrameYUV->data[2],1,y_size/4,fp_yuv);  //V
            [yuvFileHandle writeData:[NSData dataWithBytes:pFrameYUV->data[0] length:y_size]];
            [yuvFileHandle writeData:[NSData dataWithBytes:pFrameYUV->data[1] length:y_size/4]];
            [yuvFileHandle writeData:[NSData dataWithBytes:pFrameYUV->data[2] length:y_size/4]];
            
            printf("Flush Decoder: Succeed to decode 1 frame!\n");
        }
        
        sws_freeContext(img_convert_ctx);
        
        //关闭文件以及释放内存
        [h264FileHandle closeFile];
        [yuvFileHandle closeFile];
        
        av_frame_free(&pFrameYUV);
        av_frame_free(&pFrame);
        avcodec_close(pCodecCtx);
        avformat_close_input(&pFormatCtx);
        
    }
    
    error:
    return self;
}

@end
