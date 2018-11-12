//
//  yijianfankuiViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/3/20.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "yijianfankuiViewController.h"
#import <AFNetworking.h>
#import "CMInputView.h"
#import "MBProgressHUD+TVAssistant.h"

#import "gamesViewController.h"
@interface yijianfankuiViewController ()<UITextViewDelegate>


@property (nonatomic,strong) CMInputView *inputView;
@end

@implementation yijianfankuiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    self.view.backgroundColor = BackColor;
    
    
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [[self view] addGestureRecognizer:recognizer];
    [self createtextview];
    // Do any additional setup after loading the view.
}
- (void)createtextview
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 8+RECTSTATUS.size.height+44, Main_width-30, 195)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 4;
    [self.view addSubview:view];
    
    _inputView = [[CMInputView alloc]initWithFrame:CGRectMake(10, 0, Main_width-30-20, 195)];
    _inputView.font = [UIFont systemFontOfSize:15];
    _inputView.delegate = self;
    _inputView.placeholder = @"告诉我们您的建议...";
    _inputView.placeholderFont = [UIFont systemFontOfSize:15];
    _inputView.cornerRadius = 4;
    _inputView.maxNumberOfLines = 10;
    _inputView.tag = 1000;
    [view addSubview:_inputView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, view.frame.origin.y + 15 + view.frame.size.height, Main_width, 30)];
    label.text = @"i您可以致电客服中心:400-6535-355";
    label.alpha = 0.6;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    UIButton *fankuibut = [UIButton buttonWithType:UIButtonTypeCustom];
    fankuibut.frame = CGRectMake(0, Main_Height-49, Main_width, 49);
    [fankuibut addTarget:self action:@selector(fankui) forControlEvents:UIControlEventTouchUpInside];
    [fankuibut.titleLabel setFont:[UIFont systemFontOfSize:18]];
    fankuibut.backgroundColor = QIColor;
    [fankuibut setTitle:@"提交" forState:UIControlStateNormal];
    [self.view addSubview:fankuibut];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(butlong:)];
    
    longPress.minimumPressDuration = 2.0; //定义按的时间
    
    [fankuibut addGestureRecognizer:longPress];
}
#pragma  mark - textField delegate
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"点击空白");
    [_inputView endEditing:YES];
}
//点击空白处的手势要实现的方法
-(void)viewTapped:(UISwipeGestureRecognizer *)recognizer
{
    CMInputView * field3=(CMInputView *)[self.view viewWithTag:1000];
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionDown) {
        
        
        
        NSLog(@"swipe down");
        
        
        [field3 resignFirstResponder];
    }
    
}
#pragma mark - 长按,这是一个小彩蛋~么么哒

-(void)butlong:(UILongPressGestureRecognizer *)gestureRecognizer{
    
   if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
       UIAlertController*alert = [UIAlertController
                                  alertControllerWithTitle:@"呵呵"
                                  message: @"年轻人,你竟然能找到这里,我们很有缘呐,进来耍耍？"
                                  preferredStyle:UIAlertControllerStyleAlert];
       
       [alert addAction:[UIAlertAction
                         actionWithTitle:@"不去了"
                         style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                         {
                             
                         }]];
       [alert addAction:[UIAlertAction
                         actionWithTitle:@"走着~"
                         style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                         {
                             [self.navigationController pushViewController:[gamesViewController new] animated:YES];
                         }]];
       //弹出提示框
       [self presentViewController:alert
                          animated:YES completion:nil];
   }
}

- (void)fankui
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
    NSDictionary *dict = @{@"content":_inputView.text,@"type":@"1",@"token":[defaults objectForKey:@"token"],@"tokenSecret":[defaults objectForKey:@"tokenSecret"]};
    NSString *strurl = [API stringByAppendingString:@"userCenter/my_opinion"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"success==%@==%@",[responseObject objectForKey:@"msg"],responseObject);
        
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            [MBProgressHUD showToastToView:self.view withText:@"反馈成功"];
            [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
            
        }else{
           [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
        [MBProgressHUD showToastToView:self.view withText:@"反馈失败"];
    }];
}
- (void)delayMethod
{
    [self.navigationController popViewControllerAnimated:YES];
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
