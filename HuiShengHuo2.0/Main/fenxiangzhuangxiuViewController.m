//
//  fenxiangzhuangxiuViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/4/13.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "fenxiangzhuangxiuViewController.h"
#import "CustomActivity.h"

@interface fenxiangzhuangxiuViewController ()
{
    UIView *backview;
    UIScrollView *scrollview;
}

@end

@implementation fenxiangzhuangxiuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的装修";
    
    self.view.backgroundColor = BackColor;
    
    [self createui];
    // Do any additional setup after loading the view.
}
- (void)createui
{
    scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, RECTSTATUS.size.height+44, Main_width, Main_Height-RECTSTATUS.size.height-44-49)];
    [self.view addSubview:scrollview];
    
    backview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_width, 0)];
    backview.backgroundColor = [UIColor whiteColor];
    [scrollview addSubview:backview];
    
    UILabel *contentlabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, Main_width-25, 0)];
    contentlabel.numberOfLines = 0;
    contentlabel.attributedText = _content;
    contentlabel.font = [UIFont systemFontOfSize:16];// weight:10
    CGSize size = [contentlabel sizeThatFits:CGSizeMake(contentlabel.frame.size.width, MAXFLOAT)];
    contentlabel.frame = CGRectMake(contentlabel.frame.origin.x, contentlabel.frame.origin.y, size.width,  size.height);
    
    [backview addSubview:contentlabel];
    NSArray *arr1 = @[@"装修助手",@"及时送达",@"优选服务"];
    NSArray *arr2 = @[@"上门服务",@"万能跑腿",@"专属管家"];
    for (int i=0; i<3; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(Main_width/4*i, contentlabel.frame.size.height+contentlabel.frame.origin.y+50, Main_width/4, 20)];
        label.font = font15;
        label.text = [arr1 objectAtIndex:i];
        label.textAlignment = NSTextAlignmentCenter;
        [backview addSubview:label];
    }
    for (int i=0; i<3; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(Main_width/4*i, contentlabel.frame.size.height+contentlabel.frame.origin.y+50+20+5, Main_width/4, 20)];
        label.font = font15;
        label.text = [arr2 objectAtIndex:i];
        label.textAlignment = NSTextAlignmentCenter;
        [backview addSubview:label];
    }
    UIImageView *imagviewsss = [[UIImageView alloc] initWithFrame:CGRectMake((Main_width/4-(Main_width/4*3/4))/2+Main_width/4*3, contentlabel.frame.size.height+contentlabel.frame.origin.y+50, (Main_width/4*3/4), (Main_width/4*3/4))];
    imagviewsss.image = [UIImage imageNamed:@"icon_erweima"];
    [backview addSubview:imagviewsss];
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(Main_width/4*3, imagviewsss.frame.size.height+imagviewsss.frame.origin.y+5, Main_width/4*3, 20)];
    name.text = @"社区慧生活";
    [backview addSubview:name];
    
    UILabel *lablenumber = [[UILabel alloc] initWithFrame:CGRectMake(15, contentlabel.frame.size.height+contentlabel.frame.origin.y+50+50, Main_width-30, 20)];
    lablenumber.text = @"400-6535-355";
    [backview addSubview:lablenumber];
    
    backview.frame = CGRectMake(0, 0, Main_width, lablenumber.frame.size.height+lablenumber.frame.origin.y+50);
    scrollview.contentSize = CGSizeMake(Main_width, lablenumber.frame.size.height+lablenumber.frame.origin.y+50);
    
    UIButton *suer = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:suer];
    suer.backgroundColor = QIColor;
    [suer setTitle:@"分享" forState:UIControlStateNormal];
    suer.frame = CGRectMake(0, Main_Height-49, Main_width, 49);
    [suer addTarget:self action:@selector(suer) forControlEvents:UIControlEventTouchUpInside];
}
- (void)suer
{
    UIImage *image = [self snapshot:backview];
    UIImageView *snapImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 200, backview.frame.size.width, backview.frame.size.height)];
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
