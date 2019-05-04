//
//  AppDelegate.m
//  learn
//
//  Created by justin on 2019/4/20.
//  Copyright © 2019年 justin. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "LayoutViewController.h"
@interface AppDelegate ()
@property (nonatomic,strong)AVAudioPlayer *player;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    AVAudioSession * session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    LayoutViewController *lay = [[LayoutViewController alloc]init];
    self.window.rootViewController = lay;
    // 取到分栏控制器的分栏
    UITabBar *tabBar = lay.tabBar;
    // 设置分栏的风格
    tabBar.barStyle = UIBarStyleBlack;
    // 是否透明
    tabBar.translucent = NO;
    // 设置分栏的前景颜色
    tabBar.barTintColor = [UIColor whiteColor];    
    // 设置分栏元素项的颜色
    tabBar.tintColor = [UIColor colorWithRed:57.0/255 green:192.0/255 blue:125.0/255 alpha:1];
    // 设置分栏按钮的选中指定图片
    //tabBar.selectionIndicatorImage = [UIImage imageNamed:@"WeChat5f8b2665bed2b7b697934261bdd65b15.png"];
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
