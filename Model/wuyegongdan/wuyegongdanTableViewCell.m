//
//  wuyegongdanTableViewCell.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/12/17.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "wuyegongdanTableViewCell.h"

@implementation wuyegongdanTableViewCell

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
    _label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, Main_width/2-15, 18)];
    _label1.font = Font(18);
    [self.contentView addSubview:_label1];
    
    _label2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+18, Main_width/2-15, 13)];
    _label2.font = Font(13);
    _label2.textColor = [UIColor colorWithHexString:@"#9C9C9C"];
    [self.contentView addSubview:_label1];
    
    UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(15, _label2.frame.size.height+_label2.frame.origin.y+12, Main_width-30, 1)];
    lineview.backgroundColor = [UIColor colorWithHexString:@"#DEDEDE"];
    [self.contentView addSubview:lineview];
    
    _label3 = [[UILabel alloc] initWithFrame:CGRectMake(Main_width/2, 20, Main_width/2-15, 15)];
    _label3.font = Font(15);
    _label3.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_label3];
    
    _label4 = [[UILabel alloc] initWithFrame:CGRectMake(15, lineview.frame.size.height+lineview.frame.origin.y+8, Main_width-30, 13)];
    _label4.font = Font(13);
    _label4.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_label4];
}
- (void)setModel:(wuyegongdanmodel *)model
{
    _label1.text = model.type;
    _label2.text = model.erjitype;
    _label3.text = model.status_cn;
    _label4.text = model.time;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
