//
//  bangdingqianViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/3/20.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "bangdingqianViewController.h"
#import "bangdingyanzhengViewController.h"
@interface bangdingqianViewController ()

@end

@implementation bangdingqianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"绑定房屋后获得以下功能";
    self.view.backgroundColor = BackColor;
    
    [self createUI];
    
    //修改系统导航栏下一个界面的返回按钮title
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    // Do any additional setup after loading the view.
}
- (BOOL)navigationShouldPopOnBackButton{
    UIViewController *viewc = self.navigationController.viewControllers[self.navigationController.viewControllers.count-1];
    [self.navigationController popToViewController:viewc animated:YES];
    return YES;
}
- (void)createUI
{
    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, RECTSTATUS.size.height+44, Main_width, Main_Height-49-(RECTSTATUS.size.height+44))];
    [self.view addSubview:scrollview];
    scrollview.bounces = NO;
    scrollview.showsVerticalScrollIndicator = NO;
    scrollview.showsHorizontalScrollIndicator = NO;
    
    UIView *view1 = [[UIView alloc] init];
    view1.backgroundColor = [UIColor whiteColor];
    [scrollview addSubview:view1];
    UIView *view2 = [[UIView alloc] init];
    view2.backgroundColor = [UIColor whiteColor];
    [scrollview addSubview:view2];
    
    UILabel *opnedoorlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, Main_width, 25)];
    opnedoorlabel.textAlignment = NSTextAlignmentCenter;
    [opnedoorlabel setFont:font18];
    opnedoorlabel.text = @"手机开门";
    [view1 addSubview:opnedoorlabel];
    
    UIImageView *imageview1 = [[UIImageView alloc] initWithFrame:CGRectMake((Main_width - 110)/2, opnedoorlabel.frame.origin.y+opnedoorlabel.frame.size.height+10, 110, 90)];
    imageview1.image = [UIImage imageNamed:@"shoujikaimen"];
    [view1 addSubview:imageview1];
    
    NSArray *labeltextarr = @[@"开通家人开门权限",@"开通租客开门权限",@"开通客人临时开门权限"];
    for (int i=0; i<3; i++) {
        UILabel *threelabel = [[UILabel alloc] initWithFrame:CGRectMake(15+(Main_width - 110)/2-30, imageview1.frame.origin.y+imageview1.frame.size.height+10 + i*35, Main_width, 25)];
        [threelabel setFont:nomalfont];
        NSMutableAttributedString *aString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",[labeltextarr objectAtIndex:i]]];
        if (i==2) {
            
            [aString addAttribute:NSForegroundColorAttributeName value:QIColor range:NSMakeRange(2,4)];
            
        }else{
            
            [aString addAttribute:NSForegroundColorAttributeName value:QIColor range:NSMakeRange(2,2)];
            
        }
        threelabel.attributedText = aString;
        [view1 addSubview:threelabel];
        
        UIView *circle = [[UIView alloc] initWithFrame:CGRectMake((Main_width - 110)/2-30, imageview1.frame.origin.y+imageview1.frame.size.height+10 + i*35+10, 6, 6)];
        circle.layer.masksToBounds = YES;
        circle.layer.cornerRadius = 3;
        circle.backgroundColor = CIrclecolor;
        [view1 addSubview:circle];
    }
    view1.frame = CGRectMake(0, 8, Main_width, imageview1.frame.origin.y + imageview1.frame.size.height +35*3 + 35);
    
    UILabel *zhangdanlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, Main_width, 25)];
    zhangdanlabel.text = @"查看家庭账单";
    [zhangdanlabel setFont:font18];
    zhangdanlabel.textAlignment = NSTextAlignmentCenter;
    [view2 addSubview:zhangdanlabel];
    
    UIImageView *imageview2 = [[UIImageView alloc] initWithFrame:CGRectMake((Main_width - 110)/2, zhangdanlabel.frame.origin.y+zhangdanlabel.frame.size.height+10, 110, 90)];
    imageview2.image = [UIImage imageNamed:@"jiatingzhangdan"];
    [view2 addSubview:imageview2];
    
    NSArray *labeltextarr2 = @[@"物业费账单",@"水电账单"];
    
    for (int i=0; i<2; i++) {
        UILabel *twolabel = [[UILabel alloc] initWithFrame:CGRectMake(15+(Main_width - 110)/2, imageview2.frame.origin.y+imageview2.frame.size.height+10 + i*35, Main_width, 25)];
        [twolabel setFont:nomalfont];
        twolabel.text = [labeltextarr2 objectAtIndex:i];
        [view2 addSubview:twolabel];
        
        UIView *circle = [[UIView alloc] initWithFrame:CGRectMake((Main_width - 110)/2, imageview2.frame.origin.y+imageview2.frame.size.height+10 + i*35+10, 6, 6)];
        circle.layer.masksToBounds = YES;
        circle.layer.cornerRadius = 3;
        circle.backgroundColor = CIrclecolor;
        [view2 addSubview:circle];
    }
    view2.frame = CGRectMake(0, 8+view1.frame.size.height+8, Main_width, imageview2.frame.origin.y + imageview2.frame.size.height +35*3 + 35);
    scrollview.contentSize = CGSizeMake(Main_width,view2.frame.size.height+view2.frame.origin.y);
    
    UIButton *bangdingbut = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:bangdingbut];
    bangdingbut.backgroundColor = QIColor;
    [bangdingbut setTitle:@"绑定房屋" forState:UIControlStateNormal];
    bangdingbut.frame = CGRectMake(0, Main_Height-49, Main_width, 49);
    [bangdingbut addTarget:self action:@selector(bangding) forControlEvents:UIControlEventTouchUpInside];
}
- (void)bangding
{
    bangdingyanzhengViewController *yanzheng = [[bangdingyanzhengViewController alloc] init];
    [self.navigationController pushViewController:yanzheng animated:YES];
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
