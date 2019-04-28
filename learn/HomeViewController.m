//
//  HomeViewController.m
//  learn
//
//  Created by justin on 2019/4/21.
//  Copyright © 2019年 justin. All rights reserved.
//

#import "HomeViewController.h"
#import <WebKit/WebKit.h>

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //创建网页配置对象
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    // 创建设置对象
    WKPreferences *preference = [[WKPreferences alloc]init];
    //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
    preference.minimumFontSize = 0;
    //设置是否支持javaScript 默认是支持的
    preference.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
    preference.javaScriptCanOpenWindowsAutomatically = YES;
    config.preferences = preference;
    
    // 是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
    config.allowsInlineMediaPlayback = YES;
    //设置视频是否需要用户手动播放  设置为NO则会允许自动播放
    config.mediaTypesRequiringUserActionForPlayback = YES;
    //设置是否允许画中画技术 在特定设备上有效
    config.allowsPictureInPictureMediaPlayback = YES;
    //设置请求的User-Agent信息中应用程序名称 iOS9后可用
    config.applicationNameForUserAgent = @"ChinaDailyForiPad";
    //自定义的WKScriptMessageHandler 是为了解决内存不释放的问题
//    WeakWebViewScriptMessageDelegate *weakScriptMessageDelegate = [[WeakWebViewScriptMessageDelegate alloc] initWithDelegate:self];
    //这个类主要用来做native与JavaScript的交互管理
    WKUserContentController * wkUController = [[WKUserContentController alloc] init];
    //注册一个name为jsToOcNoPrams的js方法
//    [wkUController addScriptMessageHandler:weakScriptMessageDelegate  name:@"jsToOcNoPrams"];
//    [wkUController addScriptMessageHandler:weakScriptMessageDelegate  name:@"jsToOcWithPrams"];
    config.userContentController = wkUController;
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) configuration:config];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
        [webView loadRequest:request];
    [self.view addSubview:webView];
    
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 50, 100, 40)];
    [btn setTitle:@"返回上一页" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor blackColor];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

- (void)backBtn:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
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
