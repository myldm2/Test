//
//  MAVedioPlayerViewController.m
//  PlayerTest
//
//  Created by 玉洋 on 2018/12/25.
//  Copyright © 2018 baiyang. All rights reserved.
//

#import "MAVedioPlayerViewController.h"
#import "MADecoder.h"
#import "MAVedioPlayer.h"

@interface MAVedioPlayerViewController ()
{
    MADecoder* _decoder;
    UIView* _playView;
}

@end

@implementation MAVedioPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    _playView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 230)];
    // playView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_playView];
    
    char* realPath = "video.mp4";
    NSString * path0 = [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:realPath] ofType:nil];
    
    MAVedioPlayer* player = [MAVedioPlayer sharedPlayer];
    [player openUrl:path0 playerView:_playView];
    [player play];
    
}

- (void)dealloc
{
    [[MAVedioPlayer sharedPlayer] stop];
}

@end
