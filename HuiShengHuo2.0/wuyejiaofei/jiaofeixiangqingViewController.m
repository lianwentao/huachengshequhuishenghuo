//
//  jiaofeixiangqingViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/8/23.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "jiaofeixiangqingViewController.h"
#import <AFNetworking.h>
#import "newsuerViewController.h"
#import "MBProgressHUD+TVAssistant.h"
@interface jiaofeixiangqingViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_TableView;
    
    NSDictionary *wuyeDic;
    NSDictionary *dianfeiDic;
    NSDictionary *shuifeiDic;
    NSDictionary *roominfodic;
    
    NSString *is_available;
    NSString *is_available_cn;
    NSString *is_property;
    NSString *is_property_cn;
    
    UIButton *_tmpBtn;
    UIView *shuiview;
    UIView *dianview;
    UIView *wuyeview;
    UITextField *shuitextfield;
    UITextField *diantextfield;
    
    UILabel *amountlabel;

    MBProgressHUD *_HUD;
    UIView *nodataview;
    
    NSString *jieyustring;
}

@end

@implementation jiaofeixiangqingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([_biaoshi isEqualToString:@"1"]) {
        //得到当前视图控制器中的所有控制器
        NSMutableArray *array = [self.navigationController.viewControllers mutableCopy];
        //把B从里面删除
        [array removeObjectAtIndex:2];
        //把删除后的控制器数组再次赋值
        [self.navigationController setViewControllers:[array copy] animated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shuaxinmyhome" object:nil userInfo:nil];
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"缴费";
    
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [[self view] addGestureRecognizer:recognizer];
    

    [self GeneralButtonAction];

    //[self createtableview];
    // Do any additional setup after loading the view.
}
- (void)GeneralButtonAction{
    
    
    
    
    //初始化进度框，置于当前的View当中
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    
    //如果设置此属性则当前的view置于后台
    //_HUD.dimBackground = YES;
    
    //设置对话框文字
    _HUD.labelText = @"加载中,请稍后...";
    _HUD.labelFont = [UIFont systemFontOfSize:14];
    //细节文字
    //_HUD.detailsLabelText = @"请耐心等待";
    
    //显示对话框
    [_HUD showAnimated:YES whileExecutingBlock:^{
        //对话框显示时需要执行的操作
        
        wuyeDic = [[NSDictionary alloc] init];
        dianfeiDic = [[NSDictionary alloc] init];
        shuifeiDic = [[NSDictionary alloc] init];
        roominfodic = [[NSDictionary alloc] init];
        //1.创建会话管理者
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        //2.封装参数
        NSDictionary *dict = nil;
        NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
        dict = @{@"room_id":_room_id,@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"]};
        WBLog(@"*******%@",dict);
//        NSString *strurl = [API stringByAppendingString:@"property/get_room_bill"];
        NSString *strurl = [NSString stringWithFormat:@"%@%@",API,@"property/get_room_bill"];
        [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSLog(@"--%@--%@---%@--%@",strurl,dict,[responseObject objectForKey:@"msg"],responseObject);
            if ([[responseObject objectForKey:@"status"] integerValue]==1) {
                wuyeDic = [[responseObject objectForKey:@"data"] objectForKey:@"wuye"];
                dianfeiDic = [[responseObject objectForKey:@"data"] objectForKey:@"dianfei"];
                shuifeiDic = [[responseObject objectForKey:@"data"] objectForKey:@"shuifei"];
                roominfodic = [[responseObject objectForKey:@"data"] objectForKey:@"room_info"];
                is_available = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"is_available"]];
                is_available_cn = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"is_available_cn"]];
                is_property = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"is_property"]];
                is_property_cn = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"is_property_cn"]];
                [self createUI];
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"failure--%@",error);
        }];
    }// 在HUD被隐藏后的回调
       completionBlock:^{
           //操作执行完后取消对话框
           [_HUD removeFromSuperview];
           _HUD = nil;
       }];
}
- (void)createUI
{
    UIView *botomview = [[UIView alloc] initWithFrame:CGRectMake(0, Main_Height-55, Main_width, 55)];
    botomview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:botomview];
    
    amountlabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, Main_width/3*2, 30)];
    if (![wuyeDic isKindOfClass:[NSDictionary class]]) {
        amountlabel.text = [NSString stringWithFormat:@"总额:%@元",@"0"];
    }else{
        amountlabel.text = [NSString stringWithFormat:@"总额:%@元",[wuyeDic objectForKey:@"tot_sumvalue"]];
    }
    amountlabel.font = font15;
    amountlabel.textColor = QIColor;
    [botomview addSubview:amountlabel];
    
    UIButton *jiaofeibut = [UIButton buttonWithType:UIButtonTypeCustom];
    jiaofeibut.frame = CGRectMake(Main_width-50-12, 10, 50, 30);
    [jiaofeibut setTitle:@"缴费" forState:UIControlStateNormal];
    jiaofeibut.backgroundColor = [UIColor colorWithRed:255/255.0 green:92/255.0 blue:34/255.0 alpha:1];
    [jiaofeibut.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [jiaofeibut addTarget:self action:@selector(suer) forControlEvents:UIControlEventTouchUpInside];
    [botomview addSubview:jiaofeibut];
    
    UIScrollView *scrolloview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, RECTSTATUS.size.height+44, Main_width, Main_Height-55-RECTSTATUS.size.height-44)];
    scrolloview.backgroundColor = BackColor;
    scrolloview.bounces = YES;
    scrolloview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [self.view addSubview:scrolloview];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, Main_width, 49)];
    label2.text = [NSString stringWithFormat:@"  %@",[roominfodic objectForKey:@"address"]];
    label2.backgroundColor = [UIColor whiteColor];
    label2.font = font15;
    [scrolloview addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 59+10, Main_width, 49)];
    label3.text = [NSString stringWithFormat:@"  %@",[roominfodic objectForKey:@"fullname"]];
    label3.backgroundColor = [UIColor whiteColor];
    label3.font = font15;
    [scrolloview addSubview:label3];
    
    if ([_is_ym isEqualToString:@"1"]) {
        NSArray *arr  = [[NSArray alloc] init];
        arr = @[@"ic_property",@"ic_water",@"ic_elec"];
        
        NSArray *arr1 = [[NSArray alloc] init];
        arr1 = @[@"物业费",@"水费",@"电费"];
        
        UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(0, label3.frame.origin.y+label3.frame.size.height+10, Main_width, 55)];
        backview.backgroundColor = [UIColor whiteColor];
        [scrolloview addSubview:backview];
        for (int i=0; i<3; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(111*i, 0, 110, 55);
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitle:[arr1 objectAtIndex:i] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:[arr objectAtIndex:i]] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:QIColor forState:UIControlStateSelected];
            button.tag = i;
            [button addTarget:self action:@selector(selectzhonglei:) forControlEvents:UIControlEventTouchUpInside];
            [backview addSubview:button];
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(-1+111*i, 13, 1, 30)];
            view.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
            [backview addSubview:view];
            
            if (i==0) {
                button.selected = YES;
                _tmpBtn = button;
            }
        }
        
        shuiview = [[UIView alloc] initWithFrame:CGRectMake(0, backview.frame.size.height+backview.frame.origin.y+15, Main_width, 125)];
        shuiview.backgroundColor = [UIColor whiteColor];
        [scrolloview addSubview:shuiview];
        
        shuiview.hidden = YES;
        
        UILabel *shuilabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 20, 150, 20)];
        shuilabel.text = @"水费";
        shuilabel.font = font18;
        [shuiview addSubview:shuilabel];
        
        UILabel *shengyushuifei = [[UILabel alloc] initWithFrame:CGRectMake(Main_width/2, 20, Main_width/2-12, 15)];
        if (![shuifeiDic isKindOfClass:[NSDictionary class]]) {
            shengyushuifei.text = [NSString stringWithFormat:@"余额：¥%@",@"0"];
        }else{
            shengyushuifei.text = [NSString stringWithFormat:@"余额：¥%@",[[shuifeiDic objectForKey:@"info"] objectForKey:@"SMay_acc"]];
        }
        
        shengyushuifei.font = font15;
        shengyushuifei.textAlignment = NSTextAlignmentRight;
        [shuiview addSubview:shengyushuifei];
        
        UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(10, 47, Main_width-20, 1)];
        lineview.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
        [shuiview addSubview:lineview];
        
        UILabel *labelshuifei = [[UILabel alloc] initWithFrame:CGRectMake(10, lineview.frame.size.height+lineview.frame.origin.y+30, 70, 15)];
        labelshuifei.text = @"水费充值:";
        labelshuifei.font = font15;
        [shuiview addSubview:labelshuifei];
        
        shuitextfield = [[UITextField alloc] initWithFrame:CGRectMake(80+10, lineview.frame.size.height+lineview.frame.origin.y+16, 180, 40)];
        //shuitextfield.keyboardType = UIKeyboardTypeNumberPad;
        shuitextfield.delegate = self;
        shuitextfield.layer.borderWidth = 1;
        shuitextfield.placeholder = @"请输出充值金额";
        shuitextfield.tag = 1000;
        shuitextfield.layer.borderColor = [UIColor colorWithRed:212/255.0 green:212/255.0 blue:212/255.0 alpha:1].CGColor;
        [shuiview addSubview:shuitextfield];
        
        [shuitextfield addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        
        dianview = [[UIView alloc] initWithFrame:CGRectMake(0, backview.frame.size.height+backview.frame.origin.y+15, Main_width, 125)];
        dianview.backgroundColor = [UIColor whiteColor];
        [scrolloview addSubview:dianview];
        dianview.hidden = YES;
        
        UILabel *dianlabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 20, 150, 20)];
        dianlabel.text = @"电费";
        dianlabel.font = font18;
        [dianview addSubview:dianlabel];
        
        UILabel *shengyudianfei = [[UILabel alloc] initWithFrame:CGRectMake(Main_width/2, 20, Main_width/2-12, 15)];
        if (![dianfeiDic isKindOfClass:[NSDictionary class]]) {
            shengyudianfei.text = [NSString stringWithFormat:@"余额：¥%@",@"0"];
        }else{
            shengyudianfei.text = [NSString stringWithFormat:@"余额：¥%@",[[dianfeiDic objectForKey:@"info"] objectForKey:@"DMay_acc"]];
        }
        
        shengyudianfei.font = font15;
        shengyudianfei.textAlignment = NSTextAlignmentRight;
        [dianview addSubview:shengyudianfei];
        
        UIView *lineview1 = [[UIView alloc] initWithFrame:CGRectMake(10, 47, Main_width-20, 1)];
        lineview1.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
        [dianview addSubview:lineview1];
        
        UILabel *labeldianfei = [[UILabel alloc] initWithFrame:CGRectMake(10, lineview1.frame.size.height+lineview1.frame.origin.y+30, 70, 15)];
        labeldianfei.text = @"电费充值:";
        labeldianfei.font = font15;
        [dianview addSubview:labeldianfei];
        
        diantextfield = [[UITextField alloc] initWithFrame:CGRectMake(80+10, lineview1.frame.size.height+lineview1.frame.origin.y+16, 180, 40)];
        diantextfield.keyboardType = UIKeyboardTypeNumberPad;
        diantextfield.layer.borderWidth = 1;
        diantextfield.placeholder = @"请输出充值金额";
        diantextfield.tag = 1001;
        [diantextfield addTarget:self action:@selector(textFieldChanged1:) forControlEvents:UIControlEventEditingChanged];
        diantextfield.layer.borderColor = [UIColor colorWithRed:212/255.0 green:212/255.0 blue:212/255.0 alpha:1].CGColor;
        [dianview addSubview:diantextfield];
        
        //    //物业费详情
        if (![wuyeDic isKindOfClass:[NSDictionary class]]) {
            nodataview = [[UIView alloc] initWithFrame:CGRectMake(0, backview.frame.size.height+backview.frame.origin.y+15, Main_width, 150)];
            [scrolloview addSubview:nodataview];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((Main_width-100)/2, 10, 100, 100)];
            imageView.image = [UIImage imageNamed:@"pinglunweikong"];
            [nodataview addSubview:imageView];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((Main_width-300)/2, 110, 300, 40)];
            label.textColor = [UIColor grayColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"暂无数据^_^";
            [nodataview addSubview:label];
        }else{
            NSArray *wuyearr = [wuyeDic objectForKey:@"list"];
            long j=wuyearr.count;
            for (int i = 0; i<wuyearr.count; i++) {
                NSArray *arrlist = [wuyearr objectAtIndex:i];
                j = arrlist.count+j;
            }
            wuyeview = [[UIView alloc] initWithFrame:CGRectMake(0, backview.frame.size.height+backview.frame.origin.y+15, Main_width, j*35)];
            [scrolloview addSubview:wuyeview];
            
            _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_width, j*35)];
            _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            _TableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
            _TableView.scrollEnabled = NO;
            _TableView.delegate = self;
            _TableView.dataSource = self;
            
            [wuyeview addSubview:_TableView];
        }
    }else{
        NSArray *arr  = [[NSArray alloc] init];
        arr = @[@"ic_property"];
        
        NSArray *arr1 = [[NSArray alloc] init];
        arr1 = @[@"物业费"];
        
        UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(0, label3.frame.origin.y+label3.frame.size.height+10, Main_width, 55)];
        backview.backgroundColor = [UIColor whiteColor];
        [scrolloview addSubview:backview];
        for (int i=0; i<1; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(111*i, 0, 110, 55);
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitle:[arr1 objectAtIndex:i] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:[arr objectAtIndex:i]] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:QIColor forState:UIControlStateSelected];
            button.tag = i;
            [button addTarget:self action:@selector(selectzhonglei:) forControlEvents:UIControlEventTouchUpInside];
            [backview addSubview:button];

            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(-1+111*i, 13, 1, 30)];
            view.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
            [backview addSubview:view];
            if (i==0) {
                button.selected = YES;
                _tmpBtn = button;
            }
        }
        
        //    //物业费详情
        if (![wuyeDic isKindOfClass:[NSDictionary class]]) {
            nodataview = [[UIView alloc] initWithFrame:CGRectMake(0, backview.frame.size.height+backview.frame.origin.y+15, Main_width, 150)];
            [scrolloview addSubview:nodataview];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((Main_width-100)/2, 10, 100, 100)];
            imageView.image = [UIImage imageNamed:@"pinglunweikong"];
            [nodataview addSubview:imageView];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((Main_width-300)/2, 110, 300, 40)];
            label.textColor = [UIColor grayColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"暂无数据^_^";
            [nodataview addSubview:label];
        }else{
            NSArray *wuyearr = [wuyeDic objectForKey:@"list"];
            long j=wuyearr.count;
            for (int i = 0; i<wuyearr.count; i++) {
                NSArray *arrlist = [wuyearr objectAtIndex:i];
                j = arrlist.count+j;
            }
            wuyeview = [[UIView alloc] initWithFrame:CGRectMake(0, backview.frame.size.height+backview.frame.origin.y+15, Main_width, j*35)];
            [scrolloview addSubview:wuyeview];
            
            _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_width, j*35)];
            _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            _TableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
            _TableView.scrollEnabled = NO;
            _TableView.delegate = self;
            _TableView.dataSource = self;
            
            [wuyeview addSubview:_TableView];
        }
    }
    
}
#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *wuyearr = [wuyeDic objectForKey:@"list"];
    NSArray *arr = [wuyearr objectAtIndex:section];
    return arr.count+1;
}

// 分组的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSArray *wuyearr = [wuyeDic objectForKey:@"list"];
    return wuyearr.count;
}
//headview的高度和内容
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"   ";
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"  ";
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
//        cell.userInteractionEnabled = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
    }
    NSArray *wuyearr = [wuyeDic objectForKey:@"list"];
    NSArray *arr = [wuyearr objectAtIndex:indexPath.section];
    if (indexPath.row==0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, Main_width-20, 35)];
        label.text = [[arr objectAtIndex:indexPath.row] objectForKey:@"charge_type"];
        label.font = font18;
        [cell.contentView addSubview:label];
    }else{
        
        
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, Main_width/2, 35)];
        NSLog(@"%@",[[[arr objectAtIndex:indexPath.row-1] objectForKey:@"startdate"] class]);
        if ([[[arr objectAtIndex:indexPath.row-1] objectForKey:@"startdate"] isKindOfClass:[NSNull class]]||[[[arr objectAtIndex:indexPath.row-1] objectForKey:@"startdate"] isEqualToString:@""]) {
            NSTimeInterval interval    =[[[arr objectAtIndex:indexPath.row-1] objectForKey:@"bill_time"] doubleValue];
            NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *dateString       = [formatter stringFromDate: date];
            label1.text = dateString;
        }else{
            NSTimeInterval interval    =[[[arr objectAtIndex:indexPath.row-1] objectForKey:@"startdate"] doubleValue];
            NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *dateString       = [formatter stringFromDate: date];
            
            NSTimeInterval interval1    =[[[arr objectAtIndex:indexPath.row-1] objectForKey:@"enddate"] doubleValue];
            NSDate *date1               = [NSDate dateWithTimeIntervalSince1970:interval1];
            
            NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
            [formatter1 setDateFormat:@"yyyy-MM-dd"];
            NSString *dateString1       = [formatter stringFromDate: date1];
            label1.text = [NSString stringWithFormat:@"%@/%@",dateString,dateString1];
        }
        
        label1.font = font15;
        [cell.contentView addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(Main_width/2, 0, Main_width/2-10, 35)];
        label2.font = font15;
        label2.textAlignment = NSTextAlignmentRight;
        label2.text = [[arr objectAtIndex:indexPath.row-1] objectForKey:@"sumvalue"];
        [cell.contentView addSubview:label2];
    }
    return cell;
}
- (void)textFieldChanged:(UITextField*)textField{
    amountlabel.text = [NSString stringWithFormat:@"总额:%@元",shuitextfield.text];
}
- (void)textFieldChanged1:(UITextField*)textField{
    amountlabel.text = [NSString stringWithFormat:@"总额:%@元",diantextfield.text];
}
#pragma  mark - textField delegate
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"点击空白");
    [shuitextfield endEditing:YES];
}
//点击空白处的手势要实现的方法
-(void)viewTapped:(UISwipeGestureRecognizer *)recognizer
{
    UITextField * field3=(UITextField *)[self.view viewWithTag:1000];
    UITextField *firld =(UITextField *)[self.view viewWithTag:1001];
    if(recognizer.direction==UISwipeGestureRecognizerDirectionDown) {
        
        
        
        NSLog(@"swipe down");
        
        
        [field3 resignFirstResponder];
        [firld resignFirstResponder];
    }
}
- (void)selectzhonglei:(UIButton *)sender
{
    if (_tmpBtn == nil){
        sender.selected = YES;
        _tmpBtn = sender;
    }
    else if (_tmpBtn !=nil && _tmpBtn == sender){
        sender.selected = YES;
    }
    else if (_tmpBtn!= sender && _tmpBtn!=nil){
        _tmpBtn.selected = NO;
        sender.selected = YES;
        _tmpBtn = sender;
    }
    
    if (_tmpBtn == nil){
        shuiview.hidden = YES;
        dianview.hidden = YES;
    }else{
        if (_tmpBtn.tag == 1){
            shuiview.hidden = NO;
            dianview.hidden = YES;
            wuyeview.hidden = YES;
            nodataview.hidden = YES;
            if ([shuitextfield.text isEqualToString:@""]) {
                amountlabel.text = [NSString stringWithFormat:@"总额:%@元",@"0"];
            }else{
                amountlabel.text = [NSString stringWithFormat:@"总额:%@元",shuitextfield.text];
            }
        }else if (_tmpBtn.tag == 2){
            shuiview.hidden = YES;
            dianview.hidden = NO;
            wuyeview.hidden = YES;
            nodataview.hidden = YES;
            if ([diantextfield.text isEqualToString:@""]) {
                amountlabel.text = [NSString stringWithFormat:@"总额:%@元",@"0"];
            }else{
                amountlabel.text = [NSString stringWithFormat:@"总额:%@元",diantextfield.text];
            }
        }else{
            shuiview.hidden = YES;
            dianview.hidden = YES;
            wuyeview.hidden = NO;
            
            if (![wuyeDic isKindOfClass:[NSDictionary class]]){
                amountlabel.text = [NSString stringWithFormat:@"总额:%@元",@"0"];
                nodataview.hidden = NO;
            }else{
                amountlabel.text = [NSString stringWithFormat:@"总额:%@元",[wuyeDic objectForKey:@"tot_sumvalue"]];
            }
            
        }
    }
}
- (void)suer
{
    if ([is_available isEqualToString:@"1"]) {
        [MBProgressHUD showToastToView:self.view withText:is_available_cn];
    }else if (_tmpBtn.tag!=0&&[wuyeDic isKindOfClass:[NSDictionary class]]) {
        [MBProgressHUD showToastToView:self.view withText:@"请先缴清物业费"];
    }else{
        
        NSString *string = @"";
        if (_tmpBtn.tag == 0) {
            if ([is_property isEqualToString:@"0"]) {
                [MBProgressHUD showToastToView:self.view withText:is_property_cn];
            }else{
                NSArray *arr = [wuyeDic objectForKey:@"list"];
                
                for (int i = 0; i<arr.count; i++) {
                    NSArray *arr1 = [arr objectAtIndex:i];
                    for (int j = 0; j<arr1.count; j++) {
                        string = [NSString stringWithFormat:@"%@%@",string,[NSString stringWithFormat:@",%@",[[arr1 objectAtIndex:j] objectForKey:@"bill_id"]]];
                    }
                }
                NSLog(@"string--%@",[string substringFromIndex:1]);
                //property/make_property_order
                //1.创建会话管理者
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
                //2.封装参数
                NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
                NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[userinfo objectForKey:@"uid"],[userinfo objectForKey:@"username"]]];
                NSDictionary *dict = @{@"room_id":[roominfodic objectForKey:@"room_id"],@"bill_id":[string substringFromIndex:1],@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"]};
                NSString *strurl = [API stringByAppendingString:@"property/make_property_order"];
                [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSLog(@"success==%@==%@",[responseObject objectForKey:@"msg"],responseObject);
                    //_Dic = [[NSMutableDictionary alloc] init];
                    if ([[responseObject objectForKey:@"status"] integerValue]==1) {
                        newsuerViewController *newsuer = [[newsuerViewController alloc] init];
                        newsuer.DataDic = [responseObject objectForKey:@"data"];
                        newsuer.biaoshi = @"1";
                        [self.navigationController pushViewController:newsuer animated:YES];
                    }else{
                        
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"failure--%@",error);
                }];
            }
        }else{
            NSString *jieyu;
            NSString *type;
            NSString *amount;
            NSString *type_cn;
            
            if (_tmpBtn.tag == 1) {
                jieyu = [NSString stringWithFormat:@"%@",[[shuifeiDic objectForKey:@"info"] objectForKey:@"SMay_acc"]];
                type = [shuifeiDic objectForKey:@"type"];
                amount = shuitextfield.text;
                type_cn = [shuifeiDic objectForKey:@"type_cn"];
                float upper_limit = [[[shuifeiDic objectForKey:@"upper_limit"] objectForKey:@"info"] floatValue];
                float j = [shuitextfield.text floatValue];
                float i = [jieyu floatValue] + j;
                float shengyu = upper_limit - [jieyu floatValue];
                
                if (shuitextfield.text.length == 0) {
                    [MBProgressHUD showToastToView:self.view withText:@"请输入缴费金额"];
                }else if (j<=0) {
                    [MBProgressHUD showToastToView:self.view withText:@"金额必须大于0"];
                }else if (i>upper_limit){
                    [MBProgressHUD showToastToView:self.view withText:[NSString stringWithFormat:@"您剩余缴费金额上限为:%.2f元",shengyu]];
                } else{
                    //1.创建会话管理者
                    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
                    //2.封装参数
                    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
                    NSDictionary *dict = @{@"room_id":[roominfodic objectForKey:@"room_id"],@"category_id":type,@"category_name":type_cn,@"amount":amount,@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"]};
                    NSString *strurl = [API stringByAppendingString:@"property/create_order"];
                    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        NSLog(@"success==%@==%@",[responseObject objectForKey:@"msg"],responseObject);
                        //_Dic = [[NSMutableDictionary alloc] init];
                        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
                            newsuerViewController *newsuer = [[newsuerViewController alloc] init];
                            newsuer.DataDic = [responseObject objectForKey:@"data"];
                            newsuer.biaoshi = @"2";
                            [self.navigationController pushViewController:newsuer animated:YES];
                        }else{
                            
                        }
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        NSLog(@"failure--%@",error);
                    }];
                }
            }else{
                jieyu = [NSString stringWithFormat:@"%@",[[dianfeiDic objectForKey:@"info"] objectForKey:@"DMay_acc"]];
                type = [dianfeiDic objectForKey:@"type"];
                amount = diantextfield.text;
                amount = diantextfield.text;
                type_cn = [dianfeiDic objectForKey:@"type_cn"];
                
                float upper_limit = [[[dianfeiDic objectForKey:@"upper_limit"] objectForKey:@"info"] floatValue];
                float j = [diantextfield.text floatValue];
                float i = [jieyu floatValue] + j;
                float shengyu = upper_limit - [jieyu floatValue];
                
                if (diantextfield.text.length == 0) {
                    [MBProgressHUD showToastToView:self.view withText:@"请输入缴费金额"];
                }else if (j<=0) {
                    [MBProgressHUD showToastToView:self.view withText:@"金额必须大于0"];
                }else if (i>upper_limit){
                    [MBProgressHUD showToastToView:self.view withText:[NSString stringWithFormat:@"您剩余缴费金额上限为:%.2f元",shengyu]];
                } else{
                    //1.创建会话管理者
                    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
                    //2.封装参数
                    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
                    NSDictionary *dict = @{@"room_id":[roominfodic objectForKey:@"room_id"],@"category_id":type,@"category_name":type_cn,@"amount":amount,@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"]};
                    NSString *strurl = [API stringByAppendingString:@"property/create_order"];
                    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        NSLog(@"success==%@==%@",[responseObject objectForKey:@"msg"],responseObject);
                        //_Dic = [[NSMutableDictionary alloc] init];
                        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
                            newsuerViewController *newsuer = [[newsuerViewController alloc] init];
                            newsuer.DataDic = [responseObject objectForKey:@"data"];
                            newsuer.biaoshi = @"2";
                            [self.navigationController pushViewController:newsuer animated:YES];
                        }else{
                            
                        }
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        NSLog(@"failure--%@",error);
                    }];
                }
            }
        }
    }
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
