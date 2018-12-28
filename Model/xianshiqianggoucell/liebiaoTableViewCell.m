//
//  liebiaoTableViewCell.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/5/30.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "liebiaoTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+TVAssistant.h"

@implementation liebiaoTableViewCell

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
    UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(12, 12.5, Main_width-24, 110)];
    backview.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backview];
    
    _imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 110, 110)];
    [backview addSubview:_imageview];
    
    _is_hotnewimage = [[UIImageView alloc] initWithFrame:CGRectMake(5, -2, 30, 30)];
    [backview addSubview:_is_hotnewimage];
    
    _maiwanlemelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 110-25, 110, 25)];
    _maiwanlemelabel.textColor = [UIColor whiteColor];
    _maiwanlemelabel.backgroundColor = [UIColor darkGrayColor];
    _maiwanlemelabel.alpha = 0.4;
    _maiwanlemelabel.font = font15;
    _maiwanlemelabel.textAlignment = NSTextAlignmentCenter;
    _maiwanlemelabel.text = @"已售罄";
    [backview addSubview:_maiwanlemelabel];
    
    _titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(110+9, 8, backview.frame.size.width-110-18, 40)];
    _titlelabel.numberOfLines = 2;
    _titlelabel.font = font15;
    [backview addSubview:_titlelabel];
    
    _tagview = [[UIView alloc] initWithFrame:CGRectMake(119, _titlelabel.frame.size.height+_titlelabel.frame.origin.y+7, 50+45, 16)];
    [backview addSubview:_tagview];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [backview addSubview:_button];
    
    _pricelabel = [[UILabel alloc] initWithFrame:CGRectMake(119, _tagview.frame.size.height+_tagview.frame.origin.y+12.5, 65, 20)];
    _pricelabel.font = [UIFont systemFontOfSize:13];
    [backview addSubview:_pricelabel];
    
    _yuanpricelabel = [[UILabel alloc] initWithFrame:CGRectMake(119+70, _tagview.frame.size.height+_tagview.frame.origin.y+12.5, 60, 20)];
    _yuanpricelabel.font = [UIFont systemFontOfSize:12];
    [backview addSubview:_yuanpricelabel];
    
    _yishoulabel = [[UILabel alloc] initWithFrame:CGRectMake(Main_width-24-12.5-100, _tagview.frame.size.height+_tagview.frame.origin.y+12.5, 100, 20)];
    _yishoulabel.font = [UIFont systemFontOfSize:12];
    _yishoulabel.textAlignment = NSTextAlignmentRight;
    [backview addSubview:_yishoulabel];
}
- (void)setModel:(liebiaomodel *)model
{
    [_imageview sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:model.imagestring]] placeholderImage:[UIImage imageNamed:@"展位图正"]];
    
    if ([model.is_time isEqualToString:@"1"]) {
        _is_hotnewimage.image = [UIImage imageNamed:@"秒杀"];
    }else if ([model.is_hot isEqualToString:@"1"]) {
        _is_hotnewimage.image = [UIImage imageNamed:@"热卖"];
    }else if([model.is_new isEqualToString:@"1"]){
        _is_hotnewimage.image = [UIImage imageNamed:@"上新"];
    }else{
        _is_hotnewimage.alpha = 0;
    }
    
    int kuncun = [model.kucun intValue];
    if (kuncun <= 0) {
        _maiwanlemelabel.hidden = NO;
    }else{
        _maiwanlemelabel.hidden = YES;
    }
    
    _titlelabel.text = model.title;
    
    NSArray *tagarr = model.tagArr;
    if ([tagarr isKindOfClass:[NSArray class]]) {
        if (tagarr.count>2) {
            for (int j=0; j<2; j++) {
                UILabel *taglabel = [[UILabel alloc] initWithFrame:CGRectMake(60*j, 0, 55, 18)];
                taglabel.text = [[tagarr objectAtIndex:j] objectForKey:@"c_name"];
                taglabel.font = [UIFont systemFontOfSize:10];
                taglabel.textColor = QIColor;
                taglabel.textAlignment = NSTextAlignmentCenter;
                taglabel.layer.cornerRadius = 2;
                [taglabel.layer setBorderWidth:0.5];
                [taglabel.layer setBorderColor:QIColor.CGColor];
                [_tagview addSubview:taglabel];
            }
        }else{
            for (int j=0; j<tagarr.count; j++) {
                UILabel *taglabel = [[UILabel alloc] initWithFrame:CGRectMake(60*j, 0, 55, 18)];
                taglabel.text = [[tagarr objectAtIndex:j] objectForKey:@"c_name"];
                taglabel.font = [UIFont systemFontOfSize:10];
                taglabel.textColor = QIColor;
                taglabel.textAlignment = NSTextAlignmentCenter;
                taglabel.layer.cornerRadius = 2;
                [taglabel.layer setBorderWidth:0.5];
                [taglabel.layer setBorderColor:QIColor.CGColor];
                [_tagview addSubview:taglabel];
            }
        }
    }
    _button.frame = CGRectMake(Main_width-24-12.5-70, _titlelabel.frame.size.height+_titlelabel.frame.origin.y+7, 70, 30);
    _button.layer.cornerRadius = 3;
    
    [_button.titleLabel setFont:font15];
    if ([model.biaoshi isEqualToString:@"1"]) {
        if ([model.is_start isEqualToString:@"1"]) {
            _button.backgroundColor = QIColor;
            [_button setTitle:@"立即抢购" forState:UIControlStateNormal];
        }else{
            _button.backgroundColor = HColor(21, 179, 28);
            [_button setTitle:@"准备活动" forState:UIControlStateNormal];
        }
        _yishoulabel.hidden = YES;
    }else{
        _yishoulabel.hidden = NO;
        _button.frame = CGRectMake(Main_width-24-12.5-30, _titlelabel.frame.size.height+_titlelabel.frame.origin.y, 30, 30);
        [_button setImage:[UIImage imageNamed:@"gouwuche"] forState:UIControlStateNormal];
        
        _button.tag = [model.id integerValue];
        if ([model.exihours isEqualToString:@"2"]) {
             [_button addTarget:self action:@selector(bupeisong) forControlEvents:UIControlEventTouchUpInside];
        }else if ([model.kucun isEqualToString:@"0"]){
             [_button addTarget:self action:@selector(kucunbuzu) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [_button addTarget:self action:@selector(gouwuche:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    _pricelabel.text = [NSString stringWithFormat:@"¥%@/%@",model.nowprice,model.unit];
    _pricelabel.textColor = QIColor;
    
    _yuanpricelabel.text = [NSString stringWithFormat:@"¥%@",model.yuanprice];
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:_yuanpricelabel.text attributes:attribtDic];
    _yuanpricelabel.attributedText = attribtStr;
    _yuanpricelabel.textColor = CIrclecolor;
    
    _yishoulabel.text = [NSString stringWithFormat:@"已售%@%@",model.yishou,model.unit];
    _yishoulabel.textColor = CIrclecolor;
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    _dic = [[NSDictionary alloc] init];
    _dic = @{@"p_id":model.id,@"tagid":model.tagid,@"p_title":model.title,@"price":model.nowprice,@"tagname":model.tagname,@"p_title_img":model.title_img,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"],@"number":@"1"};//token tokenSecret
}
- (void)gouwuche:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"liebiaojiarugouwuche" object:nil userInfo:_dic];
    
}
- (void)bupeisong
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"bupeisong" object:nil userInfo:nil];
}
- (void)kucunbuzu
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kucunbuzu" object:nil userInfo:nil];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
