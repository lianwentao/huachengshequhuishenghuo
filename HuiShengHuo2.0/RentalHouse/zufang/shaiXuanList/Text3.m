//
//  Text3.m
//  HuiShengHuo2.0
//
//  Created by admin on 2018/12/28.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "Text3.h"

@interface Text3 ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray *titleArr;

@end

@implementation Text3

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleArr = @[@"不限", @"一室", @"二室", @"三室", @"四室"];
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_width,_titleArr.count*50)];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArr.count+1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"Text3Cell";
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    if (indexPath.row == 5) {
        
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = _titleArr[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = [NSString stringWithFormat:@"%@",_titleArr[indexPath.row]];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:str,@"text", nil];
    NSNotification *notification = [NSNotification notificationWithName:NSStringFromClass([Text3 class]) object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}


@end
