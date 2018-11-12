//
//  DiquViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/11/23.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import "DiquViewController.h"
#import "FirstRunViewController.h"
#import <AFNetworking.h>
#import "Person.h"
#import "BMChineseSort.h"
#import "XiaoquViewController.h"

#import "PrefixHeader.pch"

@interface DiquViewController ()<UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_Tableview;
    NSMutableArray *_Dataarr;
    NSMutableArray *arr;
}

//排序后的出现过的拼音首字母数组
@property(nonatomic,strong)NSMutableArray *indexArray;
//排序好的结果数组
@property(nonatomic,strong)NSMutableArray *letterResultArr;

@property(nonatomic,strong)NSMutableArray *idarr;

@end

@implementation DiquViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择地区";
    self.navigationController.delegate=self;
    //修改系统导航栏下一个界面的返回按钮title
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    [self post];
    [self createtableview];
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
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ------联网请求---
-(void)post{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSDictionary *dict = @{@"region_code":_region_code};
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
    NSString *strurl = [API stringByAppendingString:@"site/get_city"];
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _Dataarr = [[NSMutableArray alloc] initWithCapacity:0];
        arr = [[NSMutableArray alloc] init];
        arr = [responseObject objectForKey:@"data"];
        for (int i = 0; i<[arr count]; i++) {
            Person *p = [[Person alloc] init];
            p.name = [[arr objectAtIndex:i] objectForKey:@"region_name"];
            p.number = i;
            p.id = [[arr objectAtIndex:i] objectForKey:@"region_id"];
            [_Dataarr addObject:p];
        }
        //根据Person对象的 name 属性 按中文 对 Person数组 排序
        self.indexArray = [BMChineseSort IndexWithArray:_Dataarr Key:@"name"];
        self.letterResultArr = [BMChineseSort sortObjectArray:_Dataarr Key:@"name"];
        self.idarr = [BMChineseSort sortObjectArray:_Dataarr Key:@"name"];
        //NSLog(@"success--%@--%@",[[arr objectAtIndex:0] objectForKey:@"region_name"],[[arr objectAtIndex:0] objectForKey:@"region_id"]);
        [_Tableview reloadData];
        //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
        //NSLog(@"success--%@--%@",[responseObject class],responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
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
    XiaoquViewController *xiaoqu = [[XiaoquViewController alloc] init];
    Person *p = [[_idarr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    xiaoqu.region_id = p.id;
    xiaoqu.biaojistr = _biaojistr;
    //NSLog(@"===%@",xiaoqu.region_id);
    [self.navigationController pushViewController:xiaoqu animated:YES];
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
