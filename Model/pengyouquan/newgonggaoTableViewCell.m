//
//  newgonggaoTableViewCell.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/6/6.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "newgonggaoTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation newgonggaoTableViewCell

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
-(void)SetUpUI{
    UILabel *lineview = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Main_width, 5)];
    [self.contentView addSubview:lineview];
    lineview.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _contentimageview = [[UIImageView alloc] initWithFrame:CGRectMake(Main_width-80-10, 15, 80, 80)];
    [self.contentView addSubview:_contentimageview];
    
    
    _titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, Main_width-20-80-10, 40)];
    
    _titlelabel.numberOfLines = 2;
    _titlelabel.alpha = 0.87;
    _titlelabel.font = [UIFont boldSystemFontOfSize:16.5];
    [self.contentView addSubview:_titlelabel];



    _content = [[UILabel alloc] initWithFrame:CGRectMake(10, _titlelabel.frame.size.height+_titlelabel.frame.origin.y+10, Main_width-20-80-10, 40)];
    _content.numberOfLines = 2;
    _content.font = font15;
    _content.alpha = 0.54;
    [self.contentView addSubview:_content];

    _touxiangimageview = [[UIImageView alloc] initWithFrame:CGRectMake(10, _content.frame.size.height+_content.frame.origin.y+10, 20, 20)];
    _touxiangimageview.layer.cornerRadius = 10;
    [self.contentView addSubview:_touxiangimageview];

    _name = [[UILabel alloc] initWithFrame:CGRectMake(10+20+5, _content.frame.size.height+_content.frame.origin.y+10, Main_width-20-80-10-40, 20)];
    _name.font = [UIFont systemFontOfSize:13];
    _name.alpha = 0.54;
    [self.contentView addSubview:_name];

    _scan = [[UILabel alloc] initWithFrame:CGRectMake(Main_width-100-10, _content.frame.size.height+_content.frame.origin.y+10, 60, 20)];
    _scan.alpha = 0.54;
    _scan.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_scan];

    _pinglun = [[UILabel alloc] initWithFrame:CGRectMake(Main_width-100-10+60, _content.frame.size.height+_content.frame.origin.y+10, 50, 20)];
    _pinglun.alpha = 0.54;
    _pinglun.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_pinglun];
}
- (void)setModel:(pengyouquanmodel *)model
{
    NSArray *imagearr = [NSArray array];
    imagearr = model.imageArr;
    if ([imagearr isKindOfClass:[NSArray class]]&&imagearr.count>0) {
        NSString *imgurl = [API_img stringByAppendingString:[[model.imageArr objectAtIndex:0] objectForKey:@"img"]];
        _contentimageview.userInteractionEnabled = YES;
        _contentimageview.clipsToBounds = YES;
        _contentimageview.contentMode = UIViewContentModeScaleAspectFill;
        [_contentimageview sd_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
    }
    _titlelabel.text = model.title;
    
    _content.text = model.content;
    
    
    [_touxiangimageview sd_setImageWithURL:[NSURL URLWithString:model.touxiangurl] placeholderImage:[UIImage imageNamed:@"facehead1"]];
    
    _name.text = [NSString stringWithFormat:@"%@  发布于  %@  %@",model.name,model.fenlei,model.fabutime];
    
    NSMutableAttributedString *attri =     [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",model.scan]];
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    attch.image = [UIImage imageNamed:@"liulan"];
    attch.bounds = CGRectMake(0, -3, 15, 15);
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [attri insertAttributedString:string atIndex:0];
    _scan.attributedText = attri;
    
    NSMutableAttributedString *attri1 =     [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",model.pinglun]];
    NSTextAttachment *attch1 = [[NSTextAttachment alloc] init];
    attch1.image = [UIImage imageNamed:@"pinglun"];
    attch1.bounds = CGRectMake(0, -3, 15, 15);
    NSAttributedString *string1 = [NSAttributedString attributedStringWithAttachment:attch1];
    [attri1 insertAttributedString:string1 atIndex:0];
    _pinglun.attributedText = attri1;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
