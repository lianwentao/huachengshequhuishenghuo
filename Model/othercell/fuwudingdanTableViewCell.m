//
//  fuwudingdanTableViewCell.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/1/5.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "fuwudingdanTableViewCell.h"

#define screen_Width [UIScreen mainScreen].bounds.size.width
#define screen_Height [UIScreen mainScreen].bounds.size.height
@implementation fuwudingdanTableViewCell

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
    
    _line1label = [[UILabel alloc] initWithFrame:CGRectMake(0, 74                                                      , screen_Width, 1)];
    _line1label.backgroundColor = HColor(244, 247, 248);
    [self.contentView addSubview:_line1label];
    
    _timelabel = [[UILabel alloc] initWithFrame:CGRectMake(screen_Width/2, 40, screen_Width/2-10, 25)];
    _timelabel.font = [UIFont systemFontOfSize:15];
    _timelabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_timelabel];
    
    _contentlabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, screen_Width/2-10-10, 25)];
    _contentlabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_contentlabel];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
