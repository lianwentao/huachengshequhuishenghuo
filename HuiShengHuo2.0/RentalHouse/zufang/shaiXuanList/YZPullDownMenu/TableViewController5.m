//
//  TableViewController5.m
//  HuiShengHuo2.0
//
//  Created by admin on 2018/12/24.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "TableViewController5.h"
#import "TableViewCell1.h"
extern NSString * const YZUpdateMenuTitleNote5;
static NSString * const ID = @"cell";
@interface TableViewController5 ()
@property (nonatomic, copy) NSArray *titleArray;
@property (nonatomic, assign) NSInteger selectedCol;
@property (nonatomic, strong) UITextField *field1;
@property (nonatomic, strong) UITextField *field2;
@end

@implementation TableViewController5

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _selectedCol = 0;
    
    _titleArray = @[@"不限", @"30万元以下", @"30-50万元", @"50-70万元", @"70-90万元"];
    
    [self.tableView registerClass:[TableViewCell1 class] forCellReuseIdentifier:ID];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_selectedCol inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        [cell setSelected:YES animated:NO];
    }
    if (indexPath.row == 5) {
        
        UILabel *lab = [[UILabel alloc]init];
        lab.frame = CGRectMake(15, 10, 50, 30);
        lab.text = @"自定义";
        lab.font = [UIFont systemFontOfSize:15];
        [cell addSubview:lab];
        
        _field1 = [[UITextField alloc]init];
        _field1.frame = CGRectMake(CGRectGetMaxX(lab.frame)+10, 10, 60, 30);
        _field1.backgroundColor = [UIColor colorWithHexString:@"#F9F9F9"];
        _field1.placeholder = @"最低价";
        _field1.font = [UIFont systemFontOfSize:15];
        _field1.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:_field1];
        
        UIView *line = [[UIView alloc]init];
        line.frame = CGRectMake(CGRectGetMaxX(_field1.frame)+5, 24, 15, 1);
        line.backgroundColor = [UIColor blackColor];
        [cell addSubview:line];
        
        _field2 = [[UITextField alloc]init];
        _field2.frame = CGRectMake(CGRectGetMaxX(line.frame)+5, 10, 60, 30);
        _field2.backgroundColor = [UIColor  colorWithHexString:@"#F9F9F9"];
        _field2.placeholder = @"最高价";
        _field2.font = [UIFont systemFontOfSize:15];
        _field2.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:_field2];
        
        UILabel *lab1 = [[UILabel alloc]init];
        lab1.frame = CGRectMake(CGRectGetMaxX(_field2.frame)+5, 10, 50, 30);
        lab1.text = @"万元";
        lab1.font = [UIFont systemFontOfSize:15];
        [cell addSubview:lab1];
        
        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sureBtn.frame = CGRectMake(Main_width-15-60, 10, 60, 30);
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        sureBtn.backgroundColor = [UIColor  colorWithHexString:@"#F9F9F9"];
        sureBtn.tag = indexPath.row+100;
        [sureBtn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:sureBtn];
        
    }else{
        cell.textLabel.text = _titleArray[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.tag = indexPath.row;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedCol = indexPath.row;
    
    // 选中当前
    TableViewCell1 *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.row == 5) {
        
    }else{
        // 更新菜单标题
        [[NSNotificationCenter defaultCenter] postNotificationName:YZUpdateMenuTitleNote5 object:self userInfo:@{@"title":cell.textLabel.text}];
    }
    
}
-(void)sureAction:(UIButton *)sender{
    
    if (sender.tag == 105) {
        NSInteger str1 = [_field1.text integerValue];
        NSInteger str2 = [_field2.text integerValue];
        if (str1 >= str2) {
            
            [MBProgressHUD showToastToView:self.view withText:@"最低价不能大于最高价"];
        }else{
            NSString *hxstr1 = [NSString stringWithFormat:@"-%@",_field2.text];
            NSString *newStr = [_field1.text stringByAppendingString:hxstr1];
            // 更新菜单标题
            [[NSNotificationCenter defaultCenter] postNotificationName:YZUpdateMenuTitleNote5 object:self userInfo:@{@"title":newStr}];
        }
    }
}
@end
