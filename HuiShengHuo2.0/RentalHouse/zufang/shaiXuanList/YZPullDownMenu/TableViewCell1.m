//
//  TableViewCell1.m
//  HuiShengHuo2.0
//
//  Created by admin on 2018/12/24.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "TableViewCell1.h"

@implementation TableViewCell1
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
