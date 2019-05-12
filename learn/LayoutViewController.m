//
//  LayoutViewController.m
//  learn
//
//  Created by justin on 2019/5/2.
//  Copyright © 2019年 justin. All rights reserved.
//

#import "LayoutViewController.h"
#import "LocalMusicViewController.h"
#import "NetMusicViewController.h"

@interface LayoutViewController ()

@end

@implementation LayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor cyanColor];
    
    LocalMusicViewController *local = [[LocalMusicViewController alloc]init];
    local.title = @"本地音乐";
    local.tabBarItem.image = [UIImage imageNamed:@"local.png"];
    local.tabBarItem.selectedImage = [ UIImage imageNamed : @"local_a.png"];

    
    NetMusicViewController *net = [[NetMusicViewController alloc]init];
    net.title = @"网络音乐";
    net.tabBarItem.image = [UIImage imageNamed:@"net.png"];
    net.tabBarItem.selectedImage = [ UIImage imageNamed : @"net_a.png"];
    
    
    self.viewControllers = @[local,net];
}

- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    childVc.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 每一个控制器都是导航控制器
    UINavigationController *navigationVc = [[UINavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:navigationVc];
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
