#import "LocalMusicViewController.h"
#import "./utils/AudioPlayer.h"
#import <AVKit/AVKit.h>
#import "Songs.h"

@interface LocalMusicViewController () <NSURLSessionDownloadDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property float itemY;
@property (nonatomic,strong) AVAudioPlayer *player;
@property (nonatomic,strong) NSMutableArray *songsArray;
@property UILabel *labTip;
@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSFileManager *fileManager;
@end

@implementation LocalMusicViewController
-(void)viewDidLoad{
    
    self.fileManager = [NSFileManager defaultManager];
    
    [self rederHeader];
    
    //[self renderFooter];
   
}

- (void)viewDidAppear:(BOOL)animated{
    [self renderBody:[self getLocalMusics]];
}


//结束时调用
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"结束了");
    [self.player play];
}

- (void)rederHeader{
    
    UILabel *headLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 147)];
    headLable.backgroundColor = [UIColor colorWithRed:57.0/255 green:192.0/255 blue:125.0/255 alpha:1];
    headLable.userInteractionEnabled = YES;
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, 40)];
    titleLable.text = @"本地音乐";
    titleLable.textColor = [UIColor whiteColor];
    titleLable.textAlignment = NSTextAlignmentCenter;
    [headLable addSubview:titleLable];
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - [UIScreen mainScreen].bounds.size.width * 0.9)/2,titleLable.frame.origin.y + 46, [UIScreen mainScreen].bounds.size.width * 0.9, 40)];
    self.searchBar.delegate = self;// 设置代理
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.placeholder = @"本地搜索";
    self.searchBar.tintColor = [UIColor whiteColor];
    self.searchBar.barTintColor = [UIColor whiteColor];
//    self.searchBar.text = @"http://fs.w.kugou.com/201905020905/c79db1bd3d455282e97d064cbbfd7b0a/G124/M0A/0D/00/vA0DAFsOpSSAeHT7AD2ntfTQFag565.mp3";

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

- (void)renderBody:(NSMutableArray *) localMusics{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 147, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 147 - 80) style:UITableViewStylePlain];
    //设置列表数据源
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.dataSource = self;
    self.tableView.allowsSelectionDuringEditing=YES;
    [self.view addSubview:self.tableView];
    
    NSMutableArray *d = [[NSMutableArray alloc]init];
    for (NSDictionary *item in localMusics){
        UserEntity *entity = [[UserEntity alloc] initWithName:item[@"name"] Phone:@"11111111111"];
        [d addObject:entity];
    }
    _dataSource = d;
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

- (NSMutableArray *)getLocalMusics{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    NSDirectoryEnumerator<NSString *> *myDirectoryEnumerator;
    myDirectoryEnumerator =  [self.fileManager enumeratorAtPath:documentsDirectory];
    
    self.songsArray = [[NSMutableArray alloc]init];
    self.itemY = 0;
    while (documentsDirectory = [myDirectoryEnumerator nextObject]) {
        for (NSString * namePath in documentsDirectory.pathComponents) {
            //构造文件json
            NSDictionary *songItem =  @{@"name":[NSString stringWithFormat:@"%@",namePath],@"path":[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],namePath]};
            [self.songsArray addObject:songItem];
        }
    }
    return self.songsArray;
}

// 开始下载
- (void)startDownload:(UIButton *)btn {
    NSLog(@"%@",self.searchBar.text);
    NSURLSession *ses = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
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


//tableview


//返回列表每个分组section拥有cell行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

//配置每个cell，随着用户拖拽列表，cell将要出现在屏幕上时此方法会不断调用返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    UserEntity *entity = _dataSource[indexPath.row];
    cell.detailTextLabel.text = entity.phone;
    cell.textLabel.text = entity.name;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
    id currItem = [self.songsArray objectAtIndex:indexPath.row];
    self.labTip.text = [NSString stringWithFormat:@"正在播放：%@",currItem[@"name"]];
    /* 初始化url */
    NSURL *url = [[NSURL alloc] initFileURLWithPath:[NSString stringWithFormat:@"%@",currItem[@"path"]]];
    /* 初始化音频文件 */
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.player.volume=1.0;
    if (self.player == nil)
    {
        NSLog(@"ERror creating player:");
    }
    /* 加载缓冲 */
    [self.player prepareToPlay];
    [self.player play];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self deleteMusic:indexPath.row]; // 在此处自定义删除行为
    }
    else
    {
       // DEBUG_OUT(@"Unhandled editing style: %ld", (long) editingStyle);
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

//删除音乐
- (void)deleteMusic:(NSInteger) section{
    [self.fileManager removeItemAtPath:[self.songsArray objectAtIndex:section][@"path"] error:nil];
    [self.songsArray removeObjectAtIndex:section];
    [self renderBody:self.songsArray];
}

@end
