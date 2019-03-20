//
//  FacePayViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/3/23.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "FacePayViewController.h"
#import "LMJDropdownMenu.h"
#import "FacepayjiluViewController.h"
#import "FacesureViewController.h"
#import <AFNetworking.h>
#import "XiaoquViewController.h"
#import "MBProgressHUD+TVAssistant.h"
#import "selectshangpuViewController.h"
@interface FacePayViewController ()<LMJDropdownMenuDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    UITextField *pricetextfield;
    UILabel *leimuLabel;
    UILabel *houselabel;
    UILabel *namephonelabel;
    UILabel *selecthouse;
    UILabel *suernamephone;
    UIButton *housebut;
    
    UILabel *shangpulabel;
    UILabel *selectshanghulabel;
    UIButton *shangpubut;
    
    UITextView *TextView;
    UITextView *TextView1;
    UITextView *TextView2;
    
    UIScrollView *_scrollview;
    
    NSArray *_DataArr;
    
    NSString *community_id;
    NSString *building_id;
    NSString *community_name;
    NSString *building_name;
    NSString *code;
    NSString *units;
    NSString *room_id;
    NSString *name;
    NSString *phone;
    NSString *sign;
    NSString *c_name;
    NSString *company_id;
    NSString *company_name;
    NSString *department_id;
    NSString *department_name;
    NSString *floor;
    
    NSString *c_id;
    
    NSString *shangpu_id;
    NSString *shangpu_uid;
    NSString *shangpu_name;
}
@end

@implementation FacePayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"当面付";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self getData];
    
    [self createrightbutton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change:) name:@"changetextfield" object:nil];//changeshangpu
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeshangpu:) name:@"changeshangpu" object:nil];//changeshangpu
    // Do any additional setup after loading the view.
}
- (BOOL)navigationShouldPopOnBackButton{
    UIViewController *viewc = self.navigationController.viewControllers[self.navigationController.viewControllers.count-1];
    [self.navigationController popToViewController:viewc animated:YES];
    return YES;
}
-(void)changeshangpu:(NSNotification *)userinfo
{
    shangpu_id = userinfo.userInfo[@"id"];
    shangpu_uid = userinfo.userInfo[@"uid"];
    shangpu_name = userinfo.userInfo[@"merchant_name"];
    
    shangpulabel.text = [NSString stringWithFormat:@" %@",shangpu_name];
}
- (void)change:(NSNotification *)userinfo
{
    NSLog(@"--参数%@",userinfo.userInfo);
    houselabel.text = userinfo.userInfo[@"address"];
    //@"community_id":_community_id,@"building_id":_build_id,@"units":@"",@"room_id":[[_DataArr objectAtIndex:indexPath.row] objectForKey:@"code"]
    community_id = userinfo.userInfo[@"community_id"];
    community_name = userinfo.userInfo[@"community_name"];
    building_id = userinfo.userInfo[@"building_id"];
    building_name = userinfo.userInfo[@"build_name"];
    units = userinfo.userInfo[@"units"];
    room_id = userinfo.userInfo[@"room_id"];
    code = userinfo.userInfo[@"code"];
    company_id = userinfo.userInfo[@"company_id"];
    company_name = userinfo.userInfo[@"company_name"];
    department_id = userinfo.userInfo[@"department_id"];
    department_name = userinfo.userInfo[@"department_name"];
    floor = userinfo.userInfo[@"floor"];
    
    [self post];
}
#pragma mark ----联网请求---
-(void)post
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    NSDictionary *dict = @{@"room_id":room_id,@"apk_token":uid_username,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"],@"hui_community_id":[user objectForKey:@"community_id"]};
   
    NSString *urlstr = [API stringByAppendingString:@"property/get_room_personal_info"];
    [manager POST:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            name = [[responseObject objectForKey:@"data"] objectForKey:@"name"];
            phone = [[responseObject objectForKey:@"data"] objectForKey:@"mp1"];
            namephonelabel.text = [NSString stringWithFormat:@"%@/%@",name,phone];
        }else{
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
- (void)createrightbutton
{
    //自定义一个导航条右上角的一个button
    UIImage *issueImage = [UIImage imageNamed:@"ic_order5"];
    
    UIButton *issueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    issueButton.frame = CGRectMake(0, 0, 25, 25);
    [issueButton setBackgroundImage:issueImage forState:UIControlStateNormal];
    issueButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [issueButton addTarget:self action:@selector(issueBton) forControlEvents:UIControlEventTouchUpInside];
    //添加到导航条
    UIBarButtonItem *leftBarButtomItem = [[UIBarButtonItem alloc]initWithCustomView:issueButton];
    self.navigationItem.rightBarButtonItem = leftBarButtomItem;
}
- (void)issueBton
{
    FacepayjiluViewController *jilu = [[FacepayjiluViewController alloc] init];
    [self.navigationController pushViewController:jilu animated:YES];
}
#pragma mark - LMJDropdownMenu Delegate

- (void)dropdownMenu:(LMJDropdownMenu *)menu selectedCellNumber:(NSInteger)number{
    NSLog(@"你选择了：%ld",number);
    sign = [NSString stringWithFormat:@"%@",[[_DataArr objectAtIndex:number] objectForKey:@"sign"]];
    c_name = [NSString stringWithFormat:@"%@",[[_DataArr objectAtIndex:number] objectForKey:@"c_name"]];
    c_id = [NSString stringWithFormat:@"%@",[[_DataArr objectAtIndex:number] objectForKey:@"id"]];
    if ([sign isEqualToString:@"0"]) {
        selecthouse.hidden = YES;
        houselabel.hidden = YES;
        suernamephone.hidden = YES;
        namephonelabel.hidden = YES;
        housebut.hidden = YES;
        TextView1.hidden = NO;
        TextView.hidden = YES;
        shangpubut.hidden = YES;
        selectshanghulabel.hidden = YES;
        shangpulabel.hidden = YES;
        TextView2.hidden = YES;
        _scrollview.contentSize = CGSizeMake(Main_width, TextView1.frame.size.height+TextView1.frame.origin.y+258);
    }else if ([sign isEqualToString:@"1"]){
        selecthouse.hidden = NO;
        houselabel.hidden = NO;
        suernamephone.hidden = NO;
        namephonelabel.hidden = NO;
        housebut.hidden = NO;
        TextView1.hidden = YES;
        TextView.hidden = NO;
        shangpubut.hidden = YES;
        selectshanghulabel.hidden = YES;
        shangpulabel.hidden = YES;
        TextView2.hidden = YES;
        _scrollview.contentSize = CGSizeMake(Main_width, TextView.frame.size.height+TextView.frame.origin.y+258);
    }else{
        shangpubut.hidden = NO;
        selectshanghulabel.hidden = NO;
        shangpulabel.hidden = NO;
        TextView2.hidden = NO;
        selecthouse.hidden = YES;
        houselabel.hidden = YES;
        suernamephone.hidden = YES;
        namephonelabel.hidden = YES;
        housebut.hidden = YES;
        TextView1.hidden = YES;
        TextView.hidden = YES;
        _scrollview.contentSize = CGSizeMake(Main_width, TextView2.frame.size.height+TextView2.frame.origin.y+258);
    }
}
- (void)dropdownMenuWillShow:(LMJDropdownMenu *)menu{
    NSLog(@"--将要显示--");
}
- (void)dropdownMenuDidShow:(LMJDropdownMenu *)menu{
    NSLog(@"--已经显示--");
}
- (void)dropdownMenuWillHidden:(LMJDropdownMenu *)menu{
    NSLog(@"--将要隐藏--");
}
- (void)dropdownMenuDidHidden:(LMJDropdownMenu *)menu{
    NSLog(@"--已经隐藏--");
}


- (void)getData
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    dict = @{@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"],@"hui_community_id":[userinfo objectForKey:@"community_id"]};
   
    NSString *strurl = [API stringByAppendingString:@"property/face_pay_cate"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"---%@--%@",responseObject,[responseObject objectForKey:@"msg"]);
        _DataArr = [NSArray array];

        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            _DataArr = [responseObject objectForKey:@"data"];
            
        }
        [self createUI];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
- (void)createUI
{
    _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Main_width, Main_Height)];
    _scrollview.alwaysBounceVertical = YES;
    _scrollview.showsVerticalScrollIndicator = NO;
    _scrollview.showsHorizontalScrollIndicator = NO;
    _scrollview.bounces = NO;
    _scrollview.backgroundColor = BackColor;
    [self.view addSubview:_scrollview];
    _scrollview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self downshoushi];
    
    UILabel *jiaofeijine = [[UILabel alloc] initWithFrame:CGRectMake(15, 25, Main_width-30, 25)];
    [jiaofeijine setFont:font18];
    jiaofeijine.text = @"缴费金额";
    [_scrollview addSubview:jiaofeijine];
    
    UIView *priceview = [[UIView alloc] initWithFrame:CGRectMake(15, jiaofeijine.frame.size.height+jiaofeijine.frame.origin.y+12.5, Main_width-30, 50)];
    priceview.backgroundColor = [UIColor whiteColor];
    [_scrollview addSubview:priceview];
    
    pricetextfield = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, Main_width-30-30, 50)];
    pricetextfield.tag = 1000;
    pricetextfield.delegate = self;
    pricetextfield.placeholder = @"输入金额";
    //pricetextfield.keyboardType = UIKeyboardTypeNumberPad;
    pricetextfield.backgroundColor = [UIColor whiteColor];
    [priceview addSubview:pricetextfield];
    
    UILabel *selectleimu = [[UILabel alloc] initWithFrame:CGRectMake(15, priceview.frame.size.height+priceview.frame.origin.y+25, Main_width-30, 25)];
    selectleimu.text = @"请选择缴费项目";
    [selectleimu setFont:font18];
    [_scrollview addSubview:selectleimu];
    
    leimuLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, selectleimu.frame.size.height+selectleimu.frame.origin.y+12.5, Main_width-30, 50)];
    leimuLabel.backgroundColor = [UIColor whiteColor];
    [leimuLabel setFont:font15];
    [_scrollview addSubview:leimuLabel];
    
    
    selecthouse = [[UILabel alloc] initWithFrame:CGRectMake(15, leimuLabel.frame.size.height+leimuLabel.frame.origin.y+25, Main_width-30, 25)];
    selecthouse.text = @"请选择您的房屋";
    [selecthouse setFont:font18];
    [_scrollview addSubview:selecthouse];
    
    houselabel = [[UILabel alloc] initWithFrame:CGRectMake(15, selecthouse.frame.size.height+selecthouse.frame.origin.y+12.5, Main_width-30, 50)];
    houselabel.backgroundColor = [UIColor whiteColor];
    [houselabel setFont:font15];
    [_scrollview addSubview:houselabel];
    
    housebut = [UIButton buttonWithType:UIButtonTypeCustom];
    housebut.frame = houselabel.frame;
    housebut.backgroundColor = [UIColor clearColor];
    [housebut addTarget:self action:@selector(housebut) forControlEvents:UIControlEventTouchUpInside];
    [_scrollview addSubview:housebut];
    
    selectshanghulabel = [[UILabel alloc] initWithFrame:CGRectMake(15, leimuLabel.frame.size.height+leimuLabel.frame.origin.y+25, Main_width-30, 25)];
    selectshanghulabel.text = @"请选择你的商户";
    [selectshanghulabel setFont:font18];
    [_scrollview addSubview:selectshanghulabel];
    
    shangpulabel = [[UILabel alloc] initWithFrame:CGRectMake(15, selectshanghulabel.frame.size.height+selectshanghulabel.frame.origin.y+12.5, Main_width-30, 50)];
    shangpulabel.backgroundColor = [UIColor whiteColor];
    shangpulabel.font = font15;
    [_scrollview addSubview:shangpulabel];
    
    shangpubut = [UIButton buttonWithType:UIButtonTypeCustom];
    shangpubut.frame = shangpulabel.frame;
    shangpubut.backgroundColor = [UIColor clearColor];
    [shangpubut addTarget:self action:@selector(shangpubut) forControlEvents:UIControlEventTouchUpInside];
    [_scrollview addSubview:shangpubut];
    
    suernamephone = [[UILabel alloc] initWithFrame:CGRectMake(15, houselabel.frame.size.height+houselabel.frame.origin.y+25, Main_width-30, 25)];
    suernamephone.text = @"请确定您的信息";
    [suernamephone setFont:font18];
    [_scrollview addSubview:suernamephone];
    
    namephonelabel = [[UILabel alloc] initWithFrame:CGRectMake(15, suernamephone.frame.size.height+suernamephone.frame.origin.y+12.5, Main_width-30, 50)];
    namephonelabel.backgroundColor = [UIColor whiteColor];
    [namephonelabel setFont:font15];
    [_scrollview addSubview:namephonelabel];
    
    TextView = [[UITextView alloc] initWithFrame:CGRectMake(15, namephonelabel.frame.size.height+namephonelabel.frame.origin.y+12.5, Main_width-30, 125)];
    TextView.backgroundColor = [UIColor whiteColor];
    //TextView.zw_placeHolder = @"备注:";
    // placeholder
    UILabel *label = [UILabel new];
    label.font = TextView.font;
    label.text = @"备注:";
    label.numberOfLines = 0;
    label.textColor = [UIColor lightGrayColor];
    [label sizeToFit];
    [TextView addSubview:label];
    // kvc
    [TextView setValue:label forKey:@"_placeholderLabel"];
    
    TextView.font = font15;
    TextView.delegate = self;
    [_scrollview addSubview:TextView];
    
    TextView1 = [[UITextView alloc] initWithFrame:CGRectMake(15, leimuLabel.frame.size.height+leimuLabel.frame.origin.y+12.5, Main_width-30, 125)];
    TextView1.delegate = self;
    //TextView1.zw_placeHolder = @"备注:";
    // placeholder
    UILabel *label1 = [UILabel new];
    label1.font = TextView1.font;
    label1.text = @"备注:";
    label1.numberOfLines = 0;
    label1.textColor = [UIColor lightGrayColor];
    [label1 sizeToFit];
    [TextView1 addSubview:label1];
    // kvc
    [TextView1 setValue:label1 forKey:@"_placeholderLabel"];
    
    TextView1.font = font15;
    TextView1.backgroundColor = [UIColor whiteColor];
    [_scrollview addSubview:TextView1];
    
    TextView2 = [[UITextView alloc] initWithFrame:CGRectMake(15, shangpulabel.frame.size.height+shangpulabel.frame.origin.y+12.5, Main_width-30, 125)];
    TextView2.delegate = self;
    //TextView1.zw_placeHolder = @"备注:";
    // placeholder
    UILabel *label2 = [UILabel new];
    label2.font = TextView2.font;
    label2.text = @"备注:";
    label2.numberOfLines = 0;
    label2.textColor = [UIColor lightGrayColor];
    [label2 sizeToFit];
    [TextView2 addSubview:label2];
    // kvc
    [TextView2 setValue:label2 forKey:@"_placeholderLabel"];
    
    TextView2.font = font15;
    TextView2.backgroundColor = [UIColor whiteColor];
    [_scrollview addSubview:TextView2];
    
    selecthouse.hidden = YES;
    houselabel.hidden = YES;
    suernamephone.hidden = YES;
    namephonelabel.hidden = YES;
    housebut.hidden = YES;
    TextView.hidden = YES;
    TextView1.hidden = YES;
    
    shangpubut.hidden = YES;
    selectshanghulabel.hidden = YES;
    shangpulabel.hidden = YES;
    TextView2.hidden = YES;
    
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i=0; i<_DataArr.count; i++) {
        [arr addObject:[[_DataArr objectAtIndex:i] objectForKey:@"c_name"]];
    }
    LMJDropdownMenu * dropdownMenu = [[LMJDropdownMenu alloc] init];
    [dropdownMenu setFrame:CGRectMake(15, selectleimu.frame.size.height+selectleimu.frame.origin.y+12.5, Main_width-30, 50)];
    [dropdownMenu setMenuTitles:arr rowHeight:50];
    dropdownMenu.delegate = self;
    [_scrollview addSubview:dropdownMenu];
    
    
    UIButton *suer = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:suer];
    suer.backgroundColor = QIColor;
    [suer setTitle:@"下一步" forState:UIControlStateNormal];
    suer.frame = CGRectMake(0, Main_Height-49, Main_width, 49);
    [suer addTarget:self action:@selector(suer) forControlEvents:UIControlEventTouchUpInside];
}
- (void)shangpubut
{
    selectshangpuViewController *shangpu = [[selectshangpuViewController alloc] init];
    [self.navigationController pushViewController:shangpu animated:YES];
}
- (void)housebut
{
    NSLog(@"housebut");
    XiaoquViewController *xiaoqu = [[XiaoquViewController alloc] init];
    xiaoqu.biaojistr = @"yezhu";
    [self.navigationController pushViewController:xiaoqu animated:YES];
}
- (void)suer{
    float price = [pricetextfield.text floatValue];
    if (price<=0) {
        [MBProgressHUD showToastToView:self.view withText:@"缴费金额必须大于0"];
        
    }else if (c_name == nil){
        [MBProgressHUD showToastToView:self.view withText:@"请选择缴费项目"];
    }else{
        NSLog(@"生成订单");
         if ([sign isEqualToString:@"0"]) {
             if ([TextView1.text isEqualToString:@""]) {
                 [MBProgressHUD showToastToView:self.view withText:@"请填写备注"];
             }else{
                [self next];
             }
         }else if ([sign isEqualToString:@"2"]) {
             if ([TextView2.text isEqualToString:@""]) {
                 [MBProgressHUD showToastToView:self.view withText:@"请填写备注"];
             }else{
                 [self next];
             }
         } else{
             if ([houselabel.text isEqualToString:@""]) {
                 [MBProgressHUD showToastToView:self.view withText:@"请填写房屋信息"];
             }else{
                 [self next];
             }
         }
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    BOOL isHaveDian = YES;
    
    
    if (textField == pricetextfield)  {
        if ([textField.text rangeOfString:@"."].location == NSNotFound) {
            isHaveDian = NO;
        }
        if ([string length] > 0) {
            
            unichar single = [string characterAtIndex:0];//当前输入的字符
            if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
                
                //首字母不能为0和小数点
                if([textField.text length] == 0){
                    if(single == '.') {
                        [MBProgressHUD showToastToView:self.view withText:@"第一个数字不能为小数点"];
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                    
                }
                
                //输入的字符是否是小数点
                if (single == '.') {
                    if(!isHaveDian)//text中还没有小数点
                    {
                        isHaveDian = YES;
                        return YES;
                        
                    }else{
                        [MBProgressHUD showToastToView:self.view withText:@"输入过小数点了"];
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }else{
                    if (isHaveDian) {//存在小数点
                        
                        //判断小数点的位数
                        NSRange ran = [textField.text rangeOfString:@"."];
                        if (range.location - ran.location <= 2) {
                            return YES;
                        }else{
                            [MBProgressHUD showToastToView:self.view withText:@"最多输入两位小数"];
                            return NO;
                        }
                    }else{
                        return YES;
                    }
                }
            }else{//输入的数据格式不正确
                [MBProgressHUD showToastToView:self.view withText:@"输入的格式不正确"];
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }
        else
        {
            return YES;
        }
    }
    return YES;
}

- (void)next
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    NSDictionary *dict = nil;
    if ([sign isEqualToString:@"0"]) {
        dict = @{@"c_id":c_id,@"c_name":c_name,@"money":pricetextfield.text,@"note":TextView1.text,@"apk_token":uid_username,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"],@"hui_community_id":[user objectForKey:@"community_id"]};
        NSLog(@"dict===%@",dict);
    }else if ([sign isEqualToString:@"2"]) {
        dict = @{@"c_id":c_id,@"c_name":c_name,@"m_name":shangpu_name,@"m_id":shangpu_id,@"m_uid":shangpu_uid,@"money":pricetextfield.text,@"note":TextView2.text,@"apk_token":uid_username,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"],@"hui_community_id":[user objectForKey:@"community_id"]};
        NSLog(@"dict===%@",dict);
    }else{
        dict = @{@"c_id":c_id,@"c_name":c_name,@"community_id":community_id,@"community_name":community_name,@"building_id":building_id,@"building_name":building_name,@"room_id":room_id,@"company_id":company_id,@"company_name":company_name,@"department_id":department_id,@"department_name":department_name,@"floor":floor,@"unit":units,@"code":code,@"mobile":phone,@"fullname":name,@"money":pricetextfield.text,@"note":TextView.text,@"apk_token":uid_username,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"],@"hui_community_id":[user objectForKey:@"community_id"]};
    }
    
    NSString *urlstr = [API stringByAppendingString:@"property/add_face_pay_order"];
    [manager POST:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            FacesureViewController *suer = [[FacesureViewController alloc] init];
            suer.order_number = [[responseObject objectForKey:@"data"] objectForKey:@"order_number"];
            suer.name = [NSString stringWithFormat:@"%@/%@",[[responseObject objectForKey:@"data"] objectForKey:@"fullname"],[[responseObject objectForKey:@"data"] objectForKey:@"mobile"]];
            suer.time = [[responseObject objectForKey:@"data"] objectForKey:@"addtime"];
            suer.price = [[responseObject objectForKey:@"data"] objectForKey:@"money"];
            suer.c_name = [NSString stringWithFormat:@"%@%@%@单元%@",[[responseObject objectForKey:@"data"] objectForKey:@"community_name"],[[responseObject objectForKey:@"data"] objectForKey:@"building_name"],[[responseObject objectForKey:@"data"] objectForKey:@"unit"],[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            suer.leixing =[[responseObject objectForKey:@"data"] objectForKey:@"c_name"];
            suer.id = [[responseObject objectForKey:@"data"] objectForKey:@"id"];
            suer.sign = sign;
            
            if ([sign isEqualToString:@"2"]){
                suer.m_name = [[responseObject objectForKey:@"data"] objectForKey:@"m_name"];
                suer.beizhu = TextView2.text;
            }else if ([sign isEqualToString:@"1"]){
                suer.beizhu = TextView1.text;
            }else{
                suer.beizhu = TextView.text;
            }
            [self.navigationController pushViewController:suer animated:YES];
        }else{
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];

}

#pragma  mark - textField delegate
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"点击空白");
    [pricetextfield endEditing:YES];
    //[[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
- (void)downshoushi{
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [[self view] addGestureRecognizer:recognizer];
}
//点击空白处的手势要实现的方法
-(void)viewTapped:(UISwipeGestureRecognizer *)recognizer
{
    UITextField * field=(UITextField *)[self.view viewWithTag:1000];
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionDown) {
        
        NSLog(@"swipe down");
        
        [field resignFirstResponder];
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
