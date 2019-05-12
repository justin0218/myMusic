#import "LocalMusicViewController.h"
#import "./utils/AudioPlayer.h"
#import <AVKit/AVKit.h>
#import "Songs.h"

@interface LocalMusicViewController () <UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,AVAudioPlayerDelegate>
@property float itemY;
@property (nonatomic,strong) AVAudioPlayer *player;
@property UILabel *labTip;
@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSFileManager *fileManager;
@property (nonatomic) BOOL isPlaying;

@end

@implementation LocalMusicViewController
-(void)viewDidLoad{
    self.isPlaying = false;
    [self rederHeader];
    self.fileManager = [NSFileManager defaultManager];
    UITabBarController *tabBarVC = [[UITabBarController alloc] init];
    CGFloat tabBarHeight = tabBarVC.tabBar.frame.size.height;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 147, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 147 - tabBarHeight) style:UITableViewStylePlain];
    //设置列表数据源
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.allowsSelectionDuringEditing=YES;
    [self.view addSubview:self.tableView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
}


-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.searchBar resignFirstResponder];
}


- (void)viewDidAppear:(BOOL)animated{
    [self getLocalMusics];
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
    self.searchBar.enablesReturnKeyAutomatically = NO;
    self.searchBar.delegate = self;// 设置代理
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.placeholder = @"本地搜索";
    self.searchBar.tintColor = [UIColor whiteColor];
    self.searchBar.barTintColor = [UIColor whiteColor];
    UITextField *textfield = [self.searchBar valueForKey:@"_searchField"];
    [textfield setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    textfield.textColor = [UIColor whiteColor];
    [headLable addSubview:self.searchBar];
    [self.view addSubview:headLable];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
    if([self.searchBar.text isEqual:@""]){
        return;
    }
}

- (NSMutableArray *)getLocalMusics{
    NSString * docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dataFilePath = [docsdir stringByAppendingPathComponent:@"localmusic"];
    NSArray *fileList = [[NSArray alloc] init];
    fileList = [self.fileManager contentsOfDirectoryAtPath:dataFilePath error:nil];
    NSMutableArray *d = [[NSMutableArray alloc]init];
    for (NSString *file in fileList) {
        //构造文件json
        NSString *jsonPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/localmusic/%@",file]];
        
        // 取得数据
        NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:jsonPath];
        [d addObject:data];
    }
    self.searchBar.placeholder = [NSString stringWithFormat:@"本地歌曲%lu首",(unsigned long)d.count];
    self.dataSource = d;
    [self.tableView reloadData];
    return self.dataSource;
}

//tableview


//返回列表每个分组section拥有cell行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

//配置每个cell，随着用户拖拽列表，cell将要出现在屏幕上时此方法会不断调用返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    NSDictionary *entity = _dataSource[indexPath.row];
    cell.detailTextLabel.text = entity[@"singer"];
    cell.textLabel.text = entity[@"name"];
    
    UIFont *font = [UIFont fontWithName:@"Heiti SC" size:16];
    UIImage *wenbenImage = [self imageWithString:[NSString stringWithFormat:@"%@",entity[@"songId"]] font:font width:57 textAlignment:NSTextAlignmentLeft];
    
    cell.imageView.image = wenbenImage;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //[cell addSubview:dx];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id currItem = [self.dataSource objectAtIndex:indexPath.row];
    /* 初始化url */
    NSString * docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dataFilePath = [docsdir stringByAppendingPathComponent:@"songs"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:[NSString stringWithFormat:@"%@/%@.mp3",dataFilePath,currItem[@"songId"]]];
    /* 初始化音频文件 */
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.player.delegate = self;
    self.player.volume=1.0;
    if (self.player == nil)
    {
        NSLog(@"ERror creating player:");
    }
    
     [self.player play];
//
//    /* 加载缓冲 */
//    [self.player prepareToPlay];
//    [self.player play];
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
    NSString * docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dataFilePath = [docsdir stringByAppendingPathComponent:@"songs"];
    NSString *jsonFilePath = [docsdir stringByAppendingPathComponent:@"localmusic"];
    NSString *songPath = [NSString stringWithFormat:@"%@/%@.mp3",dataFilePath,[self.dataSource objectAtIndex:section][@"songId"]];
    NSString *jsonPath = [NSString stringWithFormat:@"%@/%@.json",jsonFilePath,[self.dataSource objectAtIndex:section][@"songId"]];
    [self.fileManager removeItemAtPath:songPath error:nil];
    [self.fileManager removeItemAtPath:jsonPath error:nil];
    [self.dataSource removeObjectAtIndex:section];
    [self.tableView reloadData];
}


- (UIImage *)imageWithString:(NSString *)string font:(UIFont *)font width:(CGFloat)width textAlignment:(NSTextAlignment)textAlignment
{
    NSDictionary *attributeDic = @{NSFontAttributeName:font};
    
    CGSize size = [string boundingRectWithSize:CGSizeMake(width, 10000)
                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine
                                    attributes:attributeDic
                                       context:nil].size;
    
//    if ([UIScreen.mainScreen respondsToSelector:@selector(scale)])
//    {
//        if (UIScreen.mainScreen.scale == 2.0)
//        {
//            UIGraphicsBeginImageContextWithOptions(size, NO, 1.0);
//        } else
//        {
//            UIGraphicsBeginImageContext(size);
//        }
//    }
//    else
//    {
//        UIGraphicsBeginImageContext(size);
//    }
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor colorWithRed:0 green:0 blue:0 alpha:0] set];
    
    CGRect rect = CGRectMake(0, 0, size.width + 1, size.height + 1);
    
    CGContextFillRect(context, rect);
    
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = textAlignment;
    
    NSDictionary *attributes = @ {
    NSForegroundColorAttributeName:[UIColor blackColor],
    NSFontAttributeName:font,
    NSParagraphStyleAttributeName:paragraph
    };
    
    [string drawInRect:rect withAttributes:attributes];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end
