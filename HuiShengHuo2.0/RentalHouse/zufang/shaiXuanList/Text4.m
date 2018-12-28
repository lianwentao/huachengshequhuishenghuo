//
//  Text4.m
//  HuiShengHuo2.0
//
//  Created by admin on 2018/12/28.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "Text4.h"

@interface Text4 ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray *titleArr;

@end

@implementation Text4

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleArr = @[@"默认排序", @"最新发布", @"价格从低到高", @"价格从高到低", @"面积从大到小"];
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_width,_titleArr.count*40)];
    table.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"Text4Cell";
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;  
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
    NSNotification *notification = [NSNotification notificationWithName:NSStringFromClass([Text4 class]) object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}


@end
