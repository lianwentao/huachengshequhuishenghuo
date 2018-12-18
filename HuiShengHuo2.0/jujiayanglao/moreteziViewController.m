//
//  moreteziViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/5/31.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "moreteziViewController.h"
#import <AFNetworking.h>
#import "MJRefresh.h"
#import "pengyouquanmodel.h"
#import "liebiaoTableViewCell.h"
#import "circleCell.h"
#import "newgonggaoTableViewCell.h"
#import "NoiconCell.h"
#import "circledetailsViewController.h"
@interface moreteziViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    int _pagenum;
    NSMutableArray *_dataArr;
    UITableView *tableview;
    NSMutableArray *imgarr;
}

@end

@implementation moreteziViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"居家养老";
    [self post];
    [self createui];
    // Do any additional setup after loading the view.
}
-(void)post
{
    _pagenum = 1;
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[userinfo objectForKey:@"uid"],[userinfo objectForKey:@"username"]]];
    
    //NSString *c_id = [[quanzizhongleiArr objectAtIndex:[NSString stringWithFormat:@"%d",tag]] objectForKey:@"id"];
    dict = @{@"community_id":_community_id,@"c_id":_c_id};
    NSString *strurl = [API stringByAppendingString:@"social/get_social_list"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            NSLog(@"---%@",responseObject);
            _dataArr = [NSMutableArray arrayWithCapacity:0];
            imgarr = [[NSMutableArray alloc] init];
            [imgarr addObjectsFromArray:[responseObject objectForKey:@"data"]];
            for (int i=0; i<imgarr.count; i++) {
                pengyouquanmodel *model = [[pengyouquanmodel alloc] init];
                model.name = [[imgarr objectAtIndex:i] objectForKey:@"nickname"];
                NSData *data1 = [[NSData alloc] initWithBase64EncodedString:[[imgarr objectAtIndex:i] objectForKey:@"content"] options:0];
                NSString *labeltext = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
                model.content = labeltext;
                model.touxiangurl = [API_img stringByAppendingString:[[imgarr objectAtIndex:i] objectForKey:@"avatars"]];
                model.imageArr = [[imgarr objectAtIndex:i] objectForKey:@"img_list"];
                NSData *data2 = [[NSData alloc] initWithBase64EncodedString:[[imgarr objectAtIndex:i] objectForKey:@"title"] options:0];
                NSString *labeltext2 = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
                model.title = labeltext2;
                model.social_id = [[imgarr objectAtIndex:i] objectForKey:@"id"];
                model.uid = [[imgarr objectAtIndex:i] objectForKey:@"uid"];
                model.fabutime = [[imgarr objectAtIndex:i] objectForKey:@"addtime"];
                model.scan = [[imgarr objectAtIndex:i] objectForKey:@"click"];
                model.pinglun = [[imgarr objectAtIndex:i] objectForKey:@"reply_num"];
                model.fenlei = [[imgarr objectAtIndex:i] objectForKey:@"c_name"];
                model.guanfang = [[imgarr objectAtIndex:i] objectForKey:@"admin_id"];
                model.community_name = [[imgarr objectAtIndex:i] objectForKey:@"community_name"];
                [_dataArr addObject:model];
            }
            
        }
        [tableview reloadData];
        
        [tableview.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
    
    
}

- (void)createui
{
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_width, Main_Height) style:UITableViewStylePlain];
    
    tableview.estimatedRowHeight = 0;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
    tableview.tableHeaderView = view;
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
    tableview.tableFooterView = view1;
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
    
   
    //上拉刷新
    tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(postup)];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    {
        if ([[[imgarr objectAtIndex:indexPath.section] objectForKey:@"img_list"] isKindOfClass:[NSArray class]]) {
            
            NSString *admin = [NSString stringWithFormat:@"%@",[[imgarr objectAtIndex:0] objectForKey:@"admin_id"]];
            if ([admin isEqualToString:@"0"]) {
                NSString *cellIndetifier = @"oneiconcell0";
                NSLog(@"-----------111");
                circleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
                if (cell == nil) {
                    cell = [[circleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                    
                    //cell.userInteractionEnabled = NO;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
                }
                cell.model = [_dataArr objectAtIndex:indexPath.section];
                return cell;
            }else{
                NSString *cellIndetifier = @"oneiconcell0";
                NSLog(@"-----------333");
                newgonggaoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
                if (cell == nil) {
                    cell = [[newgonggaoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                    
                    //cell.userInteractionEnabled = NO;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
                }
                cell.model = [_dataArr objectAtIndex:indexPath.section];
                return cell;
            }
        }else{
            NSLog(@"-----------222");
            NSString *cellIndetifier = @"noiconcell0";
            NoiconCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
            if (cell == nil) {
                cell = [[NoiconCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                
                //cell.userInteractionEnabled = NO;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
            }
            cell.model = [_dataArr objectAtIndex:indexPath.section];
            return cell;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[imgarr objectAtIndex:indexPath.section] objectForKey:@"img_list"] isKindOfClass:[NSArray class]]){
        if ([[[imgarr objectAtIndex:indexPath.section] objectForKey:@"admin_id"] isEqualToString:@"0"]) {
            return 75+(Main_width-36)/3+15+40+18+30+25;
        }else{
            return 147;
        }
    }else{
        return 75+40+18+30+25;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"---%zi",indexPath.section);
    circledetailsViewController *details = [[circledetailsViewController alloc] init];
    details.id = [[imgarr objectAtIndex:indexPath.section] objectForKey:@"id"];
    details.is_pro = @"0";
    details.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:details animated:YES];
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
    
    dict = @{@"community_id":[userinfo objectForKey:@"community_id"],@"c_id":_c_id,@"p":string};
    
    NSString *strurl = [API stringByAppendingString:@"social/get_social_list"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@==%@",[responseObject objectForKey:@"msg"],responseObject);
        NSArray *arr = [[NSArray alloc] init];
        arr = [responseObject objectForKey:@"data"];
        NSString *stringnumber = [[arr objectAtIndex:0] objectForKey:@"total_Pages"];
        NSInteger i = [stringnumber integerValue];
        if (_pagenum>i) {
            tableview.mj_footer.state = MJRefreshStateNoMoreData;
            [tableview.mj_footer resetNoMoreData];
        }else{
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            arr = [responseObject objectForKey:@"data"];
            [imgarr addObjectsFromArray:arr];
            for (int i=0; i<arr.count; i++) {
                pengyouquanmodel *model = [[pengyouquanmodel alloc] init];
                model.name = [[arr objectAtIndex:i] objectForKey:@"nickname"];
                NSData *data1 = [[NSData alloc] initWithBase64EncodedString:[[arr objectAtIndex:i] objectForKey:@"content"] options:0];
                NSString *labeltext = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
                model.content = labeltext;
                model.touxiangurl = [API_img stringByAppendingString:[[arr objectAtIndex:i] objectForKey:@"avatars"]];
                model.imageArr = [[arr objectAtIndex:i] objectForKey:@"img_list"];
                NSData *data2 = [[NSData alloc] initWithBase64EncodedString:[[arr objectAtIndex:i] objectForKey:@"title"] options:0];
                NSString *labeltext2 = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
                model.title = labeltext2;
                model.social_id = [[arr objectAtIndex:i] objectForKey:@"id"];
                model.uid = [[arr objectAtIndex:i] objectForKey:@"uid"];
                model.fabutime = [[arr objectAtIndex:i] objectForKey:@"addtime"];
                model.scan = [[arr objectAtIndex:i] objectForKey:@"click"];
                model.pinglun = [[arr objectAtIndex:i] objectForKey:@"reply_num"];
                model.fenlei = [[arr objectAtIndex:i] objectForKey:@"c_name"];
                model.guanfang = [[arr objectAtIndex:i] objectForKey:@"admin_id"];
                model.community_name = [[arr objectAtIndex:i] objectForKey:@"community_name"];
                [_dataArr addObject:model];
            }
            [tableview reloadData];
            [tableview.mj_footer endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
    
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
