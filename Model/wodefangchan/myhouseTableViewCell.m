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
    [self.contentView addSubview:_imageview];
    
    _detailslabel = [[UILabel alloc] initWithFrame:CGRectMake(_imageview.frame.origin.x+10+_imageview.frame.size.width, 15, Main_width-40-_imageview.frame.size.width, 40)];
    _detailslabel.numberOfLines = 2;
    _detailslabel.font = font15;
    [self.contentView addSubview:_detailslabel];
    
    _jingjirenimg = [[UIImageView alloc] initWithFrame:CGRectMake(_imageview.frame.size.width+_imageview.frame.origin.x+10, _detailslabel.frame.size.height+_detailslabel.frame.origin.y+10, 30, 30)];
    _jingjirenimg.layer.cornerRadius = 15;
    
    _namelabel = [[UILabel alloc] initWithFrame:CGRectMake(_jingjirenimg.frame.size.width+_jingjirenimg.frame.origin.x+10, _detailslabel.frame.size.height+_detailslabel.frame.origin.y+10, 150, 30)];
    _namelabel.font = Font(15);
    
    _callbut = [UIButton buttonWithType:UIButtonTypeCustom];
    _callbut.frame = CGRectMake(Main_width-30-20, _detailslabel.frame.size.height+_detailslabel.frame.origin.y+10, 30, 30);
    
    [_callbut setImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];
    
    _pricelabel = [[UILabel alloc] initWithFrame:CGRectMake(_imageview.frame.origin.x+10+_imageview.frame.size.width, 130-12-17, (Main_width-40-_imageview.frame.size.width)/2, 17)];
    _pricelabel.font = font15;
    _pricelabel.textColor = [UIColor colorWithRed:255/255.0 green:87/255.0 blue:34/255.0 alpha:1];
    [self.contentView addSubview:_pricelabel];
    
    _statuslabel = [[UILabel alloc] initWithFrame:CGRectMake(_pricelabel.frame.size.width+_pricelabel.frame.origin.x, 130-12-17, (Main_width-40-_imageview.frame.size.width)/2, 17)];
    _statuslabel.font = Font(15);
    
    _statuslabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_statuslabel];
}
- (void)setModel:(myhousemodel *)model
{
    if (![model.status isEqualToString:@"1"]) {
        _namelabel.text = [NSString stringWithFormat:@"经纪人:%@",model.name];
        [_jingjirenimg sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:model.jingjirenimg]] placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
        [self.contentView addSubview:_namelabel];
        [self.contentView addSubview:_jingjirenimg];
        [self.contentView addSubview:_callbut];
        _callbut.tag = [[NSString stringWithFormat:@"%@",model.phone] integerValue];
        [_callbut addTarget:self action:@selector(calljingjiren:) forControlEvents:UIControlEventTouchUpInside];
    }
    [_imageview sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:model.imgstring]] placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
    _detailslabel.text = model.details;
    if ([model.house_type isEqualToString:@"1"]) {
        _pricelabel.text = [NSString stringWithFormat:@"%@元/月",model.price];
    }else{
        _pricelabel.text = [NSString stringWithFormat:@"%.2f万元",[model.price floatValue]];
    }
    
    
    NSString *statustext;
    NSString *statusimg;
    if ([model.status isEqualToString:@"1"]) {
        statustext = @"未审核";
        _statuslabel.textColor = [UIColor colorWithHexString:@"#FF3939"];
        statusimg = @"shenhezhong";
    }else if ([model.status isEqualToString:@"2"]){
        if ([model.house_type isEqualToString:@"1"]) {
            statustext = @"未出租";
        }else{
            statustext = @"未售";
        }
        _statuslabel.textColor = [UIColor colorWithHexString:@"#FF3939"];
        statusimg = @"weishou";
    }else{
        if ([model.house_type isEqualToString:@"1"]) {
            statustext = @"已出租";
        }else{
            statustext = @"已售";
        }
        statusimg = @"yishou";
        _statuslabel.textColor = [UIColor colorWithHexString:@"#18B632"];
    }
    NSMutableAttributedString * attrubedStr = [[NSMutableAttributedString alloc]initWithString:statustext];
    NSTextAttachment * attach = [[NSTextAttachment alloc]init];
    attach.image = [UIImage imageNamed:statusimg];
    attach.bounds = CGRectMake(0, -3, 15, 15);
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attach];
    [attrubedStr insertAttributedString:string atIndex:0];
    _statuslabel.attributedText = attrubedStr;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)calljingjiren:(UIButton *)sender
{
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",[NSString stringWithFormat:@"%ld",sender.tag]];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.contentView addSubview:callWebview];
}
@end
