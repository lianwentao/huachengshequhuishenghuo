//
//  newfuwudingdancellTableViewCell.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/11/26.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "newfuwudingdancellTableViewCell.h"

@implementation newfuwudingdancellTableViewCell

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
    _imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 72, 72)];
    _imageview.clipsToBounds = YES;
    _imageview.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_imageview];
    
    _namelabel = [[UILabel alloc] initWithFrame:CGRectMake(_imageview.frame.size.width+_imageview.frame.origin.x+15, 20, Main_width/2, 14)];
    _namelabel.font = Font(14);
    [self.contentView addSubview:_namelabel];
    
    _statuslabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, Main_width/3, 12)];
    _statuslabel.alpha = 0.54;
    _statuslabel.font = Font(11);
    _statuslabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_statuslabel];
    
    _statusimg = [[UIImageView alloc] initWithFrame:CGRectMake(Main_width-55, 15+12, 35, 10)];
    [self.contentView addSubview:_statusimg];
    
    _addresslabel = [[UILabel alloc] initWithFrame:CGRectMake(_namelabel.frame.origin.x, _namelabel.frame.size.height+_namelabel.frame.origin.y+10, Main_width-20-15-72, 37)];
    _addresslabel.alpha = 0.54;
    [self.contentView addSubview:_addresslabel];
    
    _beizhulabel = [[UILabel alloc] initWithFrame:CGRectMake(_namelabel.frame.origin.x, _addresslabel.frame.size.height+_addresslabel.frame.origin.y, Main_width-20-15-72, 37)];
    _beizhulabel.alpha = 0.54;
    [self.contentView addSubview:_beizhulabel];
    
    _statusbut = [UIButton buttonWithType:UIButtonTypeCustom];
    _statusbut.frame = CGRectMake(Main_width-100, _imageview.frame.size.height+_imageview.frame.origin.y+20, 75, 28);
    _statusbut.titleLabel.font = [UIFont systemFontOfSize:12];
    [_statusbut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _statusbut.clipsToBounds = YES;
    _statusbut.layer.cornerRadius = 10;
    _statusbut.layer.borderWidth = 1;
    _statusbut.alpha = 0.54;
    _statusbut.layer.borderColor = [UIColor blackColor].CGColor;
    [self.contentView addSubview:_statusbut];
    
    UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(15, 146, Main_width-30, 1)];
    lineview.backgroundColor = [UIColor blackColor];
    lineview.alpha = 0.05;
    [self.contentView addSubview:lineview];
}
- (void)setModel:(newfuwudingdanmodel *)model
{
     [_imageview sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:model.imgstring]] placeholderImage:[UIImage imageNamed:@"展位图正"]];
    _namelabel.text = model.fuwuname;
    _addresslabel.text = model.address;
    
    _addresslabel.font = Font(12);
    _addresslabel.numberOfLines = 2;
    _beizhulabel.text = [NSString stringWithFormat:@"备注:%@",model.beizhu];
    
    _beizhulabel.font = Font(12);
    _beizhulabel.numberOfLines = 2;
    
    if ([model.status isEqualToString:@"1"]||[model.status isEqualToString:@"2"]) {
        _statusbut.hidden = NO;
        [_statusbut setTitle:@"取消订单" forState:UIControlStateNormal];
        _statusbut.tag = [model.dingdanid longLongValue];
        [_statusbut addTarget:self action:@selector(cancle:) forControlEvents:UIControlEventTouchUpInside];
        
        _statuslabel.frame = CGRectMake(Main_width*2/3-20, 15, Main_width/3, 12);
        _statuslabel.text = @"待服务";
        
        _statusimg.hidden = NO;
        _statusimg.image = [UIImage imageNamed:@"进度1"];
    }else if ([model.status isEqualToString:@"4"]){
        _statusbut.hidden = NO;
        [_statusbut setTitle:@"评价" forState:UIControlStateNormal];
        _statusbut.tag = [model.dingdanid longLongValue];
        [_statusbut addTarget:self action:@selector(pingjia:) forControlEvents:UIControlEventTouchUpInside];
        
        
        _statuslabel.frame = CGRectMake(Main_width*2/3-20-5, 15, Main_width/3, 12);
        _statuslabel.text = @"完成";
        
        _statusimg.hidden = NO;
        _statusimg.image = [UIImage imageNamed:@"进度3"];
    }else if ([model.status isEqualToString:@"3"]){
        _statusbut.hidden = YES;
        
        _statuslabel.frame = CGRectMake(Main_width*2/3-20, 15, Main_width/3, 12);
        _statuslabel.text = @"服务中";
        
        _statusimg.hidden = NO;
        _statusimg.image = [UIImage imageNamed:@"进度2"];
    }else if ([model.status isEqualToString:@"6"]){
        _statusbut.hidden = YES;
        
        _statuslabel.frame = CGRectMake(Main_width*2/3-20, 15, Main_width/3, 12);
        _statuslabel.text = @"订单已取消";
        
        _statusimg.hidden = YES;
    }else{
        _statusbut.hidden = YES;
        
        _statuslabel.frame = CGRectMake(Main_width*2/3-20-5, 15, Main_width/3, 12);
        _statuslabel.text = @"完成";
        _statusimg.image = [UIImage imageNamed:@"进度3"];
        _statusimg.hidden = NO;
    }
}

- (void)cancle:(UIButton *)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [[NSDictionary alloc] init];
    dict = @{@"id":[NSString stringWithFormat:@"%ld",sender.tag],@"hui_community_id":[defaults objectForKey:@"community_id"]};
    WBLog(@"cancle--%@",dict);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newfuwudingdancancle" object:nil userInfo:dict];
}
- (void)pingjia:(UIButton *)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [[NSDictionary alloc] init];
    dict = @{@"id":[NSString stringWithFormat:@"%ld",sender.tag],@"hui_community_id":[defaults objectForKey:@"community_id"]};
    WBLog(@"pingjia--%@",dict);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newfuwudingdanpingjia" object:nil userInfo:dict];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
