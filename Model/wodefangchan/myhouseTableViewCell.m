//
//  myhouseTableViewCell.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/11/20.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "myhouseTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation myhouseTableViewCell

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
    _imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 100, 100)];
    _imageview.image = [UIImage imageNamed:@"启动页2"];
    [self.contentView addSubview:_imageview];
    
    _detailslabel = [[UILabel alloc] initWithFrame:CGRectMake(_imageview.frame.origin.x+10+_imageview.frame.size.width, 15, Main_width-40-_imageview.frame.size.width, 40)];
    _detailslabel.numberOfLines = 2;
    _detailslabel.font = font15;
    [self.contentView addSubview:_detailslabel];
    
    _pricelabel = [[UILabel alloc] initWithFrame:CGRectMake(_imageview.frame.origin.x+10+_imageview.frame.size.width, 130-12-17, (Main_width-40-_imageview.frame.size.width)/2, 17)];
    _pricelabel.font = font18;
    _pricelabel.textColor = [UIColor colorWithRed:255/255.0 green:87/255.0 blue:34/255.0 alpha:1];
    [self.contentView addSubview:_pricelabel];
    
    _statuslabel = [[UILabel alloc] initWithFrame:CGRectMake(_pricelabel.frame.size.width+_pricelabel.frame.origin.x, 130-12-17, (Main_width-40-_imageview.frame.size.width)/2, 17)];
    _statuslabel.font = font18;
    
    _statuslabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_statuslabel];
}
- (void)setModel:(myhousemodel *)model
{
    _detailslabel.text = model.details;
    _pricelabel.text = model.price;
    _statuslabel.text = model.status;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
