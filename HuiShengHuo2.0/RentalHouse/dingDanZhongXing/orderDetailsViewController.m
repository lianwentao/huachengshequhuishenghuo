//
//  orderDetailsViewController.m
//  HuiShengHuo2.0
//
//  Created by admin on 2018/12/15.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "orderDetailsViewController.h"
#import "WRNavigationBar.h"
#import "SpecialAlertView.h"
#import "evaluateViewController.h"
#define NAV_HEIGHT 64
#define IMAGE_HEIGHT 0
#define SCROLL_DOWN_LIMIT 70
#import "orderDetailModel.h"
#import "mywuyegongdanViewController.h"
@interface orderDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *dataSourceArr;
    
    CGFloat height;
}
@property (nonatomic , strong)UITableView *tableView;
@property (nonatomic , strong)NSMutableArray *dataSourceArr ;
@property (nonatomic , strong)NSMutableArray *repairImgArr ;
@property (nonatomic , strong)NSMutableArray *distributeUserArr ;
@property (nonatomic , strong)NSMutableArray *completeImgArr ;
@property (nonatomic , strong)NSString *score ;
@end

@implementation orderDetailsViewController
- (void)viewDidLayoutSubviews{
    CGFloat phoneVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (phoneVersion >= 11.0) {
        height = self.view.safeAreaInsets.bottom;
    }else{
        height = 0;
    }
//    if ([_stateStr isEqualToString:@"待派单"]){
//        [self loadFunctionView];
//    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    [self loadData];
//    [self loadTableView];
    [self setRightBtn];
}
-(void)loadData{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
     NSDictionary *dict = @{@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"],@"id":_workOrderID};

    NSString *strurl = [API stringByAppendingString:@"propertyWork/getWorkDetails"];
    [manager POST:strurl parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"dataStr = %@",dataStr);
        NSInteger status = [responseObject[@"status"] integerValue];
        if (status == 1) {
        
            NSDictionary *dataDic = responseObject[@"data"];
            NSLog(@"dataDic = %@",dataDic);
            if ([dataDic[@"score"] isKindOfClass:[NSString class]]) {
                
                _score = dataDic[@"score"];
            }else{
                _score = @"0";
            }
            _dataSourceArr = [NSMutableArray array];
            orderDetailModel *model = [[orderDetailModel alloc]initWithDictionary:dataDic error:NULL];
            [_dataSourceArr addObject:model];
            NSLog(@"_dataSourceArr = %@",_dataSourceArr);
            [self loadTableView];
            if ([model.work_status isEqualToString:@"1"]) {
                
            }else{
               [self loadFunctionView];
            }
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
-(void)setRightBtn{
    if ([_stateStr isEqualToString:@"待派单"] || [_stateStr isEqualToString:@"待服务"]) {
        //等待派单
        UIButton *rightBtn1 = [UIButton buttonWithType:UIButtonTypeSystem];
        rightBtn1.frame = CGRectMake(0, 0, 80, 30);
        [rightBtn1 setTitle:@"取消订单" forState:UIControlStateNormal];
        [rightBtn1 setTitleColor:[UIColor colorWithRed:162/255.0 green:162/255.0 blue:162/255.0 alpha:1] forState:UIControlStateNormal];
        rightBtn1.layer.cornerRadius = 5.0;
        rightBtn1.layer.borderColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1].CGColor;
        rightBtn1.layer.borderWidth = 1.0f;
        [rightBtn1 addTarget:self action:@selector(rightBtn1Clicked) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc]initWithCustomView:rightBtn1];
        self.navigationItem.rightBarButtonItem = rightItem1;
    }else if ([_stateStr isEqualToString:@"待付款"]){
        //    待付款+已付款
        UIButton *rightBtn2 = [UIButton buttonWithType:UIButtonTypeSystem];
        rightBtn2.frame = CGRectMake(0, 0, 40, 20);
        [rightBtn2 setTitle:@"付款" forState:UIControlStateNormal];
        rightBtn2.titleLabel.font = [UIFont systemFontOfSize:14];
        [rightBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        rightBtn2.backgroundColor = [UIColor colorWithRed:248/255.0 green:87/255.0 blue:47/255.0 alpha:1];
        rightBtn2.layer.cornerRadius = 5.0;
        //    rightBtn2.layer.borderColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1].CGColor;
        //    rightBtn2.layer.borderWidth = 1.0f;
        [rightBtn2 addTarget:self action:@selector(rightBtn2Clicked) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem2 = [[UIBarButtonItem alloc]initWithCustomView:rightBtn2];
        self.navigationItem.rightBarButtonItem = rightItem2;
        
    }else if ([_stateStr isEqualToString:@"已完成"]){
        //已完成
        UIButton *rightBtn3 = [UIButton buttonWithType:UIButtonTypeSystem];
        rightBtn3.frame = CGRectMake(0, 0, 40, 20);
        [rightBtn3 setTitle:@"评价" forState:UIControlStateNormal];
        rightBtn3.titleLabel.font = [UIFont systemFontOfSize:14];
        [rightBtn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        rightBtn3.backgroundColor = [UIColor colorWithRed:248/255.0 green:87/255.0 blue:47/255.0 alpha:1];
        rightBtn3.layer.cornerRadius = 5.0;
        [rightBtn3 addTarget:self action:@selector(rightBtn3Clicked) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem3 = [[UIBarButtonItem alloc]initWithCustomView:rightBtn3];
        self.navigationItem.rightBarButtonItem = rightItem3;
    }
   

   
    
}
-(void)loadTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Main_width,  Main_Height-50) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
//    _tableView.contentInset = UIEdgeInsetsMake(IMAGE_HEIGHT - [self navBarBottom], 0, 0, 0);
    [self.view addSubview:_tableView];
}
- (int)navBarBottom
{
    if ([WRNavigationBar isIphoneX]) {
        return 88;
    } else {
        return 64;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        
        if([_stateStr isEqualToString:@"待付款"] || [_stateStr isEqualToString:@"已付款"] || [_stateStr isEqualToString:@"已完成"] || [_stateStr isEqualToString:@"已评价"]) {
            return 100;
        }else{
           return  50;
        }
    }else{
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 100;
    }else if (indexPath.section ==1){
        return 50;
        
    }else if (indexPath.section ==2){
        return 150;
        
    }else if (indexPath.section ==3){
        orderDetailModel *model = _dataSourceArr[0];

        if ([_stateStr isEqualToString:@"待派单"]) {
             return 160;
        }else if ([_stateStr isEqualToString:@"待服务"]){
             return 160;
        }else if ([_stateStr isEqualToString:@"待付款"]){
            return 200;
        }else if ([_stateStr isEqualToString:@"已付款"]){
            return 180;
        }else if ([_stateStr isEqualToString:@"已完成"]){
            return 180;
        }else if ([_stateStr isEqualToString:@"已评价"]){
            return 200;
        }else if ([_stateStr isEqualToString:@"已取消"]){
            return 120;
        }else{
             return 0;
        }
        
    }else{
        if ([_stateStr isEqualToString:@"待派单"]) {
            return 0;
        }else if ([_stateStr isEqualToString:@"待服务"]){
            return 0;
        }else if ([_stateStr isEqualToString:@"待付款"]){
            return 0;
        }else if ([_stateStr isEqualToString:@"已付款"]){
            return 0;
        }else if ([_stateStr isEqualToString:@"已完成"]){
            return 260;
        }else if ([_stateStr isEqualToString:@"已评价"]){
            return 300;
        }else{
           return 0;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    cell.backgroundColor = [UIColor whiteColor];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

        cell.userInteractionEnabled = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
//        cell.frame = CGRectMake(10, 0, Main_width-20, Main_Height-50);
    }

    if (indexPath.section == 0) {
        orderDetailModel *model = _dataSourceArr[0];
        UILabel *addressLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, Main_width-20, 60)];
        addressLab.numberOfLines = 2;
        addressLab.text = model.address;
        addressLab.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
        addressLab.font = [UIFont systemFontOfSize:15];
        addressLab.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:addressLab];

        UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(addressLab.frame), Main_width-20, 40)];
        NSString *nameStr = model.username;
        NSString *telStr = model.userphone;
        nameLab.text = [NSString stringWithFormat:@"%@ %@",nameStr,telStr];
        nameLab.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
        nameLab.font = [UIFont systemFontOfSize:18];
        nameLab.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:nameLab];

    }else if (indexPath.section == 1){
        orderDetailModel *model = _dataSourceArr[0];
        UILabel *projectLab = [[UILabel alloc]init];
        projectLab.frame = CGRectMake(10, 10, Main_width-20, 30);
        projectLab.text = model.type_name;
        projectLab.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
        projectLab.font = [UIFont systemFontOfSize:15];
        projectLab.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:projectLab];

    }else if(indexPath.section == 2){
        orderDetailModel *model = _dataSourceArr[0];
        if ([model.repairImg isKindOfClass:[NSNull class]]){}else{
            NSArray *imgArr = model.repairImg;
            _repairImgArr = [NSMutableArray array];
            for (int i = 0; i < imgArr.count; i++) {
                NSDictionary *dic = imgArr[i];
                NSString *img_path = [dic objectForKey:@"img_path"];
                NSString *img_name = [dic objectForKey:@"img_name"];
                NSString *newImg = [img_path stringByAppendingString:img_name];
                [_repairImgArr addObject:newImg];
            }
        }
        UIScrollView *backscrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Main_width, 90)];
        backscrollview.contentSize = CGSizeMake(60*_repairImgArr.count+16*(_repairImgArr.count-1), 60);
        backscrollview.showsVerticalScrollIndicator = NO;
        backscrollview.showsHorizontalScrollIndicator = NO;
        backscrollview.userInteractionEnabled = YES;
        [cell addSubview:backscrollview];
        for (int i=0; i<_repairImgArr.count; i++) {

            UIImageView *imgView = [[UIImageView alloc]init];
            imgView.frame = CGRectMake(10+(i*70),16, 60, 60);
            [imgView sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:_repairImgArr[i]]] placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
            imgView.layer.cornerRadius = 5;
            imgView.clipsToBounds = YES;
            [backscrollview addSubview:imgView];
        }

        UILabel *beiZhuLab = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(backscrollview.frame), Main_width-20, 60)];
        beiZhuLab.numberOfLines = 2;
        beiZhuLab.text = model.content;
        beiZhuLab.textColor = [UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1];
        beiZhuLab.font = [UIFont systemFontOfSize:13];
        beiZhuLab.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:beiZhuLab];

    }else if(indexPath.section == 3){
        orderDetailModel *model = _dataSourceArr[0];
        if ([_stateStr isEqualToString:@"待派单"]) {
            UILabel *timeLab1 = [[UILabel alloc] initWithFrame:CGRectMake(10,19, Main_width-20, 15)];
            NSTimeInterval time=[model.release_at doubleValue]+28800;
            NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
            NSLog(@"date:%@",[detaildate description]);
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
            NSString *timeStr1 = currentDateStr;
            timeLab1.text = [NSString stringWithFormat:@"下单时间:%@",timeStr1];
            timeLab1.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
            timeLab1.font = [UIFont systemFontOfSize:15];
            timeLab1.textAlignment = NSTextAlignmentLeft;
            [cell addSubview:timeLab1];
        }else if ([_stateStr isEqualToString:@"待服务"]){ //待服务

            UILabel *timeLab1 = [[UILabel alloc] initWithFrame:CGRectMake(10,19, Main_width-20, 15)];
            NSTimeInterval time=[model.release_at doubleValue]+28800;
            NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
            NSLog(@"date:%@",[detaildate description]);
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
            NSString *timeStr1 = currentDateStr;
            timeLab1.text = [NSString stringWithFormat:@"下单时间:%@",timeStr1];
            timeLab1.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
            timeLab1.font = [UIFont systemFontOfSize:15];
            timeLab1.textAlignment = NSTextAlignmentLeft;
            [cell addSubview:timeLab1];

            UILabel *timeLab2 = [[UILabel alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(timeLab1.frame)+10, Main_width-20, 15)];
            NSTimeInterval time2=[model.distribute_at doubleValue]+28800;
            NSDate *detaildate2=[NSDate dateWithTimeIntervalSince1970:time2];
            NSLog(@"date:%@",[detaildate2 description]);
            NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
            [dateFormatter2 setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSString *currentDateStr2 = [dateFormatter stringFromDate: detaildate2];
            NSString *timeStr2 = currentDateStr2;
            timeLab2.text = [NSString stringWithFormat:@"派单时间:%@",timeStr2];
            timeLab2.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
            timeLab2.font = [UIFont systemFontOfSize:15];
            timeLab2.textAlignment = NSTextAlignmentLeft;
            [cell addSubview:timeLab2];

            UILabel *timeLab3 = [[UILabel alloc] init];
            timeLab3.frame = CGRectMake(10,CGRectGetMaxY(timeLab2.frame)+10, Main_width-20, 13);
            NSString *timeStr3 = @"等待服务...";//待服务
            timeLab3.text = [NSString stringWithFormat:@"%@",timeStr3];
            timeLab3.textColor = [UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1];
            timeLab3.font = [UIFont systemFontOfSize:12];
            timeLab3.textAlignment = NSTextAlignmentLeft;
            [cell addSubview:timeLab3];

        }else if ([_stateStr isEqualToString:@"待付款"]){//待付款

            UILabel *timeLab1 = [[UILabel alloc] initWithFrame:CGRectMake(10,19, Main_width-20, 15)];
            NSTimeInterval time=[model.release_at doubleValue]+28800;
            NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
            NSLog(@"date:%@",[detaildate description]);
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
            NSString *timeStr1 = currentDateStr;
            timeLab1.text = [NSString stringWithFormat:@"下单时间:%@",timeStr1];
            timeLab1.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
            timeLab1.font = [UIFont systemFontOfSize:15];
            timeLab1.textAlignment = NSTextAlignmentLeft;
            [cell addSubview:timeLab1];

            UILabel *timeLab2 = [[UILabel alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(timeLab1.frame)+10, Main_width-20, 15)];
            NSTimeInterval time2=[model.distribute_at doubleValue]+28800;
            NSDate *detaildate2=[NSDate dateWithTimeIntervalSince1970:time2];
            NSLog(@"date:%@",[detaildate2 description]);
            NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
            [dateFormatter2 setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSString *currentDateStr2 = [dateFormatter stringFromDate: detaildate2];
            NSString *timeStr2 = currentDateStr2;
            timeLab2.text = [NSString stringWithFormat:@"派单时间:%@",timeStr2];
            timeLab2.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
            timeLab2.font = [UIFont systemFontOfSize:15];
            timeLab2.textAlignment = NSTextAlignmentLeft;
            [cell addSubview:timeLab2];

            //待付款
            if ([model.completeImg isKindOfClass:[NSNull class]]){}else{
                NSArray *cImgArr = model.completeImg;
                _completeImgArr = [NSMutableArray array];
                for (int i = 0; i < cImgArr.count; i++) {
                    NSDictionary *dic = cImgArr[i];
                    NSString *img_path = [dic objectForKey:@"img_path"];
                    NSString *img_name = [dic objectForKey:@"img_name"];
                    NSString *newImg = [img_path stringByAppendingString:img_name];
                    [_completeImgArr addObject:newImg];
                }
            }
            UIScrollView *backscrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(timeLab2.frame), Main_width, 90)];
            backscrollview.contentSize = CGSizeMake(50*_completeImgArr.count+16*(_completeImgArr.count-1), 50);
            backscrollview.showsVerticalScrollIndicator = NO;
            backscrollview.showsHorizontalScrollIndicator = NO;
            backscrollview.userInteractionEnabled = YES;
            [cell addSubview:backscrollview];
            for (int i=0; i<_completeImgArr.count; i++) {

                UIImageView *imgView = [[UIImageView alloc]init];
                imgView.frame = CGRectMake(10+(i*90),16, 50, 50);
                imgView.backgroundColor = [UIColor yellowColor];
                [imgView sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:_completeImgArr[i]]] placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
                imgView.layer.cornerRadius = 25;
                imgView.clipsToBounds = YES;
                [backscrollview addSubview:imgView];

                UILabel *queRenLab = [[UILabel alloc]init];
                queRenLab.frame = CGRectMake(CGRectGetMaxX(imgView.frame)-10, 10, 41, 16);
                NSString *timeStr2 = @"已确认";
                queRenLab.text = [NSString stringWithFormat:@"%@",timeStr2];
                queRenLab.textColor = [UIColor whiteColor];
                queRenLab.backgroundColor = [UIColor colorWithRed:80/255.0 green:204/255.0 blue:51/255.0 alpha:1];
                queRenLab.font = [UIFont systemFontOfSize:10];
                queRenLab.textAlignment = NSTextAlignmentCenter;
                [backscrollview addSubview:queRenLab];

                kuodabuttondianjifanwei *callBtn = [[kuodabuttondianjifanwei alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame)-10, CGRectGetMaxY(imgView.frame)-14, 14, 14)];
                [callBtn setEnlargeEdgeWithTop:20 right:0 bottom:10 left:30];
                [callBtn setImage:[UIImage imageNamed:@"ydianhua"] forState:UIControlStateNormal];
                [callBtn addTarget:self action:@selector(callAction:) forControlEvents:UIControlEventTouchUpInside];
                callBtn.layer.cornerRadius = 7.0;
                [backscrollview addSubview:callBtn];

                UILabel *nameLab = [[UILabel alloc]init];
                nameLab.frame = CGRectMake(10+(i*90),CGRectGetMaxY(imgView.frame)+5, 50, 13);
                NSString *timeStr3 = @"李小三";
                nameLab.text = [NSString stringWithFormat:@"%@",timeStr3];
                nameLab.textColor = [UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1];
                nameLab.font = [UIFont systemFontOfSize:13];
                nameLab.textAlignment = NSTextAlignmentCenter;
                [backscrollview addSubview:nameLab];

            }

            UILabel *timeLab3 = [[UILabel alloc] init];
            timeLab3.frame = CGRectMake(10,CGRectGetMaxY(backscrollview.frame)+10, Main_width-20, 13);
            NSString *timeStr5 = @"服务中...";
            timeLab3.text = [NSString stringWithFormat:@"%@",timeStr5];
            timeLab3.textColor = [UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1];
            timeLab3.font = [UIFont systemFontOfSize:12];
            timeLab3.textAlignment = NSTextAlignmentLeft;
            [cell addSubview:timeLab3];

            }else if([_stateStr isEqualToString:@"已付款"]){//已付款

                UILabel *timeLab1 = [[UILabel alloc] initWithFrame:CGRectMake(10,19, Main_width-20, 15)];
                NSTimeInterval time=[model.release_at doubleValue]+28800;
                NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
                NSLog(@"date:%@",[detaildate description]);
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
                NSString *timeStr1 = currentDateStr;
                timeLab1.text = [NSString stringWithFormat:@"下单时间:%@",timeStr1];
                timeLab1.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
                timeLab1.font = [UIFont systemFontOfSize:15];
                timeLab1.textAlignment = NSTextAlignmentLeft;
                [cell addSubview:timeLab1];

                UILabel *timeLab2 = [[UILabel alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(timeLab1.frame)+10, Main_width-20, 15)];
                NSTimeInterval time2=[model.distribute_at doubleValue]+28800;
                NSDate *detaildate2=[NSDate dateWithTimeIntervalSince1970:time2];
                NSLog(@"date:%@",[detaildate2 description]);
                NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
                [dateFormatter2 setDateFormat:@"yyyy-MM-dd HH:mm"];
                NSString *currentDateStr2 = [dateFormatter stringFromDate: detaildate2];
                NSString *timeStr2 = currentDateStr2;
                timeLab2.text = [NSString stringWithFormat:@"派单时间:%@",timeStr2];
                timeLab2.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
                timeLab2.font = [UIFont systemFontOfSize:15];
                timeLab2.textAlignment = NSTextAlignmentLeft;
                [cell addSubview:timeLab2];

                if ([model.completeImg isKindOfClass:[NSNull class]]){}else{
                    NSArray *cImgArr = model.completeImg;
                    _completeImgArr = [NSMutableArray array];
                    for (int i = 0; i < cImgArr.count; i++) {
                        NSDictionary *dic = cImgArr[i];
                        NSString *img_path = [dic objectForKey:@"img_path"];
                        NSString *img_name = [dic objectForKey:@"img_name"];
                        NSString *newImg = [img_path stringByAppendingString:img_name];
                        [_completeImgArr addObject:newImg];
                    }
                }
                UIScrollView *backscrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(timeLab2.frame), Main_width, 90)];
                backscrollview.contentSize = CGSizeMake(50*_completeImgArr.count+16*(_completeImgArr.count-1), 50);
                backscrollview.showsVerticalScrollIndicator = NO;
                backscrollview.showsHorizontalScrollIndicator = NO;
                backscrollview.userInteractionEnabled = YES;
                [cell addSubview:backscrollview];
                for (int i=0; i<_completeImgArr.count; i++) {
                    
                    UIImageView *imgView = [[UIImageView alloc]init];
                    imgView.frame = CGRectMake(10+(i*90),16, 50, 50);
                    imgView.backgroundColor = [UIColor yellowColor];
                    [imgView sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:_completeImgArr[i]]] placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
                    imgView.layer.cornerRadius = 25;
                    imgView.clipsToBounds = YES;
                    [backscrollview addSubview:imgView];

                    UILabel *queRenLab = [[UILabel alloc]init];
                    queRenLab.frame = CGRectMake(CGRectGetMaxX(imgView.frame)-10, 10, 41, 16);
                    NSString *timeStr2 = @"已确认";
                    queRenLab.text = [NSString stringWithFormat:@"%@",timeStr2];
                    queRenLab.textColor = [UIColor whiteColor];
                    queRenLab.backgroundColor = [UIColor colorWithRed:80/255.0 green:204/255.0 blue:51/255.0 alpha:1];
                    queRenLab.font = [UIFont systemFontOfSize:10];
                    queRenLab.textAlignment = NSTextAlignmentCenter;
                    [backscrollview addSubview:queRenLab];

                    kuodabuttondianjifanwei *callBtn = [[kuodabuttondianjifanwei alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame)-10, CGRectGetMaxY(imgView.frame)-14, 14, 14)];
                    [callBtn setEnlargeEdgeWithTop:20 right:0 bottom:10 left:30];
                    [callBtn setImage:[UIImage imageNamed:@"ydianhua"] forState:UIControlStateNormal];
                    [callBtn addTarget:self action:@selector(callAction:) forControlEvents:UIControlEventTouchUpInside];
                    callBtn.layer.cornerRadius = 7.0;
                    [backscrollview addSubview:callBtn];

                    UILabel *nameLab = [[UILabel alloc]init];
                    nameLab.frame = CGRectMake(10+(i*90),CGRectGetMaxY(imgView.frame)+5, 50, 13);
                    NSString *timeStr3 = @"李小三";
                    nameLab.text = [NSString stringWithFormat:@"%@",timeStr3];
                    nameLab.textColor = [UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1];
                    nameLab.font = [UIFont systemFontOfSize:13];
                    nameLab.textAlignment = NSTextAlignmentCenter;
                    [backscrollview addSubview:nameLab];

                }

                if ([_stateStr isEqualToString:@"已付款"]) {
                    UILabel *timeLab3 = [[UILabel alloc] init];
                    timeLab3.frame = CGRectMake(10,CGRectGetMaxY(backscrollview.frame)+10, Main_width-20, 13);
                    NSString *timeStr5 = @"等待完工...";
                    timeLab3.text = [NSString stringWithFormat:@"%@",timeStr5];
                    timeLab3.textColor = [UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1];
                    timeLab3.font = [UIFont systemFontOfSize:12];
                    timeLab3.textAlignment = NSTextAlignmentLeft;
                    [cell addSubview:timeLab3];
                }

            }else if ([_stateStr isEqualToString:@"已完成"]){

                UILabel *timeLab1 = [[UILabel alloc] initWithFrame:CGRectMake(10,19, Main_width-20, 15)];
                NSTimeInterval time=[model.release_at doubleValue]+28800;
                NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
                NSLog(@"date:%@",[detaildate description]);
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
                NSString *timeStr1 = currentDateStr;
                timeLab1.text = [NSString stringWithFormat:@"下单时间:%@",timeStr1];
                timeLab1.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
                timeLab1.font = [UIFont systemFontOfSize:15];
                timeLab1.textAlignment = NSTextAlignmentLeft;
                [cell addSubview:timeLab1];

                UILabel *timeLab2 = [[UILabel alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(timeLab1.frame)+10, Main_width-20, 15)];
                NSTimeInterval time2=[model.distribute_at doubleValue]+28800;
                NSDate *detaildate2=[NSDate dateWithTimeIntervalSince1970:time2];
                NSLog(@"date:%@",[detaildate2 description]);
                NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
                [dateFormatter2 setDateFormat:@"yyyy-MM-dd HH:mm"];
                NSString *currentDateStr2 = [dateFormatter stringFromDate: detaildate2];
                NSString *timeStr2 = currentDateStr2;
                timeLab2.text = [NSString stringWithFormat:@"派单时间:%@",timeStr2];
                timeLab2.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
                timeLab2.font = [UIFont systemFontOfSize:15];
                timeLab2.textAlignment = NSTextAlignmentLeft;
                [cell addSubview:timeLab2];

                if ([model.completeImg isKindOfClass:[NSNull class]]){}else{
                    NSArray *cImgArr = model.completeImg;
                    _completeImgArr = [NSMutableArray array];
                    for (int i = 0; i < cImgArr.count; i++) {
                        NSDictionary *dic = cImgArr[i];
                        NSString *img_path = [dic objectForKey:@"img_path"];
                        NSString *img_name = [dic objectForKey:@"img_name"];
                        NSString *newImg = [img_path stringByAppendingString:img_name];
                        [_completeImgArr addObject:newImg];
                    }
                }
                UIScrollView *backscrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(timeLab2.frame), Main_width, 90)];
                backscrollview.contentSize = CGSizeMake(50*_completeImgArr.count+16*(_completeImgArr.count-1), 50);
                backscrollview.showsVerticalScrollIndicator = NO;
                backscrollview.showsHorizontalScrollIndicator = NO;
                backscrollview.userInteractionEnabled = YES;
                [cell addSubview:backscrollview];
                for (int i=0; i<_completeImgArr.count; i++) {
                    
                    UIImageView *imgView = [[UIImageView alloc]init];
                    imgView.frame = CGRectMake(10+(i*90),16, 50, 50);
                    [imgView sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:_completeImgArr[i]]] placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
                    imgView.layer.cornerRadius = 25;
                    imgView.clipsToBounds = YES;
                    [backscrollview addSubview:imgView];

                    UILabel *queRenLab = [[UILabel alloc]init];
                    queRenLab.frame = CGRectMake(CGRectGetMaxX(imgView.frame)-10, 10, 41, 16);
                    NSString *timeStr2 = @"已确认";
                    queRenLab.text = [NSString stringWithFormat:@"%@",timeStr2];
                    queRenLab.textColor = [UIColor whiteColor];
                    queRenLab.backgroundColor = [UIColor colorWithRed:80/255.0 green:204/255.0 blue:51/255.0 alpha:1];
                    queRenLab.font = [UIFont systemFontOfSize:10];
                    queRenLab.textAlignment = NSTextAlignmentCenter;
                    [backscrollview addSubview:queRenLab];

                    kuodabuttondianjifanwei *callBtn = [[kuodabuttondianjifanwei alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame)-10, CGRectGetMaxY(imgView.frame)-14, 14, 14)];
                    [callBtn setEnlargeEdgeWithTop:20 right:0 bottom:10 left:30];
                    [callBtn setImage:[UIImage imageNamed:@"ydianhua"] forState:UIControlStateNormal];
                    [callBtn addTarget:self action:@selector(callAction:) forControlEvents:UIControlEventTouchUpInside];
                    callBtn.layer.cornerRadius = 7.0;
                    [backscrollview addSubview:callBtn];

                    UILabel *nameLab = [[UILabel alloc]init];
                    nameLab.frame = CGRectMake(10+(i*90),CGRectGetMaxY(imgView.frame)+5, 50, 13);
                    NSString *timeStr3 = @"李小三";
                    nameLab.text = [NSString stringWithFormat:@"%@",timeStr3];
                    nameLab.textColor = [UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1];
                    nameLab.font = [UIFont systemFontOfSize:13];
                    nameLab.textAlignment = NSTextAlignmentCenter;
                    [backscrollview addSubview:nameLab];

                }

            }else if ([_stateStr isEqualToString:@"已评价"]){

                UILabel *timeLab1 = [[UILabel alloc] initWithFrame:CGRectMake(10,19, Main_width-20, 15)];
                NSTimeInterval time=[model.release_at doubleValue]+28800;
                NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
                NSLog(@"date:%@",[detaildate description]);
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
                NSString *timeStr1 = currentDateStr;
                timeLab1.text = [NSString stringWithFormat:@"下单时间:%@",timeStr1];
                timeLab1.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
                timeLab1.font = [UIFont systemFontOfSize:15];
                timeLab1.textAlignment = NSTextAlignmentLeft;
                [cell addSubview:timeLab1];

                UILabel *timeLab2 = [[UILabel alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(timeLab1.frame)+10, Main_width-20, 15)];
                NSTimeInterval time2=[model.distribute_at doubleValue]+28800;
                NSDate *detaildate2=[NSDate dateWithTimeIntervalSince1970:time2];
                NSLog(@"date:%@",[detaildate2 description]);
                NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
                [dateFormatter2 setDateFormat:@"yyyy-MM-dd HH:mm"];
                NSString *currentDateStr2 = [dateFormatter stringFromDate: detaildate2];
                NSString *timeStr2 = currentDateStr2;
                timeLab2.text = [NSString stringWithFormat:@"派单时间:%@",timeStr2];
                timeLab2.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
                timeLab2.font = [UIFont systemFontOfSize:15];
                timeLab2.textAlignment = NSTextAlignmentLeft;
                [cell addSubview:timeLab2];

                if ([model.completeImg isKindOfClass:[NSNull class]]){}else{
                    NSArray *cImgArr = model.completeImg;
                    _completeImgArr = [NSMutableArray array];
                    for (int i = 0; i < cImgArr.count; i++) {
                        NSDictionary *dic = cImgArr[i];
                        NSString *img_path = [dic objectForKey:@"img_path"];
                        NSString *img_name = [dic objectForKey:@"img_name"];
                        NSString *newImg = [img_path stringByAppendingString:img_name];
                        [_completeImgArr addObject:newImg];
                    }
                }
                UIScrollView *backscrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(timeLab2.frame), Main_width, 90)];
                backscrollview.contentSize = CGSizeMake(50*_completeImgArr.count+16*(_completeImgArr.count-1), 50);
                backscrollview.showsVerticalScrollIndicator = NO;
                backscrollview.showsHorizontalScrollIndicator = NO;
                backscrollview.userInteractionEnabled = YES;
                [cell addSubview:backscrollview];
                for (int i=0; i<_completeImgArr.count; i++) {
                    
                    UIImageView *imgView = [[UIImageView alloc]init];
                    imgView.frame = CGRectMake(10+(i*90),16, 50, 50);
                    [imgView sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:_completeImgArr[i]]] placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
                    imgView.layer.cornerRadius = 25;
                    imgView.clipsToBounds = YES;
                    [backscrollview addSubview:imgView];

                    UILabel *queRenLab = [[UILabel alloc]init];
                    queRenLab.frame = CGRectMake(CGRectGetMaxX(imgView.frame)-10, 10, 41, 16);
                    NSString *timeStr2 = @"已确认";
                    queRenLab.text = [NSString stringWithFormat:@"%@",timeStr2];
                    queRenLab.textColor = [UIColor whiteColor];
                    queRenLab.backgroundColor = [UIColor colorWithRed:80/255.0 green:204/255.0 blue:51/255.0 alpha:1];
                    queRenLab.font = [UIFont systemFontOfSize:10];
                    queRenLab.textAlignment = NSTextAlignmentCenter;
                    [backscrollview addSubview:queRenLab];

                    kuodabuttondianjifanwei *callBtn = [[kuodabuttondianjifanwei alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame)-10, CGRectGetMaxY(imgView.frame)-14, 14, 14)];
                    [callBtn setEnlargeEdgeWithTop:20 right:0 bottom:10 left:30];
                    [callBtn setImage:[UIImage imageNamed:@"ydianhua"] forState:UIControlStateNormal];
                    [callBtn addTarget:self action:@selector(callAction:) forControlEvents:UIControlEventTouchUpInside];
                    callBtn.layer.cornerRadius = 7.0;
                    [backscrollview addSubview:callBtn];

                    UILabel *nameLab = [[UILabel alloc]init];
                    nameLab.frame = CGRectMake(10+(i*90),CGRectGetMaxY(imgView.frame)+5, 50, 13);
                    NSString *timeStr3 = @"李小三";
                    nameLab.text = [NSString stringWithFormat:@"%@",timeStr3];
                    nameLab.textColor = [UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1];
                    nameLab.font = [UIFont systemFontOfSize:13];
                    nameLab.textAlignment = NSTextAlignmentCenter;
                    [backscrollview addSubview:nameLab];

                }

            }else if ([_stateStr isEqualToString:@"已取消"]){
                //取消订单
                UILabel *quXiaoLab = [[UILabel alloc] initWithFrame:CGRectMake(10,19, Main_width-20, 15)];
                NSString *timeStr6 = @"订单已取消";
                quXiaoLab.text = [NSString stringWithFormat:@"%@",timeStr6];
                quXiaoLab.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
                quXiaoLab.font = [UIFont systemFontOfSize:15];
                quXiaoLab.textAlignment = NSTextAlignmentLeft;
                [cell addSubview:quXiaoLab];

                UILabel *quXiaoLab1 = [[UILabel alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(quXiaoLab.frame)+10, Main_width-20, 15)];
                NSString *timeStr7 = @"等待1~3个工作日退还您支付的预付费用";
                quXiaoLab1.text = [NSString stringWithFormat:@"%@",timeStr7];
                quXiaoLab1.textColor = [UIColor colorWithRed:255/255.0 green:87/255.0 blue:34/255.0 alpha:1];
                quXiaoLab1.font = [UIFont systemFontOfSize:13];
                quXiaoLab1.textAlignment = NSTextAlignmentLeft;
                [cell addSubview:quXiaoLab1];

            }

    }else {

        orderDetailModel *model = _dataSourceArr[0];
         if ([_stateStr isEqualToString:@"已完成"]) { //已完成
             UILabel *timeLab1 = [[UILabel alloc] initWithFrame:CGRectMake(10,19, Main_width-20, 15)];
             NSTimeInterval time=[model.order_time doubleValue]+28800;
             NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
             NSLog(@"date:%@",[detaildate description]);
             NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
             [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
             NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
             NSString *timeStr1 = currentDateStr;
             timeLab1.text = [NSString stringWithFormat:@"服务用时:%@",timeStr1];
             timeLab1.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
             timeLab1.font = [UIFont systemFontOfSize:15];
             timeLab1.textAlignment = NSTextAlignmentLeft;
             [cell addSubview:timeLab1];

             UILabel *timeLab2 = [[UILabel alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(timeLab1.frame)+10, Main_width-20, 15)];
             NSTimeInterval time2=[model.order_total_time doubleValue]+28800;
             NSDate *detaildate2=[NSDate dateWithTimeIntervalSince1970:time2];
             NSLog(@"date:%@",[detaildate2 description]);
             NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
             [dateFormatter2 setDateFormat:@"yyyy-MM-dd HH:mm"];
             NSString *currentDateStr2 = [dateFormatter stringFromDate: detaildate2];
             NSString *timeStr2 = currentDateStr2;
             timeLab2.text = [NSString stringWithFormat:@"订单完成:%@",timeStr2];
             timeLab2.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
             timeLab2.font = [UIFont systemFontOfSize:15];
             timeLab2.textAlignment = NSTextAlignmentLeft;
             [cell addSubview:timeLab2];

             if ([model.completeImg isKindOfClass:[NSNull class]]){}else{
                 NSArray *cImgArr = model.completeImg;
                 _completeImgArr = [NSMutableArray array];
                 for (int i = 0; i < cImgArr.count; i++) {
                     NSDictionary *dic = cImgArr[i];
                     NSString *img_path = [dic objectForKey:@"img_path"];
                     NSString *img_name = [dic objectForKey:@"img_name"];
                     NSString *newImg = [img_path stringByAppendingString:img_name];
                     [_completeImgArr addObject:newImg];
                 }
             }
             UIScrollView *backscrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(timeLab2.frame), Main_width, 90)];
             backscrollview.contentSize = CGSizeMake(50*_completeImgArr.count+16*(_completeImgArr.count-1), 50);
             backscrollview.showsVerticalScrollIndicator = NO;
             backscrollview.showsHorizontalScrollIndicator = NO;
             backscrollview.userInteractionEnabled = YES;
             [cell addSubview:backscrollview];
             for (int i=0; i<_completeImgArr.count; i++) {
                 
                 UIImageView *imgView = [[UIImageView alloc]init];
                 imgView.frame = CGRectMake(10+(i*90),16, 50, 50);
                 [imgView sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:_completeImgArr[i]]] placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
                 imgView.layer.cornerRadius = 25;
                 imgView.clipsToBounds = YES;
                 [backscrollview addSubview:imgView];

             }
             UILabel *beiZhuLab = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(backscrollview.frame), Main_width-20, 60)];
             beiZhuLab.numberOfLines = 2;
             beiZhuLab.text = @"备注：还记得刚的哈萨克和阿萨德回来圣诞节爱丽丝按实际的话拉动和啊啊数据库的好看打开";
             beiZhuLab.textColor = [UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1];
             beiZhuLab.font = [UIFont systemFontOfSize:13];
             beiZhuLab.textAlignment = NSTextAlignmentLeft;
             [cell addSubview:beiZhuLab];


         }else if([_stateStr isEqualToString:@"已评价"]) { //已评价

             UILabel *timeLab1 = [[UILabel alloc] initWithFrame:CGRectMake(10,19, Main_width-20, 15)];
             NSTimeInterval time=[model.order_time doubleValue]+28800;
             NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
             NSLog(@"date:%@",[detaildate description]);
             NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
             [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
             NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
             NSString *timeStr1 = currentDateStr;
             timeLab1.text = [NSString stringWithFormat:@"服务用时:%@",timeStr1];
             timeLab1.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
             timeLab1.font = [UIFont systemFontOfSize:15];
             timeLab1.textAlignment = NSTextAlignmentLeft;
             [cell addSubview:timeLab1];

             UILabel *timeLab2 = [[UILabel alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(timeLab1.frame)+10, Main_width-20, 15)];
             NSTimeInterval time2=[model.order_total_time doubleValue]+28800;
             NSDate *detaildate2=[NSDate dateWithTimeIntervalSince1970:time2];
             NSLog(@"date:%@",[detaildate2 description]);
             NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
             [dateFormatter2 setDateFormat:@"yyyy-MM-dd HH:mm"];
             NSString *currentDateStr2 = [dateFormatter stringFromDate: detaildate2];
             NSString *timeStr2 = currentDateStr2;
             timeLab2.text = [NSString stringWithFormat:@"订单完成:%@",timeStr2];
             timeLab2.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
             timeLab2.font = [UIFont systemFontOfSize:15];
             timeLab2.textAlignment = NSTextAlignmentLeft;
             [cell addSubview:timeLab2];

             if ([model.completeImg isKindOfClass:[NSNull class]]){}else{
                 NSArray *cImgArr = model.completeImg;
                 _completeImgArr = [NSMutableArray array];
                 for (int i = 0; i < cImgArr.count; i++) {
                     NSDictionary *dic = cImgArr[i];
                     NSString *img_path = [dic objectForKey:@"img_path"];
                     NSString *img_name = [dic objectForKey:@"img_name"];
                     NSString *newImg = [img_path stringByAppendingString:img_name];
                     [_completeImgArr addObject:newImg];
                 }
             }
             UIScrollView *backscrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(timeLab2.frame), Main_width, 90)];
             backscrollview.contentSize = CGSizeMake(50*_completeImgArr.count+16*(_completeImgArr.count-1), 50);
             backscrollview.showsVerticalScrollIndicator = NO;
             backscrollview.showsHorizontalScrollIndicator = NO;
             backscrollview.userInteractionEnabled = YES;
             [cell addSubview:backscrollview];
             for (int i=0; i<_completeImgArr.count; i++) {
                 
                 UIImageView *imgView = [[UIImageView alloc]init];
                 imgView.frame = CGRectMake(10+(i*90),16, 50, 50);
                 [imgView sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:_completeImgArr[i]]] placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
                 imgView.layer.cornerRadius = 25;
                 imgView.clipsToBounds = YES;
                 [backscrollview addSubview:imgView];
                 
             }
             UILabel *beiZhuLab = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(backscrollview.frame), Main_width-20, 60)];
             beiZhuLab.numberOfLines = 2;
             beiZhuLab.text = @"备注：还记得刚的哈萨克和阿萨德回来圣诞节爱丽丝按实际的话拉动和啊啊数据库的好看打开";
             beiZhuLab.textColor = [UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1];
             beiZhuLab.font = [UIFont systemFontOfSize:13];
             beiZhuLab.textAlignment = NSTextAlignmentLeft;
             [cell addSubview:beiZhuLab];

             //评价评分
             UILabel *pingJiaLab = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(beiZhuLab.frame)+10, 70, 15)];
             pingJiaLab.numberOfLines = 2;
             pingJiaLab.text = @"服务评分:";
             pingJiaLab.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:1/255.0 alpha:1];
             pingJiaLab.font = [UIFont systemFontOfSize:15];
             pingJiaLab.textAlignment = NSTextAlignmentCenter;
             [cell addSubview:pingJiaLab];

             int i = [_score intValue];
             for (int j = 0; j<i; j++) {
                 UIImageView *starView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(pingJiaLab.frame)+10+j*20, CGRectGetMaxY(beiZhuLab.frame)+10, 15, 15)];
                 starView.image = [UIImage imageNamed:@"pingjia1"];
                 [cell.contentView addSubview:starView];
             }

             UILabel *pjTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(pingJiaLab.frame)+10, CGRectGetMaxY(pingJiaLab.frame), Main_width-20-80, 60)];
             pjTitleLab.numberOfLines = 2;
             pjTitleLab.text = @"服务态度不错，小区物业服务很贴心细致";
             pjTitleLab.textColor = [UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1];
             pjTitleLab.font = [UIFont systemFontOfSize:13];
             pjTitleLab.textAlignment = NSTextAlignmentLeft;
             [cell addSubview:pjTitleLab];

         }else{

         }


    }

     return cell;

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]init];
    orderDetailModel *model = _dataSourceArr[0];
    if (section == 0) {

        headerView.frame = CGRectMake(0, 0, Main_width, 50);
        headerView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];

        //待服务
        UILabel *orderNumberLab = [[UILabel alloc]init];
        orderNumberLab.frame = CGRectMake(10, 10, Main_width-20, 30);
        NSString *textStr = model.order_number;
        orderNumberLab.text = [NSString stringWithFormat:@"订单编号:%@",textStr];
        orderNumberLab.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
        orderNumberLab.font = [UIFont systemFontOfSize:15];
        orderNumberLab.textAlignment = NSTextAlignmentLeft;
        [headerView addSubview:orderNumberLab];

        //待付款
        if([_stateStr isEqualToString:@"待付款"]) {

            UILabel *payLab = [[UILabel alloc]init];
            payLab.frame = CGRectMake(10, CGRectGetMaxY(orderNumberLab.frame)+10, Main_width-20, 30);
            NSString *payStr = @"190";
            payLab.text = [NSString stringWithFormat:@"未付: ￥%@",payStr];
            payLab.textColor = [UIColor colorWithRed:254/255.0 green:57/255.0 blue:57/255.0 alpha:1];
            [payLab setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
            payLab.textAlignment = NSTextAlignmentLeft;
            [headerView addSubview:payLab];
        }else if ([_stateStr isEqualToString:@"已付款"] || [_stateStr isEqualToString:@"已完成"] || [_stateStr isEqualToString:@"已评价"]){//已付款

            UILabel *payLab = [[UILabel alloc]init];
            payLab.frame = CGRectMake(10, CGRectGetMaxY(orderNumberLab.frame)+10, Main_width-20, 30);
            NSString *payStr = @"190";
            payLab.text = [NSString stringWithFormat:@"已付: ￥%@",payStr];
            payLab.textColor = [UIColor colorWithRed:80/255.0 green:204/255.0 blue:51/255.0 alpha:1];
            [payLab setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
            payLab.textAlignment = NSTextAlignmentLeft;
            [headerView addSubview:payLab];
        }




    }

    return headerView;
}

#pragma mark - 支付预付款
- (void)loadFunctionView {

    //等待派单
    UIView *functionView = [[UIView alloc]init];
    CGFloat contentY = Main_Height-50-height;
    functionView.frame = CGRectMake(0, contentY, Main_width, 50);
    functionView.backgroundColor = [UIColor whiteColor];

    UILabel *yfLab = [[UILabel alloc]init];
    yfLab.frame = CGRectMake(10, 15, 90, 20);
    yfLab.text = @"预付金额:";
    yfLab.textColor = [UIColor colorWithRed:125/255.0 green:125/255.0 blue:125/255.0 alpha:1];
    yfLab.font = [UIFont systemFontOfSize:14];
    yfLab.textAlignment = NSTextAlignmentRight;
    [functionView addSubview:yfLab];

    UILabel *priceLab = [[UILabel alloc]init];
    priceLab.frame = CGRectMake(CGRectGetMaxX(yfLab.frame)+10, 10, 90, 30);
    priceLab.text = @"5元";
    priceLab.textColor = [UIColor colorWithRed:252/255.0 green:88/255.0 blue:48/255.0 alpha:1];
    priceLab.font = [UIFont systemFontOfSize:16];
    priceLab.textAlignment = NSTextAlignmentLeft;
    [functionView addSubview:priceLab];

    UIButton *zhiFuBtn = [[UIButton alloc]initWithFrame:CGRectMake(Main_width-30-100, 5, 100, 40)];
    zhiFuBtn.clipsToBounds = YES;
    zhiFuBtn.layer.cornerRadius = 5;
    zhiFuBtn.backgroundColor = [UIColor colorWithRed:252/255.0 green:88/255.0 blue:48/255.0 alpha:1];
//    CAGradientLayer *layer = [CAGradientLayer layer];
//    layer.frame = zhiFuBtn.bounds;
//    layer.startPoint = CGPointMake(0,0);
//    layer.endPoint = CGPointMake(1, 0);
//    layer.colors = @[(id)[UIColor colorWithHexString:@"FF9502"].CGColor,(id)[UIColor colorWithHexString:@"FF5722"].CGColor];
//    [zhiFuBtn.layer addSublayer:layer];
    [zhiFuBtn setTitle:@"支付预付款" forState:UIControlStateNormal];
    [zhiFuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    zhiFuBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [zhiFuBtn addTarget:self action:@selector(zhiFuAction) forControlEvents:UIControlEventTouchUpInside];
    zhiFuBtn.layer.cornerRadius = 3.0;
    [functionView addSubview:zhiFuBtn];
    [self.view addSubview:functionView];

}
#pragma mark - 取消订单
-(void)rightBtn1Clicked{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = @{@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"],@"id":_workOrderID};

    NSString *strurl = [API stringByAppendingString:@"propertyWork/WorkCancel"];
    [manager POST:strurl parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"dataStr = %@",dataStr);
        NSInteger status = [responseObject[@"status"] integerValue];
        if (status == 1) {

            _stateStr = @"已评价";
            mywuyegongdanViewController *mmVC = [[mywuyegongdanViewController alloc]init];
            [self.navigationController pushViewController:mmVC animated:YES];
            [_tableView reloadData];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    }];
}
#pragma mark - 支付预付款
-(void)zhiFuAction{
     SpecialAlertView *fuKuan = [[SpecialAlertView alloc]initWithMessageTitle:@"您需要支付预付费用" messageString:@"￥5." messageString1:@"00"  sureBtnTitle:@"立即支付" sureBtnColor:[UIColor blueColor]];
}
#pragma mark - 付款
-(void)rightBtn2Clicked{
    
    SpecialAlertView *fuKuan = [[SpecialAlertView alloc]initWithMessageTitle:@"付款金额" messageString:@"￥185." messageString1:@"00" messageString2:@"已扣除预付费用5元"  messageString3:@"温馨提示" messageString4:@"请确认服务完成后再付款" sureBtnTitle:@"确定" sureBtnColor:[UIColor blueColor]];
    
}
#pragma mark - 评价
-(void)rightBtn3Clicked{
    
    evaluateViewController *pjVC = [[evaluateViewController alloc]init];
    pjVC.orderID = _workOrderID;
    [self.navigationController pushViewController:pjVC animated:YES];
 
}
@end
