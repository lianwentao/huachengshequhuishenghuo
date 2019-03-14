//
//  FirstRunViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/11/23.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import "FirstRunViewController.h"
#import <AFNetworking.h>
#import "Person.h"
#import "BMChineseSort.h"
#import "DiquViewController.h"
#import "HalfCircleActivityIndicatorView.h"

#import "PrefixHeader.pch"

@interface FirstRunViewController ()<UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_Tableview;
    NSMutableArray *_Dataarr;
    NSMutableArray *arr;
    HalfCircleActivityIndicatorView *LoadingView;
}

//排序后的出现过的拼音首字母数组
@property(nonatomic,strong)NSMutableArray *indexArray;
//排序好的结果数组
@property(nonatomic,strong)NSMutableArray *letterResultArr;
//
@property(nonatomic,strong)NSMutableArray *idArr;
@end

@implementation FirstRunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择地区";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.delegate=self;
    //修改系统导航栏下一个界面的返回按钮title
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    
    [self post];
    [self createtableview];
    [self LoadingView];
    [LoadingView startAnimating];
    //[self Createdaohanglan];
    // Do any additional setup after loading the view.
}
- (void)createtableview
{
    _Tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStyleGrouped];
    _Tableview.delegate = self;
    _Tableview.dataSource = self;
    [self.view addSubview:_Tableview];
}
#pragma mark - LoadingView
- (void)LoadingView
{
    LoadingView = [[HalfCircleActivityIndicatorView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-40)/2, (self.view.frame.size.height-40)/2, 40, 40)];
    [self.view addSubview:LoadingView];
}

#pragma mark ------联网请求---
-(void)post{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    //NSDictionary *dict = @{@"id":_IDstring};
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *API = [defaults objectForKey:@"API"];
    NSString *strurl = [API stringByAppendingString:@"site/get_city/1408"];
    [manager POST:strurl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _Dataarr = [[NSMutableArray alloc] initWithCapacity:0];
        arr = [[NSMutableArray alloc] init];
        arr = [responseObject objectForKey:@"data"];
        for (int i = 0; i<[arr count]; i++) {
            Person *p = [[Person alloc] init];
            p.name = [[arr objectAtIndex:i] objectForKey:@"region_name"];
            p.number = i;
            p.id = [[arr objectAtIndex:i] objectForKey:@"region_code"];
            [_Dataarr addObject:p];
        }
        //根据Person对象的 name 属性 按中文 对 Person数组 排序
        self.indexArray = [BMChineseSort IndexWithArray:_Dataarr Key:@"name"];
        self.letterResultArr = [BMChineseSort sortObjectArray:_Dataarr Key:@"name"];
        _idArr = [BMChineseSort sortObjectArray:_Dataarr Key:@"name"];
        [_Tableview reloadData];
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            [LoadingView stopAnimating];
            LoadingView.hidden = YES;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
        [LoadingView stopAnimating];
        LoadingView.hidden = YES;
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-50, self.view.frame.size.height/2-50, 100, 100)];
        imageview.image = [UIImage imageNamed:@"1"];
        [self.view addSubview:imageview];
        
        NSLog(@"failure--%@",error);
    }];
}
#pragma mark - UITableView -
//section的titleHeader
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.indexArray objectAtIndex:section];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"  ";
}
//section行数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.indexArray count];
}
//每组section个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.letterResultArr objectAtIndex:section] count];
}
//section右侧index数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.indexArray;
}
//点击右侧索引表项时调用 索引与section的对应关系
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index;
}
//返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
        Person *p = [[self.letterResultArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.textLabel.text = p.name;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DiquViewController *diqu = [[DiquViewController alloc] init];
    Person *p = [[_idArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    diqu.region_code = p.id;
    diqu.biaojistr = _biaojistr;
    
    [self.navigationController pushViewController:diqu animated:YES];
    NSLog(@"%@",diqu.region_code);
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
