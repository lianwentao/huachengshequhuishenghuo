//
//  edAddressViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/12/5.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import "edAddressViewController.h"
#import "XiaoquViewController.h"
#import <AFNetworking.h>
#import "MBProgressHUD+TVAssistant.h"

#define kScreen_Height   ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width    ([UIScreen mainScreen].bounds.size.width)
#import "PrefixHeader.pch"
@interface edAddressViewController ()
{
    UITextField *textfieldname;
    UITextField *textfieldaddress;
    UITextField *textfieldphone;
    UITextField *textfieldxiaoqu;
    
    NSString *str1 ;
    NSString *str2 ;
    NSString *str3 ;
}

@end

@implementation edAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change:) name:@"changexiaoquaddrss" object:nil];
    
    
    [self createui];
    [self addRightBtn];
    // Do any additional setup after loading the view.
}

    
- (void)change:(NSNotification *)userinfo
{
    NSLog(@"%@",userinfo);
    textfieldxiaoqu.text = userinfo.userInfo[@"xiaoqu"];
    str1 = userinfo.userInfo[@"id"];
    str2 = userinfo.userInfo[@"city_id"];
    str3 = userinfo.userInfo[@"region_id"];
}
#pragma mark - 导航栏rightbutton
- (void)addRightBtn
{
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(tijiao)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}
- (void)createui
{
    textfieldname = [[UITextField alloc] initWithFrame:CGRectMake(10, 64, kScreen_Width, 55)];
    textfieldname.placeholder = @"姓名";
    textfieldname.text = _strone;
    textfieldname.tag=4;
    [self.view addSubview:textfieldname];
    
    textfieldxiaoqu = [[UITextField alloc] initWithFrame:CGRectMake(10, 64+55, kScreen_Width, 55)];
    textfieldxiaoqu.placeholder = @"小区";
    textfieldxiaoqu.tag=1;
    textfieldxiaoqu.text = _strtwo;
    [self.view addSubview:textfieldxiaoqu];
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake(0, 64+55, kScreen_Width, 55);
    but.backgroundColor = [UIColor clearColor];
    [but addTarget:self action:@selector(selectxiaoqu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];
    
    textfieldaddress = [[UITextField alloc] initWithFrame:CGRectMake(10, 64+55*2, kScreen_Width, 55)];
    textfieldaddress.placeholder = @"详细地址 如：XX号楼XX单元XXX";
    textfieldaddress.text = _strthree;
    textfieldaddress.tag=2;
    [self.view addSubview:textfieldaddress];
    
    textfieldphone = [[UITextField alloc] initWithFrame:CGRectMake(10, 64+55*3, kScreen_Width, 55)];
    textfieldphone.placeholder = @"联系电话";
    textfieldphone.tag=3;
    textfieldphone.text = _strfour;
    [self.view addSubview:textfieldphone];
    
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [[self view] addGestureRecognizer:recognizer];
    
    
    for (int i=1; i<5; i++) {
        UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(0, 64+i*55, kScreen_Width, 1)];
        lineview.backgroundColor = [UIColor blackColor];
        lineview.alpha = 0.1;
        [self.view addSubview:lineview];
    }
}
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    
    UITextField * field1=(UITextField *)[self.view viewWithTag:4];
    
    UITextField * field2=(UITextField *)[self.view viewWithTag:1];
    UITextField * field3=(UITextField *)[self.view viewWithTag:2];
    UITextField * field4=(UITextField *)[self.view viewWithTag:3];
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionDown) {
        
        
        
        NSLog(@"swipe down");
        
        [field1 resignFirstResponder];
        [field2 resignFirstResponder];
        [field3 resignFirstResponder];
        [field4 resignFirstResponder];
    }
}
- (void)selectxiaoqu
{
    XiaoquViewController *xiaoqu = [[XiaoquViewController alloc] init];
    
    xiaoqu.biaojistr = @"1";
    
    [self.navigationController pushViewController:xiaoqu animated:YES];
}
- (void)tijiao
{
    if (textfieldphone.text.length==0||textfieldname.text.length==0||textfieldxiaoqu.text.length==0||textfieldaddress.text.length==0) {
        [MBProgressHUD showToastToView:self.view withText:@"请将信息补充完整"];
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
    NSString *region_idstr = [NSString stringWithFormat:@"%@.%@.%@",str3,str2,str1];
    NSDictionary *dict = nil;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    NSLog(@"%@",_id);
    if (_id==nil) {
        dict = @{@"community_cn":textfieldxiaoqu.text,@"consignee_name":textfieldname.text,@"consignee_mobile":textfieldphone.text,@"doorplate":textfieldaddress.text,@"community_id":str1,@"region_cn":@"山西省.晋中市.榆次区",@"region_id":region_idstr,@"apk_token":uid_username,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
    }else{
        dict = @{@"community_cn":textfieldxiaoqu.text,@"consignee_name":textfieldname.text,@"consignee_mobile":textfieldphone.text,@"doorplate":textfieldaddress.text,@"community_id":_community_id,@"region_cn":@"山西省.晋中市.榆次区",@"region_id":_region_id,@"id":_id,@"apk_token":uid_username,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
    }
    
    NSLog(@"%@",dict);
    
    NSString *urlstr = [API stringByAppendingString:@"userCenter/add_user_address"];
    [manager POST:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changereload" object:nil userInfo:nil];
            [self.navigationController popViewControllerAnimated:YES];
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
