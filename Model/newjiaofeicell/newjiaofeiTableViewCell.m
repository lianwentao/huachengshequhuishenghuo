//
//  newjiaofeiTableViewCell.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/9/4.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "newjiaofeiTableViewCell.h"

@implementation newjiaofeiTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self SetUpUI];
    }
    return self;
}
- (void)SetUpUI
{
    _TimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Main_width, 42)];
    _TimeLabel.font = [UIFont systemFontOfSize:13];
    _TimeLabel.textAlignment = NSTextAlignmentCenter;
    _TimeLabel.backgroundColor = BackColor;
    [self.contentView addSubview:_TimeLabel];
    
    _namelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _TimeLabel.frame.size.height+_TimeLabel.frame.origin.y+17, Main_width/2, 15)];
    _namelabel.font = font18;
    [self.contentView addSubview:_namelabel];
    
    _addresslabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _namelabel.frame.size.height+_namelabel.frame.origin.y+10, Main_width-20, 15)];
    _addresslabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_addresslabel];
    
    UIView *lineview1 = [[UIView alloc] initWithFrame:CGRectMake(10, _addresslabel.frame.size.height+_addresslabel.frame.origin.y+15, Main_width-20, 1)];
    lineview1.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    [self.contentView addSubview:lineview1];
    
    _zhangdanhaolabel = [[UILabel alloc] initWithFrame:CGRectMake(10, lineview1.frame.size.height+lineview1.frame.origin.y+15, Main_width-20, 15)];
    _zhangdanhaolabel.font = font15;
    [self.contentView addSubview:_zhangdanhaolabel];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, _zhangdanhaolabel.frame.size.height+_zhangdanhaolabel.frame.origin.y+15, Main_width-20, 15)];
    label.font = font15;
    label.text = @"缴费明细:";
    [self.contentView addSubview:label];
    
    
}
- (void)setModel:(newjiaofeimodel *)model
{
    _wuyearr = model.listarr;
    _TimeLabel.text = model.time;
    _namelabel.text = model.name;
    _addresslabel.text = model.address;
    _zhangdanhaolabel.text = model.zhangdanhao;
    _sumvaluelabel.text = model.sumvalue;

    
    long j=model.listarr.count;
    for (int i = 0; i<model.listarr.count; i++) {
        NSArray *arrlist = [model.listarr objectAtIndex:i];
        j = arrlist.count+j;
    }
    UIView *wuyeview = [[UIView alloc] initWithFrame:CGRectMake(0, _zhangdanhaolabel.frame.size.height+_zhangdanhaolabel.frame.origin.y+15+20, Main_width, j*35)];
    [self.contentView addSubview:wuyeview];
    
    _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_width, j*35)];
    _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _TableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _TableView.scrollEnabled = NO;
    _TableView.delegate = self;
    _TableView.dataSource = self;
    
    [wuyeview addSubview:_TableView];
}
#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    NSArray *arr = [_wuyearr objectAtIndex:section];
    return arr.count+1;
}

// 分组的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return _wuyearr.count;
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
    return 35;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        //        cell.userInteractionEnabled = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
    }
    
    NSArray *arr = [_wuyearr objectAtIndex:indexPath.section];
    if (indexPath.row==0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, Main_width-20, 35)];
        label.text = [[arr objectAtIndex:indexPath.row] objectForKey:@"charge_type"];
        label.font = font18;
        [cell.contentView addSubview:label];
    }else{
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, Main_width/2, 35)];
        NSLog(@"%@",[[[arr objectAtIndex:indexPath.row-1] objectForKey:@"startdate"] class]);
        if ([[[arr objectAtIndex:indexPath.row-1] objectForKey:@"startdate"] isKindOfClass:[NSNull class]]||[[[arr objectAtIndex:indexPath.row-1] objectForKey:@"startdate"] isEqualToString:@""]) {
            NSTimeInterval interval    =[[[arr objectAtIndex:indexPath.row-1] objectForKey:@"bill_time"] doubleValue];
            NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *dateString       = [formatter stringFromDate: date];
            label1.text = dateString;
        }else{
            NSTimeInterval interval    =[[[arr objectAtIndex:indexPath.row-1] objectForKey:@"startdate"] doubleValue];
            NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *dateString       = [formatter stringFromDate: date];
            
            NSTimeInterval interval1    =[[[arr objectAtIndex:indexPath.row-1] objectForKey:@"enddate"] doubleValue];
            NSDate *date1               = [NSDate dateWithTimeIntervalSince1970:interval1];
            
            NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
            [formatter1 setDateFormat:@"yyyy-MM-dd"];
            NSString *dateString1       = [formatter stringFromDate: date1];
            
            label1.text = [NSString stringWithFormat:@"%@/%@",dateString,dateString1];
        }

        label1.font = font15;
        [cell.contentView addSubview:label1];

        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(Main_width/2, 0, Main_width/2-10, 35)];
        label2.font = font15;
        label2.textAlignment = NSTextAlignmentRight;
        label2.text = [[arr objectAtIndex:indexPath.row-1] objectForKey:@"sumvalue"];
        [cell.contentView addSubview:label2];
    }
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
