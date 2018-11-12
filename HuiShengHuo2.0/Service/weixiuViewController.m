//
//  weixiuViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/1/3.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "weixiuViewController.h"
#import <AFNetworking.h>
#import "UIImageView+WebCache.h"
#import "WPhotoViewController.h"
#import "HalfCircleActivityIndicatorView.h"
#import "MBProgressHUD+TVAssistant.h"
#import "AdressViewController.h"
#import "PrefixHeader.pch"
#import "XPFPickerView.h"
#import "MBProgressHUD+TVAssistant.h"
#import "fuwudingdanViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "GZActionSheet.h"

#define screen_Width [UIScreen mainScreen].bounds.size.width
#define screen_Height [UIScreen mainScreen].bounds.size.height

@interface weixiuViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_TableView;
    UIButton *_fenleiBut;
    UILabel *_fenleilabel;
    NSMutableArray *_DataArr;
    UITextField *_textField;
    
    UIButton *_AddBut;
    UIButton *_Savebut;
    NSMutableArray *_photosArr;
    UIImageView *imageview;
    
    HalfCircleActivityIndicatorView *LoadingView;
    
    UISwitch *_Switch;
    
    UIView *shiBeiView;
    UIButton *queRenTwoBtn;
    UIButton *queRenBtn;
    
    NSString *pinStr;
    NSString *shiJianPinStr;
    UIDatePicker *shiJiandatePicker;
    UIDatePicker *riQidatePicker;
    
    UILabel *shangmentimelabel;
    
    NSString *_name;
    NSString *_phone;
    NSString *_addressid;
    
    UILabel *labelname;
    UILabel *labelcontent;
    UIButton *selectbut;
    
    XPFPickerView *picker;
    
    NSString *_typeid;
    
    NSString *_weixiuleimuid;
}

@property (strong, nonatomic)  UITextView *textView;
@property (nonatomic,strong)UIView *beiShanView;
@property (nonatomic,strong)UIButton *xuanRiQi;
@property (nonatomic,strong)UIButton *xuanShiJian;

@property (weak, nonatomic) UILabel *textLabel;
@end

@implementation weixiuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"维修";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(tijiao)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [[self view] addGestureRecognizer:recognizer];
    
    [self createtableview];
    
    
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([UITextView class], &count);
    
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        NSString *objcName = [NSString stringWithUTF8String:name];
        NSLog(@"%d : %@",i,objcName);
    }
    
    [self setupTextView];
    
    if ([_jpushstring isEqualToString:@"jpush"]) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    }
    // Do any additional setup after loading the view.
}
- (void)back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)setupTextView
{
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 5, screen_Width-20, 150)];
    _textView.tag=1000;
    [_textView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
                                                           
    // _placeholderLabel
     UILabel *placeHolderLabel = [[UILabel alloc] init];
     placeHolderLabel.text = @"这里填写维修的其它要求";
      placeHolderLabel.numberOfLines = 0;
      placeHolderLabel.textColor = [UIColor lightGrayColor];
        [placeHolderLabel sizeToFit];
       [_textView addSubview:placeHolderLabel];
                                             
       // same font
        _textView.font = [UIFont systemFontOfSize:13.f];
       placeHolderLabel.font = [UIFont systemFontOfSize:13.f];
                                                                        
            [_textView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
                                                                        
                                                                       
 
 }
                                                                        
                                                                
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    
    UITextView * textview1=(UITextView *)[self.view viewWithTag:1000];
    
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionDown) {
        
        
        
        NSLog(@"swipe down");
        
        [textview1 resignFirstResponder];
    }
}
- (void)tijiao
{
    if (labelcontent.text.length==0) {
        [MBProgressHUD showToastToView:self.view withText:@"请选择地址"];
    }else if (_textView.text.length==0){
        [MBProgressHUD showToastToView:self.view withText:@"请填写维修内容"];
    }else if (shangmentimelabel.text.length == 4){
        [MBProgressHUD showToastToView:self.view withText:@"请填写上门时间"];
    }else if ([_fenleilabel.text isEqualToString:@"选择维修类目"]){
        [MBProgressHUD showToastToView:self.view withText:@"请选择维修类目"];
    } else{
        [self savesomes];
    }
}
- (void)createtableview
{
    _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_Width, screen_Height)];
    _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _TableView.bounces = NO;
    _TableView.delegate = self;
    _TableView.dataSource = self;
    [self.view addSubview:_TableView];
}
#pragma mark - LoadingView
- (void)LoadingView
{
    LoadingView = [[HalfCircleActivityIndicatorView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-40)/2, (self.view.frame.size.height-40)/2, 40, 40)];
    [self.view addSubview:LoadingView];
}
#pragma mark ------联网请求---
-(void)post{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    NSDictionary *dict = @{@"community_id":[user objectForKey:@"community_id"],@"apk_token":uid_username,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
    
    
    NSString *strurl = [API stringByAppendingString:@"property/repair_type"];
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        _DataArr = [[NSMutableArray alloc] init];
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        NSMutableArray *titlearr = [[NSMutableArray alloc] init];
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            arr = [responseObject objectForKey:@"data"];
            for (int i=0; i<arr.count; i++) {
                [_DataArr addObject:[arr objectAtIndex:i]];
                [titlearr addObject:[[arr objectAtIndex:i] objectForKey:@"c_name"]];
            }
            GZActionSheet *sheet = [[GZActionSheet alloc]initWithTitleArray:titlearr];
            __weak typeof(sheet) weakSelf = sheet;
            sheet.ClickAction = ^(NSInteger index){
                NSLog(@"index %zi",index);
                _fenleilabel.text = [[_DataArr objectAtIndex:index-1] objectForKey:@"c_name"];
                _weixiuleimuid = [[_DataArr objectAtIndex:index-1] objectForKey:@"id"];
            };
            
            [self.view.window addSubview:sheet];
        }
        [_TableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}

#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

// 分组的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//headview的高度和内容
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @" ";
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"  ";
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
        
    }
    if (indexPath.row==0) {
        _fenleilabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 25)];
        NSMutableAttributedString *attri =     [[NSMutableAttributedString alloc] initWithString:@"选择维修类目"];
        
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        attch.image = [UIImage imageNamed:@"jiantou_down_red"];
        attch.bounds = CGRectMake(0, 0, 15, 10);
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
        [attri insertAttributedString:string atIndex:6];
        _fenleilabel.attributedText = attri;
        [cell.contentView addSubview:_fenleilabel];
        _fenleiBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _fenleiBut.frame = CGRectMake(0, 0, 200, 45);
        [_fenleiBut addTarget:self action:@selector(selectzhonglei) forControlEvents:UIControlEventTouchUpInside];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getValue:) name:@"XPFPickerView" object:nil];
        [cell.contentView addSubview:_fenleiBut];
        tableView.rowHeight = 45;
    }if (indexPath.row==1) {
//        _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 5, screen_Width-20, 150)];
//        _textView.tag=1000;
        //_textView. = @"这里填写维修的其它要求";
        [cell.contentView addSubview:_textView];
        //加号按钮
        _AddBut = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _AddBut.frame = CGRectMake(7.5, 160, (screen_Width-15-15)/4, (screen_Width-15-15)/4);
        [_AddBut setImage:[UIImage imageNamed:@"tianjia"] forState:UIControlStateNormal];
        [_AddBut addTarget:self action:@selector(Addphotos) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:_AddBut];
        for (int i=0; i<_photosArr.count; i++) {
            imageview = [[UIImageView alloc] initWithFrame:CGRectMake(i*(screen_Width-15-15)/4+5+5*i, 160, (screen_Width-15-15)/4, (screen_Width-15-15)/4)];
            imageview.image = [[_photosArr objectAtIndex:i] objectForKey:@"image"];
            [cell.contentView addSubview:imageview];
        }
        if (_photosArr.count<4) {
            _AddBut.frame = CGRectMake(7.5+_photosArr.count*(5+(screen_Width-15-15)/4), 160, (screen_Width-15-15)/4, (screen_Width-15-15)/4);
            tableView.rowHeight = 160+(screen_Width-15-15)/4+5;
            UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(10, 160+(screen_Width-15-15)/4+4, screen_Width-20, 0.5)];
            lineview.backgroundColor = [UIColor blackColor];
            lineview.alpha = 0.2;
            [cell.contentView addSubview:lineview];
        }else{
                        _AddBut.frame = CGRectMake(7.5, 160+5+(screen_Width-15-15)/4, (screen_Width-15-15)/4, (screen_Width-15-15)/4);
            tableView.rowHeight = 160+(screen_Width-15-15)/4*2+10;
            //            _tableview.frame = CGRectMake((screen_Width-(screen_Width-15-15)/4)/2, 10+(screen_Width-15-15)/2+230, (screen_Width-15-15)/4, 50);
            UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(10, 160+(screen_Width-15-15)/4*2+9, screen_Width-20, 0.5)];
            lineview.backgroundColor = [UIColor blackColor];
            lineview.alpha = 0.2;
            [cell.contentView addSubview:lineview];
        }
    }if (indexPath.row==2) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 12.5, screen_Width-100, 25)];
        label.text = @"是否需要替换部件";
        [cell.contentView addSubview:label];
        _Switch = [[UISwitch alloc] initWithFrame:CGRectMake(screen_Width-60, 10, 0, 0)];
        [cell.contentView addSubview:_Switch];
        _Switch.tag = indexPath.row;
        //定制开关颜色UI
        //tintColor 关状态下的背景颜色
        //_Switch.tintColor = [UIColor redColor];
        //        //onTintColor 开状态下的背景颜色
        _Switch.onTintColor = [UIColor redColor];
        //        //thumbTintColor 滑块的背景颜色
        //        _Switch.thumbTintColor = [UIColor blueColor];
        tableView.rowHeight = 50;
        UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(10, 49, screen_Width-20, 0.5)];
        lineview.backgroundColor = [UIColor blackColor];
        lineview.alpha = 0.2;
        [cell.contentView addSubview:lineview];
    }if (indexPath.row==3) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 12.5, 120, 25)];
        label.text = @"希望上门时段";
        [cell.contentView addSubview:label];
        
        shangmentimelabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 10, screen_Width-140, 30)];
        NSMutableAttributedString *attri =     [[NSMutableAttributedString alloc] initWithString:@"请选择"];
        shangmentimelabel.textAlignment = NSTextAlignmentRight;
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        attch.image = [UIImage imageNamed:@"jiantou_down_red"];
        attch.bounds = CGRectMake(0, 0, 15, 10);
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
        [attri insertAttributedString:string atIndex:3];
        shangmentimelabel.attributedText = attri;
        [cell.contentView addSubview:shangmentimelabel];
        NSLog(@"%ld",shangmentimelabel.text.length);
        
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        [but addTarget:self action:@selector(selecttime) forControlEvents:UIControlEventTouchUpInside];
        but.frame = CGRectMake(130, 10, screen_Width-140, 30);
        but.backgroundColor = [UIColor clearColor];
        [but.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [cell.contentView addSubview:but];
        tableView.rowHeight = 50;
        UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(10, 49, screen_Width-20, 0.5)];
        lineview.backgroundColor = [UIColor blackColor];
        lineview.alpha = 0.2;
        [cell.contentView addSubview:lineview];
    }if (indexPath.row==4) {
//        shangmentimelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12.5, screen_Width-20, 25)];
//        [cell.contentView addSubview:shangmentimelabel];
        tableView.rowHeight = 0;
//        UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(10, 49, screen_Width-20, 0.5)];
//        lineview.backgroundColor = [UIColor blackColor];
//        lineview.alpha = 0.3;
//        [cell.contentView addSubview:lineview];
    }if (indexPath.row==5) {
        labelname = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, screen_Width-40, 40)];
        labelname.font = [UIFont systemFontOfSize:18];
        [cell.contentView addSubview:labelname];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        labelcontent = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, screen_Width-40-5, 60)];
        labelcontent.numberOfLines = 2;
        labelcontent.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:labelcontent];
        //labelcontent.text = @"选择一个地址";
        
        selectbut = [UIButton buttonWithType:UIButtonTypeCustom];
        selectbut.frame = CGRectMake(20, 0, screen_Width-40, 110);
        selectbut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        NSMutableAttributedString *attri =     [[NSMutableAttributedString alloc] initWithString:@"请选择一个地址"];
        
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        attch.image = [UIImage imageNamed:@"iv_address"];
        attch.bounds = CGRectMake(0, -5, 25, 25);
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
        [attri insertAttributedString:string atIndex:0];
        [selectbut setAttributedTitle:attri forState:UIControlStateNormal];
        [selectbut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cell.contentView addSubview:selectbut];
        [selectbut addTarget:self action:@selector(seleectaddress) forControlEvents:UIControlEventTouchUpInside];
        tableView.rowHeight = 110;
        UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(10, 109, screen_Width-20, 0.5)];
        lineview.backgroundColor = [UIColor blackColor];
        lineview.alpha = 0.2;
        [cell.contentView addSubview:lineview];
    }
    
    return cell;
}


- (void)seleectaddress
{
    AdressViewController *address = [[AdressViewController alloc] init];
    
    //赋值Block，并将捕获的值赋值给UILabel
    address.returnValueBlock = ^(NSString *name,NSString *phone,NSString *address,NSString *addressid){
        labelcontent.text = address;
        labelname.text = [NSString stringWithFormat:@"%@ %@",name,phone];
        
        _name = name;
        _phone = phone;
        _addressid = addressid;
        //labelcontent.numberOfLines = 2;
        [selectbut setAttributedTitle:nil forState:UIControlStateNormal];
    };
    address.title = @"选择地址";
    address.yesnoselecte = @"1";
    [self.navigationController pushViewController:address animated:YES];
}
- (void)selecttime
{
    UIView * shiJiew = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    shiJiew.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    [self.view addSubview:shiJiew];
    self.beiShanView = shiJiew;
    
    shiBeiView = [[UIView alloc]initWithFrame:CGRectMake(114*screen_Width/414/2, 100*screen_Width/414, 300*screen_Width/414, 350*screen_Height/736)];
    shiBeiView.backgroundColor = HColor(245, 245, 245);
    [shiJiew addSubview:shiBeiView];
    
    UIButton *riQiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    riQiBtn.frame = CGRectMake(50*screen_Width/414, 30*screen_Height/736, 100*screen_Width/414, 40*screen_Height/736);
    [riQiBtn addTarget:self action:@selector(riQiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [riQiBtn setTitle:@"日期" forState:UIControlStateNormal];
    [riQiBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [riQiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    riQiBtn.selected = YES;
    riQiBtn.layer.cornerRadius = 5.0;
    riQiBtn.backgroundColor = HColor(252, 102, 52);
    riQiBtn.tag = 888;
    [shiBeiView addSubview:riQiBtn];
    self.xuanRiQi = riQiBtn;
    
    UIButton *shiJianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shiJianBtn.frame = CGRectMake(150*screen_Width/414, 30*screen_Height/736, 100*screen_Width/414, 40*screen_Height/736);
    [shiJianBtn addTarget:self action:@selector(riQiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [shiJianBtn setTitle:@"时间" forState:UIControlStateNormal];
    [shiJianBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [shiJianBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    shiJianBtn.backgroundColor = HColor(251, 251, 251);
    shiJianBtn.tag = 666;
    shiJianBtn.layer.cornerRadius = 5.0;
    [shiBeiView addSubview:shiJianBtn];
    self.xuanShiJian = shiJianBtn;
    
    
    UIButton *queXiaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    queXiaoBtn.frame = CGRectMake(30*screen_Width/414, 290*screen_Height/736, 100*screen_Width/414, 40*screen_Height/736);
    [queXiaoBtn addTarget:self action:@selector(quXiaoBtn) forControlEvents:UIControlEventTouchUpInside];
    [queXiaoBtn setTitle:@"取消" forState:UIControlStateNormal];
    [queXiaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    queXiaoBtn.layer.cornerRadius = 5.0;
    queXiaoBtn.backgroundColor = [UIColor lightGrayColor];
    [shiBeiView addSubview:queXiaoBtn];
    
    [self createQueRenBtn];
    [self createRiQiPicker];
}
#pragma mark-----第二个确认按钮即时间界面的确认按钮--------------------
- (void)createTwoQueRenBtn{
    queRenTwoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    queRenTwoBtn.frame = CGRectMake(170*screen_Width/414, 290*screen_Height/736, 100*screen_Width/414, 40*screen_Height/736);
    [queRenTwoBtn addTarget:self action:@selector(shiJianQueRenBtn:) forControlEvents:UIControlEventTouchUpInside];
    [queRenTwoBtn setTitle:@"确定" forState:UIControlStateNormal];
    queRenTwoBtn.backgroundColor = HColor(252, 102, 52);
    queRenTwoBtn.layer.cornerRadius = 5.0;
    [queRenTwoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shiBeiView addSubview:queRenTwoBtn];
}
- (void)shiJianQueRenBtn:(UIButton *)sender{
    
    NSLog(@"您所选择的时间为:%@ %@",pinStr,shiJianPinStr);
    shangmentimelabel.text = [NSString stringWithFormat:@"%@-%@",pinStr,shiJianPinStr];
    [_beiShanView removeFromSuperview];
}
#pragma mark-----第一个确认按钮--------------------
- (void)createQueRenBtn{
    queRenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    queRenBtn.frame = CGRectMake(170*screen_Width/414, 290*screen_Height/736, 100*screen_Width/414, 40*screen_Height/736);
    [queRenBtn addTarget:self action:@selector(riQiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [queRenBtn setTitle:@"确定" forState:UIControlStateNormal];
    queRenBtn.backgroundColor = HColor(252, 102, 52);
    queRenBtn.layer.cornerRadius = 5.0;
    [queRenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shiBeiView addSubview:queRenBtn];
    
}
//取消按钮
- (void)quXiaoBtn{
    [_beiShanView removeFromSuperview];
    
}
#pragma mark-----时间picker--------------------
- (void)createSHIJianPicker{
    NSDate *nowDate = [NSDate date];
    shiJiandatePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 80*screen_Height/736, 300*screen_Width/414, 200*screen_Height/736)];
    [shiBeiView addSubview:shiJiandatePicker];
    shiJiandatePicker.datePickerMode = UIDatePickerModeCountDownTimer;
    [shiJiandatePicker setDate:nowDate animated:NO];
    //属性：datePicker.date当前选中的时间 类型 NSDate
    
    [shiJiandatePicker addTarget:self action:@selector(dateChangeShiJian:) forControlEvents: UIControlEventValueChanged];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm"];
    shiJianPinStr  = [formatter stringFromDate:shiJiandatePicker.date];
    
}
- (void)dateChangeShiJian:(UIDatePicker *)senser{
    //这个NSDateFormatter类用来设计时间的格式  Formatter格式化
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //设置格式 yyyy表示几几年如2016 yy也是表示年份为16年 MM表示月 dd表示日 a表示上下午 HH表示小时 （24进制 hh表示12进制）mm表示分钟  ss表示秒  eeee表示星期几 eee表示周几 e表示第几天
    // HH点mm分ss秒  "
    [formatter setDateFormat:@"HH:mm"];
    //设置星期几的别称礼拜几 注意顺序 系统是从周日算作第一天的
    //[formatter setWeekdaySymbols:@[@"礼拜天",@"礼拜一",@"礼拜二",@"礼拜三",@"礼拜四",@"礼拜五",@"礼拜六"]];
    //设置上午下午别称
    //[formatter setAMSymbol:@"前晌"];
    //[formatter setPMSymbol:@"晌午"];
    
    //根据日期的格式formatter 把NSDate类型转换成NSString类型
    shiJianPinStr = [formatter stringFromDate:senser.date];
    NSLog(@"%@",shiJianPinStr);
    //调出设备当前的时间
    //NSDate *nowDate = [NSDate date];
    
}
#pragma mark----------日期picker--------------------
- (void)createRiQiPicker{
    
    riQidatePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 80*screen_Height/736, 300*screen_Width/414, 200*screen_Height/736)];
    [shiBeiView addSubview:riQidatePicker];
    riQidatePicker.datePickerMode = UIDatePickerModeDate;
    //[riQidatePicker setDate:nowDate animated:YES];
    //属性：datePicker.date当前选中的时间 类型 NSDate
    
    [riQidatePicker addTarget:self action:@selector(dateChange:) forControlEvents: UIControlEventValueChanged];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    pinStr = [formatter stringFromDate:riQidatePicker.date];
    
    
}
- (void)dateChange:(UIDatePicker *)senser{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    pinStr = [formatter stringFromDate:senser.date];
    
    
}
#pragma mark-----------切换button--------------------
- (void)riQiBtnClick:(UIButton *)sender{
    if (sender.tag == self.xuanRiQi.tag) {
        self.xuanRiQi.selected = YES;
        self.xuanShiJian.selected = NO;
        self.xuanShiJian.backgroundColor = HColor(251, 251, 251);
        self.xuanRiQi.backgroundColor = HColor(252, 102, 52);
        
        [shiJiandatePicker removeFromSuperview];
        [self createRiQiPicker];
        [self createQueRenBtn];
    }else{
        self.xuanShiJian.selected = YES;
        self.xuanRiQi.selected = NO;
        self.xuanShiJian.backgroundColor = HColor(252, 102, 52);
        self.xuanRiQi.backgroundColor = HColor(251, 251, 251);
        [riQidatePicker removeFromSuperview];
        [queRenBtn removeFromSuperview];
        [self createTwoQueRenBtn];
        [self createSHIJianPicker];
        
    }
}
- (void)Addphotos
{
    WPhotoViewController *Wphotovc = [[WPhotoViewController alloc] init];
    //选择图片的最大数
    Wphotovc.selectPhotoOfMax = 4;
    [Wphotovc setSelectPhotosBack:^(NSMutableArray *phostsArr) {
        _photosArr = phostsArr;
        [_TableView reloadData];
        _DataArr = nil;
    }];
    [self presentViewController:Wphotovc animated:YES completion:nil];
}
- (void)savesomes
{
    LoadingView.hidden = NO;
    [LoadingView startAnimating];
    NSLog(@"==%@",_photosArr);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    //formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
    NSString *imfnumstr = [NSString stringWithFormat:@"%zi",_photosArr.count];
    NSData *nsdata = [_textView.text
                      dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *is_replace;
    if (_Switch.on == YES) {
        is_replace = @"1";
    }else{
        is_replace = @"2";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //指定时间显示样式: HH表示24小时制 hh表示12小时制
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *lastTime = shangmentimelabel.text;
    NSDate *lastDate = [formatter dateFromString:lastTime];
    //以 1970/01/01 GMT为基准，得到lastDate的时间戳
    long firstStamp = [lastDate timeIntervalSince1970];
    NSDictionary *dic = @{@"type":[NSString stringWithFormat:@"%@",_weixiuleimuid],@"c_id":[user objectForKey:@"community_id"],@"is_replace":is_replace,@"description":_textView.text,@"pic_num":imfnumstr,@"starttime":shangmentimelabel.text,@"address":labelcontent.text,@"address_id":_addressid,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
    NSLog(@"*********8%@",dic);
    NSString *url = [API stringByAppendingString:@"property/submit_repair"];
    [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i=0; i<_photosArr.count; i++)
        {
            UIImageView *imageview = [[UIImageView alloc] init];
            imageview.image = [[_photosArr objectAtIndex:i] objectForKey:@"image"];
            UIImage *image = imageview.image;
            NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat =@"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
            [formData  appendPartWithFileData:imageData name:[NSString stringWithFormat:@"upload%d",i] fileName:fileName mimeType:@"jpg/png/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@==%@",[responseObject objectForKey:@"data"], [responseObject objectForKey:@"msg"]);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            [LoadingView stopAnimating];
            LoadingView.hidden = YES;
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
            [self performSelector:@selector(pushcanyudefuwu) withObject:nil afterDelay:0];
        }else{
            [LoadingView stopAnimating];
            LoadingView.hidden = YES;
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败：%@", error);
        [LoadingView stopAnimating];
        LoadingView.hidden = YES;
        [MBProgressHUD showToastToView:self.view withText:@"发布失败"];
    }];
}
- (void)pushcanyudefuwu
{
    fuwudingdanViewController *fuwu = [[fuwudingdanViewController alloc] init];
    [self.navigationController pushViewController:fuwu animated:YES];
}

- (void)selectzhonglei
{
    [self post];
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
