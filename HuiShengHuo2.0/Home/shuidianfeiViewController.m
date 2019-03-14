//
//  shuidianfeiViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/3/9.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "shuidianfeiViewController.h"
#import <AFNetworking.h>
#import "MBProgressHUD+TVAssistant.h"
#import "AllPayViewController.h"
@interface shuidianfeiViewController ()<UITextFieldDelegate>{
    UITextField *TextField;
    UILabel *Zhishu;
    UILabel *Jieyu;
    
    NSString *jieyustring;
    
    NSMutableArray *DataArr;
    
    NSString *room_id;
    NSString *type;
    NSString *amount;
    NSString *community_id;
    NSString *community_name;
    NSString *building_name;
    NSString *unit;
    NSString *code;
    
    MBProgressHUD *_HUD;
}

@end

@implementation shuidianfeiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([_biaoshi isEqualToString:@"shui"]) {
        self.title = @"水费缴费";
    }else{
        self.title = @"电费缴费";
    }
    self.view.backgroundColor = HColor(244, 247, 248);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change:) name:@"wuyejiaofeichenggong" object:nil];
    
    
    [self createui];
    // Do any additional setup after loading the view.
}
- (void)GeneralButtonAction1{
    //初始化进度框，置于当前的View当中
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    
    //如果设置此属性则当前的view置于后台
    //_HUD.dimBackground = YES;
    
    //设置对话框文字
    _HUD.labelText = @"请稍后...";
    _HUD.labelFont = [UIFont systemFontOfSize:14];
    //细节文字
    //_HUD.detailsLabelText = @"请耐心等待";
    
    //显示对话框
    [_HUD showAnimated:YES whileExecutingBlock:^{
        //对话框显示时需要执行的操作
        [self post];
        //sleep(3);
        
    }// 在HUD被隐藏后的回调
       completionBlock:^{
           //操作执行完后取消对话框
           [_HUD removeFromSuperview];
           _HUD = nil;
       }];
}
- (void)GeneralButtonAction{
    //初始化进度框，置于当前的View当中
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    
    //如果设置此属性则当前的view置于后台
    //_HUD.dimBackground = YES;
    
    //设置对话框文字
    _HUD.labelText = @"请稍后...";
    _HUD.labelFont = [UIFont systemFontOfSize:14];
    //细节文字
    //_HUD.detailsLabelText = @"请耐心等待";
    
    //显示对话框
    [_HUD showAnimated:YES whileExecutingBlock:^{
        //对话框显示时需要执行的操作
        //[self post];
        //sleep(2);
        
    }// 在HUD被隐藏后的回调
       completionBlock:^{
           //操作执行完后取消对话框
           [_HUD removeFromSuperview];
           _HUD = nil;
       }];
}
- (void)change:(NSNotification *)user{
    NSLog(@"shauxin");
    [self post];
    TextField.text = nil;
    [MBProgressHUD showToastToView:self.view withText:[user.userInfo objectForKey:@"msg"]];
}
- (void)createui
{
    UILabel *labelsss = [[UILabel alloc] initWithFrame:CGRectMake(15, RECTSTATUS.size.height+44+30, Main_width-30, 15)];
    if ([_biaoshi isEqualToString:@"shui"]) {
        labelsss.text = @"水费余额";
    }else{
        labelsss.text = @"电费余额";
    }
    labelsss.font = font15;
    [self.view addSubview:labelsss];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, RECTSTATUS.size.height+44+55, Main_width-30, 82.5)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    Zhishu = [[UILabel alloc] initWithFrame:CGRectMake(15, 17.5, Main_width-60, 20)];
    Zhishu.backgroundColor = [UIColor whiteColor];
    Zhishu.font = [UIFont systemFontOfSize:15];
    [view addSubview:Zhishu];
    
    Jieyu = [[UILabel alloc] initWithFrame:CGRectMake(15, Zhishu.frame.origin.y+Zhishu.frame.size.height+15, Main_width-60, 30)];
    Jieyu.backgroundColor = [UIColor whiteColor];
    Jieyu.textColor = QIColor;
    Jieyu.font = [UIFont systemFontOfSize:15];
    [view addSubview:Jieyu];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, view.frame.size.height+view.frame.origin.y+20, Main_width-30, 15)];
    label.text = @"充值金额";
    label.font = font15;
    [self.view addSubview:label];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(15, label.frame.origin.y+label.frame.size.height+13, Main_width-30, 42.5)];
    view1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view1];
    TextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, Main_width-50, 42.5)];
    TextField.delegate = self;
    TextField.placeholder = @"输入充值金额(单位/元)";
    TextField.backgroundColor = [UIColor whiteColor];
    TextField.keyboardType = UIKeyboardTypeNumberPad;
    [view1 addSubview:TextField];
    
    UIButton *suer = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:suer];
    suer.backgroundColor = QIColor;
    [suer setTitle:@"支付" forState:UIControlStateNormal];
    suer.frame = CGRectMake(0, Main_Height-49, Main_width, 49);
    [suer addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *zhishu;
    if ([_biaoshi isEqualToString:@"shui"]) {
        zhishu = [NSString stringWithFormat:@"%@",[[_shuidic objectForKey:@"info"] objectForKey:@"Total"]];
    }else{
        zhishu = [NSString stringWithFormat:@"%@",[[_diandic objectForKey:@"info"] objectForKey:@"Total"]];
    }
    
    if ([_biaoshi isEqualToString:@"shui"]) {
        Zhishu.text = [NSString stringWithFormat:@"水表数字:%@",zhishu];
    }else{
        Zhishu.text = [NSString stringWithFormat:@"电表数字:%@",zhishu];
    }
    NSString *jieyu;
    if ([_biaoshi isEqualToString:@"shui"]) {
        jieyu = [NSString stringWithFormat:@"%@",[[_shuidic objectForKey:@"info"] objectForKey:@"SMay_acc"]];
    }else{
        jieyu = [NSString stringWithFormat:@"%@",[[_diandic objectForKey:@"info"] objectForKey:@"DMay_acc"]];
    }
    
    NSLog(@"%@ddddd",jieyu);
    jieyustring = jieyu;
    Jieyu.text = [NSString stringWithFormat:@"余额:%@",jieyu];
    //[_HUD removeFromSuperview];
    NSDictionary *infodict = [[NSDictionary alloc] init];
    infodict = _room_infodic;
    room_id = [infodict objectForKey:@"room_id"];
    if ([_biaoshi isEqualToString:@"shui"]) {
        type = @"36864";
    }else{
        type = @"36865";
    }
    community_id = [infodict objectForKey:@"community_id"];
    community_name = [infodict objectForKey:@"community_name"];
    building_name = [infodict objectForKey:@"building_name"];
    unit = [infodict objectForKey:@"unit"];
    code = [infodict objectForKey:@"code"];
}
- (void)pay
{
    float j = [TextField.text floatValue];
    float i = [jieyustring floatValue] + j;
    float shengyu = 300 - [jieyustring floatValue];
    if (TextField.text.length == 0) {
        [MBProgressHUD showToastToView:self.view withText:@"请输入缴费金额"];
    }else if (j<=0) {
        [MBProgressHUD showToastToView:self.view withText:@"金额必须大于0"];
    }else if (i>300){
        [MBProgressHUD showToastToView:self.view withText:[NSString stringWithFormat:@"您剩余缴费金额上限为:%.2f元",shengyu]];
    } else{
        //1.创建会话管理者
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        //2.封装参数
        
        //NSDictionary *dict = @{@"c_id":[user objectForKey:@"community_id"]};
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
        NSDictionary *dict = @{@"apk_token":uid_username,@"room_id":room_id,@"type":type,@"amount":TextField.text,@"community_id":community_id,@"community_name":community_name,@"building_name":building_name,@"unit":unit,@"code":code,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
       
        NSString *strurl = [API stringByAppendingString:@"property/create_order"];
        [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
            NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
            if ([[responseObject objectForKey:@"status"] integerValue]==1) {
                AllPayViewController *pay = [[AllPayViewController alloc] init];
                pay.order_id = [[responseObject objectForKey:@"data"] objectForKey:@"id"];
                pay.price = [[responseObject objectForKey:@"data"] objectForKey:@"sumvalue"];
                pay.type = @"2";
                pay.shuidianfei = @"shuidianfei";
                pay.rukoubiaoshi = @"shuidianfei";
                [self.navigationController pushViewController:pay animated:YES];
            }else{
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == TextField) {
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
- (void)post
{
    
}
#pragma  mark - textField delegate
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [TextField resignFirstResponder];
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
