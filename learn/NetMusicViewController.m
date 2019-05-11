#import "NetMusicViewController.h"
#import <AVKit/AVKit.h>
#import "Songs.h"
#import "Request.h"

@interface NetMusicViewController () <NSURLSessionDownloadDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray *songsArray;
@property UILabel *labTip;
@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSFileManager *fileManager;
@property (nonatomic,strong) NSDictionary *tasks;
@property (nonatomic,strong) UILabel *progressTxt;
@property (nonatomic,strong) UIView *shadowView;

@property (nonatomic) NSInteger currTast;
@end

@implementation NetMusicViewController
-(void)viewDidLoad{
    
    self.fileManager = [NSFileManager defaultManager];
    [self rederHeader];
    UITabBarController *tabBarVC = [[UITabBarController alloc] init];
    CGFloat tabBarHeight = tabBarVC.tabBar.frame.size.height;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 147, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 147 - tabBarHeight) style:UITableViewStylePlain];
    //设置列表数据源
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.allowsSelectionDuringEditing=YES;
    [self.view addSubview:self.tableView];
    
    
    self.shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.shadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    
    self.progressTxt = [[UILabel alloc]initWithFrame:CGRectMake(self.shadowView.frame.size.width/2-50, self.shadowView.frame.size.height/2-40, 100, 40)];
    self.progressTxt.text = @"进度:0%";
    self.progressTxt.textColor = [UIColor whiteColor];
    [self.shadowView addSubview:self.progressTxt];
    [self.view addSubview:self.shadowView];
    self.shadowView.hidden = YES;
    
}

- (void)viewDidAppear:(BOOL)animated{
   [self getNetMusics];
}

//获取网络上的音乐
- (void)getNetMusics
{
    NSString * docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dataFilePath = [docsdir stringByAppendingPathComponent:@"localmusic"];
    NSArray *fileList = [[NSArray alloc] init];
    fileList = [self.fileManager contentsOfDirectoryAtPath:dataFilePath error:nil];
    
    NewRequest *req = [[NewRequest alloc]init];
    [req get:@"https://momoman.cn/v1/music/list" callBack:^(NSDictionary *data) {
        dispatch_async(dispatch_get_main_queue(),^{
            NSMutableArray *d = [[NSMutableArray alloc]init];
            for (NSDictionary *item in data[@"data"]){
                BOOL isHas = [self inArray:fileList strValue:[NSString stringWithFormat:@"%@.json",item[@"id"]]];
                if(!isHas){
                    NSNumber *taskNo = (NSNumber*)item[@"id"];
                    UserEntity *entity = [[UserEntity alloc] initWithName:item[@"name"] Phone:item[@"singer"] Url:item[@"url"] SongId:taskNo Singer:item[@"singer"]];
                    [d addObject:entity];
                }
            }
            self.dataSource = d;
            [self.tableView reloadData];
        });
    }];
}

- (BOOL)inArray:(NSArray *) arr strValue:(NSString *) strval{
    for (NSString *val in arr) {
        if([val isEqualToString:strval]){
            return true;
        }
    }
    return false;
}

- (void)rederHeader{
    UILabel *headLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 147)];
    headLable.backgroundColor = [UIColor colorWithRed:57.0/255 green:192.0/255 blue:125.0/255 alpha:1];
    headLable.userInteractionEnabled = YES;
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, 40)];
    titleLable.text = @"网络音乐";
    titleLable.textColor = [UIColor whiteColor];
    titleLable.textAlignment = NSTextAlignmentCenter;
    [headLable addSubview:titleLable];
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - [UIScreen mainScreen].bounds.size.width * 0.9)/2,titleLable.frame.origin.y + 46, [UIScreen mainScreen].bounds.size.width * 0.9, 40)];
    self.searchBar.delegate = self;// 设置代理
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.placeholder = @"网络搜索";
    self.searchBar.tintColor = [UIColor whiteColor];
    self.searchBar.barTintColor = [UIColor whiteColor];
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
}


// 下载了数据的过程中会调用的代理方法
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten
totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    self.progressTxt.text = [NSString stringWithFormat:@"进度:%2.lf",100.0 * totalBytesWritten / totalBytesExpectedToWrite];
    self.progressTxt.text = [self.progressTxt.text stringByAppendingString: @"%"];
}

// 写入数据到本地的时候会调用的方法
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location{
    NSString *taskkey = [NSString stringWithFormat:@"task_%ld",downloadTask.taskIdentifier];
    UserEntity *entity = [self.tasks objectForKey:taskkey];
    NSString * docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dataFilePath = [docsdir stringByAppendingPathComponent:@"localmusic"];
    NSString *songsPath = [docsdir stringByAppendingPathComponent:@"songs"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
    BOOL existed = [fileManager fileExistsAtPath:dataFilePath isDirectory:&isDir];
    if (!(isDir && existed)) {
        [fileManager createDirectoryAtPath:dataFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    BOOL existed2 = [fileManager fileExistsAtPath:songsPath isDirectory:&isDir];
    if (!(isDir && existed2)) {
        [fileManager createDirectoryAtPath:songsPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *musicPath = [NSString stringWithFormat:@"%@/%@.mp3",songsPath,entity.songId];
    [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:musicPath] error:nil];
    NSString *dataPath = [dataFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json",entity.songId]];
    NSDictionary *localJosn = @{@"name":entity.name,@"path":musicPath,@"songId":entity.songId,@"singer":entity.singer};
    // 文件写入
    [localJosn writeToFile:dataPath atomically:YES];
    
    [self.dataSource removeObjectAtIndex:(long)self.currTast];
    [self.tableView reloadData];
    self.shadowView.hidden = YES;
    self.progressTxt.text = @"进度:0%";
}
// 请求完成，错误调用的代理方法
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    NSLog(@"%@",error);
}

//tableview
//返回列表每个分组section拥有cell行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
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
    self.shadowView.hidden = NO;
    NSURLSession *ses = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration
                                                                defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    UserEntity *entity = [self.dataSource objectAtIndex:(long)indexPath.row];
    NSURL *url = [[NSURL alloc]initWithString:entity.url];
    // 通过会话在确定的URL上创建下载任务
    NSURLSessionDownloadTask *task = [ses downloadTaskWithURL:url];
    NSString *taskkey = [NSString stringWithFormat:@"task_%ld",task.taskIdentifier];
    self.tasks = [NSDictionary dictionaryWithObject:entity forKey:taskkey];
    self.currTast = (long)indexPath.row;
    [task resume];
}





@end
