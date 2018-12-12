//
//  queRenViewController.m
//  HuiShengHuo2.0
//
//  Created by admin on 2018/11/24.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "queRenViewController.h"
#import "AdressViewController.h"

#import <AFNetworking.h>
#import "MBProgressHUD+TVAssistant.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"

#import "SpecialAlertView.h"
#import "myserviceViewController.h"

@interface queRenViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    UILabel *labelname;
    UILabel *labelcontent;
    UIButton *but;
    
    NSString *_name;
    NSString *_phone;
    NSString *_addressid;
    
    UIImageView *redcountimage;
    NSMutableArray *dataSourceArr;
    NSMutableArray *tagListArr;
    NSMutableArray *scoreInfoArr;
    NSMutableArray *imgListArr;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UITextView *textView;
@property (nonatomic,strong)UILabel *textViewPlaceLable;

@end

@implementation queRenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"确认服务信息";
    [self createTableView];
    [self loadFunctionView];
    
}
-(void)createTableView{
    CGRect frame = CGRectMake(0, 0, Main_width, Main_Height-50);
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    //    _tableView.contentInset = UIEdgeInsetsMake(IMAGE_HEIGHT - [self navBarBottom], 0, 0, 0);
    [self.view addSubview:_tableView];
}
- (BOOL)navigationShouldPopOnBackButton{
    UIViewController *viewc = self.navigationController.viewControllers[self.navigationController.viewControllers.count-1];
    [self.navigationController popToViewController:viewc animated:YES];
    return YES;
}
#pragma mark - tableview delegate / dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 90;
    }else if (indexPath.section == 1){
        return 110;
    }else {
        return 300;
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        cell.userInteractionEnabled = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
    }
    
    if (indexPath.section == 0) {
        
        UILabel *titleLab = [[UILabel alloc]init];
        titleLab.frame = CGRectMake(Main_width/2-40, 10, 80, 30);
        titleLab.text = @"服务项目";
        titleLab.textColor = [UIColor lightGrayColor];
        titleLab.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:titleLab];
        
        UIImageView *leftImg = [[UIImageView alloc]init];
        leftImg.frame = CGRectMake(Main_width/2-90, 25, 50, 2);
        leftImg.image = [UIImage imageNamed:@"fw_left"];
        [cell addSubview:leftImg];
        
        UIImageView *rightImg = [[UIImageView alloc]init];
        rightImg.frame = CGRectMake(Main_width/2+40, 25, 50, 2);
         rightImg.image = [UIImage imageNamed:@"fw_right"];
        [cell addSubview:rightImg];
        
        UIView *bgView = [[UIView alloc]init];
        bgView.frame = CGRectMake(10, CGRectGetMaxY(titleLab.frame), Main_width-20, 50);
        bgView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
        UILabel *xmLab = [[UILabel alloc]init];
        xmLab.frame = CGRectMake(10, 0, (bgView.frame.size.width-20)/2, 60);
        xmLab.text = _serviceStr;
        xmLab.textAlignment = NSTextAlignmentLeft;
        [bgView addSubview:xmLab];
        
        UILabel *priceLab = [[UILabel alloc]init];
        priceLab.frame = CGRectMake((bgView.frame.size.width-20)/2, 0, (bgView.frame.size.width-20)/2, 60);
        priceLab.text = [NSString stringWithFormat:@"￥%@",_priceStr];
        priceLab.textColor = [UIColor lightGrayColor];
        priceLab.textAlignment = NSTextAlignmentRight;
        [bgView addSubview:priceLab];
        
        [cell addSubview:bgView];
    }else if (indexPath.section == 1){
        UILabel *titleLab = [[UILabel alloc]init];
        titleLab.frame = CGRectMake(Main_width/2-40, 10, 80, 30);
        titleLab.text = @"服务地址";
        titleLab.textColor = [UIColor lightGrayColor];
        titleLab.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:titleLab];
        
        UIImageView *leftImg = [[UIImageView alloc]init];
        leftImg.frame = CGRectMake(Main_width/2-90, 25, 50, 2);
        leftImg.image = [UIImage imageNamed:@"fw_left"];
        [cell addSubview:leftImg];
        
        UIImageView *rightImg = [[UIImageView alloc]init];
        rightImg.frame = CGRectMake(Main_width/2+40, 25, 50, 2);
         rightImg.image = [UIImage imageNamed:@"fw_right"];
        [cell addSubview:rightImg];
        
        labelname = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLab.frame), Main_width-40, 40)];
        labelname.font = [UIFont systemFontOfSize:18];
        [cell.contentView addSubview:labelname];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        labelcontent = [[UILabel alloc] initWithFrame:CGRectMake(20, 57, Main_width-40-5, 60)];
        labelcontent.numberOfLines = 2;
        labelcontent.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:labelcontent];
        //labelcontent.text = @"选择一个地址";
        
        but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(20, 0, Main_width-40, 110);
        but.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@"请选择地址"];
        
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        attch.image = [UIImage imageNamed:@"iv_address"];
        attch.bounds = CGRectMake(0, -5, 20, 20);
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
        [attri insertAttributedString:string atIndex:0];
        [but setAttributedTitle:attri forState:UIControlStateNormal];
        [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cell.contentView addSubview:but];
        [but addTarget:self action:@selector(seleectaddress) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        
        UILabel *titleLab = [[UILabel alloc]init];
        titleLab.frame = CGRectMake(Main_width/2-40, 10, 80, 30);
        titleLab.text = @"备注";
        titleLab.textColor = [UIColor lightGrayColor];
        titleLab.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:titleLab];
        
        UIImageView *leftImg = [[UIImageView alloc]init];
        leftImg.frame = CGRectMake(Main_width/2-90, 25, 50, 2);
        leftImg.image = [UIImage imageNamed:@"fw_left"];
        [cell addSubview:leftImg];
        
        UIImageView *rightImg = [[UIImageView alloc]init];
        rightImg.frame = CGRectMake(Main_width/2+40, 25, 50, 2);
        rightImg.image = [UIImage imageNamed:@"fw_right"];
        [cell addSubview:rightImg];
        
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLab.frame), Main_width-20, 180)];
        _textView.autoresizesSubviews = YES;
        _textView.layer.cornerRadius = 5.0;
        //    _textView.layer.borderWidth = 1;
        //    _textView.layer.borderColor = Gray_Line_Interval.CGColor;
        _textView.keyboardType = UIKeyboardTypeDefault;
        _textView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:15];
        [cell addSubview:_textView];
        
        _textViewPlaceLable = [[UILabel alloc]initWithFrame:CGRectMake(3, 10.5, Main_width-20, 15)];
        _textViewPlaceLable.text = @"有什么和师傅说的吗";
        _textViewPlaceLable.textColor = [UIColor lightGrayColor];
        _textViewPlaceLable.font = [UIFont systemFontOfSize:15];
        [_textView addSubview:_textViewPlaceLable];
    }
    
    return cell;
    
}
- (void)seleectaddress{
    
    AdressViewController *address = [[AdressViewController alloc] init];
    
    //赋值Block，并将捕获的值赋值给UILabel
    address.returnValueBlock = ^(NSString *name,NSString *phone,NSString *address,NSString *addressid){
        labelcontent.text = address;
        labelname.text = [NSString stringWithFormat:@"%@ %@",name,phone];
        
        _name = name;
        _phone = phone;
        _addressid = addressid;
        //labelcontent.numberOfLines = 2;
        [but setAttributedTitle:nil forState:UIControlStateNormal];
    };
    address.title = @"选择地址";
    address.yesnoselecte = @"0";
    [self.navigationController pushViewController:address animated:YES];
}
#pragma mark -UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@" "]) {
        return NO;
    }else {
        return YES;
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (_textViewPlaceLable) {
        [_textViewPlaceLable removeFromSuperview];
        _textView.keyboardType = UIKeyboardTypeDefault;
    }
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (textView.text.length <= 0 || [textView.text isEqualToString:@""]) {
        
        _textViewPlaceLable = [[UILabel alloc]initWithFrame:CGRectMake(3, 10.5, Main_width-20, 15)];
        _textViewPlaceLable.text = @"有什么和师傅说的吗";
        _textViewPlaceLable.textColor = [UIColor lightGrayColor];
        _textViewPlaceLable.font = [UIFont systemFontOfSize:15];
        _textView.keyboardType = UIKeyboardTypeDefault;
        [_textView addSubview:_textViewPlaceLable];
        return YES;
    }
    return YES;
}

#pragma mark - 确认下单
- (void)loadFunctionView {
    CGFloat contentY = Main_Height-50;
    UIView *functionView = [[UIView alloc]initWithFrame:CGRectMake(0, contentY, Main_width, 50)];
    functionView.backgroundColor = [UIColor colorWithRed:243/255.0 green:247/255.0 blue:248/255.0 alpha:1];
    
    UIButton *yuYueBtn = [[UIButton alloc]initWithFrame:CGRectMake((Main_width/2)-50, 10, 100, 30)];
    yuYueBtn.backgroundColor = [UIColor colorWithRed:252/255.0 green:88/255.0 blue:48/255.0 alpha:1];
    [yuYueBtn setTitle:@"确认下单" forState:UIControlStateNormal];
    [yuYueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [likeButton setTitleColor:Blue_Selected forState:UIControlStateSelected];
    yuYueBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    //    [likeButton setImage:[UIImage imageNamed:@"icon_praise"] forState:UIControlStateNormal];
    //    [likeButton setImage:[UIImage imageNamed:@"icon_praise_tabbar"] forState:UIControlStateSelected];
    [yuYueBtn addTarget:self action:@selector(yuYueAction:) forControlEvents:UIControlEventTouchUpInside];
    yuYueBtn.layer.cornerRadius = 3.0;
    [functionView addSubview:yuYueBtn];
    [self.view addSubview:functionView];
    
}
-(void)yuYueAction:(UIButton *)sender{
  
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    // 从字符串中过滤掉首尾的空格和换行, 得到一个新的字符串
    NSString *trimmedStr = [labelcontent.text stringByTrimmingCharactersInSet:set];
    // 判断新字符串的长度是否为0
    if (!labelcontent.text || !trimmedStr.length) {
        [MBProgressHUD showToastToView:self.view withText:@"请选择地址"];
    }else{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];

    NSDictionary *dict = [[NSDictionary alloc] init];

    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    dict = @{@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"],@"s_id":_serviceID,@"s_tag_id":_serviceTagID,@"s_tag_cn":_serviceStr,@"price":_priceStr,@"address":labelcontent.text,@"contacts":_name,@"mobile":_phone,@"address_id":_addressid,@"description":_textView.text};
    NSLog(@"dict===%@",dict);

    NSString *urlstr = [API_NOAPK stringByAppendingString:@"/service/service/serviceReserve"];
    [manager POST:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"suredingdan--success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        SpecialAlertView *special = [[SpecialAlertView alloc]initWithTitleImage:@"fw_yycg" messageTitle:@"预约成功" messageString:@"请等待服务商上门服务" sureBtnTitle:@"确定" sureBtnColor:[UIColor blueColor]];
        [special withSureClick:^(NSString *string) {
            myserviceViewController *fwddVC = [[myserviceViewController alloc]init];
            fwddVC.backStr = @"1";//1代表跳回下单界面
            [self.navigationController pushViewController:fwddVC animated:YES];
        }];

        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
        [MBProgressHUD showToastToView:self.view withText:@"请求失败"];
    }];

    }
    
}
@end
