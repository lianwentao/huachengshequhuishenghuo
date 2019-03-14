//
//  changepasswordViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/1/13.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "changepasswordViewController.h"
#import <AFNetworking.h>
#import "MBProgressHUD+TVAssistant.h"
#define kScreen_Height   ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width    ([UIScreen mainScreen].bounds.size.width)
#import "PrefixHeader.pch"

@interface changepasswordViewController ()<UITextFieldDelegate>
{
    UITextField *_textField1;
    UITextField *_textField2;
}

@end

@implementation changepasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self addRightBtn];
    [self createui];
    // Do any additional setup after loading the view.
}
#pragma mark - 导航栏rightbutton
- (void)addRightBtn
{
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(tijiao)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}
- (void)tijiao
{
    if (_textField1.text!=_textField2.text) {
        [MBProgressHUD showToastToView:self.view withText:@"俩次密码输入不一致"];
    }else if (_textField1.text.length<6){
        [MBProgressHUD showToastToView:self.view withText:@"密码不能少于6位"];
    }else{
        [self post];
    }
}
- (void)createui
{
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, rectStatus.size.height+50, kScreen_Width, 50)];
    view1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view1];
    _textField1 = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, kScreen_Width-20, 50)];
    _textField1.placeholder = @"设置新密码";
    _textField1.delegate = self;
    _textField1.backgroundColor = [UIColor whiteColor];
    _textField1.tag = 1000;
    [view1 addSubview:_textField1];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, rectStatus.size.height+50+55, kScreen_Width, 50)];
    view2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view2];
    _textField2 = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, kScreen_Width-20, 50)];
    _textField2.placeholder = @"确认新密码";
    _textField2.delegate = self;
    _textField2.backgroundColor = [UIColor whiteColor];
    _textField2.tag = 1001;
    [view2 addSubview:_textField2];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, rectStatus.size.height+50+55+55, kScreen_Width-20, 25)];
    label.text = @"密码至少要6位数,且包含数字和字母";
    label.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label];
    
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [[self view] addGestureRecognizer:recognizer];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == _textField1||textField == _textField2) {
        NSUInteger lengthOfString = string.length;  //lengthOfString的值始终为1
        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
            unichar character = [string characterAtIndex:loopIndex]; //将输入的值转化为ASCII值（即内部索引值），可以参考ASCII表
            // 48-57;{0,9};65-90;{A..Z};97-122:{a..z}
            if (character < 48) return NO; // 48 unichar for 0
            if (character > 57 && character < 65) return NO; //
            if (character > 90 && character < 97) return NO;
            if (character > 122) return NO;
            
        }
        // Check for total length
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if (proposedNewLength > 16) {
            return NO;//限制长度
        }
        return YES;
    }
    return YES;
}
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    
    UITextField * field3=(UITextField *)[self.view viewWithTag:1000];
    UITextField * field4=(UITextField *)[self.view viewWithTag:1001];
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionDown) {
        
        
        
        NSLog(@"swipe down");
        
        
        [field3 resignFirstResponder];
        [field4 resignFirstResponder];
    }
}
#pragma mark ------联网请求---
-(void)post
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    NSDictionary *dict = @{@"password_one":_textField1.text,@"password_two":_textField2.text,@"apk_token":uid_username,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *API = [defaults objectForKey:@"API"];
    NSString *urlstr = [API stringByAppendingString:@"userCenter/account"];
    [manager POST:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success--%@--%@",[responseObject class],responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
           [MBProgressHUD showToastToView:self.view withText:@"修改密码成功"];
            NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
            [userinfo removeObjectForKey:@"pwd"];
            [userinfo setObject:_textField1.text forKey:@"pwd"];
            [userinfo synchronize];
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
        [MBProgressHUD showToastToView:self.view withText:@"修改密码失败"];
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
