//
//  showtongxingzhengViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/3/24.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "showtongxingzhengViewController.h"
#import "CustomActivity.h"

@interface showtongxingzhengViewController (){
    UIView *view;
}

@end

@implementation showtongxingzhengViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"访客邀请";
    
    [self CreateUI];
    // Do any additional setup after loading the view.
}

- (void)CreateUI
{
    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, RECTSTATUS.size.height+44, Main_width, Main_Height-RECTSTATUS.size.height-44-49)];
    scrollview.backgroundColor = BackColor;
    [self.view addSubview:scrollview];
    
    view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [scrollview addSubview:view];
    
    UIImageView *imageview1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Main_width-30, 110)];
    imageview1.image = [UIImage imageNamed:@"fenxiang03"];
    [view addSubview:imageview1];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, imageview1.frame.size.height+imageview1.frame.origin.y+27.5, imageview1.frame.size.width-30, 25)];
    label1.text = @"小区大门和单元门的临时密码";
    label1.textAlignment = NSTextAlignmentCenter;
    [label1 setFont:font18];
    [view addSubview:label1];
    
    UILabel *passwordlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, label1.frame.size.height+label1.frame.origin.y+30, label1.frame.size.width, 40)];
    passwordlabel.text = _Password;
    passwordlabel.textAlignment = NSTextAlignmentCenter;
    passwordlabel.font = [UIFont boldSystemFontOfSize:30];
    [view addSubview:passwordlabel];
    
    UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(20, passwordlabel.frame.size.height+passwordlabel.frame.origin.y+25, 6, 6)];
    circle.layer.masksToBounds = YES;
    circle.layer.cornerRadius = 3;
    circle.backgroundColor = CIrclecolor;
    [view addSubview:circle];
    UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(26, passwordlabel.frame.size.height+passwordlabel.frame.origin.y+25+3-0.25, imageview1.frame.size.width-26, 0.5)];
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
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(15, lineview.frame.size.height+lineview.frame.origin.y+28, imageview1.frame.size.width-30, 25)];
    label2.text = [NSString stringWithFormat:@"1.有限期至:%@",_valiateTime];
    [label2 setFont:font15];
    [view addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(15, label2.frame.size.height+label2.frame.origin.y+20, label2.frame.size.width-30, 25)];
    label3.numberOfLines = 0;
    NSString *ssssss = @"2.请先按“*” “#”,当显示屏出现请输入访客密码,再输入6位数";
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",ssssss]];
    [aString addAttribute:NSForegroundColorAttributeName value:QIColor range:NSMakeRange(5,7)];
    label3.attributedText = aString;
    [label3 setFont:font15];
    CGSize size3 = [label3 sizeThatFits:CGSizeMake(label3.frame.size.width, MAXFLOAT)];
    label3.frame = CGRectMake(label3.frame.origin.x, label3.frame.origin.y, size3.width,  size3.height);
    
    [view addSubview:label3];
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(15, label3.frame.size.height+label3.frame.origin.y+20, label3.frame.size.width-30, 25)];
    label4.text = @"3.可打开小区大门一次,单元门一次";
    [label4 setFont:font15];
    [view addSubview:label4];
    
    UIView *circle1 = [[UIView alloc] initWithFrame:CGRectMake(20, label4.frame.size.height+label4.frame.origin.y+28, 6, 6)];
    circle1.layer.masksToBounds = YES;
    circle1.layer.cornerRadius = 3;
    circle1.backgroundColor = CIrclecolor;
    [view addSubview:circle1];
    UIView *lineview1 = [[UIView alloc] initWithFrame:CGRectMake(26, label4.frame.size.height+label4.frame.origin.y+28+3-0.25, imageview1.frame.size.width-26, 0.5)];
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
    
    UIImageView *imageview2 = [[UIImageView alloc] initWithFrame:CGRectMake(100, circle1.frame.size.height+circle1.frame.origin.y+10, Main_width-30-200, (Main_width-30-200)*9/31)];
    imageview2.image = [UIImage imageNamed:@"share_106"];
    [view addSubview:imageview2];
    NSLog(@"--%f",imageview2.frame.origin.y+110);
    
    view.frame = CGRectMake(15, 8, Main_width-30, imageview2.frame.size.height+imageview2.frame.origin.y+15);
    scrollview.contentSize = CGSizeMake(Main_width, imageview2.frame.size.height+imageview2.frame.origin.y+16);
    
    UIButton *fenxiang = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:fenxiang];
    fenxiang.backgroundColor = QIColor;
    [fenxiang setTitle:@"分享" forState:UIControlStateNormal];
    fenxiang.frame = CGRectMake(0, Main_Height-49, Main_width, 49);
    [fenxiang addTarget:self action:@selector(fenxiang) forControlEvents:UIControlEventTouchUpInside];
}
- (void)fenxiang {
    
    
    UIImage *image = [self snapshot:view];
    UIImageView *snapImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 200, view.frame.size.width, view.frame.size.height)];
    snapImg.layer.borderWidth = 1;
    
    snapImg.image = image;
    //[self.view addSubview:snapImg];
    
    // 1、设置分享的内容，并将内容添加到数组中
    NSString *shareText = @"分享图片";
    //    NSString *strurl = [NSString stringWithFormat:@"%@%@",API,_imgstr];
    //    UIImageView *imageview = [[UIImageView alloc] init];
    //    [imageview sd_setImageWithURL:[NSURL URLWithString:strurl]];
    UIImage *shareImage = snapImg.image;
    //NSURL *shareUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://m.hui-shenghuo.cn/apk/%@",_url]];
    NSArray *activityItemsArray = @[shareText,shareImage];
    
    
    // 自定义的CustomActivity，继承自UIActivity
    CustomActivity *customActivity = [[CustomActivity alloc]initWithTitle:@"wangsk" ActivityImage:[UIImage imageNamed:@"app_logo 5"] URL:[NSURL URLWithString:@"http://blog.csdn.net/flyingkuikui"] ActivityType:@"Custom"];
    NSArray *activityArray = @[customActivity];
    
    // 2、初始化控制器，添加分享内容至控制器
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItemsArray applicationActivities:activityArray];
    activityVC.modalInPopover = YES;
    // 3、设置回调
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // ios8.0 之后用此方法回调
        UIActivityViewControllerCompletionWithItemsHandler itemsBlock = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
            NSLog(@"activityType == %@",activityType);
            if (completed == YES) {
                NSLog(@"completed");
            }else{
                NSLog(@"cancel");
            }
        };
        activityVC.completionWithItemsHandler = itemsBlock;
    }else{
        // ios8.0 之前用此方法回调
        UIActivityViewControllerCompletionHandler handlerBlock = ^(UIActivityType __nullable activityType, BOOL completed){
            NSLog(@"activityType == %@",activityType);
            if (completed == YES) {
                NSLog(@"completed");
            }else{
                NSLog(@"cancel");
            }
        };
        activityVC.completionHandler = handlerBlock;
    }
    // 4、调用控制器
    [self presentViewController:activityVC animated:YES completion:nil];
}
- (UIImage *)snapshot:(UIView *)view {
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size,YES,0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    return image;
    
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
