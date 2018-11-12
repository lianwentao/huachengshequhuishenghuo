//
//  newsuerViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/9/5.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "newsuerViewController.h"

@interface newsuerViewController ()

@end

@implementation newsuerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"确认订单支付";
    self.view.backgroundColor = BackColor;
    [self createUI];
    // Do any additional setup after loading the view.
}
-(void)createUI
{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(40, (Main_Height-352-RECTSTATUS.size.height-44-49)/2+RECTSTATUS.size.height+44, Main_width-80, 352)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Main_width-80, 57.5)];
    label1.text = @"账单";
    [label1 setFont:font18];
    label1.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label1];
    
    UIView *lineview1 = [[UIView alloc] initWithFrame:CGRectMake(10, label1.frame.size.height+label1.frame.origin.y+1, Main_width-100, 1)];
    lineview1.backgroundColor = BackColor;
    [view addSubview:lineview1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, lineview1.frame.size.height+15+lineview1.frame.origin.y, Main_width-100, 15)];
    label2.text = @"郝建斌";
    label2.font = font18;
    [view addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(10, label2.frame.size.height+label2.frame.origin.y+10, Main_width-100, 40)];
    
    
    label3.numberOfLines = 2;
    label3.text = @"门前大桥下，游过一群鸭爱仕达驾驶员暗示法卡上打开 阿萨德阿士大夫";
    label3.alpha = 0.4;
    label3.font = [UIFont systemFontOfSize:13];
    [view addSubview:label3];
    
    UIView *lineview2 = [[UIView alloc] initWithFrame:CGRectMake(10, label3.frame.size.height+label3.frame.origin.y+5, Main_width-100, 1)];
    lineview2.backgroundColor = BackColor;
    [view addSubview:lineview2];
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(10, lineview2.frame.size.height+lineview2.frame.origin.y+10, Main_width-100, 15)];
    label4.font = font15;
    label4.text = @"订单号：123245624235";
    [view addSubview:label4];
    
    UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(10, label4.frame.size.height+label4.frame.origin.y+10, Main_width-100, 15)];
    label5.text = @"支付时间：2342121022";
    label5.font = font15;
    [view addSubview:label5];
    
    UIView *lineview3 = [[UIView alloc] initWithFrame:CGRectMake(10, label5.frame.size.height+label5.frame.origin.y+10, Main_width-100, 1)];
    lineview3.backgroundColor = BackColor;
    [view addSubview:lineview3];
    
    UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(10, lineview3.frame.size.height+lineview3.frame.origin.y+15, Main_width-100, 15)];
    label6.text = @"物业费";
    label6.font = font15;
    [view addSubview:label6];
    
    UILabel *labelsss = [[UILabel alloc] init];
    labelsss.text = @"2018.9.1-2018.9.1      100";
    //UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(10, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)];
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
