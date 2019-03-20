//
//  wuyeyanzhengViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/12/22.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import "wuyeyanzhengViewController.h"
#import "XiaoquViewController.h"
#import <AFNetworking.h>
#import "MBProgressHUD+TVAssistant.h"
#import "yanzhengsusessViewController.h"

#import "PrefixHeader.pch"
#define screen_Width [UIScreen mainScreen].bounds.size.width
#define screen_Height [UIScreen mainScreen].bounds.size.height
@interface wuyeyanzhengViewController ()<UITextFieldDelegate>
{
    UIButton *_yanzhnegbut;
    
    UITextField *_textfieldname;
    UITextField *_textfieldaddress;
    
    NSString *community_id;
    NSString *building_id;
    NSString *units;
    NSString *room_id;
}

@end

@implementation wuyeyanzhengViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"业主认证";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change:) name:@"changetextfield" object:nil];
    
    [self Createui];
    // Do any additional setup after loading the view.
}
- (void)change:(NSNotification *)userinfo
{
    _textfieldaddress.text = userinfo.userInfo[@"address"];
    //@"community_id":_community_id,@"building_id":_build_id,@"units":@"",@"room_id":[[_DataArr objectAtIndex:indexPath.row] objectForKey:@"code"]
    community_id = userinfo.userInfo[@"community_id"];
    building_id = userinfo.userInfo[@"building_id"];
    units = userinfo.userInfo[@"units"];
    room_id = userinfo.userInfo[@"room_id"];
}
- (void)Createui
{
    NSArray *imagearr = [[NSArray alloc] initWithObjects:@"mine_icon_mine_dianjiqian",@"mine_icon_address", nil];
    for (int i=0; i<2; i++) {
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 100+i*55+10, 30, 30)];
        imageview.image = [UIImage imageNamed:[imagearr objectAtIndex:i]];
        [self.view addSubview:imageview];
        
        UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(15, 100+50+i*55, screen_Width-30, 1)];
        lineview.backgroundColor = [UIColor blackColor];
        lineview.alpha = 0.2;
        [self.view addSubview:lineview];
    }
    //验证按钮
    _yanzhnegbut = [UIButton buttonWithType:UIButtonTypeCustom];
    _yanzhnegbut.clipsToBounds=YES;
    _yanzhnegbut.layer.cornerRadius=30;//圆角
    _yanzhnegbut.frame = CGRectMake(15, 225, self.view.frame.size.width-30, 60);
    [_yanzhnegbut setTitle:@"下一步" forState:UIControlStateNormal];
    _yanzhnegbut.backgroundColor = [UIColor redColor];
    [_yanzhnegbut addTarget:self action:@selector(yanzheng) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_yanzhnegbut];
    
    _textfieldaddress = [[UITextField alloc] initWithFrame:CGRectMake(65, 100+10+55, self.view.frame.size.width-65-70, 40)];
    [self.view addSubview:_textfieldaddress];
    _textfieldaddress.delegate = self;
    _textfieldaddress.placeholder = @"选择住址信息";
    _textfieldaddress.tag = 1;
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake(65, 100+65, self.view.frame.size.width-65-70, 40);
    [but addTarget:self action:@selector(selectxiaoqu) forControlEvents:UIControlEventTouchUpInside];
    but.backgroundColor = [UIColor clearColor];
    [self.view addSubview:but];
    
    _textfieldname = [[UITextField alloc] initWithFrame:CGRectMake(65, 100+10, self.view.frame.size.width-65-70, 40)];
    _textfieldname.delegate = self;
    _textfieldname.placeholder = @"姓名";
    _textfieldname.tag = 2;
    [self.view addSubview:_textfieldname];
    
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [[self view] addGestureRecognizer:recognizer];
}
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    
    UITextField * field3=(UITextField *)[self.view viewWithTag:2];
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionDown) {
        
        NSLog(@"swipe down");
        
        
        [field3 resignFirstResponder];
    }
}
- (void)yanzheng
{
    if (_textfieldname.text.length<1) {
        [MBProgressHUD showToastToView:self.view withText:@"请输入姓名"];
    }else if (_textfieldaddress.text.length<1){
        [MBProgressHUD showToastToView:self.view withText:@"请选择小区信息"];
    }else{
        [self post];
    }
}
- (void)selectxiaoqu
{
    XiaoquViewController *xiaoqu = [[XiaoquViewController alloc] init];
    xiaoqu.biaojistr = @"yezhu";
    [self.navigationController pushViewController:xiaoqu animated:YES];
}

#pragma mark ----联网请求---
-(void)post
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    NSDictionary *dict = @{@"community_id":community_id,@"building_id":building_id,@"units":units,@"room_id":room_id,@"fullname":_textfieldname.text,@"apk_token":uid_username,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"],@"hui_community_id":[user objectForKey:@"community_id"]};
   
    NSString *urlstr = [API stringByAppendingString:@"property/check_pro_user"];
    [manager POST:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            yanzhengsusessViewController *suess = [[yanzhengsusessViewController alloc] init];
            suess.dic = [responseObject objectForKey:@"data"];
            [self.navigationController pushViewController:suess animated:YES];
        }else{
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
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
