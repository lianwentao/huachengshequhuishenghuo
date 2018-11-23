//
//  shouFangDetailViewController.m
//  HuiShengHuo2.0
//
//  Created by admin on 2018/11/17.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "shouFangDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+TVAssistant.h"
#import "WRNavigationBar.h"
#import "MJRefresh.h"
#import "PTLMenuButton.h"
#import "KMTagListView.h"
#import "sfHuoDongDetailViewController.h"
#import <AFNetworking.h>
#import "JKBannarView.h"

#define kScreenHeight   ([UIScreen mainScreen].bounds.size.height)
#define kScreenWidth    ([UIScreen mainScreen].bounds.size.width)
#define NAV_HEIGHT 64
#define IMAGE_HEIGHT 0
#define SCROLL_DOWN_LIMIT 70

#import "sfDetailModel.h"
#import "tjListModel.h"
@interface shouFangDetailViewController ()<UITableViewDelegate,UITableViewDataSource,PTLMenuButtonDelegate, KMTagListViewDelegate>
{
    UITableView *tableView;
    UIImageView *redcountimage;
    NSMutableArray *dataSourceArr;
    NSMutableArray *tjArr;
    NSMutableArray *labelArr;
    JKBannarView *bannerView;
    
}

@end

@implementation shouFangDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
   
    [self loadData];
    [self CreateTableview];
    [self loadFunctionView];
    
    [self wr_setNavBarBarTintColor:BackColor];
    [self wr_setNavBarBackgroundAlpha:0];
    
}
-(void)loadData{

    
    NSLog(@"_sfID = %@",_sfID);
    
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = @{@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"],@"house_id":_sfID};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSLog(@"dict = %@",dict);
    NSString *strurl = [API stringByAppendingString:@"secondHouseType/getSellListDetails"];
    NSLog(@"strurl = %@",strurl);
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"gouwuche--%@",responseObject);
        
        NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"dataStr = %@",dataStr);
        NSDictionary *dataDic = responseObject[@"data"];
        NSLog(@"dataDic = %@",dataDic);
        dataSourceArr = [NSMutableArray array];
       sfDetailModel *model =  [[sfDetailModel alloc]initWithDictionary:dataDic error:nil];
        [dataSourceArr addObject:model];
        
        tjArr = [NSMutableArray array];
        for (NSDictionary *tjDic in model.recommend) {
            tjListModel *tjModel = [[tjListModel alloc]initWithDictionary:tjDic error:NULL];
            [tjArr addObject:tjModel];
        }
        
        [self CreateTableview];
        [self loadFunctionView];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
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
    
    sfDetailModel *model = dataSourceArr[0];
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return 1;
    }else if(section == 2){
        return 1;
    }else if(section == 3){
        return 1;
    }else{
        return model.recommend.count;
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
        sfDetailModel *model = dataSourceArr[0];
        NSMutableArray *imagearr = [NSMutableArray array];
        bannerView = [[JKBannarView alloc]initWithFrame:CGRectMake(0, 0, Main_width, Main_width/(1.87)) viewSize:CGSizeMake(Main_width,Main_width/(1.87))];
        for (int i=0; i<model.house_img.count; i++) {
            NSString *strurl = [API_img stringByAppendingString:[[model.house_img objectAtIndex:i]objectForKey:@"house_imgs"]];
            NSLog(@"%@",strurl);
            [imagearr addObject:strurl];
            bannerView.items = imagearr;
        }
         [cell.contentView addSubview:bannerView];
        [bannerView imageViewClick:^(JKBannarView * _Nonnull barnerview, NSInteger index) {}];
        cell.backgroundColor = [UIColor greenColor];
    }else if (indexPath.section == 1){
        
        sfDetailModel *model = dataSourceArr[0];
        
        NSString *str = [NSString stringWithFormat:@"-%@室",model.room];
        NSString *str1 = [NSString stringWithFormat:@"%@厅",model.office];
        NSString *str2 = [NSString stringWithFormat:@"%@厨",model.kitchen];
        NSString *str3 = [NSString stringWithFormat:@"%@卫",model.guard];
        NSString *str4 = [str stringByAppendingString:str1];
        NSString *str5 = [str4 stringByAppendingString:str2];
        NSString *str6 = [str5 stringByAppendingString:str3];
        NSString *str7 = [model.community_name stringByAppendingString:str6];
        NSString *str8 = [NSString stringWithFormat:@"-面积%@平米",model.area];
        NSString *str9 = [NSString stringWithFormat:@"|%@/%@层",model.floor,model.house_floor];
        NSString *str10 = [str7 stringByAppendingString:str8];
        NSString *titleStr = [str10 stringByAppendingString:str9];
        NSLog(@"titleStr = %@",titleStr);
        
        UILabel *titleLab = [[UILabel alloc]init];
        titleLab.frame = CGRectMake(10, 10, kScreenWidth-20, 50);
        titleLab.text = titleStr;
        titleLab.textColor = [UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:1];
        titleLab.font = [UIFont systemFontOfSize:20];
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
        
        labelArr = [NSMutableArray array];
        for (int i = 0; i < model.label.count; i++) {
           NSDictionary *dic = model.label[i];
           NSString *labStr = [dic objectForKey:@"label_name"];
            [labelArr addObject:labStr];
        }
       
        [tag setupSubViewsWithTitles:labelArr];
        [cell addSubview:tag];
        
        CGRect rect = tag.frame;
        rect.size.height = tag.contentSize.height;
        tag.frame = rect;
        
        UILabel *sjLab = [[UILabel alloc]init];
        sjLab.frame = CGRectMake(10, CGRectGetMaxY(tag.frame)+5, kScreenWidth/3+17, 35);
        sjLab.text = @"售价/单价";
        sjLab.textColor = [UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1];
        sjLab.font = [UIFont systemFontOfSize:17];
        sjLab.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:sjLab];
        
        UILabel *priceLab1 = [[UILabel alloc]init];
        priceLab1.frame = CGRectMake(10, CGRectGetMaxY(sjLab.frame)+5, 90, 35);
        priceLab1.text = [NSString stringWithFormat:@"%@元/",model.total_price];
        priceLab1.textColor = [UIColor colorWithRed:252/255.0 green:79/255.0 blue:40/255.0 alpha:1];
        priceLab1.font = [UIFont systemFontOfSize:16];
        priceLab1.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:priceLab1];
        
        UILabel *priceLab2 = [[UILabel alloc]init];
        priceLab2.frame = CGRectMake(CGRectGetMaxX(priceLab1.frame), CGRectGetMaxY(sjLab.frame)+5, kScreenWidth/3-3-70-10, 35);
        priceLab2.text = [NSString stringWithFormat:@"%@元",model.unit_price];
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
        NSString *hxstr = [NSString stringWithFormat:@"%@室",model.room];
        NSString *hxstr1 = [NSString stringWithFormat:@"%@厅",model.office];
        NSString *hxstr2 = [NSString stringWithFormat:@"%@厨",model.kitchen];
        NSString *hxstr3 = [NSString stringWithFormat:@"%@卫",model.guard];
        NSString *hxstr4 = [hxstr stringByAppendingString:hxstr1];
        NSString *hxstr5 = [hxstr4 stringByAppendingString:hxstr2];
        NSString *hxstr6 = [hxstr5 stringByAppendingString:hxstr3];
        hxLab1.text = hxstr6;
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
        mjLab1.text = [NSString stringWithFormat:@"%@平米",model.area];;
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
        sfDetailModel *model = dataSourceArr[0];
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
        int fk = [model.pay_type intValue];
        if (fk == 1) {
            fkLab1.text = @"月付";
        }else if (fk == 2){
            fkLab1.text = @"季付";
        }else if (fk == 3){
            fkLab1.text = @"年付";
        }else if (fk == 4){
            fkLab1.text = @"可贷款";
        }else{
            fkLab1.text = @"全款";
        }
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
        lcLab1.text = [NSString stringWithFormat:@"%@/%@层",model.floor,model.house_floor];
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
        rzLab1.text = model.check_in;
        rzLab1.font = [UIFont systemFontOfSize:16];
        rzLab1.textAlignment = NSTextAlignmentLeft;
        rzLab1.textColor = [UIColor blackColor];
        [cell addSubview:rzLab1];
        

        UILabel *dtLab = [[UILabel alloc]init];
        dtLab.frame = CGRectMake(kScreenWidth/2, CGRectGetMaxY(titleLab.frame), 80, 30);
        dtLab.text = @"电梯:";
        dtLab.font = [UIFont systemFontOfSize:16];
        dtLab.textAlignment = NSTextAlignmentLeft;
        dtLab.textColor = [UIColor colorWithRed:157/255.0 green:157/255.0 blue:157/255.0 alpha:1];
        [cell addSubview:dtLab];
        
        UILabel *dtLab1 = [[UILabel alloc]init];
        dtLab1.frame = CGRectMake(CGRectGetMaxX(dtLab.frame), CGRectGetMaxY(titleLab.frame), kScreenWidth/2-10-80, 30);
        
        int dt = [model.elevator intValue];
        if (dt == 1) {
            dtLab1.text = @"有";
        }else{
            dtLab1.text = @"无";
        }
        dtLab1.font = [UIFont systemFontOfSize:16];
        dtLab1.textAlignment = NSTextAlignmentLeft;
        dtLab1.textColor = [UIColor blackColor];
        [cell addSubview:dtLab1];
        
        UILabel *fbsjLab = [[UILabel alloc]init];
        fbsjLab.frame = CGRectMake(kScreenWidth/2, CGRectGetMaxY(dtLab.frame), 60, 30);
        fbsjLab.text = @"发布时间:";
        fbsjLab.font = [UIFont systemFontOfSize:16];
        fbsjLab.textAlignment = NSTextAlignmentLeft;
        fbsjLab.textColor = [UIColor colorWithRed:157/255.0 green:157/255.0 blue:157/255.0 alpha:1];
        [cell addSubview:fbsjLab];
        
        UILabel *fbsjLab1 = [[UILabel alloc]init];
        fbsjLab1.frame = CGRectMake(CGRectGetMaxX(fbsjLab.frame), CGRectGetMaxY(dtLab.frame), kScreenWidth/2-10-60, 30);
        fbsjLab1.text = model.release_time;
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
        
        tjListModel *tjModel = tjArr[indexPath.row];
        
        UIImageView *imgView = [[UIImageView alloc]init];
        imgView.frame = CGRectMake(10, 10, 100, 100);
        [imgView sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:tjModel.head_img]] placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
        [cell addSubview:imgView];
        
        UILabel *titleLab = [[UILabel alloc]init];
        titleLab.frame = CGRectMake(CGRectGetMaxX(imgView.frame)+5, 10, kScreenWidth-20-5-100, 40);
        NSString *str = [NSString stringWithFormat:@"-%@室",tjModel.room];
        NSString *str1 = [NSString stringWithFormat:@"%@厅",tjModel.office];
        NSString *str2 = [NSString stringWithFormat:@"%@厨",tjModel.kitchen];
        NSString *str3 = [NSString stringWithFormat:@"%@卫",tjModel.guard];
        NSString *str4 = [str stringByAppendingString:str1];
        NSString *str5 = [str4 stringByAppendingString:str2];
        NSString *str6 = [str5 stringByAppendingString:str3];
        NSString *str7 = [tjModel.community_name stringByAppendingString:str6];
        NSString *str8 = [NSString stringWithFormat:@"-面积%@平米",tjModel.area];
        NSString *str9 = [NSString stringWithFormat:@"|%@/%@层",tjModel.floor,tjModel.house_floor];
        NSString *str10 = [str7 stringByAppendingString:str8];
        NSString *titleStr = [str10 stringByAppendingString:str9];
        NSLog(@"titleStr = %@",titleStr);
        titleLab.text = titleStr;
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
        NSArray *labArr = tjModel.label;
        NSDictionary *nameDic = labArr[0];
        NSString *labStr = [nameDic objectForKey:@"label_name"];
        biaoQianLab.text = labStr;
        biaoQianLab.backgroundColor = [UIColor colorWithRed:255/255.0 green:247/255.0 blue:247/255.0 alpha:1];
        biaoQianLab.textColor = [UIColor colorWithRed:252/255.0 green:99/255.0 blue:60/255.0 alpha:1];
        biaoQianLab.font = [UIFont systemFontOfSize:15];
        biaoQianLab.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:biaoQianLab];
        
        UILabel *priceLab = [[UILabel alloc]init];
        priceLab.frame = CGRectMake(CGRectGetMaxX(imgView.frame)+5, CGRectGetMaxY(rengZhengLab.frame)+5, 100, 30);
        priceLab.text = tjModel.total_price;
        //    priceLab.backgroundColor = [UIColor colorWithRed:255/255.0 green:247/255.0 blue:247/255.0 alpha:1];
        priceLab.textColor = [UIColor colorWithRed:252/255.0 green:99/255.0 blue:60/255.0 alpha:1];
        priceLab.font = [UIFont systemFontOfSize:17];
        priceLab.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:priceLab];
        
        UILabel *jPriceLab = [[UILabel alloc]init];
        jPriceLab.frame = CGRectMake(CGRectGetMaxX(priceLab.frame)+5, CGRectGetMaxY(rengZhengLab.frame)+10, 100, 20);
        jPriceLab.text = [NSString stringWithFormat:@"%@元/平米",tjModel.unit_price];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 4) {
        
        tjListModel *tjModel = tjArr[indexPath.row];
        NSLog(@"tjModel.id == %@",tjModel.id);
        
        shouFangDetailViewController *sfDetailVC = [[shouFangDetailViewController alloc]init];
       sfDetailVC.sfID = tjModel.id;
        [self.navigationController pushViewController:sfDetailVC animated:YES];
//        [self loadData];
             
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
    sfDetailModel *model = dataSourceArr[0];
    jjlab1.text = model.name;
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
    [likeButton addTarget:self action:@selector(callAction:) forControlEvents:UIControlEventTouchUpInside];
    likeButton.tag = [model.phone integerValue];
    likeButton.layer.cornerRadius = 3.0;
    [functionView addSubview:likeButton];
    [self.view addSubview:functionView];
    
}
-(void)callAction:(UIButton *)sender{
    NSString *telStr = [NSString stringWithFormat:@"%ld",sender.tag];
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",telStr];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}
-(void)ckxqAction{
    
    sfHuoDongDetailViewController *hdDetailVC = [[sfHuoDongDetailViewController alloc]init];
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

#pragma mark - PTLMenuButtonDelegate
-(void)ptl_menuButton:(PTLMenuButton *)menuButton didSelectMenuButtonAtIndex:(NSInteger)index selectMenuButtonTitle:(NSString *)title listRow:(NSInteger)row rowTitle:(NSString *)rowTitle{
    NSLog(@"index: %zd, title:%@, listrow: %zd, rowTitle: %@", index, title, row, rowTitle);
}

#pragma mark - KMTagListViewDelegate
-(void)ptl_TagListView:(KMTagListView *)tagListView didSelectTagViewAtIndex:(NSInteger)index selectContent:(NSString *)content {
    NSLog(@"content: %@ index: %zd", content, index);
    
}


@end
