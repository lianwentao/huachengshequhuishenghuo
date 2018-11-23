//
//  zuFangDetailViewController.m
//  HuiShengHuo2.0
//
//  Created by admin on 2018/11/16.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "zuFangDetailViewController.h"
#import "WRNavigationBar.h"
#import "MJRefresh.h"
#import "PTLMenuButton.h"
#import "KMTagListView.h"
#import "huoDongDetailViewController.h"
#define kScreenHeight   ([UIScreen mainScreen].bounds.size.height)
#define kScreenWidth    ([UIScreen mainScreen].bounds.size.width)
#define NAV_HEIGHT 64
#define IMAGE_HEIGHT 0
#define SCROLL_DOWN_LIMIT 70
@interface zuFangDetailViewController ()<UITableViewDelegate,UITableViewDataSource,PTLMenuButtonDelegate, KMTagListViewDelegate>
{
    UITableView *tableView;
    UIImageView *redcountimage;
}

@end

@implementation zuFangDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

//    [self setupNavItems];
    [self CreateTableview];
    [self loadFunctionView];
    
    [self wr_setNavBarBarTintColor:BackColor];
    [self wr_setNavBarBackgroundAlpha:0];
    
}

-(void)CreateTableview{
    
    CGRect frame = CGRectMake(0, -64, kScreenWidth, kScreenHeight+64-50);
    tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.showsVerticalScrollIndicator = NO;
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor whiteColor];
    
//    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(xiala)];
//    tableView.contentInset = UIEdgeInsetsMake(IMAGE_HEIGHT - [self navBarBottom], 0, 0, 0);
    [self.view addSubview:tableView];
//    [tableView.mj_header beginRefreshing];
}

#pragma mark - tableview delegate / dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return 1;
    }else if(section == 2){
        return 1;
    }else if(section == 3){
        return 1;
    }else{
        return 5;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 4) {
        return 50;
    } else {
        return 0.001;
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 200;
    }else if (indexPath.section == 1){
        return 330;
    }else if (indexPath.section == 2){
        return 170;
    }else if (indexPath.section == 3){
        return 170;
    }else{
        return 120;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        cell.userInteractionEnabled = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
    }
    if (indexPath.section == 0) {
        
        cell.backgroundColor = [UIColor greenColor];
    }else if (indexPath.section == 1){
        
        UILabel *titleLab = [[UILabel alloc]init];
        titleLab.frame = CGRectMake(10, 10, kScreenWidth-20, 50);
        titleLab.text = @"迎宾合作住宅区-3室1厅1卫-面积120平米|3/6层";
        titleLab.textColor = [UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:1];
        titleLab.font = [UIFont systemFontOfSize:18];
        titleLab.numberOfLines = 2;
        titleLab.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:titleLab];
        
        UILabel *rengZhengLab = [[UILabel alloc]init];
        rengZhengLab.frame = CGRectMake(10, CGRectGetMaxY(titleLab.frame)+5, 80, 20);
        rengZhengLab.text = @"物业认证";
        rengZhengLab.backgroundColor = [UIColor colorWithRed:252/255.0 green:88/255.0 blue:48/255.0 alpha:1];
        rengZhengLab.textColor = [UIColor whiteColor];
        rengZhengLab.font = [UIFont systemFontOfSize:15];
        rengZhengLab.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:rengZhengLab];
        
        KMTagListView *tag = [[KMTagListView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(rengZhengLab.frame)+5, CGRectGetMaxY(titleLab.frame), kScreenWidth-20-5-80, 0)];
        tag.delegate_ = self;
        [tag setupSubViewsWithTitles:@[@"精装修", @"家具齐全㩕包入住",@"交通方便",@"精装修", @"家具齐全㩕包入住",@"交通方便"]];
        [cell addSubview:tag];
        
        CGRect rect = tag.frame;
        rect.size.height = tag.contentSize.height;
        tag.frame = rect;
        
        UILabel *sjLab = [[UILabel alloc]init];
        sjLab.frame = CGRectMake(10, CGRectGetMaxY(tag.frame)+5, kScreenWidth/3-3, 35);
        sjLab.text = @"房租(月付价)";
        sjLab.textColor = [UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1];
        sjLab.font = [UIFont systemFontOfSize:17];
        sjLab.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:sjLab];
        
        UILabel *priceLab1 = [[UILabel alloc]init];
        priceLab1.frame = CGRectMake(10, CGRectGetMaxY(sjLab.frame)+5, 70, 35);
        priceLab1.text = @"8.8万元/";
        priceLab1.textColor = [UIColor colorWithRed:252/255.0 green:79/255.0 blue:40/255.0 alpha:1];
        priceLab1.font = [UIFont systemFontOfSize:17];
        priceLab1.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:priceLab1];
        
        UILabel *priceLab2 = [[UILabel alloc]init];
        priceLab2.frame = CGRectMake(CGRectGetMaxX(priceLab1.frame), CGRectGetMaxY(sjLab.frame)+5, kScreenWidth/3-3-70-10, 35);
        priceLab2.text = @"1100元";
        priceLab2.textColor = [UIColor colorWithRed:252/255.0 green:79/255.0 blue:40/255.0 alpha:1];
        priceLab2.font = [UIFont systemFontOfSize:12];
        priceLab2.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:priceLab2];
        
        UIView *line1 = [[UIView alloc]init];
        line1.frame = CGRectMake(CGRectGetMaxX(sjLab.frame), CGRectGetMaxY(tag.frame)+5, .5, 75);
        line1.backgroundColor = [UIColor lightGrayColor];
        [cell addSubview:line1];
        
        
        UILabel *hxLab = [[UILabel alloc]init];
        hxLab.frame = CGRectMake(CGRectGetMaxX(line1.frame)+3, CGRectGetMaxY(tag.frame)+5, kScreenWidth/3-3, 35);
        hxLab.text = @"户型";
        hxLab.textColor = [UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1];
        hxLab.font = [UIFont systemFontOfSize:17];
        hxLab.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:hxLab];
        
        UILabel *hxLab1 = [[UILabel alloc]init];
        hxLab1.frame = CGRectMake(CGRectGetMaxX(line1.frame)+3, CGRectGetMaxY(hxLab.frame)+5, kScreenWidth/3-3, 35);
        hxLab1.text = @"3室1厅1卫1厨";
        hxLab1.textColor = [UIColor colorWithRed:252/255.0 green:79/255.0 blue:40/255.0 alpha:1];
        hxLab1.font = [UIFont systemFontOfSize:17];
        hxLab1.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:hxLab1];
        
        UIView *line2 = [[UIView alloc]init];
        line2.frame = CGRectMake(CGRectGetMaxX(hxLab.frame), CGRectGetMaxY(tag.frame)+5, .5, 75);
        line2.backgroundColor = [UIColor lightGrayColor];
        [cell addSubview:line2];
        
        UILabel *mjLab = [[UILabel alloc]init];
        mjLab.frame = CGRectMake(CGRectGetMaxX(line2.frame)+3, CGRectGetMaxY(tag.frame)+5, kScreenWidth/3-3, 35);
        mjLab.text = @"面积";
        mjLab.textColor = [UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1];
        mjLab.font = [UIFont systemFontOfSize:17];
        mjLab.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:mjLab];
        
        UILabel *mjLab1 = [[UILabel alloc]init];
        mjLab1.frame = CGRectMake(CGRectGetMaxX(line2.frame)+3, CGRectGetMaxY(mjLab.frame)+5, kScreenWidth/3-3, 35);
        mjLab1.text = @"120平米";
        mjLab1.textColor = [UIColor colorWithRed:252/255.0 green:79/255.0 blue:40/255.0 alpha:1];
        mjLab1.font = [UIFont systemFontOfSize:17];
        mjLab1.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:mjLab1];
        
        UIButton *ckxqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        ckxqBtn.frame = CGRectMake(10, CGRectGetMaxY(mjLab1.frame)+5, kScreenWidth-20, 115);
        ckxqBtn.backgroundColor = [UIColor purpleColor];
        ckxqBtn.layer.cornerRadius = 3.0;
        [ckxqBtn setTitle:@"查看详情 " forState:UIControlStateNormal];
        [ckxqBtn addTarget:self action:@selector(ckxqAction) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:ckxqBtn];
    
        
    }else if (indexPath.section == 2){
        
        UILabel *titleLab = [[UILabel alloc]init];
        titleLab.frame = CGRectMake(10, 10, 150, 50);
        titleLab.text = @"基本信息";
        titleLab.font = [UIFont systemFontOfSize:20];
        titleLab.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:titleLab];
        
        UILabel *fkLab = [[UILabel alloc]init];
        fkLab.frame = CGRectMake(10, CGRectGetMaxY(titleLab.frame), 50, 30);
        fkLab.text = @"付款:";
        fkLab.font = [UIFont systemFontOfSize:16];
        fkLab.textAlignment = NSTextAlignmentLeft;
        fkLab.textColor = [UIColor colorWithRed:157/255.0 green:157/255.0 blue:157/255.0 alpha:1];
        [cell addSubview:fkLab];
        
        UILabel *fkLab1 = [[UILabel alloc]init];
        fkLab1.frame = CGRectMake(CGRectGetMaxX(fkLab.frame), CGRectGetMaxY(titleLab.frame), kScreenWidth/2-10-50, 30);
        fkLab1.text = @"年付";
        fkLab1.font = [UIFont systemFontOfSize:16];
        fkLab1.textAlignment = NSTextAlignmentLeft;
        fkLab1.textColor = [UIColor blackColor];
        [cell addSubview:fkLab1];
        
        UILabel *lcLab = [[UILabel alloc]init];
        lcLab.frame = CGRectMake(10, CGRectGetMaxY(fkLab.frame), 50, 30);
        lcLab.text = @"楼层:";
        lcLab.font = [UIFont systemFontOfSize:16];
        lcLab.textAlignment = NSTextAlignmentLeft;
        lcLab.textColor = [UIColor colorWithRed:157/255.0 green:157/255.0 blue:157/255.0 alpha:1];
        [cell addSubview:lcLab];
        
        UILabel *lcLab1 = [[UILabel alloc]init];
        lcLab1.frame = CGRectMake(CGRectGetMaxX(lcLab.frame), CGRectGetMaxY(fkLab.frame), kScreenWidth/2-10-50, 30);
        lcLab1.text = @"5/9层";
        lcLab1.font = [UIFont systemFontOfSize:16];
        lcLab1.textAlignment = NSTextAlignmentLeft;
        lcLab1.textColor = [UIColor blackColor];
        [cell addSubview:lcLab1];
        
        UILabel *rzLab = [[UILabel alloc]init];
        rzLab.frame = CGRectMake(10, CGRectGetMaxY(lcLab.frame), 50, 30);
        rzLab.text = @"入住:";
        rzLab.font = [UIFont systemFontOfSize:16];
        rzLab.textAlignment = NSTextAlignmentLeft;
        rzLab.textColor = [UIColor colorWithRed:157/255.0 green:157/255.0 blue:157/255.0 alpha:1];
        [cell addSubview:rzLab];
        
        UILabel *rzLab1 = [[UILabel alloc]init];
        rzLab1.frame = CGRectMake(CGRectGetMaxX(rzLab.frame), CGRectGetMaxY(lcLab.frame), kScreenWidth/2-10-50, 30);
        rzLab1.text = @"随时入住";
        rzLab1.font = [UIFont systemFontOfSize:16];
        rzLab1.textAlignment = NSTextAlignmentLeft;
        rzLab1.textColor = [UIColor blackColor];
        [cell addSubview:rzLab1];
        
        UILabel *zqLab = [[UILabel alloc]init];
        zqLab.frame = CGRectMake(kScreenWidth/2, CGRectGetMaxY(titleLab.frame), 50, 30);
        zqLab.text = @"租期:";
        zqLab.font = [UIFont systemFontOfSize:16];
        zqLab.textAlignment = NSTextAlignmentLeft;
        zqLab.textColor = [UIColor colorWithRed:157/255.0 green:157/255.0 blue:157/255.0 alpha:1];
        [cell addSubview:zqLab];
        
        UILabel *zqLab1 = [[UILabel alloc]init];
        zqLab1.frame = CGRectMake(CGRectGetMaxX(zqLab.frame), CGRectGetMaxY(titleLab.frame), kScreenWidth/2-10-50, 30);
        zqLab1.text = @"3—12个月";
        zqLab1.font = [UIFont systemFontOfSize:16];
        zqLab1.textAlignment = NSTextAlignmentLeft;
        zqLab1.textColor = [UIColor blackColor];
        [cell addSubview:zqLab1];
        
        UILabel *dtLab = [[UILabel alloc]init];
        dtLab.frame = CGRectMake(kScreenWidth/2, CGRectGetMaxY(zqLab.frame), 50, 30);
        dtLab.text = @"电梯:";
        dtLab.font = [UIFont systemFontOfSize:16];
        dtLab.textAlignment = NSTextAlignmentLeft;
        dtLab.textColor = [UIColor colorWithRed:157/255.0 green:157/255.0 blue:157/255.0 alpha:1];
        [cell addSubview:dtLab];
        
        UILabel *dtLab1 = [[UILabel alloc]init];
        dtLab1.frame = CGRectMake(CGRectGetMaxX(dtLab.frame), CGRectGetMaxY(zqLab.frame), kScreenWidth/2-10-50, 30);
        dtLab1.text = @"无";
        dtLab1.font = [UIFont systemFontOfSize:16];
        dtLab1.textAlignment = NSTextAlignmentLeft;
        dtLab1.textColor = [UIColor blackColor];
        [cell addSubview:dtLab1];
        
        UILabel *fbsjLab = [[UILabel alloc]init];
        fbsjLab.frame = CGRectMake(kScreenWidth/2, CGRectGetMaxY(dtLab.frame), 80, 30);
        fbsjLab.text = @"发布时间:";
        fbsjLab.font = [UIFont systemFontOfSize:16];
        fbsjLab.textAlignment = NSTextAlignmentLeft;
        fbsjLab.textColor = [UIColor colorWithRed:157/255.0 green:157/255.0 blue:157/255.0 alpha:1];
        [cell addSubview:fbsjLab];
        
        UILabel *fbsjLab1 = [[UILabel alloc]init];
        fbsjLab1.frame = CGRectMake(CGRectGetMaxX(fbsjLab.frame), CGRectGetMaxY(dtLab.frame), kScreenWidth/2-10-80, 30);
        fbsjLab1.text = @"2018.08.08";
        fbsjLab1.font = [UIFont systemFontOfSize:16];
        fbsjLab1.textAlignment = NSTextAlignmentLeft;
        fbsjLab1.textColor = [UIColor blackColor];
        [cell addSubview:fbsjLab1];
    }else if (indexPath.section == 3){
        
        UILabel *titleLab = [[UILabel alloc]init];
        titleLab.frame = CGRectMake(10, 10, 150, 50);
        titleLab.text = @"小区和周边";
        titleLab.font = [UIFont systemFontOfSize:20];
        titleLab.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:titleLab];
        
        
    }else{
        
        UIImageView *imgView = [[UIImageView alloc]init];
        imgView.frame = CGRectMake(10, 10, 100, 100);
        imgView.backgroundColor = [UIColor redColor];
        [cell addSubview:imgView];
        
        UILabel *titleLab = [[UILabel alloc]init];
        titleLab.frame = CGRectMake(CGRectGetMaxX(imgView.frame)+5, 10, kScreenWidth-20-5-100, 40);
        titleLab.text = @"迎宾合作住宅区-3室1厅1卫-面积120平米|3/6层";
        titleLab.textColor = [UIColor grayColor];
        titleLab.font = [UIFont systemFontOfSize:15];
        titleLab.numberOfLines = 2;
        titleLab.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:titleLab];
        
        UILabel *rengZhengLab = [[UILabel alloc]init];
        rengZhengLab.frame = CGRectMake(CGRectGetMaxX(imgView.frame)+5, CGRectGetMaxY(titleLab.frame)+5, 80, 20);
        rengZhengLab.text = @"物业认证";
        rengZhengLab.backgroundColor = [UIColor colorWithRed:252/255.0 green:88/255.0 blue:48/255.0 alpha:1];
        rengZhengLab.textColor = [UIColor whiteColor];
        rengZhengLab.font = [UIFont systemFontOfSize:15];
        rengZhengLab.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:rengZhengLab];
        
        UILabel *biaoQianLab = [[UILabel alloc]init];
        biaoQianLab.frame = CGRectMake(CGRectGetMaxX(rengZhengLab.frame)+5, CGRectGetMaxY(titleLab.frame)+5, 50, 20);
        biaoQianLab.text = @"精装修";
        biaoQianLab.backgroundColor = [UIColor colorWithRed:255/255.0 green:247/255.0 blue:247/255.0 alpha:1];
        biaoQianLab.textColor = [UIColor colorWithRed:252/255.0 green:99/255.0 blue:60/255.0 alpha:1];
        biaoQianLab.font = [UIFont systemFontOfSize:15];
        biaoQianLab.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:biaoQianLab];
        
        UILabel *priceLab = [[UILabel alloc]init];
        priceLab.frame = CGRectMake(CGRectGetMaxX(imgView.frame)+5, CGRectGetMaxY(rengZhengLab.frame)+5, 100, 30);
        priceLab.text = @"1500元/月";
        //    priceLab.backgroundColor = [UIColor colorWithRed:255/255.0 green:247/255.0 blue:247/255.0 alpha:1];
        priceLab.textColor = [UIColor colorWithRed:252/255.0 green:99/255.0 blue:60/255.0 alpha:1];
        priceLab.font = [UIFont systemFontOfSize:17];
        priceLab.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:priceLab];
        
        UILabel *jPriceLab = [[UILabel alloc]init];
        jPriceLab.frame = CGRectMake(CGRectGetMaxX(priceLab.frame)+5, CGRectGetMaxY(rengZhengLab.frame)+10, 100, 20);
        jPriceLab.text = @"1500元/平米";
        //    jPriceLab = [UIColor colorWithRed:255/255.0 green:247/255.0 blue:247/255.0 alpha:1];
        jPriceLab.textColor = [UIColor colorWithRed:162/255.0 green:162/255.0 blue:162/255.0 alpha:1];
        jPriceLab.font = [UIFont systemFontOfSize:14];
        jPriceLab.textAlignment = NSTextAlignmentRight;
        [cell addSubview:jPriceLab];
    }
    
    
    return cell;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 4) {
        
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        headerView.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLab = [[UILabel alloc]init];
        titleLab.frame = CGRectMake(10, 10, 150, 50);
        titleLab.text = @"推荐房屋";
        titleLab.font = [UIFont systemFontOfSize:20];
        titleLab.textAlignment = NSTextAlignmentLeft;
        [headerView addSubview:titleLab];
        return headerView;
        
    }else {
        
       return nil;
    }
    
}
#pragma mark - 联系经纪人咨询
- (void)loadFunctionView {
    CGFloat contentY = kScreenHeight-50;
    UIView *functionView = [[UIView alloc]initWithFrame:CGRectMake(0, contentY, kScreenWidth, 50)];
    functionView.backgroundColor = [UIColor colorWithRed:243/255.0 green:247/255.0 blue:248/255.0 alpha:1];
    
    contentY += 30;
    
    UIImageView *logoImg = [[UIImageView alloc]init];
    logoImg.backgroundColor = [UIColor purpleColor];
    logoImg.frame = CGRectMake(10, 10, 30, 30);
    logoImg.layer.cornerRadius = 15;
    logoImg.clipsToBounds = YES;
    [functionView addSubview:logoImg];
    
    UILabel *jjlab = [[UILabel alloc]init];
    jjlab.frame = CGRectMake(CGRectGetMaxX(logoImg.frame)+3, 10, kScreenWidth/2-10-30, 15);
    jjlab.text = @"经纪人";
    jjlab.textColor = [UIColor blackColor];
    jjlab.font = [UIFont systemFontOfSize:14];
    jjlab.textAlignment = NSTextAlignmentLeft;
    [functionView addSubview:jjlab];
    
    UILabel *jjlab1 = [[UILabel alloc]init];
    jjlab1.frame = CGRectMake(CGRectGetMaxX(logoImg.frame)+3, CGRectGetMaxY(jjlab.frame), kScreenWidth/2-10-30, 15);
    jjlab1.text = @"华晟科技测试";
    jjlab1.textColor = [UIColor grayColor];
    jjlab1.font = [UIFont systemFontOfSize:14];
    jjlab1.textAlignment = NSTextAlignmentLeft;
    [functionView addSubview:jjlab1];
    
    
    
    UIButton *likeButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-10-130, 10, 130, 30)];
    likeButton.backgroundColor = [UIColor colorWithRed:252/255.0 green:88/255.0 blue:48/255.0 alpha:1];
    [likeButton setTitle:@"联系经纪人咨询" forState:UIControlStateNormal];
    [likeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [likeButton setTitleColor:Blue_Selected forState:UIControlStateSelected];
    likeButton.titleLabel.font = [UIFont systemFontOfSize:17];
//    [likeButton setImage:[UIImage imageNamed:@"icon_praise"] forState:UIControlStateNormal];
//    [likeButton setImage:[UIImage imageNamed:@"icon_praise_tabbar"] forState:UIControlStateSelected];
    [likeButton addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
    likeButton.layer.cornerRadius = 3.0;
    [functionView addSubview:likeButton];
    [self.view addSubview:functionView];
    
}
-(void)ckxqAction{
    
    huoDongDetailViewController *hdDetailVC = [[huoDongDetailViewController alloc]init];
    [self.navigationController pushViewController:hdDetailVC animated:YES];
}
- (int)navBarBottom
{
    if ([WRNavigationBar isIphoneX]) {
        return 88;
    } else {
        return 64;
    }
}
- (void)setupNavItems
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [self.navigationItem setTitleView:view];

    UIButton *butleft = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 30, 30)];
    [butleft setImage:[UIImage imageNamed:@"fenlei"] forState:UIControlStateNormal];
    butleft.backgroundColor = [UIColor redColor];
    [butleft addTarget:self action:@selector(onClickLeft) forControlEvents:UIControlEventTouchUpInside];
    butleft.backgroundColor = [UIColor clearColor];
    [view addSubview:butleft];

}
#pragma mark - PTLMenuButtonDelegate
-(void)ptl_menuButton:(PTLMenuButton *)menuButton didSelectMenuButtonAtIndex:(NSInteger)index selectMenuButtonTitle:(NSString *)title listRow:(NSInteger)row rowTitle:(NSString *)rowTitle{
    NSLog(@"index: %zd, title:%@, listrow: %zd, rowTitle: %@", index, title, row, rowTitle);
}

#pragma mark - KMTagListViewDelegate
-(void)ptl_TagListView:(KMTagListView *)tagListView didSelectTagViewAtIndex:(NSInteger)index selectContent:(NSString *)content {
    NSLog(@"content: %@ index: %zd", content, index);
    
}


@end
