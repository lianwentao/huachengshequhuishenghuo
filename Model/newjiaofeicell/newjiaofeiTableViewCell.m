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
    _TimeLabel.text = model.time;
    _namelabel.text = model.name;
    _addresslabel.text = model.address;
    _zhangdanhaolabel.text = model.zhangdanhao;
    NSLog(@"model_list---------%@--%ld",[[model.listarr objectAtIndex:0] objectAtIndex:0],model.listarr.count);
    for (int i=0; i<model.listarr.count; i++) {
        UILabel *typelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _zhangdanhaolabel.frame.size.height+_zhangdanhaolabel.frame.origin.y+45+i*80, Main_width-20, 15)];
        typelabel.text = [[[model.listarr objectAtIndex:i] objectAtIndex:0] objectForKey:@"charge_type"];
        [self.contentView addSubview:typelabel];
        NSArray *arr = [[NSArray alloc] init];
        arr = [model.listarr objectAtIndex:i];
        NSLog(@"arr---%@",arr);
//        for (int j=0; i<arr.count; j++) {
//            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10+15*j, Main_width-20, 15)];
//            label2.text = [[arr objectAtIndex:j] objectForKey:@"bill_time"];
//            [self.contentView addSubview:label2];
//        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
