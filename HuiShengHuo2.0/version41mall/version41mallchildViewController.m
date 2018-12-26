//
//  version41mallchildViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/12/22.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "version41mallchildViewController.h"
#import "liebiaomodel.h"
#import "liebiaoTableViewCell.h"
#import "GoodsDetailViewController.h"
#import "LoginViewController.h"
@interface version41mallchildViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *biaoqianarr;
    UIButton *_tmpBtn;
    NSString *liebiaoid;
    
    NSMutableArray *liebiaoArr;
    NSMutableArray *modelArr;
    
    NSArray *_searcharr;
    
    int _pagenum;
    
    
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL isHeader;

@end

@implementation version41mallchildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self postliebiao];
    
    
    // Do any additional setup after loading the view.
}
- (void)ui{
    
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_width, Main_Height - NAVHEIGHT - SegmentHeaderViewHeight-49)];
        //        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(postup)];
        _tableView.rowHeight = (Main_width-24-7)/2+112.5+16;
        //[self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (liebiaoArr.count+1)/2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const FirstViewControllerTableViewCellIdentifier = @"FirstViewControllerTableViewCell";
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:FirstViewControllerTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FirstViewControllerTableViewCellIdentifier];
    }
    if (liebiaoArr.count>indexPath.row*2) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(12, 0, (Main_width-24-7)/2, (Main_width-24-7)/2+112.5)];
        view.backgroundColor = [UIColor whiteColor];
        view.clipsToBounds = YES;
        view.layer.borderColor = BackColor.CGColor;
        view.layer.borderWidth = 1;
        [cell.contentView addSubview:view];
        
        
        
        
        
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.width)];
        NSURL *url = [NSURL URLWithString:[API_img stringByAppendingString:[[liebiaoArr objectAtIndex:indexPath.row*2] objectForKey:@"title_thumb_img"]]];
        [imageview sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"展位图正"]];
        [view addSubview:imageview];
        
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(12.5, 5+imageview.frame.size.height, view.frame.size.width-25, 40)];
        name.text = [[liebiaoArr objectAtIndex:indexPath.row*2] objectForKey:@"title"];
        name.font = font15;
        name.numberOfLines = 2;
        [view addSubview:name];
        
        UIView *tagview = [[UIView alloc] initWithFrame:CGRectMake(12.5, name.frame.size.height+name.frame.origin.y+7, 50, 16)];
        [view addSubview:tagview];
        NSArray *tagarr = [[liebiaoArr objectAtIndex:indexPath.row*2] objectForKey:@"goods_tag"];
        if ([tagarr isKindOfClass:[NSArray class]]) {
            if (tagarr.count>2) {
                for (int j=0; j<2; j++) {
                    UILabel *taglabel = [[UILabel alloc] initWithFrame:CGRectMake(60*j, 0, 55, 18)];
                    taglabel.text = [[tagarr objectAtIndex:j] objectForKey:@"c_name"];
                    taglabel.font = [UIFont systemFontOfSize:10];
                    taglabel.textColor = QIColor;
                    taglabel.textAlignment = NSTextAlignmentCenter;
                    taglabel.layer.cornerRadius = 2;
                    [taglabel.layer setBorderWidth:0.5];
                    [taglabel.layer setBorderColor:QIColor.CGColor];
                    [tagview addSubview:taglabel];
                }
            }else{
                for (int j=0; j<tagarr.count; j++) {
                    UILabel *taglabel = [[UILabel alloc] initWithFrame:CGRectMake(60*j, 0, 55, 18)];
                    taglabel.text = [[tagarr objectAtIndex:j] objectForKey:@"c_name"];
                    taglabel.font = [UIFont systemFontOfSize:10];
                    taglabel.textColor = QIColor;
                    taglabel.textAlignment = NSTextAlignmentCenter;
                    taglabel.layer.cornerRadius = 2;
                    [taglabel.layer setBorderWidth:0.5];
                    [taglabel.layer setBorderColor:QIColor.CGColor];
                    [tagview addSubview:taglabel];
                }
            }
        }
        
        UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(12.5, tagview.frame.size.height+tagview.frame.origin.y+12.5, 60, 20)];
        price.text = [NSString stringWithFormat:@"%@/%@",[[liebiaoArr objectAtIndex:indexPath.row*2] objectForKey:@"price"],[[liebiaoArr objectAtIndex:indexPath.row*2] objectForKey:@"unit"]];
        price.textColor = QIColor;
        price.font = [UIFont systemFontOfSize:13];
        
        [view addSubview:price];
        
        UILabel *originalprice = [[UILabel alloc] initWithFrame:CGRectMake(12.5+60+5, tagview.frame.size.height+tagview.frame.origin.y+12.5, 60, 20)];
        originalprice.textColor = CIrclecolor;
        originalprice.text = [NSString stringWithFormat:@"¥%@",[[liebiaoArr objectAtIndex:indexPath.row*2] objectForKey:@"original"]];
        originalprice.font = [UIFont systemFontOfSize:12];
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:originalprice.text attributes:attribtDic];
        originalprice.attributedText = attribtStr;
        [view addSubview:originalprice];
        
        
        UIButton *dianjibut = [UIButton buttonWithType:UIButtonTypeCustom];
        dianjibut.frame = view.frame;
        dianjibut.tag = [[[liebiaoArr objectAtIndex:indexPath.row*2] objectForKey:@"id"] longValue];
        [dianjibut addTarget:self action:@selector(pushgoods:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:dianjibut];
        
        UIButton *gouwuchebut = [UIButton buttonWithType:UIButtonTypeCustom];
        gouwuchebut.frame = CGRectMake((Main_width-24-7)/2-45, tagview.frame.size.height+tagview.frame.origin.y+5, 30, 30);
        [gouwuchebut setImage:[UIImage imageNamed:@"gouwuche"] forState:UIControlStateNormal];
        gouwuchebut.tag = indexPath.row*2;
        gouwuchebut.titleLabel.text = [NSString stringWithFormat:@"%ld",indexPath.section-4];
        [gouwuchebut.titleLabel setFont:[UIFont systemFontOfSize:0.01]];
        [gouwuchebut addTarget:self action:@selector(jiarugouwuche:) forControlEvents:UIControlEventTouchUpInside];
        [dianjibut addSubview:gouwuchebut];
    }
    
    
    if (liebiaoArr.count>indexPath.row*2+1) {
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(Main_width/2+3.5, 0, (Main_width-24-7)/2, (Main_width-24-7)/2+112.5)];
        view1.backgroundColor = [UIColor whiteColor];
        view1.clipsToBounds = YES;
        view1.layer.borderColor = BackColor.CGColor;
        view1.layer.borderWidth = 1;
        [cell.contentView addSubview:view1];
        
        UIButton *dianjibut1 = [UIButton buttonWithType:UIButtonTypeCustom];
        dianjibut1.frame = view1.frame;
        dianjibut1.tag = [[[liebiaoArr objectAtIndex:indexPath.row*2+1] objectForKey:@"id"] longValue];
        [dianjibut1 addTarget:self action:@selector(pushgoods:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:dianjibut1];
        
        UIImageView *imageview1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view1.frame.size.width, view1.frame.size.width)];
        NSURL *url1 = [NSURL URLWithString:[API_img stringByAppendingString:[[liebiaoArr objectAtIndex:indexPath.row*2+1] objectForKey:@"title_thumb_img"]]];
        [imageview1 sd_setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@"展位图正"]];
        [view1 addSubview:imageview1];
        
        UILabel *name1 = [[UILabel alloc] initWithFrame:CGRectMake(12.5, 5+imageview1.frame.size.height, view1.frame.size.width-25, 40)];
        name1.text = [[liebiaoArr objectAtIndex:indexPath.row*2+1] objectForKey:@"title"];
        name1.font = font15;
        name1.numberOfLines = 2;
        [view1 addSubview:name1];
        
        UIView *tagview1 = [[UIView alloc] initWithFrame:CGRectMake(12.5, name1.frame.size.height+name1.frame.origin.y+7, 50, 16)];
        [view1 addSubview:tagview1];
        NSArray *tagarr1 = [[liebiaoArr objectAtIndex:indexPath.row*2+1] objectForKey:@"goods_tag"];
        if ([tagarr1 isKindOfClass:[NSArray class]]) {
            if (tagarr1.count>2) {
                for (int j=0; j<2; j++) {
                    UILabel *taglabel = [[UILabel alloc] initWithFrame:CGRectMake(60*j, 0, 55, 18)];
                    taglabel.text = [[tagarr1 objectAtIndex:j] objectForKey:@"c_name"];
                    taglabel.font = [UIFont systemFontOfSize:10];
                    taglabel.textColor = QIColor;
                    taglabel.textAlignment = NSTextAlignmentCenter;
                    taglabel.layer.cornerRadius = 2;
                    [taglabel.layer setBorderWidth:0.5];
                    [taglabel.layer setBorderColor:QIColor.CGColor];
                    [tagview1 addSubview:taglabel];
                }
            }else{
                for (int j=0; j<tagarr1.count; j++) {
                    UILabel *taglabel = [[UILabel alloc] initWithFrame:CGRectMake(60*j, 0, 55, 18)];
                    taglabel.text = [[tagarr1 objectAtIndex:j] objectForKey:@"c_name"];
                    taglabel.font = [UIFont systemFontOfSize:10];
                    taglabel.textColor = QIColor;
                    taglabel.textAlignment = NSTextAlignmentCenter;
                    taglabel.layer.cornerRadius = 2;
                    [taglabel.layer setBorderWidth:0.5];
                    [taglabel.layer setBorderColor:QIColor.CGColor];
                    [tagview1 addSubview:taglabel];
                }
            }
        }
        
        UILabel *price1 = [[UILabel alloc] initWithFrame:CGRectMake(12.5, tagview1.frame.size.height+tagview1.frame.origin.y+12.5, 60, 20)];
        price1.text = [NSString stringWithFormat:@"%@/%@",[[liebiaoArr objectAtIndex:indexPath.row*2+1] objectForKey:@"price"],[[liebiaoArr objectAtIndex:indexPath.row*2+1] objectForKey:@"unit"]];
        price1.textColor = QIColor;
        price1.font = [UIFont systemFontOfSize:13];
        
        [view1 addSubview:price1];
        
        UILabel *originalprice1 = [[UILabel alloc] initWithFrame:CGRectMake(12.5+60+5, tagview1.frame.size.height+tagview1.frame.origin.y+12.5, 60, 20)];
        originalprice1.textColor = CIrclecolor;
        originalprice1.text = [NSString stringWithFormat:@"¥%@",[[liebiaoArr objectAtIndex:indexPath.row*2+1] objectForKey:@"original"]];
        originalprice1.font = [UIFont systemFontOfSize:12];
        NSDictionary *attribtDic1 = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr1 = [[NSMutableAttributedString alloc]initWithString:originalprice1.text attributes:attribtDic1];
        originalprice1.attributedText = attribtStr1;
        [view1 addSubview:originalprice1];
        
        UIButton *gouwuchebut1 = [UIButton buttonWithType:UIButtonTypeCustom];
        gouwuchebut1.frame = CGRectMake((Main_width-24-7)/2-45, tagview1.frame.size.height+tagview1.frame.origin.y+5, 30, 30);
        [gouwuchebut1 setImage:[UIImage imageNamed:@"gouwuche"] forState:UIControlStateNormal];
        gouwuchebut1.tag = indexPath.row*2+1;
        gouwuchebut1.titleLabel.text = [NSString stringWithFormat:@"%ld",indexPath.section-4];
        [gouwuchebut1.titleLabel setFont:[UIFont systemFontOfSize:0.01]];
        [gouwuchebut1 addTarget:self action:@selector(jiarugouwuche:) forControlEvents:UIControlEventTouchUpInside];
        [dianjibut1 addSubview:gouwuchebut1];
    }
    
    return cell;
}


-(void)postliebiao
{
    _pagenum = 1;
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
        //1.创建会话管理者
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        //2.封装参数
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSDictionary *dict = @{@"c_id":[user objectForKey:@"community_id"],@"id":_id};
        //3.发送GET请求
        /*
         第一个参数:请求路径(NSString)+ 不需要加参数
         第二个参数:发送给服务器的参数数据
         第三个参数:progress 进度回调
         第四个参数:success  成功之后的回调(此处的成功或者是失败指的是整个请求)
         task:请求任务
         responseObject:注意!!!响应体信息--->(json--->oc))
         task.response: 响应头信息
         第五个参数:failure 失败之后的回调
         */
        NSString *strurl = [API stringByAppendingString:@"shop/hotCateProlist"];
        [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            liebiaoArr = [[NSMutableArray alloc] init];
            modelArr = [NSMutableArray arrayWithCapacity:0];
            
            //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
            NSLog(@"center---success--%@--%@",[responseObject class],responseObject);
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
            arr = [responseObject objectForKey:@"data"];
            
            if ([[responseObject objectForKey:@"status"] integerValue]==1) {
                
                [liebiaoArr addObjectsFromArray:arr];
            }else{
                [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
            }
            [self.view addSubview:self.tableView];
            //[_TabelView reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD showToastToView:self.view withText:@"加载失败"];
            NSLog(@"failure--%@",error);
        }];
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            WBLog(@"failure--%@",error);
//
//        }];
    }// 在HUD被隐藏后的回调
       completionBlock:^{
           //操作执行完后取消对话框
           [_HUD removeFromSuperview];
           _HUD = nil;
       }];

}
- (void)postup
{
    _pagenum = _pagenum+1;
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = @{@"c_id":[user objectForKey:@"community_id"],@"id":_id,@"p":[NSString stringWithFormat:@"%d",_pagenum]};
    //3.发送GET请求
    /*
     第一个参数:请求路径(NSString)+ 不需要加参数
     第二个参数:发送给服务器的参数数据
     第三个参数:progress 进度回调
     第四个参数:success  成功之后的回调(此处的成功或者是失败指的是整个请求)
     task:请求任务
     responseObject:注意!!!响应体信息--->(json--->oc))
     task.response: 响应头信息
     第五个参数:failure 失败之后的回调
     */
    NSString *strurl = [API stringByAppendingString:@"shop/hotCateProlist"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
        NSLog(@"center---success--%@--%@",[responseObject class],responseObject);

        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            arr = [responseObject objectForKey:@"data"];
            NSString *stringnumber = [[arr objectAtIndex:0] objectForKey:@"total_Pages"];
            NSInteger i = [stringnumber integerValue];
            if (_pagenum>i) {
                _tableView.mj_footer.state = MJRefreshStateNoMoreData;
                [_tableView.mj_footer resetNoMoreData];
            }else{
                
                [liebiaoArr addObjectsFromArray:arr];
            }
            
        }
        [_tableView.mj_footer endRefreshing];
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
- (void)pushgoods:(UIButton *)sender
{
    NSDictionary *dict = @{@"goodsid":[NSString stringWithFormat:@"%lu",sender.tag]};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"zhuyemianpush" object:nil userInfo:dict];
   
}
- (void)jiarugouwuche:(UIButton *)sender
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:@"token"];
    if (str==nil) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self presentViewController:login animated:YES completion:nil];
    }else{
        long i = sender.tag;
        //int j = [sender.titleLabel.text intValue];
        NSArray *arr = [NSArray array];
        arr = liebiaoArr;
        
        NSString *kucun = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"inventory"]];
        NSString *exist_hours = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"exist_hours"]];
        NSString *tagname = [[arr objectAtIndex:i] objectForKey:@"inventory"];
        NSString *pid = [[arr objectAtIndex:i] objectForKey:@"id"];
        NSString *title = [[arr objectAtIndex:i] objectForKey:@"title"];
        NSString *title_img = [[arr objectAtIndex:i] objectForKey:@"title_img"];
        NSString *tagid = [[arr objectAtIndex:i] objectForKey:@"tagid"];
        NSString *price = [[arr objectAtIndex:i] objectForKey:@"price"];
        
        AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
        manager1.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        //2.封装参数
        NSUserDefaults *user1 = [NSUserDefaults standardUserDefaults];
        NSDictionary *dict1 = @{@"c_id":[user1 objectForKey:@"community_id"],@"p_id":pid,@"tagid":tagid,@"num":@"1",@"token":[user1 objectForKey:@"token"],@"tokenSecret":[user1 objectForKey:@"tokenSecret"]};
        //3.发送GET请求
        NSString *strurl1 = [API stringByAppendingString:@"shop/check_shop_limit"];
        [manager1 GET:strurl1 parameters:dict1 progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            
            //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
            NSLog(@"center---success--%@--%@",[responseObject class],responseObject);
            
            if ([[responseObject objectForKey:@"status"] integerValue]==1) {
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
                //2.封装参数
                
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
                NSDictionary *dict = [[NSDictionary alloc] init];
                
                
                dict = @{@"number":@"1",@"tagname":tagname,@"p_id":pid,@"p_title":title,@"p_title_img":title_img,@"tagid":tagid,@"price":price,@"apk_token":uid_username,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
                NSString *strurl = [API stringByAppendingString:@"shop/add_shopping_cart"];
                [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
                    NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"failure--%@",error);
                }];
            }else{
                [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD showToastToView:self.view withText:@"加载失败"];
            NSLog(@"failure--%@",error);
        }];
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
