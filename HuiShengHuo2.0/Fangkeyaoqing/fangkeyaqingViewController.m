//
//  fangkeyaqingViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/3/21.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "fangkeyaqingViewController.h"
#import "fangkejiluViewController.h"
#import "LSXAlertInputView.h"
#import "MBProgressHUD+TVAssistant.h"

#import "showerweimaViewController.h"
#import "showtongxingzhengViewController.h"
#import "AJBDoor.h"
#import "CoreBluetooth/CoreBluetooth.h"
@interface fangkeyaqingViewController ()<AJBCustomCodeDataDelegate,AJBPassRecodeDataDelegate>


/* 业主开门数据对象 **/
@property (nonatomic,strong) AJBCustomCodeData *customData;
/* 访客记录 **/
@property (nonatomic,strong) AJBPassRecodeData *passRecodeData;




/* 业主开门数据对象 **/
@property (nonatomic,strong) AJBOwnerQRData *ownerData;

@end

@implementation fangkeyaqingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邀请访客";
    self.view.backgroundColor = BackColor;
    
    [self createrightbutton];
    [self CreateUI];
    // Do any additional setup after loading the view.
}


- (void)createrightbutton
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"记录" style:UIBarButtonItemStylePlain target:self action:@selector(issueBton)];
}
- (void)issueBton
{
    [self.passRecodeData RequestDataWithUserId:[_Dic objectForKey:@"mobile"] estatecode:[_Dic objectForKey:@"community"] housecode:[NSString stringWithFormat:@"%@%@",[_Dic objectForKey:@"building"],[_Dic objectForKey:@"room_code"]]];
}
- (void)CreateUI
{
    UIView *view1 = [[UIView alloc] init];
    view1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view1];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, Main_width, 25)];
    label1.text = @"二维码";
    label1.textAlignment = NSTextAlignmentCenter;
    [label1 setFont:font18];
    [view1 addSubview:label1];
    
    UIImageView *imageview1 = [[UIImageView alloc] initWithFrame:CGRectMake((Main_width-Main_width/3.5)/2, label1.frame.size.height+label1.frame.origin.y+20, Main_width/3.5, Main_width/3.5)];
    imageview1.image = [UIImage imageNamed:@"erweima"];
    [view1 addSubview:imageview1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, imageview1.frame.size.height+imageview1.frame.origin.y+20, Main_width, 25)];
    [label2 setFont:nomalfont];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.text = @"i为您的亲友创建临时开门的二维码";
    [view1 addSubview:label2];
    
    view1.frame = CGRectMake(0, 16+RECTSTATUS.size.height+44, Main_width, label2.frame.origin.y+25+30);
    NSLog(@"%f",label2.frame.origin.y+25+30);
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, view1.frame.size.height+view1.frame.origin.y+16, Main_width, view1.frame.size.height)];
    view2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, Main_width, 25)];
    label3.text = @"6位通行证";
    label3.textAlignment = NSTextAlignmentCenter;
    [label3 setFont:font18];
    [view2 addSubview:label3];
    
    UIImageView *imageview2 = [[UIImageView alloc] initWithFrame:CGRectMake((Main_width-Main_width/3.5)/2, label3.frame.size.height+label3.frame.origin.y+20, Main_width/3.5, Main_width/3.5)];
    imageview2.image = [UIImage imageNamed:@"tongxingma"];
    [view2 addSubview:imageview2];
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(0, imageview2.frame.size.height+imageview2.frame.origin.y+20, Main_width, 25)];
    [label4 setFont:nomalfont];
    label4.textAlignment = NSTextAlignmentCenter;
    label4.text = @"i为您的亲友创建临时开门的6位通行证";
    [view2 addSubview:label4];
    
    UIButton *but1 = [UIButton buttonWithType:UIButtonTypeCustom];
    but1.frame = view1.frame;
    but1.tag = 1000;
    [but1 addTarget:self action:@selector(erweimatongxingzheng:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but1];
    
    UIButton *but2 = [UIButton buttonWithType:UIButtonTypeCustom];
    but2.frame = view2.frame;
    but2.tag = 1001;
    [but2 addTarget:self action:@selector(erweimatongxingzheng:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but2];
}
- (void)erweimatongxingzheng:(UIButton *)sender
{
    LSXAlertInputView * alert=[[LSXAlertInputView alloc]initWithTitle:@"生成通行码" PlaceholderText:@"请输入访客姓名" WithKeybordType:LSXKeyboardTypeDefault CompleteBlock:^(NSString *contents) {
        NSLog(@"contents==asdjhjasdaksda");
        if (![contents isEqualToString:@""]) {
            if (sender.tag==1000) {
                //二维码
                [self.customData RequestQRDataWithUserId:[_Dic objectForKey:@"mobile"] estatecode:[_Dic objectForKey:@"community"] housecode:[NSString stringWithFormat:@"%@%@",[_Dic objectForKey:@"building"],[_Dic objectForKey:@"room_code"]]  guestName:contents];
            }else{
                //通行证
                [self.customData RequestTemPassDataWithUserId:[_Dic objectForKey:@"mobile"] estatecode:[_Dic objectForKey:@"community"] housecode:[NSString stringWithFormat:@"%@%@",[_Dic objectForKey:@"building"],[_Dic objectForKey:@"room_code"]] guestName:contents];
            }
        }else{
            [MBProgressHUD showToastToView:self.view withText:@"邀请人不能为空"];
        }
    }];
    [alert show];
}
#pragma mark - 访客二维码和通行证和记录
#pragma mark - AJBCustomCodeDataDelegate
/// 加载数据成功 key 是数据
- (void)AJBCustomCodeDataDidLoadData:(NSDictionary *)dict{
    NSLog(@"--------key:%@",dict);
    NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"isQRorTP"]];
    if ([str isEqualToString:@"1"]) {
        showtongxingzhengViewController *tongxingzheng = [[showtongxingzhengViewController alloc] init];
        tongxingzheng.Password = [dict objectForKey:@"tempPass"];
        tongxingzheng.valiateTime = [dict objectForKey:@"valiateTime"];
        [self.navigationController pushViewController:tongxingzheng animated:YES];
    }else{
        showerweimaViewController *erweima = [[showerweimaViewController alloc] init];
        erweima.erweimaxinxi = [dict objectForKey:@"tempPass"];
        erweima.valiateTime = [dict objectForKey:@"valiateTime"];
        [self.navigationController pushViewController:erweima animated:YES];
    }
}
/// 加载数据失败 Msg  是错误信息
- (void)AJBCustomCodeDataDidFailLoadData:(NSString *)Msg{
    NSLog(@"Msg:%@",Msg);
}

#pragma mark - AJBPassRecodeDataDelegate

/// 加载数据成功 keys 是数据数组
- (void)AJBPassRecodeDataDidLoadData:(NSArray *)keys{
    NSLog(@"keys:%@",keys);
    fangkejiluViewController *fangke = [[fangkejiluViewController alloc] init];
    fangke.KeysArr = keys;
    [self.navigationController pushViewController:fangke animated:YES];
}

/// 加载数据失败 Msg  是错误信息
- (void)AJBPassRecodeDataDidFailLoadData:(NSString *)Msg{
    NSLog(@"Msg:%@",Msg);
}
#pragma mark -  set && get

- (AJBCustomCodeData *)customData{
    if (!_customData) {
        _customData = [[AJBCustomCodeData alloc] initWithHost:@"http://47.104.92.9" Port:8080];
        _customData.delegate = self;
    }
    return _customData;
}

- (AJBPassRecodeData *)passRecodeData{
    if (!_passRecodeData) {
        _passRecodeData = [[AJBPassRecodeData alloc] initWithHost:@"http://47.104.92.9" Port:8080];
        _passRecodeData.delegate = self;
    }
    return _passRecodeData;
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
