//
//  fabuzufangViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/11/16.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "fabuzufangViewController.h"

@interface fabuzufangViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *TabbleView;
}

@end

@implementation fabuzufangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发布房源信息";
    
    [self CreateTableView];
    // Do any additional setup after loading the view.
}
#pragma mark - 创建TableView
- (void)CreateTableView
{
    TabbleView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    //_Hometableview.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 0.01f)];
    /** 去除tableview 右侧滚动条 */
    TabbleView.estimatedRowHeight = 0;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
    TabbleView.tableHeaderView = view;
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
    TabbleView.tableFooterView = view1;
    TabbleView.showsVerticalScrollIndicator = YES;
    /** 去掉分割线 */
    TabbleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    TabbleView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    TabbleView.delegate = self;
    TabbleView.dataSource = self;
    [self.view addSubview:TabbleView];
}
#pragma mark - TableView的代理方法

//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

// 分组的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
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
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"  ";
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndetifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
    }
    UIView *upview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_width, 14)];
    upview.backgroundColor = TabbleView.backgroundColor;
    [cell.contentView addSubview:upview];
    if (indexPath.row==0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 24, 70, 30)];
        label.text = @"联系人";
        label.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:label];
        
        UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(125, 24, Main_width-30-140, 30)];
        textfield.placeholder = @"请输入联系人姓名";
        textfield.font = font15;
        [cell.contentView addSubview:textfield];
    }else if (indexPath.row==1){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 24, 70, 30)];
        label.text = @"手机号码";
        label.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:label];
        
        UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(125, 24, Main_width-30-140, 30)];
        textfield.placeholder = @"请输入手机号码";
        textfield.font = font15;
        [cell.contentView addSubview:textfield];
    }else if (indexPath.row==2){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 24, 70, 30)];
        label.text = @"小区名称";
        label.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:label];
        
        UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(125, 24, Main_width-30-140, 30)];
        textfield.placeholder = @"请输入小区名称";
        textfield.font = font15;
        [cell.contentView addSubview:textfield];
    }else if (indexPath.row==3){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 24, 70, 30)];
        label.text = @"户型";
        label.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:label];
    }else if (indexPath.row==4){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 24, 70, 30)];
        label.text = @"楼层";
        label.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:label];
        
        UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(125, 24, Main_width-30-140, 30)];
        textfield.placeholder = @"请输入楼层";
        textfield.font = font15;
        [cell.contentView addSubview:textfield];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(Main_width-90, 24, 75, 30)];
        label1.text = @"层";
        label1.font = font15;
        label1.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:label1];
    }else if (indexPath.row==5){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 24, 70, 30)];
        label.text = @"总楼层";
        label.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:label];
        
        UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(125, 24, Main_width-30-140, 30)];
        textfield.placeholder = @"请输入总楼层";
        textfield.font = font15;
        [cell.contentView addSubview:textfield];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(Main_width-90, 24, 75, 30)];
        label1.text = @"层";
        label1.font = font15;
        label1.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:label1];
    }else if (indexPath.row==6){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 24, 70, 30)];
        label.text = @"面积";
        label.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:label];
        
        UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(125, 24, Main_width-30-140, 30)];
        textfield.placeholder = @"请输入房屋面积";
        textfield.font = font15;
        [cell.contentView addSubview:textfield];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(Main_width-90, 24, 75, 30)];
        label1.text = @"平方米";
        label1.font = font15;
        label1.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:label1];
    } else {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 24, 70, 30)];
        label.text = @"租金";
        label.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:label];
        
        UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(125, 24, Main_width-30-140, 30)];
        textfield.placeholder = @"请输入租金";
        textfield.font = font15;
        [cell.contentView addSubview:textfield];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(Main_width-90, 24, 75, 30)];
        label1.text = @"元/月";
        label1.font = font15;
        label1.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:label1];
    }
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
