//
//  myserviceViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/11/26.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "myserviceViewController.h"
#import "cancledingdanViewController.h"
#import "pingjiadingdanViewController.h"
#import "serviceDetailViewController.h"
#import "UIViewController+BackButtonHandler.h"
@interface myserviceViewController ()<FSPageContentViewDelegate,FSSegmentTitleViewDelegate>
{
    NSString *str1;
    NSString *str2;
    NSString *str3;
    
    AppDelegate *myDelegate;
}
@property (nonatomic, strong) FSPageContentView *pageContentView;
@property (nonatomic, strong) FSSegmentTitleView *titleView;

@end

@implementation myserviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"服务订单";
    myDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    [self getdata];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancledingdan:) name:@"newfuwudingdancancle" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pingjiadingdan:) name:@"newfuwudingdanpingjia" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shauxin) name:@"newpingjiadingdan" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shauxin) name:@"newquxiaodingdan" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shauxin) name:@"newtousudingdan" object:nil];
    // Do any additional setup after loading the view.newtousudingdan
}
-(BOOL)navigationShouldPopOnBackButton {
    WBLog(@"222");
    [self backBtnClicked];
    
    return YES;
}
- (void)backBtnClicked{
    WBLog(@"%@",_backStr);
//    if (_backStr.length==0) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }else{
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)shauxin
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    dict = @{@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"]};
    
    NSString *strurl = [API_NOAPK stringByAppendingString:@"/Service/order/myOrderCount"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"---%@--%@",responseObject,[responseObject objectForKey:@"msg"]);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            NSString *dfw = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"dfw"]];
            NSString *dpj = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"dpj"]];
            NSString *wc = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"wc"]];
            if (![dfw isEqualToString:@"0"]) {
                str1 = [NSString stringWithFormat:@"待服务%@",dfw];
            }else{
                str1 = @"待服务";
            }
            if (![dpj isEqualToString:@"0"]) {
                str2 = [NSString stringWithFormat:@"待评价%@",dpj];
            }else{
                str2 = @"待评价";
            }
            if (![wc isEqualToString:@"0"]) {
                str3 = [NSString stringWithFormat:@"完成%@",wc];
            }else{
                str3 = @"完成";
            }
            self.titleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, RECTSTATUS.size.height+44, CGRectGetWidth(self.view.bounds), 50) titles:@[@"全部",str1,str2,str3] delegate:self indicatorType:FSIndicatorTypeEqualTitle];
        }else{
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
//取消订单,评价订单
- (void)cancledingdan:(NSNotification *)userinfo
{
    cancledingdanViewController *cancle = [[cancledingdanViewController alloc] init];
    cancle.dingdanid = [userinfo.userInfo objectForKey:@"id"];
    [self.navigationController pushViewController:cancle animated:YES];
    //qb",@"dfw",@"dpj
    WBLog(@"%@",[userinfo.userInfo objectForKey:@"id"]);
}
- (void)pingjiadingdan:(NSNotification *)userinfo
{
    pingjiadingdanViewController *pingjia = [[pingjiadingdanViewController alloc] init];
    pingjia.dingdanid = [userinfo.userInfo objectForKey:@"id"];
    [self.navigationController pushViewController:pingjia animated:YES];
    WBLog(@"%@",[userinfo.userInfo objectForKey:@"id"]);
}
#pragma mark --
- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.pageContentView.contentViewCurrentIndex = endIndex;
}

- (void)FSContenViewDidEndDecelerating:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.titleView.selectIndex = endIndex;
}
- (void)getdata
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    dict = @{@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"]};
    
    NSString *strurl = [API_NOAPK stringByAppendingString:@"/Service/order/myOrderCount"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"---%@--%@",responseObject,[responseObject objectForKey:@"msg"]);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            NSString *dfw = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"dfw"]];
            NSString *dpj = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"dpj"]];
            NSString *wc = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"wc"]];
            
            if (![dfw isEqualToString:@"0"]) {
                str1 = [NSString stringWithFormat:@"待服务%@",dfw];
            }else{
                str1 = @"待服务";
            }
            if (![dpj isEqualToString:@"0"]) {
                str2 = [NSString stringWithFormat:@"待评价%@",dpj];
            }else{
                str2 = @"待评价";
            }
            if (![wc isEqualToString:@"0"]) {
                str3 = [NSString stringWithFormat:@"完成%@",wc];
            }else{
                str3 = @"完成";
            }
           self.titleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, RECTSTATUS.size.height+44, CGRectGetWidth(self.view.bounds), 50) titles:@[@"全部",str1,str2,str3] delegate:self indicatorType:FSIndicatorTypeEqualTitle];
            [self setui];
        }else{
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
- (void)setui
{
    
    NSMutableArray *childVCs = [[NSMutableArray alloc]init];//类型 qb->全部  dfw->待服务 dpj->待评价 wc->完成
    for (NSString *title in @[@"qb",@"dfw",@"dpj",@"wc"]) {
        myservicechildViewController *vc = [[myservicechildViewController alloc]init];
        vc.type = title;
        [childVCs addObject:vc];
    }
    self.titleView.titleSelectFont = [UIFont systemFontOfSize:17];
    self.titleView.backgroundColor = [UIColor colorWithRed:(244)/255.0 green:(247)/255.0 blue:(248)/255.0 alpha:0.54];
    self.titleView.titleNormalColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.54];
    self.titleView.selectIndex = 0;
    [self.view addSubview:_titleView];
    
    self.pageContentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, RECTSTATUS.size.height+44+50, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 90) childVCs:childVCs parentVC:self delegate:self];
    self.pageContentView.contentViewCurrentIndex = 0;
    //self.pageContentView.contentViewCanScroll = YES;//设置滑动属性
    [self.view addSubview:_pageContentView];
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
