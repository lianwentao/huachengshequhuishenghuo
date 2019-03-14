//
//  newselectxiaoquViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/12/25.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "newselectxiaoquViewController.h"
#import "Person.h"
#import "BMChineseSort.h"
@interface newselectxiaoquViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_Tableview;
    NSMutableArray *_Dataarr;
    NSMutableArray *arr;
    
    UILabel *locationlabel;
    
    NSString *_strurl;
    
    NSString *location_region_name;
    NSString *location_region_id;
    UIButton *locationbut;
}
//排序后的出现过的拼音首字母数组
@property(nonatomic,strong)NSMutableArray *indexArray;
//排序好的结果数组
@property(nonatomic,strong)NSMutableArray *letterResultArr;
@end

@implementation newselectxiaoquViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择小区";
    [self postaaaa];
    [self createtableview];
    // Do any additional setup after loading the view.
}
- (void)createtableview
{
    _Tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, RECTSTATUS.size.height+44, Main_width, Main_Height-RECTSTATUS.size.height-44) ];
    _Tableview.estimatedRowHeight = 0;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
    _Tableview.tableHeaderView = view;
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
    _Tableview.tableFooterView = view1;
    _Tableview.delegate = self;
    _Tableview.dataSource = self;
    [self.view addSubview:_Tableview];
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
    
    Person *p = [[_letterResultArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString *str = p.id;
    __weak typeof(self) weakself = self;
    
    if (weakself.returnValueBlock) {
        //将自己的值传出去，完成传值
        weakself.returnValueBlock(str,p.name,p.is_new);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)postaaaa{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *API = [defaults objectForKey:@"API"];
    NSString *url = [API stringByAppendingString:@"property/get_pro_com"];
    NSDictionary *dict = [[NSDictionary alloc] init];
    dict = @{@"community_id":[userinfo objectForKey:@"community_id"],@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"]};
    
    NSLog(@"dict--%@",dict);
    [manager POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        _Dataarr = [[NSMutableArray alloc] initWithCapacity:0];
        arr = [[NSMutableArray alloc] init];
        arr = [responseObject objectForKey:@"data"];
        for (int i = 0; i<[arr count]; i++) {
            Person *p = [[Person alloc] init];
            p.name = [[arr objectAtIndex:i] objectForKey:@"name"];
            p.city_id = [[arr objectAtIndex:i] objectForKey:@"city_id"];
            p.region_id = [[arr objectAtIndex:i] objectForKey:@"region_id"];
            p.id = [[arr objectAtIndex:i] objectForKey:@"id"];
            p.is_new = [[arr objectAtIndex:i] objectForKey:@"houses_type"];//这里is_new没用到，所以改成house——type
            [_Dataarr addObject:p];
        }
        //根据Person对象的 name 属性 按中文 对 Person数组 排序
        self.indexArray = [BMChineseSort IndexWithArray:_Dataarr Key:@"name"];
        self.letterResultArr = [BMChineseSort sortObjectArray:_Dataarr Key:@"name"];
        [_Tableview reloadData];
        NSLog(@"location--%@--%@",[responseObject class],responseObject);
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
