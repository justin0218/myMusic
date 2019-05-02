#import "HomeViewController.h"
#import "Songs.h"

@interface HomeViewController ()<UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 147, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 147 - 80) style:UITableViewStyleGrouped];
    //设置列表数据源
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.allowsSelection = YES;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (UIViewController *)initdata:(NSMutableArray *)datas{
    _dataSource = datas;
    return self;
}

//返回列表分组数，默认为1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//返回列表每个分组section拥有cell行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

//配置每个cell，随着用户拖拽列表，cell将要出现在屏幕上时此方法会不断调用返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    cell.userInteractionEnabled = YES;
    UserEntity *entity = _dataSource[indexPath.row];
    cell.detailTextLabel.text = entity.phone;
    cell.textLabel.text = entity.name;
    
//    UIButton  *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    playButton.frame = CGRectMake(0 , 0, cell.frame.size.width, cell.frame.size.height);
//    [playButton addTarget:self action:@selector(playVoice:) forControlEvents:UIControlEventTouchUpInside];
//    playButton.tag = indexPath.row;
//    [cell.contentView addSubview:playButton];

    
    //给cell设置accessoryType或者accessoryView
    //也可以不设置，这里纯粹为了展示cell的常用可设置选项
//    if (indexPath.section == 0 && indexPath.row == 0) {
//        cell.accessoryType = UITableViewCellAccessoryDetailButton;
//    }else if (indexPath.section == 0 && indexPath.row == 1) {
//        cell.accessoryView = [[UISwitch alloc] initWithFrame:CGRectZero];
//    } else {
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    }
    
    //设置cell没有选中效果
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)playVoice:(UIButton *)btn{
    NSLog(@"%ld",(long)btn.tag);
}

//返回列表每个分组头部说明
- (UIView *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return nil;
}

//返回列表每个分组尾部说明
- (UIView *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return nil;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    NSLog(@"%@",indexPath);
    
}

@end
