//
//  gongdanadressViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/12/18.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "gongdanadressViewController.h"

@interface gongdanadressViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>
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
    AppDelegate *myDelegate;
}

@end

@implementation gongdanadressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"选择地址";
    myDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [self post];
    [self CreateTableView];
    // Do any additional setup after loading the view.
}
#pragma mark ------联网请求---
-(void)post
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = @{@"token":[defaults objectForKey:@"token"],@"tokenSecret":[defaults objectForKey:@"tokenSecret"],@"hui_community_id":[user objectForKey:@"community_id"]};
    
    NSString *urlstr = [API stringByAppendingString:@"propertyWork/getWorkAddress"];
    [manager POST:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _DataArr = [[NSMutableArray alloc] init];
        
        
        
        NSLog(@"success收货地址--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            _DataArr = [responseObject objectForKey:@"data"];
        }else{
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
        [TabbleView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
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
    
    UILabel *labelname = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, Main_width-40, 40)];
    labelname.font = [UIFont systemFontOfSize:18];
    NSString *string1 = [NSString stringWithFormat:@"%@  %@",[[_DataArr objectAtIndex:indexPath.row] objectForKey:@"fullname"],[[_DataArr objectAtIndex:indexPath.row] objectForKey:@"mobile"]];
    labelname.text = string1;
    NSLog(@"=======%@",labelname.text);
    [cell.contentView addSubview:labelname];
    
    UILabel *labelcontent = [[UILabel alloc] initWithFrame:CGRectMake(20, 55, Main_width-40-40, 0)];
    labelcontent.numberOfLines = 0;
    labelcontent.font = [UIFont systemFontOfSize:15];
    NSString *string2 = [NSString stringWithFormat:@"%@ %@号楼%@单元%@",[[_DataArr objectAtIndex:indexPath.row] objectForKey:@"community_name"],[[_DataArr objectAtIndex:indexPath.row] objectForKey:@"building_name"],[[_DataArr objectAtIndex:indexPath.row] objectForKey:@"unit"],[[_DataArr objectAtIndex:indexPath.row] objectForKey:@"code"]];
    labelcontent.text = string2;
    CGSize size = [labelcontent sizeThatFits:CGSizeMake(labelcontent.frame.size.width, MAXFLOAT)];
    labelcontent.frame = CGRectMake(labelcontent.frame.origin.x, labelcontent.frame.origin.y, labelcontent.frame.size.width,            size.height);
    tableView.rowHeight = size.height+55+10;
    [cell.contentView addSubview:labelcontent];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakself = self;
    
    if (weakself.returnValueBlock) {
        //将自己的值传出去，完成传值
        weakself.returnValueBlock([_DataArr objectAtIndex:indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:YES];
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
