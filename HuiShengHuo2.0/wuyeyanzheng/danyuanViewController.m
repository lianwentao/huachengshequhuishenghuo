//
//  danyuanViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/12/25.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import "danyuanViewController.h"
#import <AFNetworking.h>
#import "MBProgressHUD+TVAssistant.h"
#import "Person.h"
#import "roomViewController.h"

#import "PrefixHeader.pch"
#define screen_Width [UIScreen mainScreen].bounds.size.width
#define screen_Height [UIScreen mainScreen].bounds.size.height
@interface danyuanViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_DataArr;
    UITableView *_Tableview;
}

@end

@implementation danyuanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择单元";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createtableview];
    // Do any additional setup after loading the view.
}
- (void)createtableview
{
    _Tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_Width, screen_Height) ];
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

//section行数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//每组section个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int i;
    i = [_units intValue];
    return i;
}
//返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    NSString *string = [NSString stringWithFormat:@"%ld单元",indexPath.row+1];
    cell.textLabel.text = string;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    roomViewController *room = [[roomViewController alloc] init];
    room.community_id = _community_id;
    room.community_name = _community_name;
    room.build_id = _build_id;
    room.build_name = _build_name;
    room.units = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    
    room.company_id = _company_id;
    room.company_name = _company_name;
    room.department_id = _department_id;
    room.department_name = _department_name;
    
    NSString *string = [NSString stringWithFormat:@"%ld单元",indexPath.row+1];
    room.address = [NSString stringWithFormat:@"%@%@",_address,string];
    room.lou = string;
    
    room.biaoshi = _biaoshi;
    [self.navigationController pushViewController:room animated:YES];
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
