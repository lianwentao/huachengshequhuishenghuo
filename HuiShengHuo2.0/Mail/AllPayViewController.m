//
//  AllPayViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/11/27.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import "AllPayViewController.h"
#import "WXApi.h"
#import <AFNetworking.h>
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+TVAssistant.h"
#import "yikatongViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "dingdanViewController.h"
#import "fuwudingdanViewController.h"
#import "GouwucheViewController.h"
#import "ScanViewController.h"
#import "BestpaySDK.h"
#import "BestpayNativeModel.h"
#import "myserviceViewController.h"
#import "MD5.h"
#import <Security/Security.h>
#import "GoodsDetailViewController.h"
#import "FacepaysuessViewController.h"
#import "FacepayjiluViewController.h"
#import "jiatingjiaofeijiluViewController.h"
#import "FacePayViewController.h"
#import "jiatingzhangdanViewController.h"
#import "shuidianfeiViewController.h"
#import "youxianjiaofeiViewController.h"
#import "youxianjiaofeijiluViewController.h"
#import "newwuyejiaofeijiluViewController.h"
#import "mywuyegongdanViewController.h"
#import "orderDetailsViewController.h"
#define kScreen_Height   ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width    ([UIScreen mainScreen].bounds.size.width)
#import "PrefixHeader.pch"
@interface AllPayViewController ()<UIPopoverBackgroundViewMethods,NSURLConnectionDelegate>
{
    NSMutableArray *_DataArr;
    NSString *KEYSTR;
    NSString *MERID;
    NSString *PSWD;
    NSMutableDictionary *_Dic;
    NSString *str;
    
    MBProgressHUD *_HUD;
}
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, copy)   NSString *encodeOrderStr;
@property (nonatomic, strong) NSMutableData *receiveData;
@property (nonatomic, strong) NSURLConnection *connection;
@end

@implementation AllPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change) name:@"sendmsgsure" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(send) name:@"sendmsgerror" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alichange:) name:@"alisendmsgsure" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alisend:) name:@"alisendmsgerror" object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    [self post];
    
}

#pragma mark ------联网请求---
-(void)post{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数

    //3.发送GET请求
    /*
     第一个参数:请求路径(NSString)+ 不需要加参数
     第二个参数:发送给服务器的参数数据
     第三个参数:progress 进度回调
     第四个参数:success  成功之后的回调(此处的成功或者是失败指的是整个请求)
     task:请求任务
     responseObject:注意!!!响应体信息--->(json--->oc))
     task.response: 响应头信息
     第五个参数:failure 失败之后的回调
     */
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    NSDictionary *dict = @{@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
   
    NSString *strurl = [API stringByAppendingString:@"site/payment_list"];
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            
            _DataArr = [[NSMutableArray alloc] init];
            _DataArr = [responseObject objectForKey:@"data"];
            [self createui];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
-(BOOL)navigationShouldPopOnBackButton {
    [self backBtnClicked];

    return YES;
}
- (void)backBtnClicked
{
    UIAlertController*alert = [UIAlertController
                               alertControllerWithTitle: nil
                               message: @"是否确认放弃付款"
                               preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction
                      actionWithTitle:@"取消"
                      style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                      {
                          
                      }]];
    [alert addAction:[UIAlertAction
                      actionWithTitle:@"确定"
                      style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                      {
                          [self chevsuess];
                          if ([_rukoubiaoshi isEqualToString:@"jiatingzhangdan"]) {
                              //shuidianfei
                              [self.navigationController popViewControllerAnimated:YES];
                          }else if ([_rukoubiaoshi isEqualToString:@"shuidianfei"]){
                              for (UIViewController *controller in self.navigationController.viewControllers) {
                                  if ([controller isKindOfClass:[shuidianfeiViewController class]]) {
                                      shuidianfeiViewController *revise =(shuidianfeiViewController *)controller;
                                      [self.navigationController popToViewController:revise animated:YES];
                                  }
                              }
                              [self chevsuess];
                          }else if ([_rukoubiaoshi isEqualToString:@"facepay"]){
                              NSLog(@"---------facepay");
                              for (UIViewController *controller in self.navigationController.viewControllers) {
                                  if ([controller isKindOfClass:[FacePayViewController class]]) {
                                      FacePayViewController *facepay =(FacePayViewController *)controller;
                                      [self.navigationController popToViewController:facepay animated:YES];
                                  }
                              }
                              [self chevsuess];
                          }else if ([_rukoubiaoshi isEqualToString:@"youxianjiaofei"]){
                              NSLog(@"---------youxian");
                              for (UIViewController *controller in self.navigationController.viewControllers) {
                                  if ([controller isKindOfClass:[youxianjiaofeiViewController class]]) {
                                      youxianjiaofeiViewController *facepay =(youxianjiaofeiViewController *)controller;
                                      [self.navigationController popToViewController:facepay animated:YES];
                                  }
                              }
                              [self chevsuess];
                          }else if ([_rukoubiaoshi isEqualToString:@"scanjiaofei"]){
                              NSLog(@"---------扫描付款");
//                              for (UIViewController *controller in self.navigationController.viewControllers) {
//                                  if ([controller isKindOfClass:[ScanViewController class]]) {
//                                      ScanViewController *scan =(ScanViewController *)controller;
//                                      [self.navigationController popToViewController:scan animated:YES];
//                                  }
//                              }
                              [self.navigationController popToRootViewControllerAnimated:YES];
                              [self chevsuess];
                          }else if ([_rukoubiaoshi isEqualToString:@"wuyegongdanfukuan"]){
                              NSLog(@"---------物业工单预付款");
                              
                              if ([_prepayrukou isEqualToString:@"1"]) {
                                  for (UIViewController *controller in self.navigationController.viewControllers) {
                                      if ([controller isKindOfClass:[orderDetailsViewController class]]) {
                                          orderDetailsViewController *vc =(orderDetailsViewController *)controller;
                                          [self.navigationController popToViewController:vc animated:YES];
                                      }
                                  }
                                  [[NSNotificationCenter defaultCenter] postNotificationName:@"shuaxinwuyegongdanxiangqing" object:nil userInfo:nil];
                              }else{
                                  mywuyegongdanViewController *vc = [[mywuyegongdanViewController alloc] init];
                                  [self.navigationController pushViewController:vc animated:YES];
                              }
                          } else{
                              UIViewController *viewc = self.navigationController.viewControllers[1];
                              [[NSNotificationCenter defaultCenter] postNotificationName:@"shuaxingouwuche" object:nil userInfo:nil];
                              [self.navigationController popToViewController:viewc animated:YES];
                          }
                      }]];
    //弹出提示框
    [self presentViewController:alert
                       animated:YES completion:nil];
}


- (void)change
{
    //[MBProgressHUD showToastToView:self.view withText:@"支付成功"];
    if ([_type isEqualToString:@"aciti"]) {
        fuwudingdanViewController *fuwu = [[fuwudingdanViewController alloc] init];
        if ([_c_id isEqualToString:@"119"]) {
            fuwu.but_tag = @"1";
        }else if ([_c_id isEqualToString:@"116"]) {
            fuwu.but_tag = @"2";
        }
        [self.navigationController pushViewController:fuwu animated:YES];
    }else if ([_type isEqualToString:@"2"]){
        newwuyejiaofeijiluViewController *jilu = [[newwuyejiaofeijiluViewController alloc] init];
        [self.navigationController pushViewController:jilu animated:YES];
        //
    }else if ([_type isEqualToString:@"facepay"]){
        NSLog(@"*********----facepay");
        FacepayjiluViewController *jilu = [[FacepayjiluViewController alloc] init];
        [self.navigationController pushViewController:jilu animated:YES];
    }else if ([_type isEqualToString:@"youxianjiaofei"]){
        NSLog(@"*********----youxian");
        //        FacepaysuessViewController *facesuess = [[FacepaysuessViewController alloc] init];
        //        [self.navigationController pushViewController:facesuess animated:YES];
        youxianjiaofeijiluViewController *jilu = [[youxianjiaofeijiluViewController alloc] init];
        [self.navigationController pushViewController:jilu animated:YES];
    }else if ([_type isEqualToString:@"newservicescan"]){
        NSLog(@"*********----newservicescan");
        myserviceViewController *myserve = [[myserviceViewController alloc] init];
        [self.navigationController pushViewController:myserve animated:YES];
    }else if ([_type isEqualToString:@"wuyegongdanfukuan"]){
        NSLog(@"*********----wuyegongdanfukuan");
        mywuyegongdanViewController *vc = [[mywuyegongdanViewController alloc] init];
        if ([_prepay isEqualToString:@"1"]) {
            vc.titleselect = @"0";
            [self dingdantuisong:_order_id];
        }else{
            vc.titleselect = @"1";
        }
        
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        dingdanViewController *dingdan = [[dingdanViewController alloc] init];
        dingdan.but_tag = @"2";
        [self.navigationController pushViewController:dingdan animated:YES];
    }
    [self GeneralButtonAction1];
}
- (void)send
{
    if ([_type isEqualToString:@"2"]) {
        if ([_shuidianfei
             isEqualToString:@"shuidianfei"]) {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[shuidianfeiViewController class]]) {
                    shuidianfeiViewController *revise =(shuidianfeiViewController *)controller;
                    [self.navigationController popToViewController:revise animated:YES];
                }
            }
        }else{
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[jiatingzhangdanViewController class]]) {
                    jiatingzhangdanViewController *revise =(jiatingzhangdanViewController *)controller;
                    [self.navigationController popToViewController:revise animated:YES];
                }
            }
        }
    }else if ([_type isEqualToString:@"aciti"]){
        
    }else if ([_type isEqualToString:@"facepay"]){
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[FacePayViewController class]]) {
                FacePayViewController *revise =(FacePayViewController *)controller;
                [self.navigationController popToViewController:revise animated:YES];
            }
        }
    }else if ([_type isEqualToString:@"youxianjiaofei"]){
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[youxianjiaofeiViewController class]]) {
                youxianjiaofeiViewController *revise =(youxianjiaofeiViewController *)controller;
                [self.navigationController popToViewController:revise animated:YES];
            }
        }
    }else if ([_type isEqualToString:@"wuyegongdanfukuan"]){
        NSLog(@"*********----wuyegongdanfukuan");
        mywuyegongdanViewController *vc = [[mywuyegongdanViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
    }
    [MBProgressHUD showToastToView:self.view withText:@"支付失败"];
}


- (void)alichange:(NSNotification *)user
{
    NSLog(@"%@",[[user userInfo] objectForKey:@"memo"]);
    //[MBProgressHUD showToastToView:self.view withText:@"支付成功"];
    if ([_type isEqualToString:@"aciti"]) {
        fuwudingdanViewController *fuwu = [[fuwudingdanViewController alloc] init];
        if ([_c_id isEqualToString:@"119"]) {
            fuwu.but_tag = @"1";
        }else if ([_c_id isEqualToString:@"116"]) {
            fuwu.but_tag = @"2";
        }else{
            fuwu.but_tag = @"0";
        }
        [self.navigationController pushViewController:fuwu animated:YES];
    }else if ([_type isEqualToString:@"2"]){
        newwuyejiaofeijiluViewController *jilu = [[newwuyejiaofeijiluViewController alloc] init];
        [self.navigationController pushViewController:jilu animated:YES];
    }else if ([_type isEqualToString:@"facepay"]){
        NSLog(@"*********----facepay");
//        FacepaysuessViewController *facesuess = [[FacepaysuessViewController alloc] init];
//        [self.navigationController pushViewController:facesuess animated:YES];
        FacepayjiluViewController *jilu = [[FacepayjiluViewController alloc] init];
        [self.navigationController pushViewController:jilu animated:YES];
    }else if ([_type isEqualToString:@"youxianjiaofei"]){
        NSLog(@"*********----facepay");
        //        FacepaysuessViewController *facesuess = [[FacepaysuessViewController alloc] init];
        //        [self.navigationController pushViewController:facesuess animated:YES];
        youxianjiaofeijiluViewController *jilu = [[youxianjiaofeijiluViewController alloc] init];
        [self.navigationController pushViewController:jilu animated:YES];
    }else if ([_type isEqualToString:@"newservicescan"]){
        NSLog(@"*********----newservicescan");
        myserviceViewController *myserve = [[myserviceViewController alloc] init];
        [self.navigationController pushViewController:myserve animated:YES];
    }else if ([_type isEqualToString:@"wuyegongdanfukuan"]){
        NSLog(@"*********----wuyegongdanfukuan");
        mywuyegongdanViewController *vc = [[mywuyegongdanViewController alloc] init];
        if ([_prepay isEqualToString:@"1"]) {
            vc.titleselect = @"0";
            [self dingdantuisong:_order_id];
        }else{
            vc.titleselect = @"1";
        }
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        dingdanViewController *dingdan = [[dingdanViewController alloc] init];
        dingdan.but_tag = @"2";
        [self.navigationController pushViewController:dingdan animated:YES];
    }
    [self GeneralButtonAction1];
}
- (void)dingdantuisong:(NSString *)gongdanid
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
   
    NSString *url = [API stringByAppendingString:@"Jpush/userToWorkerSubmit"];
    NSDictionary *dict = [[NSDictionary alloc] init];
    dict = @{@"id":gongdanid,@"type":@"1"};
    
    NSLog(@"dict--%@",dict);
    [manager POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        WBLog(@"location--%@--%@",[responseObject class],responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"failure--%@",error);
    }];
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
        [self chevsuess];
        sleep(10);
    }// 在HUD被隐藏后的回调
       completionBlock:^{
           //操作执行完后取消对话框
           [_HUD removeFromSuperview];
           _HUD = nil;
       }];
}
- (void)chevsuess
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSLog(@"--type%@--%@",_type,_order_id);
    NSString *type;
    if ([_type isEqualToString:@"2"]) {
        type = @"property";
    }else if ([_type isEqualToString:@"aciti"]){
        type = @"activity";
    }else if ([_type isEqualToString:@"facepay"]){
        type = @"face";
    }else if ([_type isEqualToString:@"youxianjiaofei"]){
        type = @"wired";
    }else if ([_type isEqualToString:@"newservicescan"]){
        type = @"serve";
    }else if ([_type isEqualToString:@"wuyegongdanfukuan"]){
        type = @"work";
    }else{
        type = @"shop";
    }
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    //,@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"]
    NSDictionary *dict = @{@"id":_order_id,@"type":type,@"prepay":@"0",@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"],@"hui_community_id":[userinfo objectForKey:@"community_id"]};
    NSLog(@"---dict%@",dict);
    
    NSString *urlstr = [API stringByAppendingString:@"userCenter/confirm_order_payment"];
    [manager POST:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"zhifushifouchenggong--%@--%@--%@",[responseObject objectForKey:@"msg"],responseObject,dict);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            if ([_type isEqualToString:@"2"]) {
//                NSDictionary *dict = @{@"jieguo":@"1",@"msg":[responseObject objectForKey:@"msg"]};
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"wuyejiaofeichenggong" object:nil userInfo:dict];
//                [self.navigationController popViewControllerAnimated:YES];
            }else if ([_type isEqualToString:@"aciti"]){
                
            }else if ([_type isEqualToString:@"facepay"]){
                
            }else if ([_type isEqualToString:@"youxianjiaofei"]){
                
            }else if ([_type isEqualToString:@"newservicescan"]){
                [self postfuwususess];
            }else if ([_type isEqualToString:@"wuyegongdanyufukuan"]){
                
            }else{
                [self postsusess];
                [self postsusess1];
            }
        }else{
//            NSDictionary *dict = @{@"jieguo":@"0",@"msg":[responseObject objectForKey:@"msg"]};
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"wuyejiaofeichenggong" object:nil userInfo:dict];
//            [self.navigationController popViewControllerAnimated:YES];
            //[MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
- (void)alisend:(NSNotification *)user
{
    NSLog(@"%@",[[user userInfo] objectForKey:@"memo"]);
    if ([_type isEqualToString:@"2"]) {
        if ([_shuidianfei isEqualToString:@"shuidianfei"]) {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[shuidianfeiViewController class]]) {
                    shuidianfeiViewController *revise =(shuidianfeiViewController *)controller;
                    [self.navigationController popToViewController:revise animated:YES];
                }
            }
        }else{
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[jiatingzhangdanViewController class]]) {
                    jiatingzhangdanViewController *revise =(jiatingzhangdanViewController *)controller;
                    [self.navigationController popToViewController:revise animated:YES];
                }
            }
        }
    }else if ([_type isEqualToString:@"aciti"]){
        
    }else if ([_type isEqualToString:@"facepay"]){
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[FacePayViewController class]]) {
                FacePayViewController *revise =(FacePayViewController *)controller;
                [self.navigationController popToViewController:revise animated:YES];
            }
        }
    }else if ([_type isEqualToString:@"youxianjiaofei"]){
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[youxianjiaofeiViewController class]]) {
                youxianjiaofeiViewController *revise =(youxianjiaofeiViewController *)controller;
                [self.navigationController popToViewController:revise animated:YES];
            }
        }
    }else if ([_type isEqualToString:@"newservicescan"]){
        
    }else if ([_type isEqualToString:@"wuyegongdanyufukuan"]){
        NSLog(@"*********----wuyegongdanyufukuan");
        mywuyegongdanViewController *vc = [[mywuyegongdanViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
    }
    [MBProgressHUD showToastToView:self.view withText:[[user userInfo] objectForKey:@"memo"]];
}


//判断服务订单成功否

-(void)postfuwususess
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSDictionary *dict = @{@"id":_order_id};
    
    NSString *urlstr = [API stringByAppendingString:@"Jpush/service_order_toAmountWorker_push"];
    WBLog(@"%@-****-%@",dict,urlstr);
    [manager GET:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"hhhhhhhhh--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"hhhhhfailure--%@",error);
    }];
}
//判断商城订单成功否
-(void)postsusess
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSDictionary *dict = @{@"id":_order_id};
    
    NSString *urlstr = [API stringByAppendingString:@"site/merchant_push"];
    [manager POST:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"zhifu--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
-(void)postsusess1
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSDictionary *dict = @{@"oid":_order_id};
   
    NSString *urlstr = [API stringByAppendingString:@"Jpush/distribution_push"];
    [manager POST:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"zhifu1--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
- (void)createui
{
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10+44+rectStatus.size.height, kScreen_Width, 40)];
    label1.text = [NSString stringWithFormat:@"需要支付金额:¥%@",_price];
    [self.view addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 55+44+rectStatus.size.height, kScreen_Width, 30)];
    label2.text = @"选择支付方式";
    [self.view addSubview:label2];
    
//    NSArray *arr1 = @[@"微信支付",@"支付宝支付",@"华晟生活一卡通"];
//    NSArray *arr2 = @[@"(无需微信零钱,支持储蓄卡)",@"(无手续费)",@"(无手续费)"];
//    NSArray *arr3 = @[@"wxPayIcon/",@"alipayIcon",@"hc_card1"];
    for (int i=0; i<_DataArr.count; i++) {
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(80, 15+40+55+44+rectStatus.size.height+75*i, kScreen_Width-80, 30)];
        label3.text = [[_DataArr objectAtIndex:i] objectForKey:@"byname"];
        [self.view addSubview:label3];

        UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(80, 35+40+55+44+rectStatus.size.height+75*i, kScreen_Width-80, 30)];
        label4.text = [[_DataArr objectAtIndex:i] objectForKey:@"p_introduction"];
        label4.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:label4];
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10+40+55+44+rectStatus.size.height+i*75, 55, 55)];
        NSString *strurl = [NSString stringWithFormat:@"%@%@",API_img,[[_DataArr objectAtIndex:i] objectForKey:@"icon"]];
        [imageview sd_setImageWithURL:[NSURL URLWithString:strurl]];
        [self.view addSubview:imageview];
        
        UILabel *labelline = [[UILabel alloc] initWithFrame:CGRectMake(0, 40+55+44+rectStatus.size.height+(i+1)*75, kScreen_Width, 1)];
        labelline.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.view addSubview:labelline];
        
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(0, 40+55+44+rectStatus.size.height+1+75*i, kScreen_Width, 75);
        but.backgroundColor = [UIColor clearColor];
        but.tag = [[[_DataArr objectAtIndex:i] objectForKey:@"id"] intValue];
        [but addTarget:self action:@selector(allpays:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:but];
    }
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
        sleep(3);
        
    }// 在HUD被隐藏后的回调
       completionBlock:^{
           //操作执行完后取消对话框
           [_HUD removeFromSuperview];
           _HUD = nil;
       }];
}
-(void)allpays: (UIButton *)sender
{
    if (sender.tag==2) {
        [self GeneralButtonAction];
        [self postweixin];
    }if (sender.tag==4) {
        yikatongViewController *yikatong = [[yikatongViewController alloc] init];
        yikatong.hidesBottomBarWhenPushed = YES;
        yikatong.id = _order_id;
        yikatong.price = _price;
        yikatong.prepay = _prepay;
        if ([_type isEqualToString:@"aciti"]) {
            yikatong.otype = @"hd";
        }else if ([_type isEqualToString:@"2"]){
            yikatong.otype = @"wy";
        }else if ([_type isEqualToString:@"facepay"]){
            yikatong.otype = @"dm";
        }else if ([_type isEqualToString:@"youxianjiaofei"]){
            yikatong.otype = @"yx";
        }else if ([_type isEqualToString:@"newservicescan"]){
            yikatong.otype = @"se";
        }else if ([_type isEqualToString:@"wuyegongdanfukuan"]){
             yikatong.otype = @"wo";
        }else{
            yikatong.otype = @"gw";
        }
        [self.navigationController pushViewController:yikatong animated:YES];
    }if (sender.tag==1){
        [self GeneralButtonAction];
        [self postalipay];
    }if (sender.tag==3) {
        [self GeneralButtonAction];
        [self postbsetpay];
    }
}
#pragma mark ----联网请求---
-(void)postweixin
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [[NSDictionary alloc] init];
    if ([_prepay isEqualToString:@"1"]) {
        dict = @{@"prepay":_prepay,@"id":_order_id,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
    }else{
        dict = @{@"id":_order_id,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
    }
    
    NSString *urlstr;
    if ([_type isEqualToString:@"aciti"]) {
        urlstr = [API stringByAppendingString:@"activity/pay_activity_order/typename/wxpay"];
    }else if ([_type isEqualToString:@"2"]){
        urlstr = [API stringByAppendingString:@"property/pay_property_order/typename/wxpay"];
    }else if ([_type isEqualToString:@"facepay"]){
        urlstr = [API stringByAppendingString:@"property/pay_face_order/typename/wxpay"];
    }else if ([_type isEqualToString:@"youxianjiaofei"]){
        urlstr = [API stringByAppendingString:@"property/pay_wired_order/typename/wxpay"];
    }else if ([_type isEqualToString:@"newservicescan"]){
        urlstr = [API_NOAPK stringByAppendingString:@"/service/order/pay_service_order/typename/wxpay"];
    }else if ([_type isEqualToString:@"wuyegongdanfukuan"]){
        urlstr = [API stringByAppendingString:@"propertyWork/pay_work_order/typename/wxpay"];
    }else{//
        urlstr = [API stringByAppendingString:@"userCenter/pay_shopping_order/typename/wxpay"];
    }
    
    [manager POST:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        NSMutableDictionary *dict = [responseObject objectForKey:@"data"];
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"packages"];
        req.sign                = [dict objectForKey:@"paySign"];
        
        //日志输出
        NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            //[MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
            [WXApi sendReq:req];
        }else{
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
-(void)postalipay
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    NSDictionary *dict;
    if ([_prepay isEqualToString:@"1"]) {
        dict = @{@"prepay":_prepay,@"id":_order_id,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
    }else{
        dict = @{@"id":_order_id,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
    }
//     = @{@"id":_order_id,@"apk_token":uid_username,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
    NSString *urlstr;
    
    if ([_type isEqualToString:@"aciti"]) {
        urlstr = [API stringByAppendingString:@"activity/pay_activity_order/typename/alipay"];
    }else if  ([_type isEqualToString:@"2"]){
        urlstr = [API stringByAppendingString:@"property/pay_property_order/typename/alipay"];
    }else if ([_type isEqualToString:@"facepay"]){
        urlstr = [API stringByAppendingString:@"property/pay_face_order/typename/alipay"];
    }else if ([_type isEqualToString:@"youxianjiaofei"]){
        urlstr = [API stringByAppendingString:@"property/pay_wired_order/typename/alipay"];
    }else if ([_type isEqualToString:@"newservicescan"]){
        urlstr = [API_NOAPK stringByAppendingString:@"/service/order/pay_service_order/typename/alipay"];
    }else if ([_type isEqualToString:@"wuyegongdanfukuan"]){
        urlstr = [API stringByAppendingString:@"propertyWork/pay_work_order/typename/alipay"];
    }else{
        urlstr = [API stringByAppendingString:@"userCenter/pay_shopping_order/typename/alipay"];
    }
    [manager POST:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        NSMutableDictionary *dict = [responseObject objectForKey:@"data"];
        //日志输出
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            NSString *appScheme = @"com.huacheng.CommunityWisdomLife";
            NSString * orderString = [responseObject objectForKey:@"data"];
            // NOTE: 调用支付结果开始支付
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                NSLog(@"____________reslut = %@",resultDic);
                
            }];
            //[MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }else{
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
-(void)postbsetpay
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    NSDictionary *dict;
    if ([_prepay isEqualToString:@"1"]) {
        dict = @{@"prepay":_prepay,@"id":_order_id,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
    }else{
        dict = @{@"id":_order_id,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
    }
    
    NSString *urlstr;
    if ([_type isEqualToString:@"aciti"]) {
        urlstr = [API stringByAppendingString:@"activity/pay_activity_order/typename/bestpay"];
    }else if ([_type isEqualToString:@"2"]){
        urlstr = [API stringByAppendingString:@"property/pay_property_order/typename/bestpay"];
    }else if ([_type isEqualToString:@"facepay"]){
        urlstr = [API stringByAppendingString:@"property/pay_face_order/typename/bestpay"];
    }else if ([_type isEqualToString:@"youxianjiaofei"]){
        urlstr = [API stringByAppendingString:@"property/pay_wired_order/typename/bestpay"];
    }else if ([_type isEqualToString:@"newservicescan"]){
        urlstr = [API_NOAPK stringByAppendingString:@"/service/order/pay_service_order/typename/bestpay"];
    }else if ([_type isEqualToString:@"wuyegongdanfukuan"]){
        urlstr = [API stringByAppendingString:@"propertyWork/pay_work_order/typename/bestpay"];
    }else{
        urlstr = [API stringByAppendingString:@"userCenter/pay_shopping_order/typename/bestpay"];
    }
    
    [manager POST:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            KEYSTR = [[responseObject objectForKey:@"data"] objectForKey:@"KEY"];
            MERID = [[responseObject objectForKey:@"data"] objectForKey:@"MERCHANTID"];
            PSWD = [[responseObject objectForKey:@"data"] objectForKey:@"MERCHANTPWD"];
            _Dic = [[NSMutableDictionary alloc] init];
            _Dic = [responseObject objectForKey:@"data"];
            [self submitOrder];
        }else{
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
        [MBProgressHUD showToastToView:self.view withText:@"请求失败"];
    }];
}
- (void)doOrder{
    
    //获取订单信息
    NSString *orderStr = [self orderInfos];
    
    /////////////////////////////////
    NSLog(@"*****************跳转支付页面带入信息：%@", orderStr);
    NSDictionary *dic = [[NSBundle mainBundle] infoDictionary];
    NSArray *urls = [dic objectForKey:@"CFBundleURLTypes"];
    
    BestpayNativeModel *order =[[BestpayNativeModel alloc]init];
    order.orderInfo = orderStr;
    order.launchType = launchTypePay1;
    order.scheme = [[[urls firstObject] objectForKey:@"CFBundleURLSchemes"] firstObject];
    
    //调用sdk的方法
    [BestpaySDK payWithOrder:order fromViewController:self callback:^(NSDictionary *resultDic) {
        //支付成功后回调结果
        NSLog(@"bestpay");
        NSLog(@"result == %@", resultDic);
        switch ([resultDic[@"resultCode"] intValue])
        {
            case 00:
                NSLog(@"************8支付成功");
                [self bestpaysuess];
                break;
                
            case 02:
                [self chevsuess];
                NSLog(@"************8支付取消");
                if ([_type isEqualToString:@"2"]) {
                    if ([_shuidianfei isEqualToString:@"shuidianfei"]) {
                        for (UIViewController *controller in self.navigationController.viewControllers) {
                            if ([controller isKindOfClass:[shuidianfeiViewController class]]) {
                                shuidianfeiViewController *revise =(shuidianfeiViewController *)controller;
                                [self.navigationController popToViewController:revise animated:YES];
                            }
                        }
                    }else{
                        for (UIViewController *controller in self.navigationController.viewControllers) {
                            if ([controller isKindOfClass:[jiatingzhangdanViewController class]]) {
                                jiatingzhangdanViewController *revise =(jiatingzhangdanViewController *)controller;
                                [self.navigationController popToViewController:revise animated:YES];
                            }
                        }
                    }
                }else if ([_type isEqualToString:@"aciti"]){
                    
                }else if ([_type isEqualToString:@"facepay"]){
                    for (UIViewController *controller in self.navigationController.viewControllers) {
                        if ([controller isKindOfClass:[FacePayViewController class]]) {
                            FacePayViewController *revise =(FacePayViewController *)controller;
                            [self.navigationController popToViewController:revise animated:YES];
                        }
                    }
                }else if ([_type isEqualToString:@"youxianjiaofei"]){
                    for (UIViewController *controller in self.navigationController.viewControllers) {
                        if ([controller isKindOfClass:[FacePayViewController class]]) {
                            youxianjiaofeiViewController *revise =(youxianjiaofeiViewController *)controller;
                            [self.navigationController popToViewController:revise animated:YES];
                        }
                    }
                }else if ([_type isEqualToString:@"newservicescan"]){
                    //[self.navigationController popToRootViewControllerAnimated:YES];
                }else{
                    
                }
                break;
                
            default:
                [self chevsuess];
                NSLog(@"************8支付失败");
                if ([_type isEqualToString:@"2"]) {
                    if ([_shuidianfei isEqualToString:@"shuidianfei"]) {
                        for (UIViewController *controller in self.navigationController.viewControllers) {
                            if ([controller isKindOfClass:[shuidianfeiViewController class]]) {
                                shuidianfeiViewController *revise =(shuidianfeiViewController *)controller;
                                [self.navigationController popToViewController:revise animated:YES];
                            }
                        }
                    }else{
                        for (UIViewController *controller in self.navigationController.viewControllers) {
                            if ([controller isKindOfClass:[jiatingzhangdanViewController class]]) {
                                jiatingzhangdanViewController *revise =(jiatingzhangdanViewController *)controller;
                                [self.navigationController popToViewController:revise animated:YES];
                            }
                        }
                    }
                    
                }else if ([_type isEqualToString:@"aciti"]){
                    
                }else if ([_type isEqualToString:@"facepay"]){
                    for (UIViewController *controller in self.navigationController.viewControllers) {
                        if ([controller isKindOfClass:[FacePayViewController class]]) {
                            FacePayViewController *revise =(FacePayViewController *)controller;
                            [self.navigationController popToViewController:revise animated:YES];
                        }
                    }
                }else if ([_type isEqualToString:@"youxianjiaofei"]){
                    for (UIViewController *controller in self.navigationController.viewControllers) {
                        if ([controller isKindOfClass:[FacePayViewController class]]) {
                            youxianjiaofeiViewController *revise =(youxianjiaofeiViewController *)controller;
                            [self.navigationController popToViewController:revise animated:YES];
                        }
                    }
                }else{
                    
                }
                break;
        }
        
    }];
    
}
- (void)bestpaysuess
{
    [self GeneralButtonAction1];
    [MBProgressHUD showToastToView:self.view withText:@"支付成功"];
    if ([_type isEqualToString:@"aciti"]) {
        fuwudingdanViewController *fuwu = [[fuwudingdanViewController alloc] init];
        if ([_c_id isEqualToString:@"119"]) {
            fuwu.but_tag = @"1";
        }else if ([_c_id isEqualToString:@"116"]) {
            fuwu.but_tag = @"2";
        }else{
            fuwu.but_tag = @"0";
        }
        [self.navigationController pushViewController:fuwu animated:YES];
    }else if ([_type isEqualToString:@"2"]){
        jiatingjiaofeijiluViewController *jilu = [[jiatingjiaofeijiluViewController alloc] init];
        [self.navigationController pushViewController:jilu animated:YES];
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"wuyejiaofeichenggong" object:nil userInfo:nil];
    }else if ([_type isEqualToString:@"facepay"]){
        FacepayjiluViewController *jilu = [[FacepayjiluViewController alloc] init];
        [self.navigationController pushViewController:jilu animated:YES];
    }else if ([_type isEqualToString:@"youxianjiaofei"]){
        youxianjiaofeijiluViewController *jilu = [[youxianjiaofeijiluViewController alloc] init];
        [self.navigationController pushViewController:jilu animated:YES];
    }else if ([_type isEqualToString:@"newservicescan"]){
        NSLog(@"*********----newservicescan");
        myserviceViewController *myserve = [[myserviceViewController alloc] init];
        [self.navigationController pushViewController:myserve animated:YES];
    }else if ([_type isEqualToString:@"wuyegongdanfukuan"]){
        NSLog(@"*********----wuyegongdanfukuan");
        mywuyegongdanViewController *vc = [[mywuyegongdanViewController alloc] init];
        if ([_prepay isEqualToString:@"1"]) {
            vc.titleselect = @"0";
            [self dingdantuisong:_order_id];
        }else{
            vc.titleselect = @"1";
        }
        [self.navigationController pushViewController:vc animated:YES];
    } else{
        dingdanViewController *dingdan = [[dingdanViewController alloc] init];
        dingdan.but_tag = @"2";
        [self.navigationController pushViewController:dingdan animated:YES];
    }
    
}
- (NSString *)orderInfos{
    
    NSMutableString * orderDes = [NSMutableString string];
    
    // 签名参数
    //1. 接口名称
    NSString *service = @"mobile.security.pay";
    [orderDes appendFormat:@"SERVICE=%@", service];
    //2. 商户号
    [orderDes appendFormat:@"&MERCHANTID=%@", MERID];
    //3. 商户密码 由翼支付网关平台统一分配给各接入商户
    [orderDes appendFormat:@"&MERCHANTPWD=%@", PSWD];
    //4. 子商户号
    [orderDes appendFormat:@"&SUBMERCHANTID=%@", @""];
    //5. 支付结果通知地址 翼支付网关平台将支付结果通知到该地址，详见支付结果通知接口
    [orderDes appendFormat:@"&BACKMERCHANTURL=%@", [_Dic objectForKey:@"BGURL"]];
    //6. 订单号
    [orderDes appendFormat:@"&ORDERSEQ=%@", [_params objectForKey:@"ORDERSEQ"]];
    //7. 订单请求流水号，唯一
    [orderDes appendFormat:@"&ORDERREQTRANSEQ=%@", [_params objectForKey:@"ORDERREQTRNSEQ"]];
    //8. 订单请求时间 格式：yyyyMMddHHmmss
    [orderDes appendFormat:@"&ORDERTIME=%@", [_params objectForKey:@"ORDERREQTIME"]];
    //9. 订单有效截至日期
    [orderDes appendFormat:@"&ORDERVALIDITYTIME=%@", @""];
    //10. 币种, 默认RMB
    [orderDes appendFormat:@"&CURTYPE=%@", @"RMB"];
    //11. 订单金额/积分扣减
    [orderDes appendFormat:@"&ORDERAMOUNT=%.2f", [[_Dic objectForKey:@"ORDERAMT"] floatValue]];
    //    [orderDes appendFormat:@"&ORDERAMT=%@", self.money.text];
    //12.商品简称
    [orderDes appendFormat:@"&SUBJECT=%@", [_Dic objectForKey:@"PRODUCTDESC"]];
    //13. 业务标识 optional
    [orderDes appendFormat:@"&PRODUCTID=%@", @"04"];
    //14. 产品描述 optional
    [orderDes appendFormat:@"&PRODUCTDESC=%@", [_Dic objectForKey:@"PRODUCTDESC"]];
    //15. 客户标识 在商户系统的登录名 optional
    [orderDes appendFormat:@"&CUSTOMERID=%@", @"gehudedengluzhanghao"];
    //16.切换账号标识
    [orderDes appendFormat:@"&SWTICHACC=%@", [_Dic objectForKey:@"SWTICHACC"]];
    NSString *SignStr =[NSString stringWithFormat:@"%@&KEY=%@",orderDes,KEYSTR];
    //17. 签名信息 采用MD5加密
    NSString *signStr = [MD5 MD5:SignStr];
    [orderDes appendFormat:@"&SIGN=%@", signStr];
    
    
    //18. 产品金额
    [orderDes appendFormat:@"&PRODUCTAMOUNT=%@", [_Dic objectForKey:@"ORDERAMT"]];
    //19. 附加金额 单位元，小数点后2位
    [orderDes appendFormat:@"&ATTACHAMOUNT=%@",@"0.00"];
    //20. 附加信息 optional
    [orderDes appendFormat:@"&ATTACH=%@", @""];
    //21. 分账描述 optional
    //    [orderDes appendFormat:@"&DIVDETAILS=%@", @""];
    //22. 翼支付账户号
    [orderDes appendFormat:@"&ACCOUNTID=%@", @""];
    
    //23. 用户IP 主要作为风控参数 optional
    [orderDes appendFormat:@"&USERIP=%@", @""];
    //24. 业务类型标识
    [orderDes appendFormat:@"&BUSITYPE=%@", @"04"];
    
    //25.授权令牌
    [orderDes appendFormat:@"&EXTERNTOKEN=%@", @"NO"];
    //    //27.客户端号
    //    [orderDes appendFormat:@"&APPID=%@", @""];
    //    //28.客户端来源
    //    [orderDes appendFormat:@"&APPENV=%@", @"112233"];
    //27. 签名方式
    [orderDes appendFormat:@"&SIGNTYPE=%@", @"MD5"];
    
    return orderDes;
    
}
//***********************************  订单处理  ***************************************//

//获取当前时间戳
- (NSString *)getOrderTrSeq{
    NSDate *senddate=[NSDate date];
    NSString *locationString = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
    return locationString;
}
//获取当前时间毫秒级
- (NSString *)getOrderTimeMS{
    NSDate *senddate = [NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMddHHmmssSS"];
    NSString *locationString = [dateformatter stringFromDate:senddate];
    return locationString;
}

//获取当前时间分钟级
- (NSString *)getOrderTime{
    NSDate *senddate = [NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *locationString = [dateformatter stringFromDate:senddate];
    return locationString;
}
// 生产
#define releaseURL @"https://webpaywg.bestpay.com.cn/order.action"
// 准生产
#define debugURL @"http://wapchargewg.bestpay.com.cn/order.action"

// 下单处理
- (void)submitOrder
{
    NSString *orderSeq = [self getOrderTimeMS];
    NSString *orderReqTrnSeq = [NSString stringWithFormat:@"%@0001",orderSeq];
    NSString *orderTime = [self getOrderTime];
    
    
    self.receiveData = [[NSMutableData alloc] init];
    NSURL *url = [NSURL URLWithString:releaseURL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    
    str = [NSString stringWithFormat:@"MERCHANTID=%@&SUBMERCHANTID=%@&ORDERSEQ=%@&ORDERREQTRANSEQ=%@&ORDERREQTIME=%@&TRANSCODE=%@&ORDERAMT=%@&SERVICECODE=05&PRODUCTID=04&PRODUCTDESC=%@&BGURL=%@&ENCODETYPE=%@&RISKCONTROLINFO=%@&MAC=%@",MERID, @"", _Dic[@"ORDERSEQ"],
           _Dic[@"ORDERREQTRANSEQ"],
           _Dic[@"ORDERREQTIME"],
           _Dic[@"TRANSCODE"], [NSString stringWithFormat:@"%.0f",[_Dic[@"ORDERAMT"] floatValue]*100.0f],_Dic[@"PRODUCTDESC"], _Dic[@"BGURL"], _Dic[@"ENCODETYPE"], _Dic[@"RISKCONTROLINFO"],
           _Dic[@"MAC"]];
    //    str = [NSString stringWithFormat:@"MERCHANTID=%@&SUBMERCHANTID=%@&ORDERSEQ=%@&ORDERAMT=%@&ORDERREQTRANSEQ=%@&ORDERREQTIME=%@&MAC=%@&TRANSCODE=%@", MERID, @"", dict[@"ORDERSEQ"], [NSString stringWithFormat:@"%.0f",[dict[@"ORDERAMT"] floatValue]*100.0f], dict[@"ORDERREQTRANSEQ"], dict[@"ORDERREQTIME"], dict[@"MAC"], dict[@"TRANSCODE"]];
    _params = [[NSMutableDictionary alloc] init];
    
    [_params setObject:_Dic[@"ORDERSEQ"] forKey:@"ORDERSEQ"];
    [_params setObject:_Dic[@"ORDERREQTRANSEQ"] forKey:@"ORDERREQTRNSEQ"];
    [_params setObject:_Dic[@"ORDERREQTIME"] forKey:@"ORDERREQTIME"];
    NSLog(@"下单接口信息：%@",str);
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    _connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        [[challenge sender] useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //self.receiveData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receiveData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *receiveStr = [[NSString alloc]initWithData:self.receiveData encoding:NSUTF8StringEncoding];
    if([[receiveStr substringToIndex:2] isEqualToString:@"00"])
    {
        [self doOrder];
    }
    else
    {
        NSLog(@"下单失败：%@", receiveStr);
        [self showAlert:@"下单失败，请稍后再试！"];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"请求失败%@",[error localizedDescription]);
    [self showAlert:@"请求失败，请稍后再试！"];
}

- (void)showAlert:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alter show];
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
