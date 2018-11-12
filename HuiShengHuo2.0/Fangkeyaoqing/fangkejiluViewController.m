//
//  fangkejiluViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/3/24.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "fangkejiluViewController.h"

@interface fangkejiluViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_TabelView;
}

@end

@implementation fangkejiluViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通行证记录";
    
    [self createUI];
    // Do any additional setup after loading the view.
}
- (void)createUI
{
    _TabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_width, Main_Height)];
    _TabelView.delegate = self;
    _TabelView.dataSource = self;
   
    //_TabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _TabelView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_TabelView];
}
#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _KeysArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
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
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    
//    UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_width, 8)];
//    lineview.backgroundColor = BackColor;
//    [cell.contentView addSubview:lineview];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
     _TabelView.tableHeaderView.backgroundColor = BackColor;
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, Main_width, 55)];
    name.text = [[_KeysArr objectAtIndex:indexPath.row] objectForKey:@"guestName"];
    [name setFont:font15];
    [cell.contentView addSubview:name];
    
    UILabel *timelabel = [[UILabel alloc] initWithFrame:CGRectMake(Main_width/3, 0, Main_width/3*2-30, 55)];
    timelabel.text = [[_KeysArr objectAtIndex:indexPath.row] objectForKey:@"valiateTime"];
    [timelabel setFont:font15];
    timelabel.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:timelabel];
    return cell;
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
