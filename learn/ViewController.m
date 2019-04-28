#import "ViewController.h"
#import "./utils/AudioPlayer.h"
#import <AVKit/AVKit.h>

@interface ViewController () <NSURLSessionDownloadDelegate>
@property float itemY;
@property (nonatomic,strong) AVAudioPlayer *player;
@property (nonatomic,strong) UIScrollView *bodyScrollView;
@property (nonatomic,strong) NSMutableArray *songsArray;
@property UILabel *labTip;
@property (nonatomic,strong) UISearchBar *searchBar;
@end

@implementation ViewController
-(void)viewDidLoad{
    [self rederHeader];
    [self renderBody];
    [self renderFooter];
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 600, 100, 40)];
//    btn.backgroundColor = [UIColor greenColor];
//    [btn setTitle:@"开始下载" forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(startDownload:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];

}

- (void)rederHeader{
    UILabel *headLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 147)];
    headLable.backgroundColor = [UIColor colorWithRed:57.0/255 green:192.0/255 blue:125.0/255 alpha:1];
    headLable.userInteractionEnabled = YES;
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, 40)];
    titleLable.text = @"我的音乐";
    titleLable.textColor = [UIColor whiteColor];
    titleLable.textAlignment = NSTextAlignmentCenter;
    [headLable addSubview:titleLable];
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(12,titleLable.frame.origin.y + 46, [UIScreen mainScreen].bounds.size.width * 0.9, 40)];
    self.searchBar.delegate = self;// 设置代理
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.placeholder = @"搜索";
    self.searchBar.tintColor = [UIColor whiteColor];
    self.searchBar.barTintColor = [UIColor whiteColor];
//    self.searchBar.text = @"http://fs.w.kugou.com/201904272241/160d7fb0ba84ff81a9dce587ea575549/G156/M04/1A/14/3A0DAFzCZgWAMpfkAC8k3ciDXC0566.mp3";
    UITextField *textfield = [self.searchBar valueForKey:@"_searchField"];
    [textfield setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    textfield.textColor = [UIColor whiteColor];
    [headLable addSubview:self.searchBar];


    [self.view addSubview:headLable];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if([self.searchBar.text isEqual:@""]){
        return;
    }
    NSURLSession *ses = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration
                                                                defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    // 确定URL
    NSURL *url = [[NSURL alloc]initWithString:self.searchBar.text];
    // 通过会话在确定的URL上创建下载任务
    NSURLSessionDownloadTask *task = [ses downloadTaskWithURL:url];
    [task resume];
    
    [self.searchBar resignFirstResponder];
}

- (void)renderBody{
    self.bodyScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 147, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 147 - 80)];
    self.bodyScrollView.backgroundColor = [UIColor colorWithRed:222.0/255 green:222.0/255 blue:222.0/255 alpha:1];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    NSDirectoryEnumerator<NSString *> * myDirectoryEnumerator;
    myDirectoryEnumerator =  [fileManager enumeratorAtPath:documentsDirectory];
    
    self.songsArray = [[NSMutableArray alloc]init];
    self.itemY = 0;
    while (documentsDirectory = [myDirectoryEnumerator nextObject]) {
        for (NSString * namePath in documentsDirectory.pathComponents) {
            //构造文件json
            NSDictionary *songItem =  @{@"name":[NSString stringWithFormat:@"%@",namePath],@"path":[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],namePath]};
            [self.songsArray addObject:songItem];
        }
    }
    
    int index = 0;
    for (NSDictionary *item in self.songsArray){
        
        UIButton *musicItemLab = [[UIButton alloc]initWithFrame:CGRectMake(0, self.itemY, [UIScreen mainScreen].bounds.size.width, 65)];
        [musicItemLab setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        [musicItemLab setTitle:[NSString stringWithFormat:@"%@",item[@"name"]] forState:UIControlStateNormal];
        musicItemLab.backgroundColor = [UIColor whiteColor];
        musicItemLab.tag = index;
        musicItemLab.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        musicItemLab.titleLabel.textAlignment = NSTextAlignmentLeft;
        musicItemLab.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        index++;
        self.bodyScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width,index * 65 + 5);
        [musicItemLab addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
        self.itemY += 66;
        [self.bodyScrollView addSubview:musicItemLab];
    }
    
    NSLog(@"===数组%@",self.songsArray);
    
    [self.view addSubview:self.bodyScrollView];
}

- (void)renderFooter{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 80, [UIScreen mainScreen].bounds.size.width, 80)];
    footView.backgroundColor = [UIColor whiteColor];
    footView.layer.shadowColor = [UIColor blackColor].CGColor;
    footView.layer.shadowOffset = CGSizeMake(0,0);
    footView.layer.shadowOpacity = 0.4;
    footView.layer.masksToBounds = YES;
    footView.clipsToBounds = NO;
    
    self.labTip = [[UILabel alloc]initWithFrame:CGRectMake(0, 14, footView.frame.size.width, footView.frame.size.height - 20)];
    self.labTip.textAlignment = NSTextAlignmentCenter;
    self.labTip.textColor = [UIColor blackColor];
    [footView addSubview:self.labTip];
    [self.view addSubview:footView];
}


- (void)playAudio:(UIButton *)btn{
    id currItem = [self.songsArray objectAtIndex:btn.tag];
    self.labTip.text = [NSString stringWithFormat:@"正在播放：%@",currItem[@"name"]];
    /* 初始化url */
    NSURL *url = [[NSURL alloc] initFileURLWithPath:[NSString stringWithFormat:@"%@",currItem[@"path"]]];
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

// 开始下载
- (void)startDownload:(UIButton *)btn {
    NSLog(@"%@",self.searchBar.text);
    NSURLSession *ses = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration
                                                                defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    // 确定URL
    NSURL *url = [[NSURL alloc]initWithString:self.searchBar.text];
    // 通过会话在确定的URL上创建下载任务
    NSURLSessionDownloadTask *task = [ses downloadTaskWithURL:url];
    [task resume];
}

// 下载了数据的过程中会调用的代理方法
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten
totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    NSLog(@"下载进度:%lf",1.0 * totalBytesWritten / totalBytesExpectedToWrite);
    self.searchBar.text = [NSString stringWithFormat:@"%lf",1.0 * totalBytesWritten / totalBytesExpectedToWrite];
}
// 重新恢复下载的代理方法
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
    didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes{
}
// 写入数据到本地的时候会调用的方法
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location{
    NSString* fullPath =
    [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
     stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    
    [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:fullPath] error:nil];
    NSLog(@"%@",fullPath);
}
// 请求完成，错误调用的代理方法
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    NSLog(@"%@",error);
}

@end
