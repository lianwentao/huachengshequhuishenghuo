//
//  newserviceViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/11/23.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "newserviceViewController.h"
#import "WRNavigationBar.h"
#import <AFNetworking.h>
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "JKBannarView.h"
#import "MenuScrollView.h"
#import "CustomerScrollViewModel.h"
#import "ScanViewController.h"//扫描二维码界面
#import <AVFoundation/AVFoundation.h>
#import "newshangjiaViewController.h"

#import "fengLeiDetailViewController.h"
#import "serviceDetailViewController.h"

#define NAVBAR_COLORCHANGE_POINT (-IMAGE_HEIGHT + NAV_HEIGHT)
#define NAV_HEIGHT 64
#define IMAGE_HEIGHT 0
#define SCROLL_DOWN_LIMIT 70
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define LIMIT_OFFSET_Y -(IMAGE_HEIGHT + SCROLL_DOWN_LIMIT)
@interface newserviceViewController ()<UITableViewDelegate,UITableViewDataSource,MenuScrollViewDeleagte,AVCaptureMetadataOutputObjectsDelegate>{
    NSArray *category;
    NSArray *category_service;
    NSArray *info;
    NSArray *item;
    
    NSArray *topArr;
    JKBannarView *bannerView;
}

@property (nonatomic,strong) MenuScrollView * menuScrollView;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation newserviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    category = [[NSArray alloc] init];
    category_service = [[NSArray alloc] init];
    info = [[NSArray alloc] init];
    item = [[NSArray alloc] init];
    topArr = [[NSArray alloc] init];
    
    [self topData];
    [self getdata];
    
    [self setupNavItems];
    [self createui];
    
    
    [self wr_setNavBarBarTintColor:[UIColor whiteColor]];
    [self wr_setNavBarBackgroundAlpha:0];
    // Do any additional setup after loading the view.
}
- (void)setupNavItems
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [self.navigationItem setTitleView:view];

    UIButton *butleft = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
    [butleft setImage:[UIImage imageNamed:@"扫描"] forState:UIControlStateNormal];
    butleft.backgroundColor = [UIColor redColor];
    [butleft addTarget:self action:@selector(onClickLeft) forControlEvents:UIControlEventTouchUpInside];
    butleft.backgroundColor = [UIColor clearColor];
    [view addSubview:butleft];

    UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-50, 5, 30, 30)];
    [but setImage:[UIImage imageNamed:@"订单"] forState:UIControlStateNormal];
    but.backgroundColor = [UIColor redColor];
    [but addTarget:self action:@selector(onClickRight) forControlEvents:UIControlEventTouchUpInside];
    but.backgroundColor = [UIColor clearColor];
    [view addSubview:but];

    UIButton *butthree = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-50-40, 5, 30, 30)];
    [butthree setImage:[UIImage imageNamed:@"搜索"] forState:UIControlStateNormal];
    butthree.backgroundColor = [UIColor redColor];
    [butthree addTarget:self action:@selector(butthree) forControlEvents:UIControlEventTouchUpInside];
    butthree.backgroundColor = [UIColor clearColor];
    [view addSubview:butthree];

}
- (void)onClickLeft
{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (granted) {
                //配置扫描view
                ScanViewController *scan = [[ScanViewController alloc] init];
                scan.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:scan animated:YES];
            } else {
                NSString *title = @"请在iPhone的”设置-隐私-相机“选项中，允许App访问你的相机";
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:@"" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
                [alertView show];
            }
            
        });
    }];
}
- (void)onClickRight
{
    myserviceViewController *myservice = [[myserviceViewController alloc] init];
    myservice.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myservice animated:YES];
}
- (void)butthree
{}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < -IMAGE_HEIGHT) {
        [self updateNavBarButtonItemsAlphaAnimated:.0f];
    } else {
        [self updateNavBarButtonItemsAlphaAnimated:1.0f];
    }
    
    if (offsetY > NAVBAR_COLORCHANGE_POINT)
    {
        CGFloat alpha = (offsetY - NAVBAR_COLORCHANGE_POINT) / NAV_HEIGHT;
        [self wr_setNavBarBackgroundAlpha:alpha];
    }
    else
    {
        [self wr_setNavBarBackgroundAlpha:0];
    }
    
    //    //限制下拉的距离
    //    if(offsetY < LIMIT_OFFSET_Y) {
    //        [scrollView setContentOffset:CGPointMake(0, LIMIT_OFFSET_Y)];
    //    }
}
- (void)updateNavBarButtonItemsAlphaAnimated:(CGFloat)alpha
{
    [UIView animateWithDuration:0.2 animations:^{
        [self.navigationController.navigationBar wr_setBarButtonItemsAlpha:alpha hasSystemBackIndicator:NO];
    }];
}
- (void)createui
{
    CGRect frame = CGRectMake(0, 0, Main_width, Main_Height);
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = BackColor;
    
    __weak typeof(self) weakSelf = self;
    _tableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    //_tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(xiala)];
    self.tableView.contentInset = UIEdgeInsetsMake(IMAGE_HEIGHT - [self navBarBottom], 0, 0, 0);
    [self.view addSubview:self.tableView];
}
- (void)loadData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView.mj_header endRefreshing];
        [self getdata];
        [self topData];
    });
}


#pragma mark - tableview delegate / dataSource

// 分组的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==2) {
        return category_service.count+1;
    }else if (section==3) {
        return 2;
    }else if (section==4){
        return item.count+1;
    } else{
        return 1;
    }
}


//headview的高度和内容
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section==3){
        return @"";
    }else{
        return @"";
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIndetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
        
    }
    if (indexPath.section==0) {
        if ([topArr isKindOfClass:[NSArray class]]) {
            tableView.rowHeight = Main_width/(1.87);
            [cell.contentView addSubview:bannerView];
        }else{
            tableView.rowHeight = RECTSTATUS.size.height+44;
        }
    }else if (indexPath.section==1){
        if ([category isKindOfClass:[NSArray class]]) {
            _menuScrollView = [[MenuScrollView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 200)];
            _menuScrollView.maxCol  =  5;
            _menuScrollView.maxRow = 2;
            _menuScrollView.delegate = self;
            [cell.contentView addSubview:_menuScrollView];
            
            NSMutableArray *mulu = [NSMutableArray arrayWithCapacity:0];
            for (int i=0; i<category.count; i++) {
                CustomerScrollViewModel * model = [[CustomerScrollViewModel alloc ] init];
                model.name = [[category objectAtIndex:i] objectForKey:@"name"];
                model.icon = [[category objectAtIndex:i] objectForKey:@"img"];
                [mulu addObject:model];
            }
            self.menuScrollView.dataArr = mulu;
            tableView.rowHeight = 200;
        }else{
            tableView.rowHeight = 0;
        }
    }else if (indexPath.section==2){
        if (indexPath.row==0) {
            UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 105, 45)];
            imageview.image = [UIImage imageNamed:@"最受欢迎"];
            [cell.contentView addSubview:imageview];
            
            tableView.rowHeight = 65;
        }else{
            
            UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            titleBtn.frame = CGRectMake(15, 20, Main_width-30, 15);
            titleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            NSString *titleStr = [NSString stringWithFormat:@"%@>",[[category_service objectAtIndex:indexPath.row-1] objectForKey:@"name"]];
            titleBtn.tag = [[NSString stringWithFormat:@"%@",[[category_service objectAtIndex:indexPath.row-1] objectForKey:@"id"]] integerValue]+100;
            [titleBtn setTitle: titleStr forState:UIControlStateNormal];
             titleBtn.alpha = 0.54;
            [titleBtn addTarget:self action:@selector(titleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:titleBtn];
            
//            UILabel *label = [[UILabel alloc] init];
//            label.frame = CGRectMake(15, 20, Main_width-30, 15);
//            label.font = [UIFont systemFontOfSize:14];
//            label.alpha = 0.54;
//            label.text = [NSString stringWithFormat:@"%@>",[[category_service objectAtIndex:indexPath.row-1] objectForKey:@"name"]];
//            [cell.contentView addSubview:label];
            
            UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 35+18, Main_width, 114+10+15)];
            scrollview.showsHorizontalScrollIndicator = NO;
            scrollview.showsVerticalScrollIndicator = NO;
            [cell.contentView addSubview:scrollview];
            
            NSArray *imgarr = [[NSArray alloc] init];
            imgarr = [[category_service objectAtIndex:indexPath.row-1] objectForKey:@"service"];
            scrollview.contentSize = CGSizeMake(30+252*imgarr.count-10, 114+10+15);
            for (int i=0; i<imgarr.count; i++) {
                
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15+242*i+10*i, 0, 242, 97)];
                view.backgroundColor = [UIColor whiteColor];
                view.layer.cornerRadius = 3;
                [scrollview addSubview:view];
                
                UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 242, 97)];
                [img sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:[[imgarr objectAtIndex:i] objectForKey:@"title_img"]]] placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
                img.clipsToBounds = YES;
                img.layer.cornerRadius = 7;
                [view addSubview:img];
                
                UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                imgBtn.frame = CGRectMake(0, 0, 242, 97);
                imgBtn.tag = [[[imgarr objectAtIndex:i] objectForKey:@"id"] integerValue]+100;
                [imgBtn addTarget:self action:@selector(imgBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:imgBtn];
                
                UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15+242*i+10*i, 107, 242, 15)];
                label1.text = [[imgarr objectAtIndex:i] objectForKey:@"title"];
                label1.font = [UIFont systemFontOfSize:14];
                label1.textAlignment = NSTextAlignmentCenter;
                [scrollview addSubview:label1];
            }
            
            UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(15, scrollview.frame.size.height+scrollview.frame.origin.y+10, Main_width-30, 0.5)];
            lineview.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.05];
            [cell.contentView addSubview:lineview];
            
            tableView.rowHeight = lineview.frame.size.height+lineview.frame.origin.y;
        }
    }else if (indexPath.section==3){
        if (indexPath.row==0) {
            UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 105, 45)];
            imageview.image = [UIImage imageNamed:@"优质商家"];
            [cell.contentView addSubview:imageview];
            
            UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            titleBtn.frame = CGRectMake(Main_width-60, 20, 50, 30);
            titleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            NSString *titleStr = @"更多>";
            [titleBtn setTitle: titleStr forState:UIControlStateNormal];
            titleBtn.alpha = 0.54;
            [titleBtn addTarget:self action:@selector(gengDuoAction1:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:titleBtn];
            
            tableView.rowHeight = 65;
        }else{
            UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(15, 20, Main_width-30, 227)];
            scrollview.showsHorizontalScrollIndicator = NO;
            scrollview.showsVerticalScrollIndicator = NO;
            scrollview.contentSize = CGSizeMake(168*info.count, 227);
            [cell.contentView addSubview:scrollview];
            
            for (int i = 0; i<info.count; i++) {
                
                UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(168*i, 0, 158, 227)];
                backview.clipsToBounds = YES;
                backview.layer.cornerRadius = 10;
                backview.layer.borderColor = BackColor.CGColor;//颜色
                backview.layer.borderWidth = 1.0f;//设置边框粗细
                [scrollview addSubview:backview];
                
                UIImageView *imgview1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 158, 80)];
                [imgview1 sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:[[info objectAtIndex:i] objectForKey:@"index_img"]]] placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
                [backview addSubview:imgview1];
                
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(55, 50, 48, 48)];
                view.backgroundColor = [UIColor whiteColor];
                view.clipsToBounds = YES;
                view.layer.cornerRadius = 24;
                [backview addSubview:view];
                
                UIImageView *imgview2 = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, 40, 40)];
                [imgview2 sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:[[info objectAtIndex:i] objectForKey:@"logo"]]] placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
                imgview2.clipsToBounds = YES;
                imgview2.layer.cornerRadius = 20;
                [view addSubview:imgview2];
                
                UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, view.frame.size.height+view.frame.origin.y+10, 158, 15)];
                label1.text = [[info objectAtIndex:i] objectForKey:@"name"];
                label1.font = [UIFont systemFontOfSize:14];
                label1.textAlignment = NSTextAlignmentCenter;
                [backview addSubview:label1];
                
                UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(45, label1.frame.size.height+label1.frame.origin.y+64, 68, 27)];
                label2.layer.borderColor = [UIColor blackColor].CGColor;//颜色
                label2.layer.borderWidth = 1.0f;//设置边框粗细
                label2.layer.masksToBounds = YES;
                label2.layer.cornerRadius = 10;
                label2.font = [UIFont systemFontOfSize:11];
                label2.text = @"进店逛逛";
                label2.textAlignment = NSTextAlignmentCenter;
                [backview addSubview:label2];
                
                UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
                but.frame = CGRectMake(0, 0, 158, 227);
                but.tag = i;
                [but addTarget:self action:@selector(pushshangjia:) forControlEvents:UIControlEventTouchUpInside];
                [backview addSubview:but];
            }
            
            UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(15, scrollview.frame.size.height+scrollview.frame.origin.y+19.5, Main_width-30, 0.5)];
            lineview.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.05];
            [cell.contentView addSubview:lineview];
            
            tableView.rowHeight = 227+40;
        }
    }else if (indexPath.section==4){
        if (indexPath.row==0) {
            UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 105, 45)];
            imageview.image = [UIImage imageNamed:@"精选服务"];
            [cell.contentView addSubview:imageview];
            
            UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            titleBtn.frame = CGRectMake(Main_width-60, 20, 50, 30);
            titleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            NSString *titleStr = @"更多>";
            [titleBtn setTitle: titleStr forState:UIControlStateNormal];
            titleBtn.alpha = 0.54;
            [titleBtn addTarget:self action:@selector(gengDuoAction2:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:titleBtn];
            
            tableView.rowHeight = 65;
        }else{
            
            
            UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, Main_width-30, (Main_width-30)/[[[item objectAtIndex:indexPath.row-1] objectForKey:@"title_img_size"] floatValue])];
            [imgview sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:[[item objectAtIndex:indexPath.row-1] objectForKey:@"title_img"]]] placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
            imgview.clipsToBounds = YES;
            imgview.layer.cornerRadius = 10;
            [cell.contentView addSubview:imgview];
            
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 15+imgview.frame.size.height+imgview.frame.origin.y, Main_width*3/4, 15)];
            label1.text = [[item objectAtIndex:indexPath.row-1] objectForKey:@"title"];
            label1.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:label1];
            
            UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(Main_width*3/4-15, 15+imgview.frame.size.height+imgview.frame.origin.y, Main_width/4, 15)];
            price.text = [NSString stringWithFormat:@"¥%@",[[item objectAtIndex:indexPath.row-1] objectForKey:@"price"]];
            price.font = [UIFont systemFontOfSize:14];
            price.textAlignment = NSTextAlignmentRight;
            price.textColor = [UIColor colorWithRed:255/255.0 green:87/255.0 blue:34/255.0 alpha:1.0];
            [cell.contentView addSubview:price];
            
            UIImageView *touxiang = [[UIImageView alloc] initWithFrame:CGRectMake(15, label1.frame.size.height+label1.frame.origin.y+15, 20, 20)];
            touxiang.clipsToBounds = YES;
            touxiang.layer.cornerRadius = 10;
            [touxiang sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:[[item objectAtIndex:indexPath.row-1] objectForKey:@"logo"]]] placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
            [cell.contentView addSubview:touxiang];
            
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(15+20+7, label1.frame.size.height+label1.frame.origin.y+15, Main_width-30, 20)];
            label2.text = [[item objectAtIndex:indexPath.row-1] objectForKey:@"i_name"];
            label2.font = [UIFont systemFontOfSize:11];
            [cell.contentView addSubview:label2];
            
            UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(15, label2.frame.size.height+label2.frame.origin.y+10, Main_width-30, 0.5)];
            lineview.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.05];
            [cell.contentView addSubview:lineview];
            
            tableView.rowHeight = lineview.frame.size.height+lineview.frame.origin.y;
        }
    }else {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Main_width, Main_width/1.76)];
        img.image = [UIImage imageNamed:@"底部"];
        [cell.contentView addSubview:img];
        tableView.rowHeight = Main_width/1.76;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section==4){
        if (indexPath.row == 0) {
        }else{
            NSString *idStr =  [[item objectAtIndex:indexPath.row-1] objectForKey:@"id"];
            NSString *titleStr =  [[item objectAtIndex:indexPath.row-1] objectForKey:@"title"];
//            NSLog(@"idStr = %@",idStr);
//            NSLog(@"titleStr = %@",titleStr);
            serviceDetailViewController *sdVC = [[serviceDetailViewController alloc]init];
            sdVC.hidesBottomBarWhenPushed = YES;
            sdVC.serviceID = idStr;
            sdVC.serviceTitle = titleStr;
            [self.navigationController pushViewController:sdVC animated:YES];
        }
    }
}
- (void)pushshangjia:(UIButton *)sender
{
    newshangjiaViewController *shangjia = [[newshangjiaViewController alloc] init];
    shangjia.shangjiaid = [[info objectAtIndex:sender.tag] objectForKey:@"id"];
    shangjia.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shangjia animated:YES];
}

- (int)navBarBottom
{
    if ([WRNavigationBar isIphoneX]) {
        return 88;
    } else {
        return 64;
    }
}
//下拉刷新
- (void)xiala
{
    
}
-(void)getdata
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = @{@"c_id":[user objectForKey:@"community_id"]};
    NSString *strurl = [API_NOAPK stringByAppendingString:@"/service/index/serviceindex"];
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        WBLog(@"fuwujiekou--%@",responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            category = [[responseObject objectForKey:@"data"] objectForKey:@"category"];
            category_service = [[responseObject objectForKey:@"data"] objectForKey:@"category_service"];
            info = [[responseObject objectForKey:@"data"] objectForKey:@"info"];
            item = [[responseObject objectForKey:@"data"] objectForKey:@"item"];
        }
        
        [_tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WBLog(@"failure--%@",error);
    }];
}
-(void)topData
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = @{@"community_id":[user objectForKey:@"community_id"]};
    NSString *strurl = [API stringByAppendingString:@"site/get_Advertising/c_name/service_indextop"];
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        WBLog(@"fuwujiekoutop--%@",responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            topArr = [responseObject objectForKey:@"data"];
            
            NSMutableArray *imagearr = [NSMutableArray array];
            bannerView = [[JKBannarView alloc]initWithFrame:CGRectMake(0, 0, Main_width, Main_width/(1.87)) viewSize:CGSizeMake(Main_width,Main_width/(1.87))];
            
            if ([topArr isKindOfClass:[NSArray class]]) {
                for (int i=0; i<topArr.count; i++) {
                    NSString *strurl = [API_img stringByAppendingString:[[topArr objectAtIndex:i]objectForKey:@"img"]];
                    WBLog(@"%@",strurl);
                    [imagearr addObject:strurl];
                    bannerView.items = imagearr;
                }
            }else{
                imagearr  =  nil;
                
            }
        }
        
        [_tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
#pragma mark - item 点击跳转
- (void)menuScrollViewDeleagte:(id)menuScrollViewDeleagte index:(NSInteger)index{
    NSLog(@"点击的是 第%ld个",index);
    if ([category isKindOfClass:[NSArray class]]) {
        
        NSMutableArray *IDArr = [NSMutableArray array];
        for (int i = 0; i < category.count; i++) {
            NSDictionary *dic = category[i];
            NSString *idStr = [dic objectForKey:@"id"];
            [IDArr addObject:idStr];
        }
        NSMutableArray *titleArr = [NSMutableArray array];
        for (int i = 0; i < category.count; i++) {
            NSDictionary *dic = category[i];
            NSString *titleStr = [dic objectForKey:@"name"];
            [titleArr addObject:titleStr];
        }
        fengLeiDetailViewController *fldVC = [[fengLeiDetailViewController alloc]init];
        fldVC.hidesBottomBarWhenPushed = YES;
        fldVC.fuwuid = IDArr[index];
        fldVC.name = titleArr[index];
        [self.navigationController pushViewController:fldVC animated:YES];
        
    }
}
#pragma mark - 最受欢迎 titleBtn 点击跳转
-(void)titleBtnAction:(UIButton *)sender{
    
    fengLeiDetailViewController *fldVC = [[fengLeiDetailViewController alloc]init];
    fldVC.hidesBottomBarWhenPushed = YES;
    fldVC.fuwuid =[NSString stringWithFormat:@"%ld",sender.tag-100];
    fldVC.name = sender.titleLabel.text;
    [self.navigationController pushViewController:fldVC animated:YES];
}
#pragma mark - 最受欢迎 imgActionBtn 点击跳转
-(void)imgBtnAction:(UIButton *)sender{
    serviceDetailViewController *sdVC = [[serviceDetailViewController alloc]init];
    sdVC.hidesBottomBarWhenPushed = YES;
    sdVC.serviceID =[NSString stringWithFormat:@"%ld",sender.tag-100];
    sdVC.serviceTitle = sender.titleLabel.text;
    [self.navigationController pushViewController:sdVC animated:YES];
}
#pragma mark - 更多
-(void)gengDuoAction1:(UIButton *)sender{
    fengLeiDetailViewController *fldVC = [[fengLeiDetailViewController alloc]init];
    fldVC.hidesBottomBarWhenPushed = YES;
    fldVC.fuwuid = @"";
    fldVC.name = @"全部";
    fldVC.tagStr = @"1";
    [self.navigationController pushViewController:fldVC animated:YES];
}
-(void)gengDuoAction2:(UIButton *)sender{
    fengLeiDetailViewController *fldVC = [[fengLeiDetailViewController alloc]init];
    fldVC.hidesBottomBarWhenPushed = YES;
    fldVC.fuwuid = @"";
    fldVC.name = @"全部";
    fldVC.tagStr = @"0";
    [self.navigationController pushViewController:fldVC animated:YES];
}

@end
