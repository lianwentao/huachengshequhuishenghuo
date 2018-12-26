//
//  xinfangshouceCell.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/3/27.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "xinfangshouceCell.h"
#import <AFNetworking.h>
#import "UIImageView+WebCache.h"

@implementation xinfangshouceCell

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
    _imageview = [[UIImageView alloc] init];
    [self.contentView addSubview:_imageview];
    
    _content = [[UILabel alloc] init];
    [self.contentView addSubview:_content];
}
- (void)setModel:(xinfangshoucemolde *)model
{
    float height = [model.img_size floatValue];
    _imageview.frame = CGRectMake(15, 0, Main_width-30, (Main_width-30)/height);
    [_imageview sd_setImageWithURL:[NSURL URLWithString:model.imageviewurl] placeholderImage:[UIImage imageNamed:@"展位图正"]];
    
    _content.frame = CGRectMake(125, _imageview.frame.size.height-40, _imageview.frame.size.width-125, 40);
    _content.text = model.content;
    
    NSLog(@"%@--%@",model.imageviewurl,model.content);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
