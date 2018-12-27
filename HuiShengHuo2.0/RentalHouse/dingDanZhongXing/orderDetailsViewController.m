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
#import "AllPayViewController.h"
#define NAV_HEIGHT 64
#define IMAGE_HEIGHT 0
#define SCROLL_DOWN_LIMIT 70
#import "orderDetailModel.h"
#import "mywuyegongdanViewController.h"
#import "XLPhotoBrowser.h"
@interface orderDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *dataSourceArr;
    
    CGFloat height;
    
    UIImageView *starView ;
    NSDictionary *dataDic;
}
@property (nonatomic , strong)UITableView *tableView;
@property (nonatomic , strong)NSMutableArray *dataSourceArr ;
@property (nonatomic , strong)NSMutableArray *repairImgArr ;
@property (nonatomic , strong)NSMutableArray *distributeUserArr ;
@property (nonatomic , strong)NSMutableArray *distributeUserImgArr ;
@property (nonatomic , strong)NSMutableArray *completeImgArr ;
@property (nonatomic , strong)NSDictionary *score ;
@property (nonatomic , assign)CGFloat backscrollviewH;
@property (nonatomic , strong)NSMutableArray  *cArr;
@property (nonatomic , strong)NSMutableArray  *rArr;
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
//    [self setRightBtn];
//
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shauxin) name:@"shuaxinwuyegongdanxiangqing" object:nil];
}
- (void)shauxin{
    [self loadData];
}
-(void)loadData{
    
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
                
                dataDic = responseObject[@"data"];
                NSLog(@"dataDic = %@",dataDic);
                _score = dataDic[@"score"];
                NSLog(@"_score = %@",[dataDic[@"score"] class]);
                _dataSourceArr = [NSMutableArray array];
                orderDetailModel *model = [[orderDetailModel alloc]initWithDictionary:dataDic error:NULL];
                [_dataSourceArr addObject:model];
                NSLog(@"_dataSourceArr = %@",_dataSourceArr);
                [self loadTableView];
                if ([model.work_status isEqualToString:@"0"]) {
                    [self loadFunctionView];
                }
                [self setRightBtn];
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
    }// 在HUD被隐藏后的回调
       completionBlock:^{
           //操作执行完后取消对话框
           [_HUD removeFromSuperview];
           _HUD = nil;
       }];
   
}
-(void)setRightBtn{
    orderDetailModel *model = _dataSourceArr[0];
    if ([model.work_status isEqualToString:@"1"] || [model.work_status isEqualToString:@"2"]) {
        WBLog(@"************111111111111-------22222222222222222");
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
    }else if ([model.work_status isEqualToString:@"3"]){
        WBLog(@"************33333333333333");
        //    待付款+已付款
        UIButton *rightBtn2 = [UIButton buttonWithType:UIButtonTypeSystem];
        rightBtn2.frame = CGRectMake(0, 0, 58, 35);
        [rightBtn2 setTitle:@"付款" forState:UIControlStateNormal];
        rightBtn2.titleLabel.font = [UIFont systemFontOfSize:18];
        [rightBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        rightBtn2.backgroundColor = [UIColor colorWithRed:255/255.0 green:87/255.0 blue:34/255.0 alpha:1];
        rightBtn2.layer.cornerRadius = 5.0;
        //    rightBtn2.layer.borderColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1].CGColor;
        //    rightBtn2.layer.borderWidth = 1.0f;
        [rightBtn2 addTarget:self action:@selector(rightBtn2Clicked) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem2 = [[UIBarButtonItem alloc]initWithCustomView:rightBtn2];
        self.navigationItem.rightBarButtonItem = rightItem2;
        
    }else if ([model.work_status isEqualToString:@"5"]){
        WBLog(@"************55555555555");
        if ([_score isKindOfClass:[NSNull class]] || [model.work_type isEqualToString:@"2"]) {
            WBLog(@"************55555555555----有评价按钮");
            UIButton *rightBtn3 = [UIButton buttonWithType:UIButtonTypeSystem];
            rightBtn3.frame = CGRectMake(0, 0, 58, 35);
            [rightBtn3 setTitle:@"评价" forState:UIControlStateNormal];
            rightBtn3.titleLabel.font = [UIFont systemFontOfSize:14];
            [rightBtn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            rightBtn3.backgroundColor = [UIColor colorWithRed:255/255.0 green:87/255.0 blue:34/255.0 alpha:1];
            rightBtn3.layer.cornerRadius = 5.0;
            [rightBtn3 addTarget:self action:@selector(rightBtn3Clicked) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *rightItem3 = [[UIBarButtonItem alloc]initWithCustomView:rightBtn3];
            self.navigationItem.rightBarButtonItem = rightItem3;
        }else{
            WBLog(@"************55555555555-没评价按钮");
            self.navigationItem.rightBarButtonItem = nil;
        }
        
    }else{
        self.navigationItem.rightBarButtonItem = nil;
        WBLog(@"************666666666666");
    }
  
}
-(void)loadTableView{
    orderDetailModel *model = _dataSourceArr[0];
    CGFloat tableViewH;
    if ([model.work_status isEqualToString:@"0"]) {
        tableViewH = Main_Height-50;
    }else{
        tableViewH = Main_Height;
    }
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, Main_width-20,  tableViewH) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _tableView.contentInset = UIEdgeInsetsMake(IMAGE_HEIGHT - [self navBarBottom], 0, 0, 0);
    [self.view addSubview:_tableView];
    
    
    CGFloat headerViewH = 0;
    if([model.work_status isEqualToString:@"1"] || [model.work_status isEqualToString:@"0"] || [model.work_status isEqualToString:@"2"] || [model.work_status isEqualToString:@"6"]) {
        headerViewH = 50;
    }else{
        headerViewH = 100;
    }
//    if([_stateStr isEqualToString:@"待付款"] || [_stateStr isEqualToString:@"待完工"] || [_stateStr isEqualToString:@"已完工"] || [_stateStr isEqualToString:@"已评价"]) {
//        headerViewH = 100;
//    }else{
//        headerViewH = 50;
//    }
   
    UIView *headerView = [[UIView alloc]init];
    headerView.frame = CGRectMake(0, 0, Main_width, headerViewH);
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
    if([model.work_status isEqualToString:@"3"]) {
        UILabel *payLab = [[UILabel alloc]init];
        payLab.frame = CGRectMake(10, CGRectGetMaxY(orderNumberLab.frame)+10, Main_width-20, 30);
        NSString *payStr = model.total_fee;
        payLab.text = [NSString stringWithFormat:@"未付: ￥%@",payStr];
        payLab.textColor = [UIColor colorWithRed:254/255.0 green:57/255.0 blue:57/255.0 alpha:1];
        [payLab setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
        payLab.textAlignment = NSTextAlignmentLeft;
        [headerView addSubview:payLab];
    }else if ([model.work_status isEqualToString:@"4"] || [model.work_status isEqualToString:@"5"] || _evaluate_status == 1){//已付款
        UILabel *payLab = [[UILabel alloc]init];
        payLab.frame = CGRectMake(10, CGRectGetMaxY(orderNumberLab.frame)+10, Main_width-20, 30);
        NSString *payStr = model.total_fee;
        payLab.text = [NSString stringWithFormat:@"已付: ￥%@",payStr];
        payLab.textColor = [UIColor colorWithRed:80/255.0 green:204/255.0 blue:51/255.0 alpha:1];
        [payLab setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
        payLab.textAlignment = NSTextAlignmentLeft;
        [headerView addSubview:payLab];
    }
    _tableView.tableHeaderView = headerView;

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
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 70;
    }else if (indexPath.section ==1){
        return 50;
        
    }else if (indexPath.section ==2){
        orderDetailModel *model = _dataSourceArr[0];
        if (model.repairImg.count == 0) {
            if ([model.content isEqualToString:@""]) {
                return 0;
            }else{
                // 计算文字占据的高度
                NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:13]};
                CGSize maxSize = CGSizeMake(Main_width-80, MAXFLOAT);
                CGSize size = [model.content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
                if (size.height < 20) {
                    return 50;
                }else{
                     return size.height+10;
                }
               
            }
            
        }else{
            
            if ([model.content isEqualToString:@""]) {
                return 90;
            }else{
                // 计算文字占据的高度
                NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:13]};
                CGSize maxSize = CGSizeMake(Main_width-80, MAXFLOAT);
                CGSize size = [model.content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
//                WBLog(@"size.height = %lf",size.height+90);
                if (size.height < 20) {
                    return 90+10;
                }else{
                    return 90+10+size.height;
                }
               
            }
           
        }
       
        
    }else if (indexPath.section ==3){
        orderDetailModel *model = _dataSourceArr[0];

        if ([model.work_status isEqualToString:@"1"]) {//待派单
             return 160;
        }else if ([model.work_status isEqualToString:@"2"]){//待服务
             return 160;
        }else if ([model.work_status isEqualToString:@"3"] || [model.work_status isEqualToString:@"0"] ){//待付款
            
            if (model.distributeUser.count == 0) {
                return 110;
            }else{
                return 200;
            }
           
        }else if ([model.work_status isEqualToString:@"4"]){//待完工
            if (model.distributeUser.count == 0) {
                return 90;
            }else{
                return 180;
            }
        }else if ([model.work_status isEqualToString:@"5"]){//已完工
            
            if (model.completeImg.count == 0) {
                return 90;
            }else{
                return 180;
            }

        }else if ([model.work_status isEqualToString:@"6"]){
            return 120;
        }else{
             return 0;
        }
        
    }else{
        orderDetailModel *model = _dataSourceArr[0];
        if ([model.work_status isEqualToString:@"1"]) {//待派单
            return 0;
        }else if ([model.work_status isEqualToString:@"2"]){//待服务
            return 0;
        }else if ([model.work_status isEqualToString:@"3"] || [model.work_status isEqualToString:@"0"] ){//待付款
            return 0;
        }else if ([model.work_status isEqualToString:@"4"]){//待完工
            return 0;
        }else if ([model.work_status isEqualToString:@"5"]){//已完工
            if (model.completeImg.count == 0) {
               
                if ([_score isKindOfClass:[NSNull class]]) {
                    return 170;
                }else{
                    
                    // 计算文字占据的高度
                    NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:13]};
                    CGSize maxSize = CGSizeMake(Main_width-80, MAXFLOAT);
                    CGSize size = [_score[@"evaluate_content"] boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
                    //                WBLog(@"size.height = %lf",size.height+90);
                    if (size.height < 20) {
                        return 210;
                    }else{
                        return 210+size.height;
                    }
                }
            }else{
                if ([_score isKindOfClass:[NSNull class]]) {
                    return 260;
                }else{
                    // 计算文字占据的高度
                    NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:13]};
                    CGSize maxSize = CGSizeMake(Main_width-80, MAXFLOAT);
                    CGSize size = [_score[@"evaluate_content"] boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
                    //                WBLog(@"size.height = %lf",size.height+90);
                    if (size.height < 20) {
                        return 300;
                    }else{
                        return 300+size.height;
                    }
                }
            }
        }else{
           return 0;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    cell.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

        cell.userInteractionEnabled = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
    }

    if (indexPath.section == 0) {
        orderDetailModel *model = _dataSourceArr[0];
        UILabel *addressLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, Main_width-20, 30)];
        addressLab.numberOfLines = 0;
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
        
        UIView *line = [[UIView alloc]init];
        line.frame = CGRectMake(10, CGRectGetMaxY(nameLab.frame)-0.5, Main_width-40, .5);
        line.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1];
        [cell addSubview:line];

    }else if (indexPath.section == 1){
        orderDetailModel *model = _dataSourceArr[0];
        UILabel *projectLab = [[UILabel alloc]init];
        projectLab.frame = CGRectMake(10, 10, Main_width-20, 30);
        projectLab.text = model.type_name;
        projectLab.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
        projectLab.font = [UIFont systemFontOfSize:15];
        projectLab.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:projectLab];
        
        UIView *line = [[UIView alloc]init];
        line.frame = CGRectMake(10, 49.5, Main_width-40, .5);
        line.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1];
        [cell addSubview:line];
        

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
            
            _rArr = [NSMutableArray array];
            for (int j=0; j< imgArr.count; j++) {
                NSDictionary *dic = imgArr[j];
                NSString *img_path = [dic objectForKey:@"img_path"];
                NSString *img_name = [dic objectForKey:@"img_name"];
                NSString *newImg = [img_path stringByAppendingString:img_name];
                NSString *imgurl = [API_img stringByAppendingString:newImg];
                [_rArr addObject:imgurl];
            }
        }
        if (_repairImgArr.count == 0) {
            
            _backscrollviewH = 0;
        }else{
            _backscrollviewH = 90;
        }
        UIScrollView *backscrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Main_width, _backscrollviewH)];
        backscrollview.contentSize = CGSizeMake(60*_repairImgArr.count+16*(_repairImgArr.count-1), 60);
        backscrollview.showsVerticalScrollIndicator = NO;
        backscrollview.showsHorizontalScrollIndicator = NO;
        backscrollview.userInteractionEnabled = YES;
        [cell addSubview:backscrollview];
        for (int i=0; i<_repairImgArr.count; i++) {

            UIImageView *imgView = [[UIImageView alloc]init];
            imgView.frame = CGRectMake(10+(i*70),16, 60, 60);
            [imgView sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:_repairImgArr[i]]] placeholderImage:[UIImage imageNamed:@"展位图正"]];
            imgView.layer.cornerRadius = 5;
            imgView.clipsToBounds = YES;
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            imgView.tag = i;
            imgView.userInteractionEnabled = YES;
            UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(browerImage1:)];
            [imgView addGestureRecognizer:tap1];
            [backscrollview addSubview:imgView];
        }
        
        CGFloat beiZhuLabH = 0;
        
        UILabel *beiZhuLab = [[UILabel alloc] init];
        // 计算文字占据的高度
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:13]};
        CGSize maxSize = CGSizeMake(Main_width-80, MAXFLOAT);
        CGSize size = [model.content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
        beiZhuLab.numberOfLines = 0;
        beiZhuLab.text = [NSString stringWithFormat:@"维修备注:%@",model.content];
        beiZhuLab.textColor = [UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1];
        beiZhuLab.font = [UIFont systemFontOfSize:13];
        beiZhuLab.textAlignment = NSTextAlignmentLeft;
        if ([model.content isEqualToString:@""]) {
             beiZhuLab.frame = CGRectMake(10, CGRectGetMaxY(backscrollview.frame), Main_width-40, beiZhuLabH);
        }else{
            
            if (_repairImgArr.count == 0) {
                
                beiZhuLab.frame = CGRectMake(10, 10, Main_width-40, size.height);
            }else{
                 beiZhuLab.frame = CGRectMake(10, CGRectGetMaxY(backscrollview.frame), Main_width-40, size.height);
            }
           
        }
    
        [cell addSubview:beiZhuLab];
        //分割线
        UIView *line = [[UIView alloc]init];
        if (model.repairImg.count == 0) {
            if ([model.content isEqualToString:@""]) {
               line.frame = CGRectMake(0, 0, 0, 0);
            }else{
                if (size.height < 20) {
                   line.frame = CGRectMake(10, 49.5, Main_width-40, .5);
                }else{
                    line.frame = CGRectMake(10, size.height-0.5, Main_width-40, .5);
                }
                
            }
            
        }else{
            
            if ([model.content isEqualToString:@""]) {
                line.frame = CGRectMake(10, 90-0.5, Main_width-40, .5);
            }else{
                line.frame = CGRectMake(10, 90+10+size.height-0.5, Main_width-40, .5);
            }
            
        }
        line.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1];
        [cell addSubview:line];

    }else if(indexPath.section == 3){
        orderDetailModel *model = _dataSourceArr[0];
        if ([model.work_status isEqualToString:@"1"] || [model.work_status isEqualToString:@"0"]) {//待派单
            UILabel *timeLab1 = [[UILabel alloc] initWithFrame:CGRectMake(10,19, Main_width-20, 15)];
            NSTimeInterval time=[model.release_at doubleValue];
            NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
            NSLog(@"date:%@",[detaildate description]);
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
//            NSString *timestring = [[arr objectAtIndex:i] objectForKey:@"release_at"];
//            NSTimeInterval interval   =[timestring doubleValue];
//            NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            [formatter setDateFormat:@"MM/dd HH:mm"];
//            NSString *dateString = [formatter stringFromDate: date];
            NSString *timeStr1 = currentDateStr;
            timeLab1.text = [NSString stringWithFormat:@"下单时间:%@",timeStr1];
            timeLab1.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
            timeLab1.font = [UIFont systemFontOfSize:15];
            timeLab1.textAlignment = NSTextAlignmentLeft;
            [cell addSubview:timeLab1];
        }else if ([model.work_status isEqualToString:@"2"]){ //待服务

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

        }else if ([model.work_status isEqualToString:@"3"] || [model.work_status isEqualToString:@"0"]){//待付款

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
           
            if ([model.distributeUser isKindOfClass:[NSNull class]]){}else{
                NSArray *cImgArr = model.distributeUser;
                _distributeUserArr = [NSMutableArray array];
                for (int i = 0; i < cImgArr.count; i++) {
                    NSDictionary *dic = cImgArr[i];
                    NSString *name = [dic objectForKey:@"name"];
                    [_distributeUserArr addObject:name];
                }
            }
            if ([model.distributeUser isKindOfClass:[NSNull class]]){}else{
                NSArray *cImgArr = model.distributeUser;
                _distributeUserImgArr = [NSMutableArray array];
                for (int i = 0; i < cImgArr.count; i++) {
                    NSDictionary *dic = cImgArr[i];
                    NSString *head_img = [dic objectForKey:@"head_img"];
                    [_distributeUserImgArr addObject:head_img];
                }
            }
            if (_distributeUserArr.count == 0) {
                
                _backscrollviewH = 0;
            }else{
                _backscrollviewH = 90;
            }
            UIScrollView *backscrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(timeLab2.frame), Main_width, _backscrollviewH)];
            backscrollview.contentSize = CGSizeMake(50*_completeImgArr.count+16*(_completeImgArr.count-1), 50);
            backscrollview.showsVerticalScrollIndicator = NO;
            backscrollview.showsHorizontalScrollIndicator = NO;
            backscrollview.userInteractionEnabled = YES;
            [cell addSubview:backscrollview];
            for (int i=0; i<_distributeUserArr.count; i++) {

                UIImageView *imgView = [[UIImageView alloc]init];
                imgView.frame = CGRectMake(10+(i*90),16, 50, 50);
                [imgView sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:_distributeUserImgArr[i]]] placeholderImage:[UIImage imageNamed:@"头像"]];
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
                NSString *timeStr3 = _distributeUserArr[i];
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

            }else if([model.work_status isEqualToString:@"4"]){//待完工

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
                NSTimeInterval time2=[model.distribute_at doubleValue];
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

                if ([model.distributeUser isKindOfClass:[NSNull class]]){}else{
                    NSArray *cImgArr = model.distributeUser;
                    _distributeUserArr = [NSMutableArray array];
                    for (int i = 0; i < cImgArr.count; i++) {
                        NSDictionary *dic = cImgArr[i];
                        NSString *name = [dic objectForKey:@"name"];
                        [_distributeUserArr addObject:name];
                    }
                }
                if ([model.distributeUser isKindOfClass:[NSNull class]]){}else{
                    NSArray *cImgArr = model.distributeUser;
                    _distributeUserImgArr = [NSMutableArray array];
                    for (int i = 0; i < cImgArr.count; i++) {
                        NSDictionary *dic = cImgArr[i];
                        NSString *head_img = [dic objectForKey:@"head_img"];
                        [_distributeUserImgArr addObject:head_img];
                    }
                }
                if (_distributeUserArr.count == 0) {
                    
                    _backscrollviewH = 0;
                }else{
                    _backscrollviewH = 90;
                }
                UIScrollView *backscrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(timeLab2.frame), Main_width, _backscrollviewH)];
                backscrollview.contentSize = CGSizeMake(50*_distributeUserArr.count+16*(_distributeUserArr.count-1), 50);
                backscrollview.showsVerticalScrollIndicator = NO;
                backscrollview.showsHorizontalScrollIndicator = NO;
                backscrollview.userInteractionEnabled = YES;
                [cell addSubview:backscrollview];
                for (int i=0; i<_distributeUserArr.count; i++) {
                    
                    UIImageView *imgView = [[UIImageView alloc]init];
                    imgView.frame = CGRectMake(10+(i*90),16, 50, 50);
                    [imgView sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:_distributeUserImgArr[i]]] placeholderImage:[UIImage imageNamed:@"头像"]];
                    imgView.layer.cornerRadius = 25;
                    imgView.clipsToBounds = YES;
                    [backscrollview addSubview:imgView];

                    UILabel *queRenLab = [[UILabel alloc]init];
                    queRenLab.frame = CGRectMake(CGRectGetMaxX(imgView.frame)-10, 10, 41, 16);
                    NSString *timeStr2 = @"已确认";
                    queRenLab.text = [NSString stringWithFormat:@"%@",timeStr2];
                    queRenLab.textColor = [UIColor whiteColor];
                    queRenLab.layer.cornerRadius = 2;
                    queRenLab.clipsToBounds = YES;
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
                    NSString *timeStr3 = _distributeUserArr[i];
                    nameLab.text = [NSString stringWithFormat:@"%@",timeStr3];
                    nameLab.textColor = [UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1];
                    nameLab.font = [UIFont systemFontOfSize:13];
                    nameLab.textAlignment = NSTextAlignmentCenter;
                    [backscrollview addSubview:nameLab];

                }

                if ([model.work_status isEqualToString:@"4"]) {
                    UILabel *timeLab3 = [[UILabel alloc] init];
                    timeLab3.frame = CGRectMake(10,CGRectGetMaxY(backscrollview.frame)+10, Main_width-20, 13);
                    NSString *timeStr5 = @"等待完工...";
                    timeLab3.text = [NSString stringWithFormat:@"%@",timeStr5];
                    timeLab3.textColor = [UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1];
                    timeLab3.font = [UIFont systemFontOfSize:12];
                    timeLab3.textAlignment = NSTextAlignmentLeft;
                    [cell addSubview:timeLab3];
                }

            }else if ([model.work_status isEqualToString:@"5"]){

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

                if ([model.distributeUser isKindOfClass:[NSNull class]]){}else{
                    NSArray *cImgArr = model.distributeUser;
                    _distributeUserArr = [NSMutableArray array];
                    for (int i = 0; i < cImgArr.count; i++) {
                        NSDictionary *dic = cImgArr[i];
                        NSString *name = [dic objectForKey:@"name"];
                        [_distributeUserArr addObject:name];
                    }
                }
                if ([model.distributeUser isKindOfClass:[NSNull class]]){}else{
                    NSArray *cImgArr = model.distributeUser;
                    _distributeUserImgArr = [NSMutableArray array];
                    for (int i = 0; i < cImgArr.count; i++) {
                        NSDictionary *dic = cImgArr[i];
                        NSString *head_img = [dic objectForKey:@"head_img"];
                        [_distributeUserImgArr addObject:head_img];
                    }
                }
                if (_distributeUserArr.count == 0) {
                    
                    _backscrollviewH = 0;
                }else{
                    _backscrollviewH = 90;
                }
                UIScrollView *backscrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(timeLab2.frame), Main_width, _backscrollviewH)];
                backscrollview.contentSize = CGSizeMake(50*_distributeUserArr.count+16*(_distributeUserArr.count-1), 50);
                backscrollview.showsVerticalScrollIndicator = NO;
                backscrollview.showsHorizontalScrollIndicator = NO;
                backscrollview.userInteractionEnabled = YES;
                [cell addSubview:backscrollview];
                for (int i=0; i<_distributeUserArr.count; i++) {
                    
                    UIImageView *imgView = [[UIImageView alloc]init];
                    imgView.frame = CGRectMake(10+(i*90),16, 50, 50);
                    [imgView sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:_distributeUserImgArr[i]]] placeholderImage:[UIImage imageNamed:@"头像"]];
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
                    NSString *timeStr3 = _distributeUserArr[i];
                    nameLab.text = [NSString stringWithFormat:@"%@",timeStr3];
                    nameLab.textColor = [UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1];
                    nameLab.font = [UIFont systemFontOfSize:13];
                    nameLab.textAlignment = NSTextAlignmentCenter;
                    [backscrollview addSubview:nameLab];

                }

            }else if ([_score isKindOfClass:[NSDictionary class]]){

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
                    [imgView sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:_completeImgArr[i]]] placeholderImage:[UIImage imageNamed:@"展位图正"]];
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

            }else if ([model.work_status isEqualToString:@"6"]){//已取消
                //取消订单
                UILabel *quXiaoLab = [[UILabel alloc] initWithFrame:CGRectMake(10,19, Main_width-20, 15)];
                NSString *timeStr6 = @"订单已取消";
                quXiaoLab.text = [NSString stringWithFormat:@"%@",timeStr6];
                quXiaoLab.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
                quXiaoLab.font = [UIFont systemFontOfSize:15];
                quXiaoLab.textAlignment = NSTextAlignmentLeft;
                [cell addSubview:quXiaoLab];

                UILabel *quXiaoLab1 = [[UILabel alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(quXiaoLab.frame)+10, Main_width-20, 15)];
                if ([model.work_type isEqualToString:@"1"]) {
                    NSString *timeStr7 = @"等待1~3个工作日退还您支付的预付费用";
                    quXiaoLab1.text = [NSString stringWithFormat:@"%@",timeStr7];
                }
                quXiaoLab1.textColor = [UIColor colorWithRed:255/255.0 green:87/255.0 blue:34/255.0 alpha:1];
                quXiaoLab1.font = [UIFont systemFontOfSize:13];
                quXiaoLab1.textAlignment = NSTextAlignmentLeft;
                [cell addSubview:quXiaoLab1];

            }
        
        UIView *line = [[UIView alloc]init];
        if ([model.work_status isEqualToString:@"1"]) {//待派单
            line.frame = CGRectMake(10, 160-0.5, Main_width-40, .5);
        }else if ([model.work_status isEqualToString:@"2"]){//待服务
            line.frame = CGRectMake(10, 160-0.5, Main_width-40, .5);
        }else if ([model.work_status isEqualToString:@"3"] || [model.work_status isEqualToString:@"0"] ){//待付款
            if (model.distributeUser.count == 0) {
                line.frame = CGRectMake(10, 110-0.5, Main_width-40, .5);
            }else{
                line.frame = CGRectMake(10, 200-0.5, Main_width-40, .5);
            }
        }else if ([model.work_status isEqualToString:@"4"]){//待完工
            if (model.distributeUser.count == 0) {
                line.frame = CGRectMake(10, 90-0.5, Main_width-40, .5);
            }else{
                line.frame = CGRectMake(10, 180-0.5, Main_width-40, .5);
            }
        }else if ([model.work_status isEqualToString:@"5"]){//已完工
            
            if (model.completeImg.count == 0) {
                line.frame = CGRectMake(10, 90-0.5, Main_width-40, .5);
            }else{
                line.frame = CGRectMake(10, 180-0.5, Main_width-40, .5);
            }
            
        }else if ([model.work_status isEqualToString:@"6"]){
            line.frame = CGRectMake(10, 120-0.5, Main_width-40, .5);
        }else{
            return 0;
        }
        
        line.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1];
        [cell addSubview:line];

    }else {

        orderDetailModel *model = _dataSourceArr[0];
         if ([model.work_status isEqualToString:@"5"]) { //已完工
             UILabel *timeLab1 = [[UILabel alloc] initWithFrame:CGRectMake(10,19, Main_width-20, 15)];
             NSTimeInterval time=[model.order_time doubleValue];
             NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
             NSLog(@"date:%@",[detaildate description]);
             NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
             [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
             NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
             NSString *timeStr1 = currentDateStr;
             timeLab1.text = [NSString stringWithFormat:@"服务用时:%@",model.order_time];
             timeLab1.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
             timeLab1.font = [UIFont systemFontOfSize:15];
             timeLab1.textAlignment = NSTextAlignmentLeft;
             [cell addSubview:timeLab1];

             UILabel *timeLab2 = [[UILabel alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(timeLab1.frame)+10, Main_width-20, 15)];
             NSTimeInterval time2=[model.complete_at doubleValue];
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
                 _cArr = [NSMutableArray array];
                 for (int j=0; j< cImgArr.count; j++) {
                     NSDictionary *dic = cImgArr[j];
                     NSString *img_path = [dic objectForKey:@"img_path"];
                     NSString *img_name = [dic objectForKey:@"img_name"];
                     NSString *newImg = [img_path stringByAppendingString:img_name];
                     NSString *imgurl = [API_img stringByAppendingString:newImg];
                     [_cArr addObject:imgurl];
                 }
             }
             UIScrollView *backscrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(timeLab2.frame), Main_width, 80)];
             backscrollview.contentSize = CGSizeMake(80*_completeImgArr.count+16*(_completeImgArr.count-1), 80);
             backscrollview.showsVerticalScrollIndicator = NO;
             backscrollview.showsHorizontalScrollIndicator = NO;
             backscrollview.userInteractionEnabled = YES;
             [cell addSubview:backscrollview];
             for (int i=0; i<_completeImgArr.count; i++) {
                 
                 UIImageView *imgView = [[UIImageView alloc]init];
                 imgView.frame = CGRectMake(10+(i*70),16, 60, 60);
                 [imgView sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:_completeImgArr[i]]] placeholderImage:[UIImage imageNamed:@"头像"]];
//                 imgView.layer.cornerRadius = 5;
                 imgView.clipsToBounds = YES;
                 imgView.contentMode = UIViewContentModeScaleAspectFill;;
                 imgView.tag = i;
                 imgView.userInteractionEnabled = YES;
                 UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(browerImage:)];
                 [imgView addGestureRecognizer:tap];
                 [backscrollview addSubview:imgView];

             }
             UILabel *beiZhuLab = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(backscrollview.frame), Main_width-20, 60)];
             beiZhuLab.numberOfLines = 2;
             beiZhuLab.text = [NSString stringWithFormat:@"完工备注:%@",model.complete_content];
             beiZhuLab.textColor = [UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1];
             beiZhuLab.font = [UIFont systemFontOfSize:13];
             beiZhuLab.textAlignment = NSTextAlignmentLeft;
             [cell addSubview:beiZhuLab];
             
            
        
        if([_score isKindOfClass:[NSDictionary class]]) { //已评价
            //评价评分
            UILabel *pingJiaLab = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(beiZhuLab.frame)+10, 70, 15)];
            pingJiaLab.numberOfLines = 2;
            pingJiaLab.text = @"服务评分:";
            pingJiaLab.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:1/255.0 alpha:1];
            pingJiaLab.font = [UIFont systemFontOfSize:15];
            pingJiaLab.textAlignment = NSTextAlignmentCenter;
            [cell addSubview:pingJiaLab];
            
             int i = [_score[@"level"] intValue];

             for (int j = 0; j<i; j++) {
                 starView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(pingJiaLab.frame)+10+j*20, CGRectGetMaxY(beiZhuLab.frame)+10, 15, 15)];
                 starView.image = [UIImage imageNamed:@"pingjia1"];
                 [cell.contentView addSubview:starView];
                 
            }
            UILabel *pjTitleLab = [[UILabel alloc] init];
            // 计算文字占据的高度
            NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:13]};
            CGSize maxSize = CGSizeMake(Main_width-80, MAXFLOAT);
            CGSize size = [_score[@"evaluate_content"] boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
            pjTitleLab.numberOfLines = 0;
            pjTitleLab.text = _score[@"evaluate_content"];
            pjTitleLab.textColor = [UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1];
            pjTitleLab.font = [UIFont systemFontOfSize:13];
            pjTitleLab.textAlignment = NSTextAlignmentLeft;
            if ([_score[@"evaluate_content"] isEqualToString:@""]) {
                pjTitleLab.frame = CGRectMake(10, CGRectGetMaxY(starView.frame)+10, Main_width-40, 0);
                
            }else{
                pjTitleLab.frame = CGRectMake(10, CGRectGetMaxY(starView.frame)+10, Main_width-40, size.height);
            }
            [cell addSubview:pjTitleLab];
            
        }

             
            
            

         }
//         else if([_score isKindOfClass:[NSDictionary class]]) { //已评价
//
//             UILabel *timeLab1 = [[UILabel alloc] initWithFrame:CGRectMake(10,19, Main_width-20, 15)];
//             NSTimeInterval time=[model.order_time doubleValue]+28800;
//             NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
//             NSLog(@"date:%@",[detaildate description]);
//             NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//             [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//             NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
//             NSString *timeStr1 = currentDateStr;
//             timeLab1.text = [NSString stringWithFormat:@"服务用时:%@",timeStr1];
//             timeLab1.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
//             timeLab1.font = [UIFont systemFontOfSize:15];
//             timeLab1.textAlignment = NSTextAlignmentLeft;
//             [cell addSubview:timeLab1];
//
//             UILabel *timeLab2 = [[UILabel alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(timeLab1.frame)+10, Main_width-20, 15)];
//             NSTimeInterval time2=[model.order_total_time doubleValue]+28800;
//             NSDate *detaildate2=[NSDate dateWithTimeIntervalSince1970:time2];
//             NSLog(@"date:%@",[detaildate2 description]);
//             NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
//             [dateFormatter2 setDateFormat:@"yyyy-MM-dd HH:mm"];
//             NSString *currentDateStr2 = [dateFormatter stringFromDate: detaildate2];
//             NSString *timeStr2 = currentDateStr2;
//             timeLab2.text = [NSString stringWithFormat:@"订单完成:%@",timeStr2];
//             timeLab2.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
//             timeLab2.font = [UIFont systemFontOfSize:15];
//             timeLab2.textAlignment = NSTextAlignmentLeft;
//             [cell addSubview:timeLab2];
//
//             if ([model.completeImg isKindOfClass:[NSNull class]]){}else{
//                 NSArray *cImgArr = model.completeImg;
//                 _completeImgArr = [NSMutableArray array];
//                 for (int i = 0; i < cImgArr.count; i++) {
//                     NSDictionary *dic = cImgArr[i];
//                     NSString *img_path = [dic objectForKey:@"img_path"];
//                     NSString *img_name = [dic objectForKey:@"img_name"];
//                     NSString *newImg = [img_path stringByAppendingString:img_name];
//                     [_completeImgArr addObject:newImg];
//                 }
//             }
//             UIScrollView *backscrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(timeLab2.frame), Main_width, 90)];
//             backscrollview.contentSize = CGSizeMake(50*_completeImgArr.count+16*(_completeImgArr.count-1), 50);
//             backscrollview.showsVerticalScrollIndicator = NO;
//             backscrollview.showsHorizontalScrollIndicator = NO;
//             backscrollview.userInteractionEnabled = YES;
//             [cell addSubview:backscrollview];
//             for (int i=0; i<_completeImgArr.count; i++) {
//
//                 UIImageView *imgView = [[UIImageView alloc]init];
//                 imgView.frame = CGRectMake(10+(i*90),16, 50, 50);
//                 imgView.layer.cornerRadius = 25;
//                 imgView.clipsToBounds = YES;
//                 [backscrollview addSubview:imgView];
//
//             }
//             UILabel *beiZhuLab = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(backscrollview.frame), Main_width-20, 60)];
//             beiZhuLab.numberOfLines = 2;
//             beiZhuLab.text = model.complete_content;
//             beiZhuLab.textColor = [UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1];
//             beiZhuLab.font = [UIFont systemFontOfSize:13];
//             beiZhuLab.textAlignment = NSTextAlignmentLeft;
//             [cell addSubview:beiZhuLab];
//
//             //评价评分
//             UILabel *pingJiaLab = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(beiZhuLab.frame)+10, 70, 15)];
//             pingJiaLab.numberOfLines = 2;
//             pingJiaLab.text = @"服务评分:";
//             pingJiaLab.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:1/255.0 alpha:1];
//             pingJiaLab.font = [UIFont systemFontOfSize:15];
//             pingJiaLab.textAlignment = NSTextAlignmentCenter;
//             [cell addSubview:pingJiaLab];
//
//             int i = [_score[@"level"] intValue];
//             for (int j = 0; j<i; j++) {
//                 UIImageView *starView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(pingJiaLab.frame)+10+j*20, CGRectGetMaxY(beiZhuLab.frame)+10, 15, 15)];
//                 starView.image = [UIImage imageNamed:@"pingjia1"];
//                 [cell.contentView addSubview:starView];
//             }
//
//             UILabel *pjTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(pingJiaLab.frame)+10, CGRectGetMaxY(pingJiaLab.frame), Main_width-20-80, 60)];
//             pjTitleLab.numberOfLines = 2;
//             pjTitleLab.text = _score[@"evaluate_content"];
//             pjTitleLab.textColor = [UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1];
//             pjTitleLab.font = [UIFont systemFontOfSize:13];
//             pjTitleLab.textAlignment = NSTextAlignmentLeft;
//             [cell addSubview:pjTitleLab];
//
//         }else{
//
//         }


    }

     return cell;

}

#pragma mark - 支付预付款
- (void)loadFunctionView {

    //等待派单
    UIView *functionView = [[UIView alloc]init];
    CGFloat contentY = Main_Height-50-height;
    functionView.frame = CGRectMake(0, contentY, Main_width, 50);
    functionView.backgroundColor = [UIColor whiteColor];

    UILabel *yfLab = [[UILabel alloc]init];
    yfLab.frame = CGRectMake(10, 15, 65, 20);
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

    UIButton *zhiFuBtn = [[UIButton alloc]initWithFrame:CGRectMake(Main_width-20-100, 5, 100, 40)];
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
    //初始化警告框
    UIAlertController*alert = [UIAlertController
                               alertControllerWithTitle:@"提示"
                               message: @"是否确定取消订单"
                               preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction
                      actionWithTitle:@"取消"
                      style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                      {
                          NSLog(@"取消取消订单");
                      }]];
    [alert addAction:[UIAlertAction
                      actionWithTitle:@"确定"
                      style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                      {
                          
                          orderDetailModel *model = _dataSourceArr[0];
                          //1.创建会话管理者
                          AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                          manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
                          //2.封装参数
                          NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
                          NSDictionary *dict = @{@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"],@"id":model.id};
                          
                          NSString *strurl = [API stringByAppendingString:@"propertyWork/WorkCancel"];
                          [manager POST:strurl parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
                              
                          } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                              
                              NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
                              NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                              NSLog(@"dataStr = %@",dataStr);
                              NSInteger status = [responseObject[@"status"] integerValue];
                              if (status == 1) {
                                  
                                  for (UIViewController *controller in self.navigationController.viewControllers) {
                                      if ([controller isKindOfClass:[mywuyegongdanViewController class]]) {
                                          mywuyegongdanViewController *vc =(mywuyegongdanViewController *)controller;
                                          [self.navigationController popToViewController:vc animated:YES];
                                      }
                                  }
                                  [self dingdantuisong:[dataDic objectForKey:@"id"]];
                              }else{
                                  [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
                              }
                          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                              
                          }];
                      
                      }]];
    //弹出提示框
    [self presentViewController:alert
                       animated:YES completion:nil];
    
   
}
- (void)dingdantuisong:(NSString *)gongdanid
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSString *url = [API stringByAppendingString:@"Jpush/userToWorkerSubmit"];
    NSDictionary *dict = [[NSDictionary alloc] init];
    dict = @{@"id":gongdanid,@"type":@"2"};
    
    NSLog(@"dict--%@",dict);
    [manager POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        WBLog(@"location--%@--%@",[responseObject class],responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"failure--%@",error);
    }];
}
#pragma mark - 支付预付款
-(void)zhiFuAction{
    orderDetailModel *model = _dataSourceArr[0];
    NSString *str = model.entry_fee;
    NSArray *array = [str componentsSeparatedByString:@"."]; //从字符.中分隔成2个元素的数组
     SpecialAlertView *fuKuan = [[SpecialAlertView alloc]initWithMessageTitle:@"您需要支付预付费用" messageString:[NSString stringWithFormat:@"¥%@.",array[0]] messageString1:array[1]  sureBtnTitle:@"立即支付" sureBtnColor:[UIColor blueColor]];
    [fuKuan withSureClick:^(NSString *string) {
        AllPayViewController *allpay = [[AllPayViewController alloc] init];
        allpay.order_id = model.id;
        allpay.type = @"wuyegongdanfukuan";
        allpay.rukoubiaoshi = @"wuyegongdanfukuan";
        allpay.price = model.entry_fee;
        allpay.prepay = @"1";//预付款
        allpay.prepayrukou = @"0";//1订单详情进入订单中心进入，0代表下单进入
        [self.navigationController pushViewController:allpay animated:YES];
    }];
}
#pragma mark - 付款
-(void)rightBtn2Clicked{
    orderDetailModel *model = _dataSourceArr[0];
    NSString *str = [NSString stringWithFormat:@"%.2f",[model.total_fee floatValue]-[model.entry_fee floatValue]];
    NSArray *array = [str componentsSeparatedByString:@"."]; //从字符.中分隔成2个元素的数组
    SpecialAlertView *fuKuan = [[SpecialAlertView alloc]initWithMessageTitle:@"付款金额" messageString:[NSString stringWithFormat:@"¥%@.",array[0]] messageString1:array[1] messageString2:[NSString stringWithFormat:@"已扣除预付费用%@元",model.entry_fee]  messageString3:@"温馨提示" messageString4:@"请确认服务完成后再付款" sureBtnTitle:@"确定" sureBtnColor:[UIColor blueColor]];
    WBLog(@"%@--%@",array[0],array[1]);
    [fuKuan withSureClick:^(NSString *string) {
        
        AllPayViewController *allpay = [[AllPayViewController alloc] init];
        allpay.order_id = model.id;
        allpay.type = @"wuyegongdanfukuan";
        allpay.rukoubiaoshi = @"wuyegongdanfukuan";
        allpay.price = [NSString stringWithFormat:@"%f",[model.total_fee floatValue]-[model.entry_fee floatValue]];
        allpay.prepayrukou = @"1";
        [self.navigationController pushViewController:allpay animated:YES];
    }];
}
#pragma mark - 评价
-(void)rightBtn3Clicked{
    orderDetailModel *model = _dataSourceArr[0];
    evaluateViewController *pjVC = [[evaluateViewController alloc]init];
    pjVC.orderID = model.id;
    [self.navigationController pushViewController:pjVC animated:YES];
}
#pragma mark - 图片点击
- (void)browerImage:(UITapGestureRecognizer *)tap
{
    XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithImages:_cArr currentImageIndex:tap.view.tag];
    browser.browserStyle = XLPhotoBrowserStylePageControl;
}
- (void)browerImage1:(UITapGestureRecognizer *)tap1
{
    XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithImages:_rArr currentImageIndex:tap1.view.tag];
    browser.browserStyle = XLPhotoBrowserStylePageControl;
}
#pragma mark 获得文字高度
-(float)getContactHeight:(NSString*)contact
{
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:13]};
    CGSize maxSize = CGSizeMake(Main_width-100, MAXFLOAT);
    
    // 计算文字占据的高度
    CGSize size = [contact boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    
    
    return size.height;
    
}
@end
