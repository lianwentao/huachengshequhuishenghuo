//
//  Text1.m
//  HuiShengHuo2.0
//
//  Created by admin on 2018/12/28.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "Text1.h"

@interface Text1 ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray *titleArr;
@property (nonatomic, strong) UITextField *field1;
@property (nonatomic, strong) UITextField *field2;
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, strong) UILabel *textlab;
@property (nonatomic, strong)UIButton *textBtn;
@end

@implementation Text1

- (void)viewDidLoad {
    [super viewDidLoad];
     _titleArr = @[@"不限", @"500以下", @"500-1000元", @"1000-1500元", @"1500-2000元"];
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_width,(_titleArr.count+1)*40)];
    table.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArr.count+1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"Text1Cell";
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;  
    }
    
    if (indexPath.row == 5) {
        
        UILabel *lab = [[UILabel alloc]init];
        lab.frame = CGRectMake(15, 5, 50, 30);
        lab.text = @"自定义";
        lab.font = [UIFont systemFontOfSize:15];
        [cell addSubview:lab];
        
        _field1 = [[UITextField alloc]init];
        _field1.frame = CGRectMake(CGRectGetMaxX(lab.frame)+10, 5, 60, 30);
        _field1.backgroundColor = [UIColor colorWithHexString:@"#F9F9F9"];
        _field1.placeholder = @"最低价";
        _field1.font = [UIFont systemFontOfSize:15];
        _field1.textAlignment = NSTextAlignmentCenter;
        _field1.keyboardType = UIKeyboardTypeDecimalPad;
        [cell addSubview:_field1];
        
        UIView *line = [[UIView alloc]init];
        line.frame = CGRectMake(CGRectGetMaxX(_field1.frame)+5, 19, 15, 1);
        line.backgroundColor = [UIColor blackColor];
        [cell addSubview:line];
        
        _field2 = [[UITextField alloc]init];
        _field2.frame = CGRectMake(CGRectGetMaxX(line.frame)+5, 5, 60, 30);
        _field2.backgroundColor = [UIColor  colorWithHexString:@"#F9F9F9"];
        _field2.placeholder = @"最高价";
        _field2.font = [UIFont systemFontOfSize:15];
        _field2.textAlignment = NSTextAlignmentCenter;
        _field2.keyboardType = UIKeyboardTypeDecimalPad;
        [cell addSubview:_field2];
        
        UILabel *lab1 = [[UILabel alloc]init];
        lab1.frame = CGRectMake(CGRectGetMaxX(_field2.frame)+5, 5, 30, 30);
        lab1.text = @"元";
        lab1.font = [UIFont systemFontOfSize:15];
        [cell addSubview:lab1];
        
        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sureBtn.frame = CGRectMake(Main_width-15-60, 5, 60, 30);
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        sureBtn.backgroundColor = [UIColor  colorWithHexString:@"#F9F9F9"];
        sureBtn.tag = indexPath.row+100;
        [sureBtn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:sureBtn];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = _titleArr[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row != 5) {
        NSString *str = [NSString stringWithFormat:@"%@",_titleArr[indexPath.row]];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:str,@"text", nil];
        NSNotification *notification = [NSNotification notificationWithName:NSStringFromClass([Text1 class]) object:nil userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
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
            NSString *str = [NSString stringWithFormat:@"%@",newStr];
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:str,@"text", nil];
            NSNotification *notification = [NSNotification notificationWithName:NSStringFromClass([Text1 class]) object:nil userInfo:dict];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
    }
}

@end
