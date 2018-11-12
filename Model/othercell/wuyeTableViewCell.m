//
//  wuyeTableViewCell.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/12/15.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import "wuyeTableViewCell.h"

#define screen_Width [UIScreen mainScreen].bounds.size.width
#define screen_Height [UIScreen mainScreen].bounds.size.height
@implementation wuyeTableViewCell

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
    _name = [[UILabel alloc] initWithFrame:CGRectMake(85, 5, screen_Width-95, 30)];
    [self.contentView addSubview:_name];
    
    _content = [[UILabel alloc] initWithFrame:CGRectMake(85, 40, screen_Width-95, 30)];
    [self.contentView addSubview:_content];
    
    _avaimageview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 65, 65)];
    _avaimageview.layer.masksToBounds = YES;
    _avaimageview.layer.cornerRadius = 32.5;
    [self.contentView addSubview:_avaimageview];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
