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
    
//    _decoder = [[MADecoder alloc] init];
//    if (![_decoder openUrl:path0 error:nil])
//    {
//        NSLog(@"open vedio source failed");
//    }
    
    MAVedioPlayer* player = [MAVedioPlayer sharedPlayer];
    [player openUrl:path0 playerView:_playView];
    [player play];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
