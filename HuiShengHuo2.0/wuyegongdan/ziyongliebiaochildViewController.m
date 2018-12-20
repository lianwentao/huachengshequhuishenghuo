//
//  ziyongliebiaochildViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/12/17.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "ziyongliebiaochildViewController.h"
#import "ziyonggongdanViewController.h"
@interface ziyongliebiaochildViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_TableView;
}

@end

@implementation ziyongliebiaochildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createtableview];
    // Do any additional setup after loading the view.
}
- (void)createtableview
{
    _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_width, Main_Height-RECTSTATUS.size.height-44-50)];
    _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _TableView.delegate = self;
    _TableView.dataSource = self;
    //_TableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(post1)];
    [self.view addSubview:_TableView];
}
#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arr.count;
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
    return @"   ";
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"  ";
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIndetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, Main_width/2, 49)];
    label.text = [[_arr objectAtIndex:indexPath.row] objectForKey:@"type_name"];
    label.font = Font(15);
    label.textColor = [UIColor colorWithHexString:@"#555555"];
    [cell.contentView addSubview:label];
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake(Main_width-100-15, 0, 100, 49);
    [but setTitle:@"服务说明" forState:UIControlStateNormal];
    but.titleLabel.font = Font(15);
    [but setTitleColor:[UIColor colorWithHexString:@"#555555"] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(pushshuming) forControlEvents:UIControlEventTouchUpInside];
    but.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [cell.contentView addSubview:but];
    
    UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(15, 49, Main_width-30, 1)];
    lineview.backgroundColor = [UIColor colorWithHexString:@"#D2D2D2"];
    [cell.contentView addSubview:lineview];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ziyonggongdanViewController *vc = [[ziyonggongdanViewController alloc] init];
    
    vc.title = @"家用报修";
    vc.type = [[_arr objectAtIndex:indexPath.row] objectForKey:@"type_name"];
    vc.entry_fee = [[_arr objectAtIndex:indexPath.row] objectForKey:@"entry_fee"];
    vc.type_id = [[_arr objectAtIndex:indexPath.row] objectForKey:@"id"];
    vc.type_pid = [[_arr objectAtIndex:indexPath.row] objectForKey:@"pid"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)pushshuming{
    WBLog(@"aaaa");
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
