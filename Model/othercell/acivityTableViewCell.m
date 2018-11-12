//
//  acivityTableViewCell.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/12/4.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import "acivityTableViewCell.h"

#define screen_Width [UIScreen mainScreen].bounds.size.width
#define screen_Height [UIScreen mainScreen].bounds.size.height
@implementation acivityTableViewCell

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
    UIView *acticityview = [[UIView alloc] initWithFrame:CGRectMake(10, 10, screen_Width-20, 210-165+(screen_Width-20)/(2.5))];
    // 设置圆角的大小
    acticityview.layer.cornerRadius = 5;
    [acticityview.layer setMasksToBounds:YES];
    acticityview.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:acticityview];
    
    _imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screen_Width-20, (screen_Width-20)/(2.5))];
    [acticityview addSubview:_imageview];
    
    _labeltitle = [[UILabel alloc] initWithFrame:CGRectMake(0, (screen_Width-20)/(2.5)+15, screen_Width-20, 20)];
    _labeltitle.textAlignment = NSTextAlignmentCenter;
    [acticityview addSubview:_labeltitle];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
