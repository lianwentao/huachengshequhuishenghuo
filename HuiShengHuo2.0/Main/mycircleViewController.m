//
//  mycircleViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/12/5.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import "mycircleViewController.h"
#import "PrefixHeader.pch"
#import <AFNetworking.h>
#import "UIImageView+WebCache.h"
#import "SaveViewController.h"
#import "MJRefresh.h"
#import "circledetailsViewController.h"
#import "UITableView+PlaceHolderView.h"
#import <YYLabel.h>
#import "pengyouquanmodel.h"
#import "circleCell.h"
#import "NoiconCell.h"
#import "HavrReplyCell.h"
#import "HaveNOiconCell.h"
#import "circledetailsViewController.h"
#import "MBProgressHUD+TVAssistant.h"
#define screen_Width [UIScreen mainScreen].bounds.size.width
#define screen_Height [UIScreen mainScreen].bounds.size.height
@interface mycircleViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *Arr;
    int _pagenum;
    NSMutableArray *ImageArr;
}

@property(nonatomic ,strong)UITableView *TableView;
@property(nonatomic ,strong)NSMutableArray *DataArr;
@end

@implementation mycircleViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的邻里";
    _DataArr = [[NSMutableArray alloc] init];
    ImageArr = [[NSMutableArray alloc] init];
    NSLog(@"******mycircle");
    [self createtableview];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gengxinmain" object:nil userInfo:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deletetiezi:) name:@"shanchuwodetiezi" object:nil];//
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deletetiezi:) name:@"shanchutiezi" object:nil];//
    // Do any additional setup after loading the view.
}
- (void)deletetiezi:(NSNotification *)userinfo
{
    //初始化警告框
    UIAlertController*alert = [UIAlertController
                               alertControllerWithTitle:@"提示"
                               message: @"是否确认删除"
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
                          NSString *socail_id = [userinfo.userInfo objectForKey:@"scoailid"];
                          //1.创建会话管理者
                          AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                          manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
                          //2.封装参数
                          NSDictionary *dict = nil;
                          NSUserDefaults *userdefalts = [NSUserDefaults standardUserDefaults];
                          NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[userdefalts objectForKey:@"uid"],[userdefalts objectForKey:@"username"]]];
                          //NSString *c_id = [[quanzizhongleiArr objectAtIndex:[NSString stringWithFormat:@"%d",tag]] objectForKey:@"id"];
                          dict = @{@"social_id":socail_id,@"apk_token":uid_username,@"token":[userdefalts objectForKey:@"token"],@"tokenSecret":[userdefalts objectForKey:@"tokenSecret"]};
                          NSString *strurl = [API stringByAppendingString:@"social/SocialDel"];
                          [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                              NSLog(@"%@--%@",responseObject,[responseObject class]);
                              if ([[responseObject objectForKey:@"status"] integerValue]==1) {
                                  [self postdown];
                                  [[NSNotificationCenter defaultCenter] postNotificationName:@"changequnzishouye" object:nil userInfo:nil];
                              }else{
                                  
                              }
                              [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
                          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                              NSLog(@"failure--%@",error);
                          }];
                      }]];
    //弹出提示框
    [self presentViewController:alert
                       animated:YES completion:nil];
}
- (void)createtableview
{
    _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_Width, screen_Height) style:UITableViewStylePlain];
    _TableView.estimatedRowHeight = 0;
    _TableView.delegate = self;
    _TableView.dataSource = self;
    _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
 //   _TableView.tableFooterView = [UIView new];
    __weak typeof(self) weakSelf = self;
    _TableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    //_TableView.mj_header.las = YES;
    //上拉刷新
    //_TableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(postup)];
    [_TableView.mj_header beginRefreshing];
   [self.view addSubview:_TableView];
}
- (void)loadData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self postdown];
    });
}
#pragma mark - TableView 占位图
- (UIImage *)xy_noDataViewImage {
    return [UIImage imageNamed:@"pinglunweikong"];
}

- (NSString *)xy_noDataViewMessage {
    return @"暂无数据";
}
- (UIColor *)xy_noDataViewMessageColor {
    return [UIColor blackColor];
}
#pragma mark ------联网请求---
-(void)postdown
{
    NSLog(@"qqqqq******mycircle");
    _pagenum =1;
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[userinfo objectForKey:@"uid"],[userinfo objectForKey:@"username"]]];
    //NSString *c_id = [[quanzizhongleiArr objectAtIndex:[NSString stringWithFormat:@"%d",tag]] objectForKey:@"id"];
    dict = @{@"community_id":[userinfo objectForKey:@"community_id"],@"type":@"1",@"p":@"1",@"is_pro":@"0",@"apk_token":uid_username,@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"]};
    NSString *strurl = [API stringByAppendingString:@"social/get_user_social_list"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"---%@",responseObject);
        [_DataArr removeAllObjects];
        [ImageArr removeAllObjects];
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            
            
            NSMutableArray *imgarr = [[NSMutableArray alloc] init];
            imgarr = [responseObject objectForKey:@"data"];
            [ImageArr addObjectsFromArray:imgarr];
            for (int i=0; i<ImageArr.count; i++) {
                pengyouquanmodel *model = [[pengyouquanmodel alloc] init];
                model.name = [[ImageArr objectAtIndex:i] objectForKey:@"nickname"];
                NSData *data1 = [[NSData alloc] initWithBase64EncodedString:[[imgarr objectAtIndex:i] objectForKey:@"content"] options:0];
                NSString *labeltext = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
                model.content = labeltext;
                model.touxiangurl = [API_img stringByAppendingString:[[imgarr objectAtIndex:i] objectForKey:@"avatars"]];
                model.imageArr = [[imgarr objectAtIndex:i] objectForKey:@"img_list"];

                model.social_id = [[imgarr objectAtIndex:i] objectForKey:@"id"];
                model.uid = [[imgarr objectAtIndex:i] objectForKey:@"uid"];
                model.fabutime = [[imgarr objectAtIndex:i] objectForKey:@"addtime"];
                model.scan = [[ImageArr objectAtIndex:i] objectForKey:@"click"];
                model.pinglun = [[ImageArr objectAtIndex:i] objectForKey:@"reply_num"];
                model.fenlei = [[ImageArr objectAtIndex:i] objectForKey:@"c_name"];
                model.guanfang = [[ImageArr objectAtIndex:i] objectForKey:@"admin_id"];
                model.community_name = [[ImageArr objectAtIndex:i] objectForKey:@"community_name"];
                
                model.qufenwodelinli = @"wodelinli";
                
                NSDictionary *replylist = [[NSDictionary alloc] init];
                replylist = [[[responseObject objectForKey:@"data"] objectAtIndex:i] objectForKey:@"reply"];
                if (![[replylist objectForKey:@"new_reply_num"] isEqualToString:@"0"]) {
                    model.replytime = [replylist objectForKey:@"addtime"];
                    model.replytouxiangurl = [API_img stringByAppendingString:[replylist objectForKey:@"avatars"]];
                    model.replyname = [replylist objectForKey:@"nickname"];
                    
                    NSData *data2 = [[NSData alloc] initWithBase64EncodedString:[replylist objectForKey:@"content"] options:0];
                    NSString *labeltext2 = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
                    model.replycontent = labeltext2;
                    model.replynumber = [replylist objectForKey:@"new_reply_num"];
                }
                [_DataArr addObject:model];
            }
        }
        
        
        
        [_TableView reloadData];
        [_TableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
- (void)postup
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    _pagenum = _pagenum+1;
    //2.封装参数
    NSString *string = [NSString stringWithFormat:@"%d",_pagenum];
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[userinfo objectForKey:@"uid"],[userinfo objectForKey:@"username"]]];
    dict = @{@"community_id":[userinfo objectForKey:@"community_id"],@"is_pro":@"0",@"type":@"1",@"p":string,@"apk_token":uid_username,@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"]};
    
    NSString *strurl = [API stringByAppendingString:@"social/get_user_social_list"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            NSArray *arr = [[NSArray alloc] init];
            arr = [responseObject objectForKey:@"data"];
            NSString *stringnumber = [[arr objectAtIndex:0] objectForKey:@"total_Pages"];
            NSInteger i = [stringnumber integerValue];
            if (_pagenum>i) {
                _TableView.mj_footer.state = MJRefreshStateNoMoreData;
                [_TableView.mj_footer resetNoMoreData];
            }else{
                NSMutableArray *imgarr = [[NSMutableArray alloc] init];
                imgarr = [responseObject objectForKey:@"data"];
                [ImageArr addObjectsFromArray:imgarr];
                for (int i=0; i<imgarr.count; i++) {
                    pengyouquanmodel *model = [[pengyouquanmodel alloc] init];
                    model.name = [[imgarr objectAtIndex:i] objectForKey:@"nickname"];
                    NSData *data1 = [[NSData alloc] initWithBase64EncodedString:[[imgarr objectAtIndex:i] objectForKey:@"content"] options:0];
                    NSString *labeltext = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
                    model.content = labeltext;
                    model.touxiangurl = [API_img stringByAppendingString:[[imgarr objectAtIndex:i] objectForKey:@"avatars"]];
                    model.imageArr = [[imgarr objectAtIndex:i] objectForKey:@"img_list"];
                    
                    model.social_id = [[imgarr objectAtIndex:i] objectForKey:@"id"];
                    model.uid = [[imgarr objectAtIndex:i] objectForKey:@"uid"];
                    model.fabutime = [[imgarr objectAtIndex:i] objectForKey:@"addtime"];
                    model.scan = [[imgarr objectAtIndex:i] objectForKey:@"click"];
                    model.pinglun = [[imgarr objectAtIndex:i] objectForKey:@"reply_num"];
                    model.fenlei = [[imgarr objectAtIndex:i] objectForKey:@"c_name"];
                    model.guanfang = [[imgarr objectAtIndex:i] objectForKey:@"admin_id"];
                    model.community_name = [[imgarr objectAtIndex:i] objectForKey:@"community_name"];
                    model.qufenwodelinli = @"wodelinli";
                    
                    
                    NSDictionary *replylist = [[NSDictionary alloc] init];
                    replylist = [[[responseObject objectForKey:@"data"] objectAtIndex:i] objectForKey:@"reply"];
                    if (![[replylist objectForKey:@"new_reply_num"] isEqualToString:@"0"]) {
                        model.replytime = [replylist objectForKey:@"addtime"];
                        model.replytouxiangurl = [API_img stringByAppendingString:[replylist objectForKey:@"avatars"]];
                        model.replyname = [replylist objectForKey:@"nickname"];
                        
                        NSData *data2 = [[NSData alloc] initWithBase64EncodedString:[replylist objectForKey:@"content"] options:0];
                        NSString *labeltext2 = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
                        model.replycontent = labeltext2;
                        model.replynumber = [replylist objectForKey:@"new_reply_num"];
                    }
                    [_DataArr addObject:model];
                }
                
            }
        }
        NSLog(@"%@==%@",[responseObject objectForKey:@"msg"],responseObject);
        [_TableView.mj_footer endRefreshing];
        [_TableView reloadData];
        

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _DataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr = [[NSArray alloc] init];
    arr = [[ImageArr objectAtIndex:indexPath.section] objectForKey:@"img_list"];
    if (arr.count>0) {
        if ([[[[ImageArr objectAtIndex:indexPath.section] objectForKey:@"reply"] objectForKey:@"new_reply_num"] isEqualToString:@"0"])
        {
            NSString *cellIndetifier = @"oneiconcell";
            NSLog(@"-----------有图--无评论");
            circleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
            if (cell == nil) {
                cell = [[circleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                
                //cell.userInteractionEnabled = NO;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
            }
            cell.model = [_DataArr objectAtIndex:indexPath.section];
            return cell;
        }else{
            NSString *cellIndetifier = @"havereplycell";
            NSLog(@"-----------有图--有评论");
            HavrReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
            if (cell == nil) {
                cell = [[HavrReplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                
                //cell.userInteractionEnabled = NO;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
            }
            cell.model = [_DataArr objectAtIndex:indexPath.section];
            return cell;
        }
    }else{
        if ([[[[ImageArr objectAtIndex:indexPath.section] objectForKey:@"reply"] objectForKey:@"new_reply_num"] isEqualToString:@"0"])
        {
            NSLog(@"-----------无图--无评论");
            NSString *cellIndetifier = @"noiconcell";
            NoiconCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
            if (cell == nil) {
                cell = [[NoiconCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                
                //cell.userInteractionEnabled = NO;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
            }
            cell.model = [_DataArr objectAtIndex:indexPath.section];
            return cell;
        }else{
            NSLog(@"-----------无图--有评论");
            NSString *cellIndetifier = @"havereplynoiconcell";
            HaveNOiconCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
            if (cell == nil) {
                cell = [[HaveNOiconCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                
                //cell.userInteractionEnabled = NO;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
            }
            cell.model = [_DataArr objectAtIndex:indexPath.section];
            return cell;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr = [[NSArray alloc] init];
    arr = [[ImageArr objectAtIndex:indexPath.section] objectForKey:@"img_list"];
    if (arr.count>0) {
        if ([[[[ImageArr objectAtIndex:indexPath.section] objectForKey:@"reply"] objectForKey:@"new_reply_num"] isEqualToString:@"0"])
        {
            return 203+(Main_width-36)/3;
        }else{
            return 203+(Main_width-36)/3+112.5;
        }
    }else{
        if ([[[[ImageArr objectAtIndex:indexPath.section] objectForKey:@"reply"] objectForKey:@"new_reply_num"] isEqualToString:@"0"])
        {
            return 203-15;
        }else{
            return 203+112.5;
        }
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    circledetailsViewController *details = [[circledetailsViewController alloc] init];
    details.id = [[ImageArr objectAtIndex:indexPath.section] objectForKey:@"id"];
    details.is_pro = @"0";
    details.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:details animated:YES];
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
