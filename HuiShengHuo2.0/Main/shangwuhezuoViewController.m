//
//  shangwuhezuoViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/3/27.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "shangwuhezuoViewController.h"
#import <AFNetworking.h>
#import "MBProgressHUD+TVAssistant.h"
#import "CMInputView.h"
@interface shangwuhezuoViewController ()<UITextViewDelegate,UITextFieldDelegate>
{
    UIScrollView *_scrollview;
    
    UITextField *name;
    UITextField *phone;
}



@property (nonatomic,strong) CMInputView *inputView;

@end

@implementation shangwuhezuoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商务合作";
    
    
    
    [self createtextview];
    // Do any additional setup after loading the view.
}
- (void)createtextview
{
    _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Main_width, Main_Height-49)];
    _scrollview.backgroundColor = BackColor;
    _scrollview.showsVerticalScrollIndicator = NO;
    _scrollview.showsHorizontalScrollIndicator = NO;
    _scrollview.bounces = NO;
    [self.view addSubview:_scrollview];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 25, Main_width-30, 15)];
    label.text = @"请告诉我们您的联系方式";
    [label setFont:font15];
    [_scrollview addSubview:label];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(15, label.frame.size.height+label.frame.origin.y+15, Main_width-30, 50)];
    view1.backgroundColor = [UIColor whiteColor];
    [_scrollview addSubview:view1];
    
    name = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, Main_width-30-20, 50)];
    name.placeholder = @" 输入您的姓名"; 
    name.tag = 1001;
    name.delegate = self;
    name.backgroundColor = [UIColor whiteColor];
    [view1 addSubview:name];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(15, view1.frame.size.height+view1.frame.origin.y+8, Main_width-30, 50)];
    view2.backgroundColor = [UIColor whiteColor];
    [_scrollview addSubview:view2];
    
    phone = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, Main_width-30-20, 50)];
    phone.placeholder = @" 手机号";
    phone.tag = 1002;
    phone.delegate = self;
    phone.keyboardType = UIKeyboardTypeNumberPad;
    phone.backgroundColor = [UIColor whiteColor];
    [view2 addSubview:phone];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, view2.frame.size.height+view2.frame.origin.y+25, Main_width-30, 25)];
    label1.text = @"请告诉我们您的合作意向,稍后有专人与您联系";
    [label1 setFont:font15];
    [_scrollview addSubview:label1];
    
    _inputView = [[CMInputView alloc]initWithFrame:CGRectMake(15, label1.frame.size.height+label1.frame.origin.y+12.5, Main_width-30, 195)];
    _inputView.font = [UIFont systemFontOfSize:15];
    _inputView.delegate = self;
    _inputView.placeholder = @"写在这里...";
    _inputView.placeholderFont = [UIFont systemFontOfSize:15];
    _inputView.cornerRadius = 4;
    _inputView.maxNumberOfLines = 10;
    _inputView.tag = 1000;
    [_scrollview addSubview:_inputView];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, _inputView.frame.origin.y + 15 + _inputView.frame.size.height, Main_width, 30)];
    label2.text = @"i您可以致电客服中心:400-6535-355";
    label2.alpha = 0.6;
    label2.textAlignment = NSTextAlignmentCenter;
    [_scrollview addSubview:label2];
    
    UIButton *shangwu = [UIButton buttonWithType:UIButtonTypeCustom];
    shangwu.frame = CGRectMake(0, Main_Height-64-49, Main_width, 49);
    [shangwu addTarget:self action:@selector(shangwu) forControlEvents:UIControlEventTouchUpInside];
    [shangwu.titleLabel setFont:[UIFont systemFontOfSize:18]];
    shangwu.backgroundColor = QIColor;
    [shangwu setTitle:@"提交" forState:UIControlStateNormal];
    [self.view addSubview:shangwu];
    
    _scrollview.contentSize = CGSizeMake(Main_width, Main_Height-49);
    
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [[self view] addGestureRecognizer:recognizer];
}
- (void)shangwu
{
    if ([_inputView.text isEqualToString:@""]) {
        [MBProgressHUD showToastToView:self.view withText:@"内容不能为空"];
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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = @{@"content":_inputView.text,@"type":@"2",@"name":name.text,@"mobile":phone.text,@"token":[defaults objectForKey:@"token"],@"tokenSecret":[defaults objectForKey:@"tokenSecret"]};
   
    NSString *strurl = [API stringByAppendingString:@"userCenter/my_opinion"];
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"success==%@==%@",[responseObject objectForKey:@"msg"],responseObject);
        
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            [MBProgressHUD showToastToView:self.view withText:@"提交成功"];
            [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
        }else{
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
        [MBProgressHUD showToastToView:self.view withText:@"提交失败"];
    }];
}

- (void)delayMethod
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma  mark - textField delegate
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"点击空白");
    [name endEditing:YES];
    [phone endEditing:YES];
    [_inputView endEditing:YES];
}
//点击空白处的手势要实现的方法
-(void)viewTapped:(UISwipeGestureRecognizer *)recognizer
{
    CMInputView * field3=(CMInputView *)[self.view viewWithTag:1000];
    UITextField *field1 = (UITextField *)[self.view viewWithTag:1001];
    UITextField *field2 = (UITextField *)[self.view viewWithTag:1002];
    if(recognizer.direction==UISwipeGestureRecognizerDirectionDown) {
        
        
        
        NSLog(@"swipe down");
        [field1 resignFirstResponder];
        [field2 resignFirstResponder];
        [field3 resignFirstResponder];
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
