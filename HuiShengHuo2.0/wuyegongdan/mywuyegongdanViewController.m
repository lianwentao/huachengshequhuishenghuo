//
//  mywuyegongdanViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/12/15.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "mywuyegongdanViewController.h"
#import "mywuyegongdanchildViewController.h"
#import "UIViewController+BackButtonHandler.h"
@interface mywuyegongdanViewController ()<FSPageContentViewDelegate,FSSegmentTitleViewDelegate,BackButtonHandlerProtocol>{
    NSArray *dataarr;
    AppDelegate *myDelegate;
}

@property (nonatomic, strong) FSPageContentView *pageContentView;
@property (nonatomic, strong) FSSegmentTitleView *titleView;

@end

@implementation mywuyegongdanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"订单中心";
    myDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //[self getdata];
    [self setui];
    if ([_jpushstring isEqualToString:@"jpush"]) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    }

    // Do any additional setup after loading the view.
    
}
- (void)back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(BOOL)navigationShouldPopOnBackButton {
    [self backBtnClicked];
    
    return YES;
}
- (void)backBtnClicked
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)getdata
{
    //初始化进度框，置于当前的View当中
    static MBProgressHUD *_HUD;
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    
    //如果设置此属性则当前的view置于后台
    //_HUD.dimBackground = YES;
    
    //设置对话框文字
    _HUD.labelText = @"加载中...";
    _HUD.labelFont = [UIFont systemFontOfSize:14];
    
    //显示对话框
    [_HUD showAnimated:YES whileExecutingBlock:^{
        //对话框显示时需要执行的操作
        //1.创建会话管理者
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        //2.封装参数
        NSDictionary *dict = nil;
        NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
        dict = @{@"state":@"1",@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"]};
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *API = [defaults objectForKey:@"API"];
        NSString *strurl = [API stringByAppendingString:@"propertyWork/getWorkList"];
        [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            WBLog(@"---%@--%@",responseObject,[responseObject objectForKey:@"msg"]);
            dataarr = [[NSArray alloc] init];
            if ([[responseObject objectForKey:@"status"] integerValue]==1) {
                dataarr = [responseObject objectForKey:@"data"];
            }else{
                [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            WBLog(@"failure--%@",error);
            [MBProgressHUD showToastToView:self.view withText:@"加载失败"];
        }];
        
    }// 在HUD被隐藏后的回调
       completionBlock:^{
           //操作执行完后取消对话框
           [_HUD removeFromSuperview];
           _HUD = nil;
       }];
}
- (void)setui
{
    
    
    
    NSMutableArray *childVCs = [[NSMutableArray alloc]init];
    for (int i=0; i<3; i++) {
        mywuyegongdanchildViewController *vc = [[mywuyegongdanchildViewController alloc] init];
        vc.state = [NSString stringWithFormat:@"%d",i+1];
        [childVCs addObject:vc];
    }
    
    self.titleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, RECTSTATUS.size.height+44, CGRectGetWidth(self.view.bounds), 50) titles:@[@"待服务",@"服务中",@"已完成"] delegate:self indicatorType:FSIndicatorTypeEqualTitle];
    self.titleView.titleSelectFont = [UIFont systemFontOfSize:17];
    self.titleView.backgroundColor = [UIColor colorWithRed:(244)/255.0 green:(247)/255.0 blue:(248)/255.0 alpha:0.54];
    self.titleView.titleNormalColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.54];
    
    [self.view addSubview:_titleView];
    
    self.pageContentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, RECTSTATUS.size.height+44+50, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 90) childVCs:childVCs parentVC:self delegate:self];
    
    //self.pageContentView.contentViewCanScroll = YES;//设置滑动属性
    [self.view addSubview:_pageContentView];
    
    if (_titleselect==nil) {
        self.titleView.selectIndex = 0;
        self.pageContentView.contentViewCurrentIndex = 0;
    }else{
        self.titleView.selectIndex = [_titleselect integerValue];
        self.pageContentView.contentViewCurrentIndex = [_titleselect integerValue];
    }
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
