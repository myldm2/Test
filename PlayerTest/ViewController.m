//
//  ViewController.m
//  PlayerTest
//
//  Created by 玉洋 on 2018/10/14.
//  Copyright © 2018年 baiyang. All rights reserved.
//

#import "ViewController.h"
#import "VedioViewController.h"
#import "AudioViewController.h"
#import "MAAudioViewController.h"
#import "VedioPlayerViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView* tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView* tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        if (indexPath.row == 0)
        {
            cell.textLabel.text = @"视频播放";
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"音频播放";
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"我的音频播放";
        } else if (indexPath.row == 3) {
            cell.textLabel.text = @"视频播放2";
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        VedioViewController* vc = [[VedioViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 1) {
        AudioViewController* vc = [[AudioViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 2) {
        MAAudioViewController* vc = [[MAAudioViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 3)
    {
        VedioPlayerViewController* vc = [[VedioPlayerViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
