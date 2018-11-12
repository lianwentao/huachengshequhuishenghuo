//
//  xiaofeijiluTableViewCell.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/1/5.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "xiaofeijiluTableViewCell.h"

#define screen_Width [UIScreen mainScreen].bounds.size.width
#define screen_Height [UIScreen mainScreen].bounds.size.height
@implementation xiaofeijiluTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 初始化子视图
        [self createui];
    }
    return self;
}
- (void)createui
{
    _labeltitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, screen_Width-150, 25)];
    _labeltitle.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_labeltitle];
    
    _total_amount = [[UILabel alloc] initWithFrame:CGRectMake(screen_Width-160, 10, 150, 25)];
    _total_amount.font = [UIFont systemFontOfSize:15];
    _total_amount.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_total_amount];
    
    _labelnum = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, screen_Width-20, 25)];
    _labelnum.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_labelnum];
    
    _lineview = [[UIView alloc] initWithFrame:CGRectMake( 10, 69, screen_Width-20, 0.5)];
    _lineview.backgroundColor = HColor(244, 247, 248);
    [self.contentView addSubview:_lineview];
    
    _paytype = [[UILabel alloc] initWithFrame:CGRectMake(10, 75, screen_Width/2, 25)];
    _paytype.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_paytype];
    
    _timelabel = [[UILabel alloc] initWithFrame:CGRectMake(screen_Width/2, 75, screen_Width/2-10, 25)];
    _timelabel.font = [UIFont systemFontOfSize:15];
    _timelabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_timelabel];
    
    _lineview1 = [[UIView alloc] initWithFrame:CGRectMake( 0, 110, screen_Width, 10)];
    _lineview1.backgroundColor = HColor(244, 247, 248);
    [self.contentView addSubview:_lineview1];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
