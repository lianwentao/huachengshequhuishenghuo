//
//  FacesureViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/3/23.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "FacesureViewController.h"
#import "FacepaysuessViewController.h"
#import "AllPayViewController.h"
@interface FacesureViewController ()

@end

@implementation FacesureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"请确认信息后付款";
    self.view.backgroundColor = BackColor;
    
    [self createUI];
    // Do any additional setup after loading the view.
}
-(void)createUI
{
    UIButton *pay = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:pay];
    pay.backgroundColor = QIColor;
    [pay setTitle:@"立即支付" forState:UIControlStateNormal];
    pay.frame = CGRectMake(0, Main_Height-49, Main_width, 49);
    [pay addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(40, (Main_Height-352-RECTSTATUS.size.height-44-49)/2+RECTSTATUS.size.height+44, Main_width-80, 352)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Main_width-80, 57.5)];
    label1.text = @"当面付账单";
    [label1 setFont:font18];
    label1.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label1];
    
    UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(20, label1.frame.size.height, 6, 6)];
    circle.layer.masksToBounds = YES;
    circle.layer.cornerRadius = 3;
    circle.backgroundColor = CIrclecolor;
    [view addSubview:circle];
    UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(26, label1.frame.size.height+3-0.25, Main_width-80-26, 0.5)];
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
    lineview.alpha = 0.5;
    [view addSubview:lineview];
    
    //NSArray *arr1 = @[@"付款编号：9864151658452454",@"付款时间：1025.12.58  20.54"];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(20, lineview.frame.size.height+lineview.frame.origin.y+20, Main_width-80-40, 25)];
    
    label2.text = [NSString stringWithFormat:@"付款编号：%@",_order_number];
    [label2 setFont:font15];
    [view addSubview:label2];
    NSTimeInterval interval    =[_time doubleValue];
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString       = [formatter stringFromDate: date];
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(20, lineview.frame.size.height+lineview.frame.origin.y+20+15+25, Main_width-80-40, 25)];
    label3.text = [NSString stringWithFormat:@"付款时间：%@",dateString];
    [label3 setFont:font15];
    [view addSubview:label3];
    
    UIView *circle1 = [[UIView alloc] initWithFrame:CGRectMake(20, label3.frame.size.height+label3.frame.origin.y+20, 6, 6)];
    circle1.layer.masksToBounds = YES;
    circle1.layer.cornerRadius = 3;
    circle1.backgroundColor = CIrclecolor;
    [view addSubview:circle1];
    UIView *lineview1 = [[UIView alloc] initWithFrame:CGRectMake(26, label3.frame.origin.y+label3.frame.size.height+20+3-0.25, Main_width-80-26, 0.5)];
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
    lineview1.alpha = 0.5;
    [view addSubview:lineview1];
    
    //NSArray *arr1 = @[@"付款编号：9864151658452454",@"付款时间：1025.12.58  20.54"];
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(20, lineview1.frame.size.height+lineview1.frame.origin.y+20, Main_width-80-40, 25)];
   
    
    [label4 setFont:font15];
    [view addSubview:label4];
    
    UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(20, lineview1.frame.size.height+lineview1.frame.origin.y+20+15+25, Main_width-80-40, 25)];
    
    [label5 setFont:font15];
    [view addSubview:label5];
    
    if ([_sign isEqualToString:@"1"]) {
        label4.numberOfLines = 2;
        label4.text = [NSString stringWithFormat:@"屋主信息:%@",_name];
        label5.text = [NSString stringWithFormat:@"房屋:%@",_c_name];
    }else if ([_sign isEqualToString:@"2"]) {
        label4.numberOfLines = 2;
        label4.text = [NSString stringWithFormat:@"商户:%@",_m_name];
        label5.text = [NSString stringWithFormat:@"备注:%@",_beizhu];
    } else{
        label4.numberOfLines = 3;
        label4.text = [NSString stringWithFormat:@"备注:%@",_beizhu];
        label5.text = @"";
    }
    
    UIView *circle2 = [[UIView alloc] initWithFrame:CGRectMake(20, label5.frame.size.height+label5.frame.origin.y+20, 6, 6)];
    circle2.layer.masksToBounds = YES;
    circle2.layer.cornerRadius = 3;
    circle2.backgroundColor = CIrclecolor;
    [view addSubview:circle2];
    UIView *lineview2 = [[UIView alloc] initWithFrame:CGRectMake(26, label5.frame.origin.y+label5.frame.size.height+20+3-0.25, Main_width-80-26, 0.5)];
    CAShapeLayer *shapeLayer2 = [CAShapeLayer layer];
    [shapeLayer2 setBounds:lineview2.bounds];
    [shapeLayer2 setPosition:CGPointMake(CGRectGetWidth(lineview2.frame) / 2, CGRectGetHeight(lineview2.frame))];
    [shapeLayer2 setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer2 setStrokeColor:[UIColor blackColor].CGColor];
    //  设置虚线宽度
    [shapeLayer2 setLineWidth:CGRectGetHeight(lineview2.frame)];
    [shapeLayer2 setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer2 setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:3], [NSNumber numberWithInt:1],  nil]];
    //  设置路径
    CGMutablePathRef path2 = CGPathCreateMutable();
    CGPathMoveToPoint(path2, NULL, 0, 0);
    CGPathAddLineToPoint(path2, NULL, CGRectGetWidth(lineview1.frame), 0);
    [shapeLayer2 setPath:path2];
    CGPathRelease(path2);
    //  把绘制好的虚线添加上来
    [lineview2.layer addSublayer:shapeLayer2];
    lineview2.alpha = 0.5;
    [view addSubview:lineview2];
    
    UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(20, lineview2.frame.size.height+lineview2.frame.origin.y+20, Main_width-80-40, 40)];
    label6.textColor = QIColor;
    label6.numberOfLines = 2;
    label6.text = [NSString stringWithFormat:@"%@:%@元",_leixing,_price];
    [label6 setFont:nomalfont];
    [view addSubview:label6];
    NSLog(@"%f",label6.frame.origin.y+30+25);
}
- (void)pay
{ 
//    FacepaysuessViewController *suess = [[FacepaysuessViewController alloc] init];
//    [self.navigationController pushViewController:suess animated:YES];
    
    AllPayViewController *allpay = [[AllPayViewController alloc] init];
    allpay.order_id = _id;
    allpay.price = _price;
    allpay.type = @"facepay";
    allpay.rukoubiaoshi = @"facepay";
    [self.navigationController pushViewController:allpay animated:YES];
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
