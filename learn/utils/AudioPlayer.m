//  ViewController.m
//  MusicPlayer
//
//  Created by dlios on 15/10/6.
//  Copyright © 2015年 dlios. All rights reserved.
//

#import "AudioPlayer.h"
//导入系统库
#import <AVFoundation/AVFoundation.h>

@interface AudioPlayer ()<AVAudioPlayerDelegate>
@property (nonatomic,strong)AVAudioPlayer *player;

@end

@implementation AudioPlayer

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self getButtonControl];

    
}

#pragma mark - 创建按钮和进度滑条方法
- (void)getButtonControl
{
    //创建播放按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setFrame:CGRectMake(0, 0, 40, 20)];
    
    button.center = CGPointMake(375 / 2, 400);
    
    [button setTitle:@"播放" forState:UIControlStateNormal];
    
    [button setTitle:@"暂停" forState:UIControlStateSelected];
    
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    
    /* 声音slider */
    //创建slider
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
    
    slider.center = CGPointMake(375 / 2, 450);
    
    /* 最大值 */
    [slider setMaximumValue:100.];
    
    /* 最小值 */
    [slider setMinimumValue:0.];
    
    /* 显示颜色 */
    [slider setMaximumTrackTintColor:[UIColor purpleColor]];
    
    /* 滑动后颜色 */
    [slider setMinimumTrackTintColor:[UIColor cyanColor]];
    
    /* 滑动就调用 */
    [slider setContinuous:YES];
    
    /* 滑动事件 */
    [slider addTarget:self action:@selector(slider:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    
    /* 进度slider */
    UISlider *schSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
    
    schSlider.center = CGPointMake(375 / 2, 500);
    
    [schSlider setMaximumValue:280.];
    
    [schSlider setMinimumValue:0.];
    
    [schSlider setContinuous:YES];
    
    [schSlider addTarget:self action:@selector(sliderClick:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:schSlider];
}
#pragma mark - 播放方法
- (void)getPlayer:(NSString *)path
{
    
    /* 获取本地文件 */
    
    /* 初始化url */
    NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
    NSLog(@"播放=====%@",url);
    /* 初始化音频文件 */
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _player.volume=1.0;
    
    if (_player == nil)
    {
        NSLog(@"ERror creating player:");
    }
    
    /* 加载缓冲 */
    [_player prepareToPlay];
    [_player play];
}
#pragma mark - button 点击方法
- (void)click:(UIButton *)button
{
    if (button.selected == NO) {
        [self.player play];
        button.selected = YES;
    }else{
        button.selected = NO;
        [self.player pause];
    }
}
#pragma mark - 声音滑动事件方法
- (void)slider:(UISlider *)slider
{
    self.player.volume = slider.value;
}
#pragma mark - 进度滑动事件
- (void)sliderClick:(UISlider *)slider
{
    self.player.currentTime = slider.value;
}
#pragma mark - player Dlegate
//结束时调用
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"结束了");
}
//解析错误调用
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
