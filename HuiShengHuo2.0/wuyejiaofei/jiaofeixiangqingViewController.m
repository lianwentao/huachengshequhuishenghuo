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

@interface jiaofeixiangqingViewController ()<UITextFieldDelegate>
{
    UITableView *_TableView;
    
    NSArray *wuyeArr;
    NSDictionary *dianfeiDic;
    NSDictionary *shuifeiDic;
    NSDictionary *roominfodic;
    
    NSString *is_available;
    
    UIButton *_tmpBtn;
    UIView *shuiview;
    UIView *dianview;
    UITextField *shuitextfield;
    UITextField *diantextfield;
}

@end

@implementation jiaofeixiangqingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"缴费";
    
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [[self view] addGestureRecognizer:recognizer];
    
    [self getData];
    
    //[self createtableview];
    // Do any additional setup after loading the view.
}

- (void)getData
{
    
    wuyeArr = [NSArray array];
    dianfeiDic = [[NSDictionary alloc] init];
    shuifeiDic = [[NSDictionary alloc] init];
    roominfodic = [[NSDictionary alloc] init];
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[userinfo objectForKey:@"uid"],[userinfo objectForKey:@"username"]]];
    dict = @{@"room_id":_room_id,@"apk_token":uid_username,@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"]};
    NSString *strurl = [API stringByAppendingString:@"property/getBillByRoom"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"--%@--%@---%@--%@",strurl,dict,[responseObject objectForKey:@"msg"],responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            wuyeArr = [[responseObject objectForKey:@"data"] objectForKey:@"wuye"];
            dianfeiDic = [[responseObject objectForKey:@"data"] objectForKey:@"dianfei"];
            shuifeiDic = [[responseObject objectForKey:@"data"] objectForKey:@"shuifei"];
            roominfodic = [[responseObject objectForKey:@"data"] objectForKey:@"room_info"];
            is_available = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"is_available"]];
            
            [self createUI];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
- (void)createUI
{
    UIView *botomview = [[UIView alloc] initWithFrame:CGRectMake(0, Main_Height-55, Main_width, 55)];
    botomview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:botomview];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, Main_width/3*2, 30)];
    label1.text = @"总额:15215.14元";
    label1.font = font15;
    label1.textColor = QIColor;
    [botomview addSubview:label1];
    
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
    shengyushuifei.text = [NSString stringWithFormat:@"余额：¥%@",[[shuifeiDic objectForKey:@"info"] objectForKey:@"Saccount"]];
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
    shuitextfield.keyboardType = UIKeyboardTypeNumberPad;
    shuitextfield.delegate = self;
    shuitextfield.layer.borderWidth = 1;
    shuitextfield.placeholder = @"请输出充值金额";
    shuitextfield.tag = 1000;
    shuitextfield.layer.borderColor = [UIColor colorWithRed:212/255.0 green:212/255.0 blue:212/255.0 alpha:1].CGColor;
    [shuiview addSubview:shuitextfield];
    
    
    
    dianview = [[UIView alloc] initWithFrame:CGRectMake(0, backview.frame.size.height+backview.frame.origin.y+15, Main_width, 125)];
    dianview.backgroundColor = [UIColor whiteColor];
    [scrolloview addSubview:dianview];
    dianview.hidden = YES;
    
    UILabel *dianlabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 20, 150, 20)];
    dianlabel.text = @"电费";
    dianlabel.font = font18;
    [dianview addSubview:dianlabel];
    
    UILabel *shengyudianfei = [[UILabel alloc] initWithFrame:CGRectMake(Main_width/2, 20, Main_width/2-12, 15)];
    shengyudianfei.text = [NSString stringWithFormat:@"余额：¥%@",[[dianfeiDic objectForKey:@"info"] objectForKey:@"Daccount"]];
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
    diantextfield.layer.borderColor = [UIColor colorWithRed:212/255.0 green:212/255.0 blue:212/255.0 alpha:1].CGColor;
    [dianview addSubview:diantextfield];
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
        }else if (_tmpBtn.tag == 2){
            shuiview.hidden = YES;
            dianview.hidden = NO;
        }else{
            shuiview.hidden = YES;
            dianview.hidden = YES;
        }
    }
}
- (void)suer
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[userinfo objectForKey:@"uid"],[userinfo objectForKey:@"username"]]];
    NSDictionary *dict = @{@"room_id":[roominfodic objectForKey:@"room_id"],@"type":@"36864",@"type_cn":[shuifeiDic objectForKey:@"type_cn"],@"amount":@"100",@"apk_token":uid_username,@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"]};
    NSString *strurl = [API stringByAppendingString:@"property/create_order"];
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success==%@==%@",[responseObject objectForKey:@"msg"],responseObject);
        //_Dic = [[NSMutableDictionary alloc] init];
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            newsuerViewController *newsuer = [[newsuerViewController alloc] init];
            [self.navigationController pushViewController:newsuer animated:YES];
        }else{
            
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
