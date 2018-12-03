//
//  newshangjiaViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/11/30.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "newshangjiaViewController.h"
#import "LolitaTableView.h"
#import "SubView.h"
#import "TitlesView.h"
#import "WRNavigationBar.h"
#define getRandomNumberFromAtoB(A,B) (int)(A+(arc4random()%(B-A+1)))
static CGFloat const kHeaderViewHeight = 50.0f;

#define NAVBAR_COLORCHANGE_POINT (IMAGE_HEIGHT - NAV_HEIGHT*2)
#define IMAGE_HEIGHT 220
#define NAV_HEIGHT 64

@interface newshangjiaViewController ()<UITableViewDelegate,UITableViewDataSource,LolitaTableViewDelegate>
{
    NSDictionary *datadic;
}
@property (strong ,nonatomic) LolitaTableView *mainTable;
@property (strong ,nonatomic) SubView *subView;
@property (strong ,nonatomic) TitlesView *titlesView;
@property (nonatomic, strong) UIImageView *topView;

@end

@implementation newshangjiaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    

    // Do any additional setup after loading the view.
    
    [self getdata];
}
- (void)getdata
{
    //初始化进度框，置于当前的View当中
    static MBProgressHUD *_HUD;
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    
    //如果设置此属性则当前的view置于后台
    //_HUD.dimBackground = YES;
    
    //设置对话框文字
    _HUD.labelText = @"加载中...";
    _HUD.labelFont = [UIFont systemFontOfSize:14];
    
    //显示对话框
    [_HUD showAnimated:YES whileExecutingBlock:^{
        //对话框显示时需要执行的操作
        //1.创建会话管理者
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        //2.封装参数
        NSDictionary *dict = nil;
        NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
        dict = @{@"id":_shangjiaid,@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"]};
        NSString *strurl = [API_NOAPK stringByAppendingString:@"/Service/institution/merchantDetails"];
        [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            WBLog(@"---%@--%@",responseObject,[responseObject objectForKey:@"msg"]);
            datadic = [[NSDictionary alloc] init];
            if ([[responseObject objectForKey:@"status"] integerValue]==1) {
                datadic = [responseObject objectForKey:@"data"];
            }else{
                [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
            }
            self.title = [datadic objectForKey:@"name"];
            [self.view addSubview:self.mainTable];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            WBLog(@"failure--%@",error);
            [MBProgressHUD showToastToView:self.view withText:@"加载失败"];
        }];
    }// 在HUD被隐藏后的回调
       completionBlock:^{
           //操作执行完后取消对话框
           [_HUD removeFromSuperview];
           _HUD = nil;
       }];
}

-(SubView *)subView{
    if (_subView==nil) {
        _subView = [[SubView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.mainTable.frame.size.height-kHeaderViewHeight)];
        _subView.cateArr = [datadic objectForKey:@"category"];
        __weak typeof(self) weakSelf = self;
        _subView.scrollEventBlock = ^(NSInteger row) {
            [weakSelf.titlesView setItemSelected:row];
            
        };
    }
    return _subView;
}

-(TitlesView *)titlesView{
    if (_titlesView==nil) {
        _titlesView = [[TitlesView alloc] initWithTitleArray:@[@"服务",@"评价"]];
        __weak typeof(self) weakSelf = self;
        _titlesView.titleClickBlock = ^(NSInteger row){
            if (weakSelf.subView.contentView) {
                weakSelf.subView.contentView.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width*row, 0);
            }
        };
    }
    return _titlesView;
}


-(LolitaTableView *)mainTable{
    if (_mainTable==nil) {
        _mainTable = [[LolitaTableView alloc] initWithFrame:CGRectMake(0, RECTSTATUS.size.height+44, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-RECTSTATUS.size.height-44) style:UITableViewStyleGrouped];
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        _mainTable.delegate_StayPosition = self;
        _mainTable.tableFooterView = [UIView new];
        _mainTable.showsVerticalScrollIndicator = NO;
        _mainTable.type = LolitaTableViewTypeMain;
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 240)];
        headerView.backgroundColor = [UIColor whiteColor];
        _mainTable.tableHeaderView = headerView;
        
        UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Main_width, 140)];
        [imgv sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:[datadic objectForKey:@"index_img"]]] placeholderImage:[UIImage imageNamed:@"默认商家背景"]];
        imgv.contentMode = UIViewContentModeScaleAspectFill;
        [headerView addSubview:imgv];
        
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(Main_width/2-40, 100, 80, 80)];
        view1.clipsToBounds = YES;
        view1.backgroundColor = [UIColor whiteColor];
        view1.layer.cornerRadius = 40;
        [headerView addSubview:view1];
        
        UIImageView *imgv2 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 70, 70)];
        imgv2.clipsToBounds = YES;
        imgv2.layer.cornerRadius = 35;
        [imgv2 sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:[datadic objectForKey:@"logo"]]] placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
        [view1 addSubview:imgv2];
        
        UIImageView *imgv3 = [[UIImageView alloc] initWithFrame:CGRectMake(42, 20+140, 27, 27)];
        imgv3.image = [UIImage imageNamed:@"联系商家"];
        [headerView addSubview:imgv3];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(22, 20+27+5+140, 67, 14)];
        label1.text = @"联系商家";
        label1.font = Font(13);
        label1.textColor = [UIColor colorWithRed:255/255.0 green:87/255.0 blue:34/255.0 alpha:1.0];
        label1.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(22, 20+27+5+14+5+140, 87, 14)];
        label2.font = Font(11);
        label2.textColor = [UIColor colorWithRed:255/255.0 green:87/255.0 blue:34/255.0 alpha:1.0];
        label2.text = [datadic objectForKey:@"telphone"];
        label2.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:label2];
        
        UIImageView *imgv4 = [[UIImageView alloc] initWithFrame:CGRectMake(Main_width-27-42, 20+140, 27, 27)];
        imgv4.image = [UIImage imageNamed:@"服务"];
        [headerView addSubview:imgv4];
        
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(Main_width-15-120, 20+27+15+140, 120, 15)];
        label3.font = Font(14);
        label3.textColor = [UIColor colorWithRed:255/255.0 green:87/255.0 blue:34/255.0 alpha:1.0];
        label3.textAlignment = NSTextAlignmentRight;
        label3.text = [NSString stringWithFormat:@"共%@个服务 >",[datadic objectForKey:@"serviceCount"]];
        [headerView addSubview:label3];
    }
    return _mainTable;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell addSubview:self.subView];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kHeaderViewHeight;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return self.titlesView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return self.subView.bounds.size.height;
}


// !!!: 悬停的位置
-(CGFloat)lolitaTableViewHeightForStayPosition:(LolitaTableView *)tableView{
    return [tableView rectForSection:0].origin.y;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
