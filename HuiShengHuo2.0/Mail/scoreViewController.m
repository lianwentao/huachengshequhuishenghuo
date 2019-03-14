//
//  scoreViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/1/22.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "scoreViewController.h"
#import <AFNetworking.h>
#import "UIImageView+WebCache.h"
#import "shangpinpingjiaTableViewCell.h"
#define screen_Width [UIScreen mainScreen].bounds.size.width
#define screen_Height [UIScreen mainScreen].bounds.size.height
@interface scoreViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_TableView;
    NSMutableArray *_DataArr;
}

@end

@implementation scoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品评价";
    self.view.backgroundColor = [UIColor whiteColor];
    [self post];
    [self CreateTableview];
    // Do any additional setup after loading the view.
}
#pragma mark - 创建tableview
- (void)CreateTableview
{
    _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    //_TableView.estimatedRowHeight = 0;
    _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _TableView.delegate = self;
    _TableView.dataSource = self;
    [self.view addSubview:_TableView];
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
//headview的高度和内容
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @" ";
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"  ";
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"-+-+-+-+%@",_DataDic);
    static NSString *cellIndetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
    }
    UILabel *namelabel = [[UILabel alloc] initWithFrame:CGRectMake(screen_Width/2, 10, screen_Width/2-15, 25)];
    namelabel.text = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"username"];
    namelabel.font = [UIFont systemFontOfSize:12];
    namelabel.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:namelabel];
    
    int i = [[[_DataArr objectAtIndex:indexPath.row] objectForKey:@"score"] intValue];
    for (int j = 0; j<i; j++) {
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15+j*35, 10, 20, 20)];
        imageview.image = [UIImage imageNamed:@"circle_icon_xingxing_dianjihou"];
        [cell.contentView addSubview:imageview];
    }
    
    UILabel *labelcontent = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, screen_Width-30, 0)];
    labelcontent.text = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"description"];
    labelcontent.font = [UIFont systemFontOfSize:15];
    labelcontent.numberOfLines = 0;
    CGSize size = [labelcontent sizeThatFits:CGSizeMake(labelcontent.frame.size.width, MAXFLOAT)];
    labelcontent.frame = CGRectMake(labelcontent.frame.origin.x, labelcontent.frame.origin.y, labelcontent.frame.size.width,            size.height);
    [cell.contentView addSubview:labelcontent];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 40+size.height+4, screen_Width, 0.5)];
    view.alpha = 0.2;
    view.backgroundColor = [UIColor blackColor];
    [cell.contentView addSubview:view];
    tableView.rowHeight = 40+size.height+5;
    return cell;
}
#pragma mark ------联网请求---
-(void)post{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    NSDictionary *dict = @{@"id":_id,@"apk_token":uid_username,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
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
    
    NSString *strurl = [API stringByAppendingString:@"shop/goods_review"];
    _DataArr = [[NSMutableArray alloc] init];
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _DataArr = [responseObject objectForKey:@"data"];
        NSLog(@"success--%@--%@",[responseObject class],responseObject);
        [_TableView reloadData];
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
