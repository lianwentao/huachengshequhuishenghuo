//
//  AdressViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/11/30.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import "AdressViewController.h"
#import <AFNetworking.h>
#import "MBProgressHUD+TVAssistant.h"
#import "edAddressViewController.h"
#import "UITableView+PlaceHolderView.h"

#define kScreen_Height   ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width    ([UIScreen mainScreen].bounds.size.width)
#import "PrefixHeader.pch"
@interface AdressViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>
{
    UITableView *TabbleView;
    NSMutableArray *_DataArr;
    
    NSString *str1;
    NSString *str2;
    NSString *str3;
    NSString *str4;
    
    NSString *strid;
    NSString *stringid;
    
    NSDictionary *dict;
}

@end

@implementation AdressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change) name:@"changereload" object:nil];
    
    [self CreateTableView];
    [self post];
    [self addRightBtn];
    // Do any additional setup after loading the view.
}
- (void)change
{
    [self post];
}
#pragma mark - 创建TableView
- (void)CreateTableView
{
    TabbleView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    TabbleView.backgroundColor = [UIColor whiteColor];
    TabbleView.estimatedRowHeight = 0;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
    TabbleView.tableHeaderView = view;
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
    TabbleView.tableFooterView = view1;
    //_Hometableview.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 0.01f)];
    /** 去除tableview 右侧滚动条 */
    TabbleView.showsVerticalScrollIndicator = YES;
    /** 去掉分割线 */
    //Hometableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    TabbleView.delegate = self;
    TabbleView.dataSource = self;
    //TabbleView.enablePlaceHolderView = YES;
    [self.view addSubview:TabbleView];
}
#pragma mark - TableView的代理方法

//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _DataArr.count;
}

// 分组的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }    //点击的时候无效果
    
    UILabel *labelname = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, kScreen_Width-40, 40)];
    labelname.font = [UIFont systemFontOfSize:18];
    NSString *string1 = [NSString stringWithFormat:@"%@  %@",[[_DataArr objectAtIndex:indexPath.row] objectForKey:@"consignee_name"],[[_DataArr objectAtIndex:indexPath.row] objectForKey:@"consignee_mobile"]];
    labelname.text = string1;
    NSLog(@"=======%@",labelname.text);
    [cell.contentView addSubview:labelname];
    
    UILabel *labelcontent = [[UILabel alloc] initWithFrame:CGRectMake(20, 55, kScreen_Width-40-40, 0)];
    labelcontent.numberOfLines = 0;
    labelcontent.font = [UIFont systemFontOfSize:15];
    NSString *string2 = [NSString stringWithFormat:@"%@ %@ %@",[[_DataArr objectAtIndex:indexPath.row] objectForKey:@"region_cn"],[[_DataArr objectAtIndex:indexPath.row] objectForKey:@"community_cn"],[[_DataArr objectAtIndex:indexPath.row] objectForKey:@"doorplate"]];
    labelcontent.text = string2;
    CGSize size = [labelcontent sizeThatFits:CGSizeMake(labelcontent.frame.size.width, MAXFLOAT)];
    labelcontent.frame = CGRectMake(labelcontent.frame.origin.x, labelcontent.frame.origin.y, labelcontent.frame.size.width,            size.height);
    tableView.rowHeight = size.height+55+10;
    [cell.contentView addSubview:labelcontent];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_yesnoselecte isEqualToString:@"1"]) {
        NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
        if (![[userinfo objectForKey:@"community_id"] isEqualToString:[[_DataArr objectAtIndex:indexPath.row] objectForKey:@"community_id"]]) {
            [MBProgressHUD showToastToView:self.view withText:@"您选择的地址不在当前小区配送范围内，请返回首页选择与您地址相符合的小区"];
        }else{
            __weak typeof(self) weakself = self;
            
            if (weakself.returnValueBlock) {
                NSString *stringname = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"consignee_name"];
                NSString *stringphone = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"consignee_mobile"];
                NSString *stringaddress = [NSString stringWithFormat:@"%@ %@ %@",[[_DataArr objectAtIndex:indexPath.row] objectForKey:@"region_cn"],[[_DataArr objectAtIndex:indexPath.row] objectForKey:@"community_cn"],[[_DataArr objectAtIndex:indexPath.row] objectForKey:@"doorplate"]];
                NSString *stringaddressid = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"id"];
                //将自己的值传出去，完成传值
                weakself.returnValueBlock(stringname,stringphone,stringaddress,stringaddressid,[_DataArr objectAtIndex:indexPath.row]);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        __weak typeof(self) weakself = self;
        
        if (weakself.returnValueBlock) {
            NSString *stringname = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"consignee_name"];
            NSString *stringphone = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"consignee_mobile"];
            NSString *stringaddress = [NSString stringWithFormat:@"%@ %@ %@",[[_DataArr objectAtIndex:indexPath.row] objectForKey:@"region_cn"],[[_DataArr objectAtIndex:indexPath.row] objectForKey:@"community_cn"],[[_DataArr objectAtIndex:indexPath.row] objectForKey:@"doorplate"]];
            NSString *stringaddressid = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"id"];
            //将自己的值传出去，完成传值
            weakself.returnValueBlock(stringname,stringphone,stringaddress,stringaddressid,[_DataArr objectAtIndex:indexPath.row]);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteRoWAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {//title可自已定义
        
        stringid = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"id"];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
        dict = @{@"id":stringid,@"apk_token":uid_username,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"],@"hui_community_id":[user objectForKey:@"community_id"]};
        [self post1];
    }];//此处是iOS8.0以后苹果最新推出的api
    UITableViewRowAction *editRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"编辑");
        edAddressViewController *edaddress = [[edAddressViewController alloc] init];
        str1 = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"consignee_name"];
        str2 = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"community_cn"];
        str3 = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"doorplate"];
        str4 = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"consignee_mobile"];
        strid = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"id"];
        edaddress.title = @"修改地址";
        edaddress.strone = str1;
        edaddress.strtwo = str2;
        edaddress.strthree = str3;
        edaddress.strfour = str4;
        edaddress.id = strid;
        edaddress.region_id = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"region_id"];
        edaddress.community_id = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"community_id"];
        [self.navigationController pushViewController:edaddress animated:YES];
    }];
    editRowAction.backgroundColor = [UIColor colorWithRed:0 green:124/255.0 blue:223/255.0 alpha:1];//可以定义RowAction的颜色
    return @[deleteRoWAction, editRowAction];//最后返回这俩个RowAction 的数组
}
#pragma mark - 导航栏rightbutton
- (void)addRightBtn
{
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(tianjia)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}
- (void)tianjia
{
    edAddressViewController *edaddress = [[edAddressViewController alloc] init];
    edaddress.title = @"添加地址";
    edaddress.biaojistr = @"1";
    [self.navigationController pushViewController:edaddress animated:YES];
}
#pragma mark ------联网请求---
-(void)post
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[defaults objectForKey:@"uid"],[defaults objectForKey:@"username"]]];
    NSDictionary *dict = @{@"c_id":[defaults objectForKey:@"community_id"],@"token":[defaults objectForKey:@"token"],@"tokenSecret":[defaults objectForKey:@"tokenSecret"],@"hui_community_id":[defaults objectForKey:@"community_id"]};
    NSString *urlstr = [API stringByAppendingString:@"userCenter/get_user_address"];
    [manager POST:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _DataArr = [[NSMutableArray alloc] init];
       
        
        
        NSLog(@"success收货地址--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            _DataArr = [[responseObject objectForKey:@"data"] objectForKey:@"com_list"];
        }else{
             _DataArr = nil;
            //[MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
        [TabbleView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
-(void)post1
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSString *urlstr = [API stringByAppendingString:@"userCenter/del_user_address"];
    [manager POST:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self post];
        [TabbleView reloadData];
        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            
        }else{
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
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
