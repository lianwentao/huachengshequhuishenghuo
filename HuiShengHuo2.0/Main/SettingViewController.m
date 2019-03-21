//
//  SettingViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/11/24.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import "SettingViewController.h"
#import "guanyuwomenViewController.h"
#import "changepasswordViewController.h"
#import <AFNetworking.h>
#import "yijianfankuiViewController.h"
#import "shangwuhezuoViewController.h"
#import "HWPopTool.h"
#define kScreen_Height   ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width    ([UIScreen mainScreen].bounds.size.width)
#import "PrefixHeader.pch"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>
{
    UITableView *TabbleView;
}

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self CreateTableView];
    
    // Do any additional setup after loading the view.
}
#pragma mark - 创建TableView
- (void)CreateTableView
{
    TabbleView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    //_Hometableview.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 0.01f)];
    /** 去除tableview 右侧滚动条 */
    TabbleView.estimatedRowHeight = 0;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
    TabbleView.tableHeaderView = view;
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
    TabbleView.tableFooterView = view1;
    TabbleView.showsVerticalScrollIndicator = YES;
    /** 去掉分割线 */
    //Hometableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    TabbleView.delegate = self;
    TabbleView.dataSource = self;
    [self.view addSubview:TabbleView];
}
#pragma mark - TableView的代理方法

//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 4;
    }else{
        return 2;
    }
}

// 分组的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
//headview的高度和内容
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"   ";
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==0) {
        return 10;
    }else{
        return 0;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"  ";
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndetifier];
        
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    if (indexPath.section==0) {
        
        if (indexPath.row==0) {
            cell.textLabel.text = @"关于我们";
        }else if(indexPath.row==1){
            cell.textLabel.text = @"意见反馈";
        }else if(indexPath.row==2){
            cell.textLabel.text = @"商务合作";
        }else if(indexPath.row==3){
            cell.textLabel.text = @"客服热线";
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, Main_width-30, 30)];
            label.text = @"400-6535-355";
            label.textColor = HColor(187, 187, 187);
            [label setFont:font15];
            label.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:label];
        }
    }else{
        if(indexPath.row==0){
            cell.textLabel.text = @"版本信息";
            //获取手机程序的版本号
            NSString *ver = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            UILabel *verlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, kScreen_Width-30, 30)];
            [cell.contentView addSubview:verlabel];
            verlabel.text = [NSString stringWithFormat:@"当前版本号:v%@",ver];
            verlabel.font = [UIFont systemFontOfSize:15];
            verlabel.textColor = HColor(187, 187, 187);
            verlabel.textAlignment = NSTextAlignmentRight;
        }else{
            cell.textLabel.text = @"退出登录";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            [self checkv];
        }else{
            //初始化警告框
            UIAlertController*alert = [UIAlertController
                                       alertControllerWithTitle:@"提示"
                                       message: @"是否确定退出登录"
                                       preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction
                              actionWithTitle:@"取消"
                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                              {
                                  NSLog(@"取消退出登录");
                              }]];
            [alert addAction:[UIAlertAction
                              actionWithTitle:@"确定"
                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                              {
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
                                  [self logout];
                              }]];
            //弹出提示框
            [self presentViewController:alert
                               animated:YES completion:nil];
        }
    }if (indexPath.section==0) {
        if (indexPath.row==0) {
            guanyuwomenViewController *guanyu = [[guanyuwomenViewController alloc] init];
            [self.navigationController pushViewController:guanyu animated:YES];
        }else if (indexPath.row==1){
            yijianfankuiViewController *yijian = [[yijianfankuiViewController alloc] init];
            [self.navigationController pushViewController:yijian animated:YES];
        }else if (indexPath.row==2){
            //商务合作
            [self.navigationController pushViewController:[shangwuhezuoViewController alloc] animated:YES];
        }else{
           //kefurexian
            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"400-6535-355"];
            UIWebView *callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
        }
    }
    
}
- (void)logout
{
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil]];
   
    NSString *url = [API stringByAppendingString:@"site/logout"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSLog(@"token--%@",[user objectForKey:@"token"]);
//    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
//    NSDictionary *dict = @{@"apk_token":uid_username,@"c_id":[user objectForKey:@"community_id"],@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
    //POST必须上传的字段
    [mgr POST:url parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"logout---%@",responseObject);
        NSString *status = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]];
        
        if ([status isEqualToString:@"1"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeselecetindex" object:nil userInfo:nil];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            NSLog(@"logout11--%@",responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
- (void)checkv
{
    //获取手机程序的版本号
    NSString *ver = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"-------%@",ver);
    //获取网络该应用的版本号
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil]];
    
//    NSString *url = [API stringByAppendingString:@"site/version_update"];
    NSString *url = @" http://com.hui-shenghuo.cn/Api/Version/version_update";
    NSDictionary *dict = @{@"type":@"2",@"version":ver};
    //POST必须上传的字段
    [mgr POST:url parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"ver---%@",responseObject);
        NSString *status = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]];
        
        if ([status isEqualToString:@"1"]) {
            
            NSString *compel = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"compel"]];
            NSString *path = [[responseObject objectForKey:@"data"] objectForKey:@"path"];
            if ([compel isEqualToString:@"0"]) {
                [self creategengxinview:@"0" : [[responseObject objectForKey:@"data"] objectForKey:@"mgs"]:[[responseObject objectForKey:@"data"] objectForKey:@"version"]:path];
            }else {
                [self creategengxinview:@"1" : [[responseObject objectForKey:@"data"] objectForKey:@"mgs"]:[[responseObject objectForKey:@"data"] objectForKey:@"version"]:path];
            }
        }else{
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
- (void)creategengxinview :(NSString *)compels :(NSString *)msage :(NSString *)ver :(NSString *)path
{
    NSLog(@"%@%@%@",compels,msage,ver);
    
    UIView *shandowview = [[UIView alloc] initWithFrame:self.view.frame];
    [[HWPopTool sharedInstance] showWithPresentView:shandowview animated:YES];
    
    UIView *alertview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_width-100, Main_Height-250)];
    alertview.center = self.view.center;
    alertview.layer.cornerRadius = 5;
    alertview.backgroundColor = [UIColor clearColor];
    [shandowview addSubview:alertview];
    
    UIImageView *imageview1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, alertview.frame.size.width, alertview.frame.size.width/1.7)];
    imageview1.image = [UIImage imageNamed:@"icon_update_top"];
    [alertview addSubview:imageview1];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, imageview1.frame.size.height/2, imageview1.frame.size.width, 20)];
    label1.text = @"发现新版本";
    label1.textColor = [UIColor whiteColor];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:17];
    [imageview1 addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, imageview1.frame.size.height/2+20+10, imageview1.frame.size.width, 20)];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = [UIColor whiteColor];
    label2.font = nomalfont;
    label2.text = [NSString stringWithFormat:@"版本号:%@",ver];
    [imageview1 addSubview:label2];
    
    UIImageView *imageview2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, alertview.frame.size.height-alertview.frame.size.width/4.4, alertview.frame.size.width, alertview.frame.size.width/4.4)];
    imageview2.image = [UIImage imageNamed:@"icon_update_bottom"];
    imageview2.userInteractionEnabled = YES;
    [alertview addSubview:imageview2];
    
    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, imageview1.frame.size.height, alertview.frame.size.width, alertview.frame.size.height-alertview.frame.size.width/4.4-alertview.frame.size.width/1.7)];
    scrollview.backgroundColor = [UIColor whiteColor];
    [alertview addSubview:scrollview];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, alertview.frame.size.width-30, 0)];
    
    NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    // 行间距设置为30
    [paragraphStyle  setLineSpacing:8];
    
    NSString  *testString = msage;
    NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:testString];
    [setString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [testString length])];
    // 设置Label要显示的text
    [label  setAttributedText:setString];
    label.alpha = 0.7;
    label.numberOfLines = 0;
    label.font = font15;
    CGSize size = [label sizeThatFits:CGSizeMake(label.frame.size.width, MAXFLOAT)];
    label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, size.width,  size.height);
    [scrollview addSubview:label];
    
    scrollview.contentSize = CGSizeMake(scrollview.frame.size.width, label.frame.size.height+40);
    
    
    if ([compels isEqualToString:@"0"]) {
        NSArray *arr = @[@"残忍拒绝",@"立即更新"];
        for (int i=0; i<2; i++) {
            UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
            but.frame = CGRectMake(i*imageview2.frame.size.width/2, imageview2.frame.size.height-60, imageview2.frame.size.width/2, 60);
            [imageview2 addSubview:but];
            but.titleLabel.font = font15;
            [but setTitle:[arr objectAtIndex:i] forState:UIControlStateNormal];
            [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            but.tag = i;
            [but addTarget:self action:@selector(butclick:)forControlEvents:UIControlEventTouchUpInside];
        }
    }else{
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(0, imageview2.frame.size.height-60, imageview2.frame.size.width, 60);
        [imageview2 addSubview:but];
        [but setTitle:@"立即更新" forState:UIControlStateNormal];
        but.tag = 1;
        but.titleLabel.font = font15;
        [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [but addTarget:self action:@selector(butclick:) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)butclick:(UIButton *)sender
{
    if (sender.tag==0) {
        NSLog(@"0000000");
        [[HWPopTool sharedInstance] closeWithBlcok:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }else{
        NSLog(@"11111111");
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1205914187?mt=8"]];
    }
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
