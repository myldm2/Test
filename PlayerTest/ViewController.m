//
//  ViewController.m
//  PlayerTest
//
//  Created by baiyang on 2018/2/27.
//  Copyright © 2018年 baiyang. All rights reserved.
//

#import "ViewController.h"
#import "MediaView.h"
#import "MovieObject.h"
#import "TextureOneViewController.h"
#import "TestOne.h"

#define LERP(A,B,C) ((A)*(1.0-C)+(B)*C)

@interface ViewController ()

@property (nonatomic, strong) MediaView* mediaView;

@property (nonatomic, strong) UIButton* playBtn;
@property (nonatomic, strong) UIButton* timerBtn;
@property (nonatomic, strong) MovieObject *video;
@property (nonatomic, assign) float lastFrameTime;
@property (nonatomic, strong) UIImageView* imageView;

@property (nonatomic, strong) TextureOneViewController* ovc;

@property (nonatomic, strong) TestOne* testOne;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    _testOne = [[TestOne alloc] init];
    
//    self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
//    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    [self.view addSubview:self.imageView];
    
    MediaView* mediaView = [[MediaView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:mediaView];
    _mediaView = mediaView;
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
    NSURL* url = [NSURL fileURLWithPath:path];

    //播放网络视频
    MovieObject *extractedExpr = [[MovieObject alloc] initWithVideo:url.absoluteString];
    self.video = extractedExpr;

    CGFloat pw = 50;
    CGFloat ph = 35;
    CGFloat px = 0;
    CGFloat py = CGRectGetHeight(self.view.bounds) - ph;
    _playBtn = [[UIButton alloc] initWithFrame:CGRectMake(px, py, pw, ph)];
    [_playBtn setTitle:@"播放" forState:UIControlStateNormal];
    [self.view addSubview:_playBtn];
    [_playBtn addTarget:self action:@selector(PlayClick:) forControlEvents:UIControlEventTouchUpInside];
    _playBtn.backgroundColor = [UIColor redColor];
    
    
//
//    int tns, thh, tmm, tss;
//    tns = _video.duration;
//    thh = tns / 3600;
//    tmm = (tns % 3600) / 60;
//    tss = tns % 60;
    

    
//    [self displayImage:@"timg.jpeg"];
    
//    __block NSInteger i = 0;
//    [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        i ++;
//        if (i % 2 == 0) {
//            [self displayImage:@"timg.jpeg"];
//        } else {
//            [self displayImage:@"123.jpg"];
//        }
//    }];
    
    
//    TextureOneViewController* ovc = [[TextureOneViewController alloc] init];
//    [self addChildViewController:ovc];
//    ovc.view.frame = self.view.bounds;
//    [self.view addSubview:ovc.view];
    
    
    
//    GLuint width = 1024;
//    GLuint height = 1024;
//    CGRect rect = CGRectMake(0, 0, width, height);
//
//    uint8_t per = 3;
//
////    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    uint8_t *imageData = malloc(width * height * per);
////    CGContextRef context = CGBitmapContextCreate(imageData, width, height, 8, width * 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
////    CGContextTranslateCTM(context, 0, height);
////    CGContextScaleCTM(context, 1.0f, -1.0f);
////    CGColorSpaceRelease(colorSpace);
////    CGContextClearRect(context, rect);
////    CGContextDrawImage(context, rect, cgImageRef);
////    CGContextRelease(context);
//
//    for (int r = 0; r < height; r++)
//    {
//        for (int c = 0; c < width; c++)
//        {
//            NSInteger ir = r * width * per + c * per;
//            NSInteger ig = r * width * per + c * per + 1;
//            NSInteger ib = r * width * per + c * per + 2;
////            NSInteger ia = r * width * per + width * (per-1) + c;
//
//            uint8_t r = 0;
//            uint8_t g = 0;
//            uint8_t b = 0;
//            uint8_t a = 0;
//
//            [self row:r column:c r:&r g:&g b:&b a:&a];
//
//            imageData[ir] = r;
//            imageData[ig] = g;
//            imageData[ib] = b;
////            imageData[ia] = a;
//
////            if (c % (per-1) == 0) {
////                imageData[i] = 255;
////            }else if (c % (per-1) == 1)
////            {
////                imageData[i] = 0;
////            }else
////            {
////                imageData[i] = 0;
////            }
////            NSLog(@"mayinglun log:%d %d %d %d %d %d", ir, ig, ib, r, g, b);
////            NSLog(@"mayinglun log:%d %d %d %d %d %d", ir, ig, ib, r, g, b);
//        }
//    }
//
////    NSMutableString* string = [NSMutableString string];
////    for (int i = 0; i < height * width * per; i ++)
////    {
////        NSLog(@"%@", [NSString stringWithFormat:@" %d", imageData[i]]);
//////        [string appendString:[NSString stringWithFormat:@" %d", imageData[i]]];
//////        if (i % (width * per) == width * per - 1) {
//////            NSLog(@"%@", string);
//////            string = [NSMutableString string];
//////        }
////
////    }
//
//    NSData* data = [NSData dataWithBytes:imageData length:width * height * per];
//    free(imageData);
//
//    [self.mediaView display:data width:width height:height];
    
    
}

- (void)row:(NSInteger)row column:(NSInteger)column r:(uint8_t*)r g:(uint8_t*)g b:(uint8_t*)b a:(uint8_t*)a
{
    *r = 255;
    *g = 0;
    *b = 0;
    *a = 255;
}

- (void)displayImage:(NSString*)image
{
    UIImage* textureImage = [UIImage imageNamed:image];
    CGImageRef cgImageRef = [textureImage CGImage];
    GLuint width = (GLuint)CGImageGetWidth(cgImageRef);
    GLuint height = (GLuint)CGImageGetHeight(cgImageRef);
    CGRect rect = CGRectMake(0, 0, width, height);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    void *imageData = malloc(width * height * 4);
    CGContextRef context = CGBitmapContextCreate(imageData, width, height, 8, width * 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextTranslateCTM(context, 0, height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    CGColorSpaceRelease(colorSpace);
    CGContextClearRect(context, rect);
    CGContextDrawImage(context, rect, cgImageRef);
    CGContextRelease(context);
    
    NSData* data = [NSData dataWithBytes:imageData length:width * height * 4];
    free(imageData);
    
    [self.mediaView display:data width:width height:height];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)PlayClick:(UIButton *)sender {
    
    [_playBtn setEnabled:NO];
    _lastFrameTime = -1;
    
    // seek to 0.0 seconds
    [_video seekTime:0.0];
    
    
    [NSTimer scheduledTimerWithTimeInterval: 1 / _video.fps
                                     target:self
                                   selector:@selector(displayNextFrame:)
                                   userInfo:nil
                                    repeats:YES];
}

- (IBAction)TimerCilick:(id)sender {
    
    //    NSLog(@"current time: %f s",video.currentTime);
    //    [video seekTime:150.0];
    //    [video replaceTheResources:@"/Users/king/Desktop/Stellar.mp4"];
    if (_playBtn.enabled) {
        [_video redialPaly];
        [self PlayClick:_playBtn];
    }
    
}

-(void)displayNextFrame:(NSTimer *)timer {
    NSTimeInterval startTime = [NSDate timeIntervalSinceReferenceDate];
//    self.TimerLabel.text  = [self dealTime:video.currentTime];
    if (![_video stepFrame]) {
        [timer invalidate];
        [_playBtn setEnabled:YES];
        return;
    }
//    _imageView.image = _video.currentImage;
    
    NSData* data;
    GLsizei width = 0;
    GLsizei height = 0;

    [_video imageFromAVPicture:&data width:&width height:&height];
    
//    uint8_t* d = data.bytes;
//    uint8_t a = d[0];
//    uint8_t r = d[1];
//    uint8_t g = d[2];
//    uint8_t b = d[3];
//    NSLog(@"mayinglun log: %d %d %d %d", a, r, g, b);
    
    [self.mediaView display:data width:width height:height];
    
    float frameTime = 1.0 / ([NSDate timeIntervalSinceReferenceDate] - startTime);
    if (_lastFrameTime < 0) {
        _lastFrameTime = frameTime;
    } else {
        _lastFrameTime = LERP(frameTime, _lastFrameTime, 0.8);
    }
//    [fps setText:[NSString stringWithFormat:@"fps %.0f",_lastFrameTime]];
}

- (NSString *)dealTime:(double)time {
    
    int tns, thh, tmm, tss;
    tns = time;
    thh = tns / 3600;
    tmm = (tns % 3600) / 60;
    tss = tns % 60;
    
    
    //        [ImageView setTransform:CGAffineTransformMakeRotation(M_PI)];
    return [NSString stringWithFormat:@"%02d:%02d:%02d",thh,tmm,tss];
}

@end
