//
//  youhuiquanxiangqingViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/1/6.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "youhuiquanxiangqingViewController.h"
#import <AFNetworking.h>
#import "MBProgressHUD+TVAssistant.h"
#import "UIImageView+WebCache.h"

#define kScreen_Height   ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width    ([UIScreen mainScreen].bounds.size.width)
#import "PrefixHeader.pch"
@interface youhuiquanxiangqingViewController ()
{
    NSMutableDictionary *_Dic;
}

@end

@implementation youhuiquanxiangqingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    [self post];
    if ([_jpushstring isEqualToString:@"jpush"]) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    }
    // Do any additional setup after loading the view.
}
- (BOOL)navigationShouldPopOnBackButton{
    UIViewController *viewc = self.navigationController.viewControllers[self.navigationController.viewControllers.count-1];
    [self.navigationController popToViewController:viewc animated:YES];
    return YES;
}
- (void)back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)createui
{
    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, RECTSTATUS.size.height+44, Main_width, Main_Height-RECTSTATUS.size.height-44)];
    [self.view addSubview:scrollview];
    
    float i = [[_Dic objectForKey:@"img_size"] floatValue];
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, Main_width/i)];
    [imageview sd_setImageWithURL:[NSURL URLWithString:[_Dic objectForKey:@"box_img"]]];
    [scrollview addSubview:imageview];
    
    UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(0, imageview.frame.size.height+imageview.frame.origin.y, Main_width, 0)];
    [scrollview addSubview:backview];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 150, Main_width-30, 0)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 5;
    [scrollview addSubview:view];
    
    self.title = [_Dic objectForKey:@"name"];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, Main_width-30, 25)];
    label1.text = [_Dic objectForKey:@"name"];
    label1.font = [UIFont boldSystemFontOfSize:25];
    label1.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label1];
    
    UILabel *timelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, label1.frame.size.height+label1.frame.origin.y+9, Main_width-30, 13)];
    NSTimeInterval interval    =[[_Dic objectForKey:@"endtime"] doubleValue];
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString       = [formatter stringFromDate: date];
    timelabel.alpha = 0.4;
    timelabel.font = [UIFont systemFontOfSize:12];
    timelabel.textAlignment = NSTextAlignmentCenter;
    timelabel.text = [NSString stringWithFormat:@"有效期至 %@",dateString];
    [view addSubview:timelabel];
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake(38, timelabel.frame.size.height+timelabel.frame.origin.y+18, view.frame.size.width-76, 39);
    but.backgroundColor = HColor(59, 158, 49);
    [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [but.titleLabel setFont:biaotifont];
    
    NSString *coupon_status = [NSString stringWithFormat:@"%@",[_Dic objectForKey:@"coupon_status"]];
    int j = [coupon_status intValue];
    if (j==0) {
        [but setTitle:@"立即领取" forState:UIControlStateNormal];
        but.alpha = 1;
    }if (j==1) {
        [but setTitle:@"立即使用" forState:UIControlStateNormal];
        but.alpha = 1;
    }if (j==2) {
        [but setTitle:@"已经使用" forState:UIControlStateNormal];
        but.alpha = 0.2;
    } 
    but.tag = j;
    [but addTarget:self action:@selector(usedaodianjuan:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:but];
    
    UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(0, but.frame.size.height+but.frame.origin.y+22.5, kScreen_Width-30, 0.5)];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineview.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineview.frame) / 2, CGRectGetHeight(lineview.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:[UIColor blackColor].CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineview.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:3], [NSNumber numberWithInt:1],  nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(lineview.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineview.layer addSublayer:shapeLayer];
    [view addSubview:lineview];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, lineview.frame.size.height+lineview.frame.origin.y+20, 0,15)];
    label2.text = @"到店券使用";
    CGSize size = [label2 sizeThatFits:CGSizeMake(MAXFLOAT, 15)];
    label2.frame = CGRectMake((view.frame.size.width-size.width)/2, label2.frame.origin.y,size.width,15);
    [view addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(25, label2.frame.size.height+label2.frame.origin.y+20, view.frame.size.width-50, 0)];
    label3.numberOfLines = 0;
    label3.text = [_Dic objectForKey:@"condition"];
    CGSize size3 = [label3 sizeThatFits:CGSizeMake(label3.frame.size.width, MAXFLOAT)];
    label3.frame = CGRectMake(label3.frame.origin.x, label3.frame.origin.y, label3.frame.size.width,size3.height);
    label3.font = [UIFont systemFontOfSize:13];
    [view addSubview:label3];
    
    UIView *lineview1 = [[UIView alloc] initWithFrame:CGRectMake(0, label3.frame.size.height+label3.frame.origin.y+25, kScreen_Width-30, 0.5)];
    CAShapeLayer *shapeLayer1 = [CAShapeLayer layer];
    [shapeLayer1 setBounds:lineview1.bounds];
    [shapeLayer1 setPosition:CGPointMake(CGRectGetWidth(lineview1.frame) / 2, CGRectGetHeight(lineview1.frame))];
    [shapeLayer1 setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer1 setStrokeColor:[UIColor blackColor].CGColor];
    //  设置虚线宽度
    [shapeLayer1 setLineWidth:CGRectGetHeight(lineview1.frame)];
    [shapeLayer1 setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer1 setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:3], [NSNumber numberWithInt:1],  nil]];
    //  设置路径
    CGMutablePathRef path1 = CGPathCreateMutable();
    CGPathMoveToPoint(path1, NULL, 0, 0);
    CGPathAddLineToPoint(path1, NULL, CGRectGetWidth(lineview1.frame), 0);
    [shapeLayer1 setPath:path1];
    CGPathRelease(path1);
    //  把绘制好的虚线添加上来
    [lineview1.layer addSublayer:shapeLayer1];
    [view addSubview:lineview1];
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(0, lineview1.frame.size.height+lineview1.frame.origin.y+20, 0,15)];
    label4.text = @"使用门店";
    CGSize size4 = [label4 sizeThatFits:CGSizeMake(MAXFLOAT, 15)];
    label4.frame = CGRectMake((view.frame.size.width-size4.width)/2, label4.frame.origin.y,size4.width,15);
    [view addSubview:label4];
    
    UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(25, label4.frame.size.height+label4.frame.origin.y+20, Main_width-50, 0)];
    
    label5.numberOfLines = 0;
    label5.font = [UIFont systemFontOfSize:13];
    label5.text = [_Dic objectForKey:@"userule"];
    CGSize size5 = [label5 sizeThatFits:CGSizeMake(label5.frame.size.width, MAXFLOAT)];
    label5.frame = CGRectMake(label5.frame.origin.x, label5.frame.origin.y, size5.width,size5.height);
    label5.alpha = 0.5;
    [view addSubview:label5];
    
    view.frame = CGRectMake(15, RECTSTATUS.size.height+44+150, Main_width-30, label5.frame.size.height+label5.frame.origin.y+27.5);
    
    scrollview.contentSize = CGSizeMake(Main_width, view.frame.size.height+view.frame.origin.y+27.5+60);
    
    backview.frame = CGRectMake(0, imageview.frame.size.height+imageview.frame.origin.y, Main_width, view.frame.size.height+view.frame.origin.y+27.5+60-Main_width/i);
    backview.backgroundColor = [UIColor blackColor];
    CAGradientLayer *_gradLayer = [CAGradientLayer layer];
    NSArray *colors = [NSArray arrayWithObjects:
                       (id)[[UIColor colorWithWhite:0 alpha:0] CGColor],
                       (id)[[UIColor colorWithWhite:0 alpha:0.5] CGColor],
                       (id)[[UIColor colorWithWhite:0 alpha:1] CGColor],
                       nil];
    [_gradLayer setColors:colors];
    //渐变起止点，point表示向量
    [_gradLayer setStartPoint:CGPointMake(0.0f, 0.0f)];
    [_gradLayer setEndPoint:CGPointMake(0.0f, 1.0f)];
    
    [_gradLayer setFrame:backview.bounds];
    
    [backview.layer setMask:_gradLayer];
    
    UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(0, view.frame.size.height+view.frame.origin.y+20, Main_width, 20)];
    label6.text = @"7*14小时管家热线:400-6535-355";
    label6.textColor = [UIColor whiteColor];
    label6.textAlignment = NSTextAlignmentCenter;
    label6.alpha = 0.5;
    [scrollview addSubview:label6];
}
- (void)usedaodianjuan: (UIButton *)sender
{
    if (sender.tag==0) {
        
    }if (sender.tag==1) {
        UIAlertController*alert = [UIAlertController
                                   alertControllerWithTitle: @"提示"
                                   message: @"是否确定使用"
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
                              [self post1];
                          }]];
        //弹出提示框
        [self presentViewController:alert
                           animated:YES completion:nil];
    }if (sender.tag==2) {
        
    }
}
- (void)shiyong:(UIButton *)sender
{
    
}
#pragma mark ------联网请求---
-(void)post
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    NSDictionary *dict = @{@"id":_id,@"apk_token":uid_username,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"],@"hui_community_id":[user objectForKey:@"community_id"]};
    
    NSString *urlstr = [API stringByAppendingString:@"userCenter/coupon_details_40"];
    [manager POST:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _Dic = [[NSMutableDictionary alloc] init];
        
        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            _Dic = [responseObject objectForKey:@"data"];
        }else{
            _Dic = nil;
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
        [self createui];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
-(void)post1
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    NSDictionary *dict = @{@"m_c_id":[_Dic objectForKey:@"m_c_id"],@"apk_token":uid_username,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"],@"hui_community_id":[user objectForKey:@"community_id"]};
   
    NSString *urlstr = [API stringByAppendingString:@"userCenter/use_coupon"];
    [manager POST:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shiyongyouhuiquan" object:nil userInfo:nil];
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
