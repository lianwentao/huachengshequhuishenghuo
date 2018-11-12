//
//  gouwudingdanTableViewCell.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/12/6.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import "gouwudingdanTableViewCell.h"

#define screen_Width [UIScreen mainScreen].bounds.size.width
#define screen_Height [UIScreen mainScreen].bounds.size.height
@implementation gouwudingdanTableViewCell

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
    _titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, screen_Width, 40)];
    _titlelabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_titlelabel];
    
    _line1label = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, screen_Width, 1)];
    _line1label.backgroundColor = HColor(244, 247, 248);
    [self.contentView addSubview:_line1label];
    
    _linelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 150-3, screen_Width, 3)];
    _linelabel.backgroundColor = HColor(244, 247, 248);
    [self.contentView addSubview:_linelabel];
    
    _numlabel = [[UILabel alloc] initWithFrame:CGRectMake(screen_Width-30-100, 50, 100, 30)];
    _numlabel.font = [UIFont systemFontOfSize:13];
    _numlabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_numlabel];
    
    _pricelabel = [[UILabel alloc] initWithFrame:CGRectMake(screen_Width-30-100, 80, 100, 25)];
    _pricelabel.font = [UIFont systemFontOfSize:13];
    _pricelabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_pricelabel];
    
    _imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 50, 90, 90)];
    [self.contentView addSubview:_imageview];
    
    _imageview1 = [[UIImageView alloc] initWithFrame:CGRectMake(110, 50, 90, 90)];
    [self.contentView addSubview:_imageview1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
