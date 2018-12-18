//
//  SuredingdanViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/11/27.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import "SuredingdanViewController.h"
#import "AllPayViewController.h"
#import <AFNetworking.h>
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+TVAssistant.h"
#import "youhuiquanViewController.h"
#import "AdressViewController.h"
#import "UIViewController+BackButtonHandler.h"
#import "PrefixHeader.pch"
#import "GoodsDetailViewController.h"
#define screen_Width [UIScreen mainScreen].bounds.size.width
#define screen_Height [UIScreen mainScreen].bounds.size.height
@interface SuredingdanViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UITextFieldDelegate,UIPopoverBackgroundViewMethods>
{
    UITableView *_TableView;
    NSMutableArray *_DataArr;
    NSDictionary *Dict;
    
    UILabel *Youhuiquanlabel;
    UILabel *labelname;
    UILabel *labelcontent;
    UILabel *labelamuots;
    
    NSString *_name;
    NSString *_phone;
    NSString *_addressid;
    
    UITextField *textfield;
    
    UIButton *but;
    
    NSArray *_Arr;
    
    UISwitch *_Switch;
    
    NSString *amountprice;
    NSString *_youhuiquanname;
    NSString *_youhuiquanid;
    
    CGFloat height;
}

@end

@implementation SuredingdanViewController
- (void)viewDidLayoutSubviews{
    CGFloat phoneVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (phoneVersion >= 11.0) {
        height = self.view.safeAreaInsets.bottom;
    }else{
        height = 0;
    }
    WBLog(@"h = %lf",height);
    [self createbottomview];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认订单";
    amountprice = @"0.00";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _Arr = [[NSArray alloc] init];
    _Arr = [_Dic objectForKey:@"pro_data"];
    
    _name = [_Dic objectForKey:@"contact"];
    _phone = [_Dic objectForKey:@"mobile"];
    _addressid = [_Dic objectForKey:@"address_id"];
    NSLog(@"%@",_Dic);
    [self createtableview];
    [self createbottomview];
    
    
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    // Do any additional setup after loading the view.
}
//- (BOOL)navigationShouldPopOnBackButton{
////    UIViewController *viewc = self.navigationController.viewControllers[1];
////    [self.navigationController popToViewController:viewc animated:YES];
//
//    for (UIViewController *controller in self.navigationController.viewControllers) {
//        if ([controller isKindOfClass:[GoodsDetailViewController class]]) {
//            [self.navigationController popToViewController:controller animated:YES];
//        }
//    }
//    return YES;
//}
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    NSLog(@"%d",height);
    _TableView.frame = CGRectMake(0, -height+(screen_Height-64-440), screen_Width, screen_Height-64);
}
#pragma  mark - textField delegate
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"点击空白");
    [textfield resignFirstResponder];
}
//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    _TableView.frame = CGRectMake(0, 0, screen_Width, screen_Height-64);
}
- (void)createtableview
{
    _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_Width, screen_Height-64-height)];
    _TableView.delegate = self;
    _TableView.bounces = NO;
    _TableView.dataSource = self;
    [self.view addSubview:_TableView];
}
- (void)createbottomview
{
    UIView *bottomview = [[UIView alloc] initWithFrame:CGRectMake(0, screen_Height-64-height, screen_Width, 64)];
    bottomview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomview];
    
    labelamuots = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, screen_Width/3*2-35, 44)];
    float price = [[_Dic objectForKey:@"amount"] floatValue];
    labelamuots.text = [NSString stringWithFormat:@"实付款:¥%.2f",price];
    [bottomview addSubview:labelamuots];
    
    UIButton *tijiao = [UIButton buttonWithType:UIButtonTypeCustom];
    tijiao.frame = CGRectMake(screen_Width/3*2-20, 10, screen_Width/3, 44);
    tijiao.layer.cornerRadius = 5;
    [tijiao setTitle:@"提交订单" forState:UIControlStateNormal];
    [tijiao setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    tijiao.backgroundColor = QIColor;
    [tijiao addTarget:self action:@selector(tijiaodingdan) forControlEvents:UIControlEventTouchUpInside];
    [bottomview addSubview:tijiao];
}
#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==1) {
        return _Arr.count;
    }else{
        return 1;
    }
}

// 分组的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    // 从重用队列里查找可重用的cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 判断如果没有可以重用的cell，创建
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section==0) {
        labelname = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, screen_Width-40, 40)];
        labelname.font = [UIFont systemFontOfSize:18];
        [cell.contentView addSubview:labelname];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        if ([[_Dic objectForKey:@"address"] isKindOfClass:[NSNull class]]||[[_Dic objectForKey:@"address"] isEqualToString:@""]){
            //labelname.text = @"选择一个地址";
            
            labelcontent = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, screen_Width-40-5, 60)];
            labelcontent.numberOfLines = 2;
            labelcontent.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:labelcontent];
            //labelcontent.text = @"选择一个地址";
            
            but = [UIButton buttonWithType:UIButtonTypeCustom];
            but.frame = CGRectMake(20, 0, screen_Width-40, 110);
            but.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@"请选择一个地址"];
            
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            attch.image = [UIImage imageNamed:@"iv_address"];
            attch.bounds = CGRectMake(0, -5, 25, 25);
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
            [attri insertAttributedString:string atIndex:0];
            [but setAttributedTitle:attri forState:UIControlStateNormal];
            [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [cell.contentView addSubview:but];
            [but addTarget:self action:@selector(seleectaddress) forControlEvents:UIControlEventTouchUpInside];
            tableView.rowHeight = 110;
        }else{
            NSString *string1 = [NSString stringWithFormat:@"%@  %@",[_Dic objectForKey:@"contact"],[_Dic objectForKey:@"mobile"]];
            labelname.text = string1;
            
            labelcontent = [[UILabel alloc] initWithFrame:CGRectMake(20, 55, screen_Width-40-5, 0)];
            labelcontent.numberOfLines = 0;
            labelcontent.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:labelcontent];
            labelcontent.text = [_Dic objectForKey:@"address"];
            CGSize size = [labelcontent sizeThatFits:CGSizeMake(labelcontent.frame.size.width, MAXFLOAT)];
            labelcontent.frame = CGRectMake(labelcontent.frame.origin.x, labelcontent.frame.origin.y, labelcontent.frame.size.width,            size.height);
            tableView.rowHeight = size.height+60;
            UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
            but.frame = CGRectMake(0, 0, screen_Width, size.height+60);
            [cell.contentView addSubview:but];
            [but addTarget:self action:@selector(seleectaddress) forControlEvents:UIControlEventTouchUpInside];
        }
    }else if (indexPath.section==1){
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, screen_Width-20, 40)];
        label1.text = [[_Arr objectAtIndex:indexPath.row] objectForKey:@"merchant_name"];
        [cell.contentView addSubview:label1];
        
        NSArray *arr = [[_Arr objectAtIndex:indexPath.row] objectForKey:@"img"];
        for (int i=0; i<arr.count; i++) {
            NSString *string = [[arr objectAtIndex:i] objectForKey:@"one_img"];
            NSString *strurl = [API_img stringByAppendingString:string];
            UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10+85*i, 55, 80, 80)];
            [imageview sd_setImageWithURL:[NSURL URLWithString: strurl]];
            [cell.contentView addSubview:imageview];
        }
        UILabel *num = [[UILabel alloc] initWithFrame:CGRectMake(screen_Width-100, 50, 90, 30)];
        num.text = [NSString stringWithFormat:@"件数:X%@",[[_Arr objectAtIndex:indexPath.row] objectForKey:@"number"]];
        [cell.contentView addSubview:num];
        UILabel *shigouziti = [[UILabel alloc] initWithFrame:CGRectMake(screen_Width-100, 80, 90, 20)];
        shigouziti.text = @"是否自提";
        [cell.contentView addSubview:shigouziti];
        
        _Switch = [[UISwitch alloc] initWithFrame:CGRectMake(screen_Width-100, 105, 0, 0)];
        [cell.contentView addSubview:_Switch];
        _Switch.tag = indexPath.row;
        //定制开关颜色UI
        //tintColor 关状态下的背景颜色
        //_Switch.tintColor = [UIColor redColor];
//        //onTintColor 开状态下的背景颜色
        _Switch.onTintColor = [UIColor redColor];
//        //thumbTintColor 滑块的背景颜色
//        _Switch.thumbTintColor = [UIColor blueColor];
        
        tableView.rowHeight = 140;
    }else if (indexPath.section==2){
        tableView.rowHeight = 50;
        cell.textLabel.text = @"配送费";
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(screen_Width/2-20, 10, screen_Width/2, 40)];
        label.text = [NSString stringWithFormat:@"¥%@",[_Dic objectForKey:@"send_amount"]];
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:label];
    }else if (indexPath.section==3){
        tableView.rowHeight = 50;
        cell.textLabel.text = @"优惠券";
        Youhuiquanlabel = [[UILabel alloc] initWithFrame:CGRectMake(screen_Width/2-10, 10, screen_Width/2, 40)];
        
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame =CGRectMake(screen_Width/2-10, 0, screen_Width/2, 50);
        [but addTarget:self action:@selector(selecteyouhuiquan) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:but];
        NSString *youhui = [NSString stringWithFormat:@"%@",[_Dic objectForKey:@"is_coupon"]];
        if([youhui isEqualToString:@"1"]){
            Youhuiquanlabel.text = @"选择使用优惠券";
            but.userInteractionEnabled = YES;
        }else{
            but.userInteractionEnabled = NO;
            Youhuiquanlabel.text = @"暂无可用";
        }
        Youhuiquanlabel.font = [UIFont systemFontOfSize:13];
        Youhuiquanlabel.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:Youhuiquanlabel];
    }else if (indexPath.section==4){
        tableView.rowHeight = 50;
        cell.textLabel.text = @"积分";
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(screen_Width/2-10, 10, screen_Width/2, 40)];
        label.text = @"不支持使用积分";
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:label];
        
    }else if (indexPath.section==5){
        tableView.rowHeight = 60;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 40)];
        label.text = @"买家留言:";
        [cell.contentView addSubview:label];
        
        textfield = [[UITextField alloc] initWithFrame:CGRectMake(90, 10, screen_Width-100, 40)];
        textfield.backgroundColor = [UIColor groupTableViewBackgroundColor];
        textfield.placeholder = @"备注留言（选填）";
        textfield.delegate = self;
        textfield.tag = 1000;
        [cell.contentView addSubview:textfield];
        UISwipeGestureRecognizer *recognizer;
        recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
        [[self view] addGestureRecognizer:recognizer];
    }
    return cell;
}
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    
    UITextField * field3=(UITextField *)[self.view viewWithTag:1000];
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionDown) {
        
        NSLog(@"swipe down");
        
        
        [field3 resignFirstResponder];
    }
}
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    NSLog(@"1111111");
//    _TableView.frame = CGRectMake(0, -250, screen_Width, screen_Height-64);
//}
- (void)selecteyouhuiquan
{
    youhuiquanViewController *youhuiquan = [[youhuiquanViewController alloc] init];
    youhuiquan.shiyong = @"1";
    youhuiquan.shop_id_str = [_Dic objectForKey:@"shop_id_str"];
    youhuiquan.amount = [NSString stringWithFormat:@"%@",[_Dic objectForKey:@"amount"]];
    youhuiquan.returnValueBlock = ^(NSString *price,NSString *detail,NSString *youhuiquanid){
        Youhuiquanlabel.text = [NSString stringWithFormat:@"%@%@",price,detail];
        amountprice = price;
        _youhuiquanname = detail;
        _youhuiquanid = youhuiquanid;
        labelamuots.text = [NSString stringWithFormat:@"实付款:¥%.2f",[[_Dic objectForKey:@"amount"] floatValue] - [price floatValue]];
    };
    [self.navigationController pushViewController:youhuiquan animated:YES];
}
- (void)seleectaddress
{
    AdressViewController *address = [[AdressViewController alloc] init];
    
    //赋值Block，并将捕获的值赋值给UILabel
    address.returnValueBlock = ^(NSString *name,NSString *phone,NSString *address,NSString *addressid,NSDictionary *datadic){
        labelcontent.text = address;
        labelname.text = [NSString stringWithFormat:@"%@ %@",name,phone];

        _name = name;
        _phone = phone;
        _addressid = addressid;
        //labelcontent.numberOfLines = 2;
        [but setAttributedTitle:nil forState:UIControlStateNormal];
    };
    address.title = @"选择地址";
    address.yesnoselecte = @"1";
    [self.navigationController pushViewController:address animated:YES];
}
- (void)tijiaodingdan
{
    NSLog(@"tijiao---%@",_name);
    if ([_name isEqualToString:@""]) {
        [MBProgressHUD showToastToView:self.view withText:@"请选择地址信息"];
    }else{
      [self post];
    }
}
#pragma mark ------联网请求---
-(void)post
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSString *idandtype;
    for (int i=0; i<_Arr.count; i++) {
            if (_Switch.on == YES&&_Switch.tag==i) {
                idandtype = [NSString stringWithFormat:@"%@.2",[[_Arr objectAtIndex:i] objectForKey:@"merchant_id"]];
                [arr addObject:idandtype];
            }else{
                idandtype = [NSString stringWithFormat:@"%@.1",[[_Arr objectAtIndex:i] objectForKey:@"merchant_id"]];
                [arr addObject:idandtype];
            }
        
        
    }
    NSString *string;
    string = [arr componentsJoinedByString:@"|"];
    NSLog(@"%@====%@",string,arr);
    NSDictionary *dict = [[NSDictionary alloc] init];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    NSString *is_coupon = [NSString stringWithFormat:@"%@",[_Dic objectForKey:@"is_coupon"]];
    if ([[_Dic objectForKey:@"address"] isEqualToString:@""]) {
        if ([is_coupon isEqualToString:@"0"]) {
            dict = @{@"products":_jsonstring,@"address":labelcontent.text,@"contact":_name,@"mobile":_phone,@"type":string,@"address_id":_addressid,@"apk_token":uid_username,@"description":textfield.text,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
        }else{dict = @{@"products":_jsonstring,@"address":labelcontent.text,@"contact":_name,@"mobile":_phone,@"type":string,@"address_id":_addressid,@"apk_token":uid_username,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"],@"m_c_id":_youhuiquanid,@"m_c_name":_youhuiquanname,@"m_c_amount":amountprice,@"description":textfield.text};}
    }else{
        if ([is_coupon isEqualToString:@"0"]) {
        dict = @{@"products":_jsonstring,@"address":labelcontent.text,@"contact":_name,@"mobile":_phone,@"type":string,@"address_id":_addressid,@"apk_token":uid_username,@"description":textfield.text,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
        }else{
            dict = @{@"products":_jsonstring,@"address":labelcontent.text,@"contact":_name,@"mobile":_phone,@"type":string,@"address_id":_addressid,@"apk_token":uid_username,@"m_c_id":_youhuiquanid,@"m_c_name":_youhuiquanname,@"m_c_amount":amountprice,@"description":textfield.text,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
        }
    }
    NSLog(@"dict===%@",dict);
    NSString *urlstr = [API stringByAppendingString:@"shop/submit_order"];
    [manager POST:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"suredingdan--success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            
            AllPayViewController *allpay = [[AllPayViewController alloc] init];
            allpay.order_id = [[responseObject objectForKey:@"data"] objectForKey:@"order_id"];
            allpay.price = [NSString stringWithFormat:@"%.2f",[[_Dic objectForKey:@"amount"] floatValue] - [amountprice floatValue]];
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"shuaxingouwuche" object:nil userInfo:nil];
            [self.navigationController pushViewController:allpay animated:YES];
        }else{
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
        
        [_TableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
        [MBProgressHUD showToastToView:self.view withText:@"请求失败"];
    }];
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
