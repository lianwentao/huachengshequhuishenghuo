//
//  selectHomeViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/3/21.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "selectHomeViewController.h"
#import "NewPagedFlowView.h"
#import "PGIndexBannerSubiew.h"
#import "MyhomeViewController.h"
#import <AFNetworking.h>
#import "MBProgressHUD+TVAssistant.h"
#import "UIViewController+BackButtonHandler.h"
#import "blueyaViewController.h"
#import "fangkeyaqingViewController.h"
#import "jiatingzhangdanViewController.h"
@interface selectHomeViewController ()<NewPagedFlowViewDelegate, NewPagedFlowViewDataSource>

/**
 *  图片数组
 */
@property (nonatomic, strong) NSMutableArray *imageArray;


/**
 *  轮播图
 */
@property (nonatomic, strong) NewPagedFlowView *pageFlowView;
@end

@implementation selectHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"请选择房屋";
    self.view.backgroundColor = BackColor;
    
    UIImageView *iamgeviewsss = [[UIImageView alloc] initWithFrame:CGRectMake(0, RECTSTATUS.size.height+44, Main_width, Main_Height-RECTSTATUS.size.height-44)];
    iamgeviewsss.image = [UIImage imageNamed:@"ic_house_bg_big1"];
    [self.view addSubview:iamgeviewsss];
    //NSArray *arr = @[@"w1",@"w2",@"w3",@"w4",@"w1"];
    for (int index = 0; index < _homeArr.count; index++) {
//        UIImage *image = [UIImage imageNamed:[arr objectAtIndex:index]];
//        [self.imageArray addObject:image];
        UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_width-140, (Main_Height - 60)*9/16)];
        backview.backgroundColor = [UIColor whiteColor];
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, backview.frame.size.width, (backview.frame.size.height)*0.6)];
        imageview.image = [UIImage imageNamed:@"ic_house_bg"];
        imageview.backgroundColor = QIColor;
        [backview addSubview:imageview];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake((backview.frame.size.width-65)/2, backview.frame.size.height*3/5-32.5, 65, 65)];
        label1.backgroundColor = [UIColor whiteColor];
        label1.numberOfLines = 2;
        label1.textAlignment = NSTextAlignmentCenter;
        label1.layer.masksToBounds = YES;
        label1.layer.cornerRadius = 32.5;
        label1.text = [[_homeArr objectAtIndex:index] objectForKey:@"community_name"];
        label1.font = [UIFont systemFontOfSize:15];
        [backview addSubview:label1];
        
        UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(17.5, label1.frame.size.height+label1.frame.origin.y+30, 6, 6)];
        circle.layer.masksToBounds = YES;
        circle.layer.cornerRadius = 3;
        circle.backgroundColor = CIrclecolor;
        [backview addSubview:circle];
        
        UIView *circle1 = [[UIView alloc] initWithFrame:CGRectMake(17.5, label1.frame.size.height+label1.frame.origin.y+30+25, 6, 6)];
        circle1.layer.masksToBounds = YES;
        circle1.layer.cornerRadius = 3;
        circle1.backgroundColor = CIrclecolor;
        [backview addSubview:circle1];
        
        UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(20, label1.frame.size.height+label1.frame.origin.y+30+6, 1, 19)];
        lineview.backgroundColor = CIrclecolor;
        [backview addSubview:lineview];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(17.5+16, label1.frame.size.height+label1.frame.origin.y+30, Main_width-17.5-17.5-32, 15)];
        label2.text = [[_homeArr objectAtIndex:index] objectForKey:@"address"];
        [label2 setFont:font15];
        [backview addSubview:label2];
        
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(17.5+16, label1.frame.size.height+label1.frame.origin.y+30+20, Main_width-17.5-17.5-32, 15)];
        label3.text = [NSString stringWithFormat:@"%@人已绑定房屋",[[_homeArr objectAtIndex:index] objectForKey:@"per_count"]];
        [label3 setFont:font15];
        [backview addSubview:label3];
        
        UIImageView *imagevew1 = [[UIImageView alloc] initWithFrame:CGRectMake(backview.frame.size.width-30-15, label1.frame.size.height+label1.frame.origin.y+30+10, 10, 20)];
        imagevew1.image = [UIImage imageNamed:@"ic_arrow_right_grayblack"];
        [backview addSubview:imagevew1];
        
        [self.imageArray addObject:backview];
    }
    UILabel *label1111 = [[UILabel alloc] initWithFrame:CGRectMake(0, Main_Height-49, Main_width, 49)];
    label1111.text = @"i若房屋信息有错,请联系400-6535-355";
    label1111.font = [UIFont systemFontOfSize:14];
    label1111.textAlignment = NSTextAlignmentCenter;
    label1111.alpha = 0.5;
    label1111.textColor = [UIColor whiteColor];
    [self.view addSubview:label1111];
    
    [self setupUI];
    // Do any additional setup after loading the view.
}
- (BOOL)navigationShouldPopOnBackButton{
    UIViewController *viewc = self.navigationController.viewControllers[0];
    [self.navigationController popToViewController:viewc animated:YES];
    return YES;
}
//- (void)get
//{
//    //1.创建会话管理者
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
//    //2.封装参数
//    //NSDictionary *dict = @{@"mobile":phonbe.text};
//    NSString *strurl = [API stringByAppendingString:@"apk/property/binding_community"];
//    [manager GET:strurl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
//            //[MBProgressHUD showToastToView:self.view withText:@"验证码发送成功"];
//        }else{
//            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"failure--%@",error);
//    }];
//}
#pragma mark --懒加载
- (NSMutableArray *)imageArray {
    if (_imageArray == nil) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (void)setupUI {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NewPagedFlowView *pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 150, Main_width, Main_Height*9/16)];
    pageFlowView.delegate = self;
    pageFlowView.dataSource = self;
    pageFlowView.minimumPageAlpha = 0.1;
    pageFlowView.isCarousel = NO;
    pageFlowView.orientation = NewPagedFlowViewOrientationHorizontal;
    pageFlowView.isOpenAutoScroll = YES;
    
//    //初始化pageControl
//    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, pageFlowView.frame.size.height - 32, Main_width, 8)];
//    pageFlowView.pageControl = pageControl;
//    [pageFlowView addSubview:pageControl];
    [pageFlowView reloadData];
    
    [self.view addSubview:pageFlowView];
}

#pragma mark NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    return CGSizeMake(Main_width - 140, (Main_Height - 60)*9/16);
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    NSString *room_id = [[_homeArr objectAtIndex:subIndex] objectForKey:@"room_id"];
    NSLog(@"点击了第%ld张图",(long)subIndex + 1);
    if ([_rukoubiaoshi isEqualToString:@"layakaimen"]) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[defaults objectForKey:@"uid"],[defaults objectForKey:@"username"]]];
        NSDictionary *dict = @{@"apk_token":uid_username,@"room_id":[[_homeArr objectAtIndex:subIndex] objectForKey:@"room_id"],@"token":[defaults objectForKey:@"token"],@"tokenSecret":[defaults objectForKey:@"tokenSecret"]};
        
        NSString *strurl = [API stringByAppendingString:@"property/checkIsAjb"];
        [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@-11111-%@",[responseObject objectForKey:@"msg"],responseObject);
            NSDictionary *dicccc = [[NSDictionary alloc] init];
            if ([[responseObject objectForKey:@"status"] integerValue]==1) {
                dicccc = [responseObject objectForKey:@"data"];
                if ([dicccc isKindOfClass:[NSDictionary class]]) {
                    blueyaViewController *blueya = [[blueyaViewController alloc] init];
                    blueya.Dic = dicccc;
                    blueya.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:blueya animated:YES];
                }else{
                    [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
                }
            }else if ([[responseObject objectForKey:@"status"] integerValue]==2){
                [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
                NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
                [userinfo removeObjectForKey:@"username"];
                [userinfo removeObjectForKey:@"phone_type"];
                [userinfo removeObjectForKey:@"uid"];
                [userinfo removeObjectForKey:@"pwd"];
                [userinfo removeObjectForKey:@"is_bind_property"];
                [userinfo removeObjectForKey:@"Cookie"];
                [userinfo removeObjectForKey:@"is_new"];
                [userinfo removeObjectForKey:@"token"];
                [userinfo removeObjectForKey:@"tokenSecret"];
                NSHTTPCookieStorage *manager = [NSHTTPCookieStorage sharedHTTPCookieStorage];
                NSArray *cookieStorage = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
                for (NSHTTPCookie *cookie in cookieStorage) {
                    [manager deleteCookie:cookie];
                }
//                [self logout];
            }else{
                [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"failure--%@",error);
        }];
    }else if ([_rukoubiaoshi isEqualToString:@"fangkeyaoqing"]){
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[defaults objectForKey:@"uid"],[defaults objectForKey:@"username"]]];
        NSDictionary *dict = @{@"apk_token":uid_username,@"room_id":[[_homeArr objectAtIndex:subIndex] objectForKey:@"room_id"],@"token":[defaults objectForKey:@"token"],@"tokenSecret":[defaults objectForKey:@"tokenSecret"]};
       
        NSString *strurl = [API stringByAppendingString:@"property/checkIsAjb"];
        [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@-11111-%@",[responseObject objectForKey:@"msg"],responseObject);
            NSDictionary *dicccc = [[NSDictionary alloc] init];
            if ([[responseObject objectForKey:@"status"] integerValue]==1) {
                dicccc = [responseObject objectForKey:@"data"];
                if ([dicccc isKindOfClass:[NSDictionary class]]) {
                    fangkeyaqingViewController *yaoqing = [[fangkeyaqingViewController alloc] init];
                    yaoqing.Dic = dicccc;
                    [self.navigationController pushViewController:yaoqing animated:YES];
                }else{
                    [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
                }
            }else if ([[responseObject objectForKey:@"status"] integerValue]==2){
                [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
                NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
                [userinfo removeObjectForKey:@"username"];
                [userinfo removeObjectForKey:@"phone_type"];
                [userinfo removeObjectForKey:@"uid"];
                [userinfo removeObjectForKey:@"pwd"];
                [userinfo removeObjectForKey:@"is_bind_property"];
                [userinfo removeObjectForKey:@"Cookie"];
                [userinfo removeObjectForKey:@"is_new"];
                [userinfo removeObjectForKey:@"token"];
                [userinfo removeObjectForKey:@"tokenSecret"];
                NSHTTPCookieStorage *manager = [NSHTTPCookieStorage sharedHTTPCookieStorage];
                NSArray *cookieStorage = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
                for (NSHTTPCookie *cookie in cookieStorage) {
                    [manager deleteCookie:cookie];
                }
//                [self logout];
            }else{
                [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"failure--%@",error);
        }];
    }else if ([_rukoubiaoshi isEqualToString:@"jiatingzhangdan"]){
        jiatingzhangdanViewController *yaoqing = [[jiatingzhangdanViewController alloc] init];
        yaoqing.room_id = room_id;
        [self.navigationController pushViewController:yaoqing animated:YES];
    } else{
        MyhomeViewController *myhome = [[MyhomeViewController alloc] init];
        myhome.room_id = room_id;
        [self.navigationController pushViewController:myhome animated:YES];
        
    }
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    
    NSLog(@"ViewController 滚动到了第%ld页",pageNumber);
}

#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    
    return self.imageArray.count;
    
}

- (PGIndexBannerSubiew *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    PGIndexBannerSubiew *bannerView = [flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[PGIndexBannerSubiew alloc] init];
        bannerView.tag = index;
        bannerView.layer.cornerRadius = 4;
        bannerView.layer.masksToBounds = YES;
    }
    //在这里下载网络图片
    //  [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:hostUrlsImg,imageDict[@"img"]]] placeholderImage:[UIImage imageNamed:@""]];
    UIView *view = [[UIView alloc] init];
    view = self.imageArray[index];
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake(0, 0, Main_width-140, (Main_Height - 60)*9/16);
    [bannerView.mainImageView addSubview:view];
    
    return bannerView;
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
