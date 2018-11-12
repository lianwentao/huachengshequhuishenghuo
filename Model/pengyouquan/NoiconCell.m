//
//  NoiconCell.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/3/17.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "NoiconCell.h"
#import "UIImageView+WebCache.h"

@implementation NoiconCell

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
    
    _content = [[UILabel alloc] initWithFrame:CGRectMake(15, 20+40+15, Main_width-30, 40)];
    _content.font = nomalfont;
    _content.alpha = 0.87;
    [self.contentView addSubview:_content];
    
    _touxiangimageview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 40, 40)];
    _touxiangimageview.layer.cornerRadius = 20;
    [_touxiangimageview.layer setMasksToBounds:YES];
    [self.contentView addSubview:_touxiangimageview];
    
    _name = [[UILabel alloc] initWithFrame:CGRectMake(15+40+15, 20, Main_width*3/4, 40)];
    [_name setFont:biaotifont];
    [self.contentView addSubview:_name];
    
    _deletebut = [UIButton buttonWithType:UIButtonTypeCustom];
    _deletebut.frame = CGRectMake(Main_width-65, 20, 65, 40);
    [_deletebut setTitle:@"删除" forState:UIControlStateNormal];
    [_deletebut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _deletebut.alpha = 0.7;
    [_deletebut.titleLabel setFont:biaotifont];
    [self.contentView addSubview:_deletebut];
    
    _fabutime = [[UILabel alloc] init];
    [_fabutime setFont:biaotifont];
    _fabutime.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_fabutime];
    
    
    _fabutime.alpha = 0.7;
    
    _scan = [[UILabel alloc] initWithFrame:CGRectMake(15, 75+40+18, 60, 30)];
    [self.contentView addSubview:_scan];
    
    
    
    _pinglun = [[UILabel alloc] initWithFrame:CGRectMake(15+70, 75+40+18, 60, 30)];
    [self.contentView addSubview:_pinglun];
    
    
    _pinglun.font = [UIFont systemFontOfSize:13];
    _scan.font = [UIFont systemFontOfSize:13];
    
    _fenlei = [[UILabel alloc] initWithFrame:CGRectMake(15+140, 75+40+18, Main_width-140-15-15, 30)];
    [self.contentView addSubview:_fenlei];
    
    _fenlei.font = [UIFont systemFontOfSize:13];
    
    _pinglun.alpha = 0.54;
    _scan.alpha = 0.54;
    _fenlei.alpha = 0.54;
}
- (void)deletewodelinli:(UIButton *)sender
{
    
    NSLog(@"帖子id===%ld",sender.tag);
    
    NSDictionary *dic = @{@"scoailid":[NSString stringWithFormat:@"%ld",sender.tag]};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shanchuwodetiezi" object:nil userInfo:dic];
}
- (void)delete:(UIButton *)sender
{
    
    NSLog(@"帖子id===%ld",sender.tag);
    
    NSDictionary *dic = @{@"scoailid":[NSString stringWithFormat:@"%ld",sender.tag]};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shanchutiezi" object:nil userInfo:dic];
}
- (void)setModel:(pengyouquanmodel *)model
{
    NSLog(@"model.touxiangurl---%@",model.touxiangurl);
    _content.text = model.content;
    _content.numberOfLines = 2;
    [_content setFont:nomalfont];
    CGSize size = [_content sizeThatFits:CGSizeMake(_content.frame.size.width, MAXFLOAT)];
    //_content.frame = CGRectMake(_content.frame.origin.x, _content.frame.origin.y, _content.frame.size.width,            size.height);
    _name.text = model.name;
    
    _fabutime.text = model.fabutime;
    
    
    
    _deletebut.tag = [model.social_id integerValue];
    if (![model.qufenwodelinli isEqualToString:@"wodelinli"]) {
        [_deletebut addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [_deletebut addTarget:self action:@selector(deletewodelinli:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSString *uid = [userinfo objectForKey:@"uid"];
    if ([uid isEqualToString:model.uid]) {
        _deletebut.hidden = NO;
        _fabutime.frame = CGRectMake(Main_width*2/3-50, 20, Main_width/3-15, 40);
    }else{
        _deletebut.hidden = YES;
        _fabutime.frame = CGRectMake(Main_width*2/3, 20, Main_width/3-15, 40);
    }
    
    if (![model.guanfang isEqualToString:@"0"]) {
        _name.textColor = admincolor;
    }else{
        _name.textColor = [UIColor blackColor];
    }
    NSMutableAttributedString *attri =     [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",model.scan]];
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    attch.image = [UIImage imageNamed:@"liulan"];//liulanpinglun
    attch.bounds = CGRectMake(0, -5, 20, 20);
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [attri insertAttributedString:string atIndex:0];
    _scan.attributedText = attri;
    
    NSMutableAttributedString *attri1 =     [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",model.pinglun]];
    NSTextAttachment *attch1 = [[NSTextAttachment alloc] init];
    attch1.image = [UIImage imageNamed:@"pinglun"];
    attch1.bounds = CGRectMake(0, -5, 20, 20);
    NSAttributedString *string1 = [NSAttributedString attributedStringWithAttachment:attch1];
    [attri1 insertAttributedString:string1 atIndex:0];
    _pinglun.attributedText = attri1;
    
    _fenlei.text = [NSString stringWithFormat:@"#%@  #%@",model.fenlei,model.community_name];
    _fenlei.textAlignment = NSTextAlignmentRight;
    [_touxiangimageview sd_setImageWithURL:[NSURL URLWithString:model.touxiangurl] placeholderImage:[UIImage imageNamed:@"facehead1"]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
