//
//  circleCell.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/3/17.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "circleCell.h"
#import "UIImageView+WebCache.h"

@implementation circleCell

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
    
    _touxiangimageview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 40, 40)];
    _touxiangimageview.layer.cornerRadius = 20;
    [_touxiangimageview.layer setMasksToBounds:YES];
    [self.contentView addSubview:_touxiangimageview];
    
    _content = [[UILabel alloc] init];
    _content.alpha = 0.87;
    _content.font = nomalfont;
    
    [self.contentView addSubview:_content];
    
    _name = [[UILabel alloc] initWithFrame:CGRectMake(15+40+15, 20, Main_width*3/4, 40)];
    [_name setFont:biaotifont];
    [self.contentView addSubview:_name];
    
    _fabutime = [[UILabel alloc] init];
    _fabutime.textAlignment = NSTextAlignmentRight;
    
    [_fabutime setFont:biaotifont];
    [self.contentView addSubview:_fabutime];
    
    
    _deletebut = [UIButton buttonWithType:UIButtonTypeCustom];
    _deletebut.frame = CGRectMake(Main_width-65, 20, 65, 40);
    [_deletebut setTitle:@"删除" forState:UIControlStateNormal];
    [_deletebut.titleLabel setFont:font15];
    [_deletebut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _deletebut.alpha = 0.7;
    [self.contentView addSubview:_deletebut];
    
    
    _fabutime.alpha = 0.7;
    
    _scan = [[UILabel alloc] init];
    [self.contentView addSubview:_scan];
    
    
    _pinglun = [[UILabel alloc] init];
    [self.contentView addSubview:_pinglun];
    _pinglun.font = [UIFont systemFontOfSize:13];
    _scan.font = [UIFont systemFontOfSize:13];
    
    _fenlei = [[UILabel alloc] init];
    [self.contentView addSubview:_fenlei];
    _fenlei.font = [UIFont systemFontOfSize:13];
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
    _imgArray = [NSMutableArray array];
    for (int i=0; i<model.imageArr.count; i++) {
        NSString *imgurl = [API_img stringByAppendingString:[[model.imageArr objectAtIndex:i] objectForKey:@"img"]];
        [_imgArray addObject:imgurl];
    }
//        CGSize size = [_content sizeThatFits:CGSizeMake(_content.frame.size.width, MAXFLOAT)];
//        _content.frame = CGRectMake(_content.frame.origin.x, _content.frame.origin.y, _content.frame.size.width,            size.height);
    
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
    
    
    _content.text = model.content;
    _content.numberOfLines = 2;
    [_content setFont:nomalfont];

    _name.text = model.name;
    _fabutime.text = model.fabutime;
    NSMutableAttributedString *attri =     [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",model.scan]];
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    attch.image = [UIImage imageNamed:@"liulan"];
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
    _pinglun.alpha = 0.54;
    _scan.alpha = 0.54;
    _fenlei.alpha = 0.54;
    _fenlei.text = [NSString stringWithFormat:@"#%@  #%@",model.fenlei,model.community_name];
    _fenlei.textAlignment = NSTextAlignmentRight;
    
    [_touxiangimageview sd_setImageWithURL:[NSURL URLWithString:model.touxiangurl] placeholderImage:[UIImage imageNamed:@"facehead1"]];
    NSArray *imagearr = [NSArray array];
    imagearr = model.imageArr;
    NSLog(@"admin--id--%@--%@",model.guanfang,model.content);
    if ([imagearr isKindOfClass:[NSArray class]]&&imagearr.count>0) {
        if (![model.guanfang isEqualToString:@"0"]) {
            
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 75+55, Main_width-0, Main_width/1.5)];
            NSString *url = [[model.imageArr objectAtIndex:0] objectForKey:@"img"];
            [img sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:url]] placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
            [self.contentView addSubview:img];
            img.userInteractionEnabled = YES;
            img.clipsToBounds = YES;
            img.contentMode = UIViewContentModeScaleAspectFill;
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(browerImage:)];
//            [img addGestureRecognizer:tap];
//            [_groupImgArr addObject:img];
            
            _name.textColor = admincolor;
            _content.frame = CGRectMake(15, 75, Main_width-30, 40);
            _scan.frame = CGRectMake(15, 75+40+18+15+Main_width/1.5, 60, 30);
            _pinglun.frame = CGRectMake(15+50+20, 75+40+18+15+Main_width/1.5, 60, 30);
            _fenlei.frame = CGRectMake(15+140, 75+40+18+15+Main_width/1.5, Main_width-15-155, 30);
        }else{
            
            _name.textColor = [UIColor blackColor];
            
            if (imagearr.count<3) {
                for (int i = 0; i<imagearr.count; i++) {
                    CGFloat width = (Main_width - 36)/3;
                    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake((3+width)*i+15, 75+55, width, width)];
                    NSString *url = [[model.imageArr objectAtIndex:i] objectForKey:@"img"];
                    [img sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:url]] placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
                    [self.contentView addSubview:img];
                    img.clipsToBounds = YES;
                    img.contentMode = UIViewContentModeScaleAspectFill;
                    img.tag = i;
                    img.userInteractionEnabled = YES;
                    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(browerImage:)];
                    [img addGestureRecognizer:tap];
                    [_groupImgArr addObject:img];
                }
            }else{
                for (int i = 0; i<3; i++) {
                    CGFloat width = (Main_width - 36)/3;
                    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake((3+width)*i+15, 75+55, width, width)];
                    NSString *url = [[model.imageArr objectAtIndex:i] objectForKey:@"img"];
                    [img sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:url]] placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
                    [self.contentView addSubview:img];
                    img.clipsToBounds = YES;
                    img.contentMode = UIViewContentModeScaleAspectFill;
                    img.tag = i;
                    if (i==2) {
                        UILabel *labelnum = [[UILabel alloc] initWithFrame:CGRectMake(0, width-5-20, 0, 20)];
                        labelnum.backgroundColor = [UIColor blackColor];
                        labelnum.alpha = 0.3;
                        labelnum.font = [UIFont systemFontOfSize:14];
                        labelnum.text = [NSString stringWithFormat:@"共%ld张",imagearr.count];
                        CGSize size = [labelnum sizeThatFits:CGSizeMake(MAXFLOAT, 15)];
                        labelnum.frame = CGRectMake(width-5-size.width, labelnum.frame.origin.y,size.width,20);
                        
                        labelnum.textColor = [UIColor whiteColor];
                        [img addSubview:labelnum];
                    }
                    img.userInteractionEnabled = YES;
                    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(browerImage:)];
                    [img addGestureRecognizer:tap];
                    [_groupImgArr addObject:img];
                }
            }
            
            _content.frame = CGRectMake(15, 75, Main_width-30, 40);
            _scan.frame = CGRectMake(15, 75+40+18+15+(Main_width-36)/3, 60, 30);
            _pinglun.frame = CGRectMake(15+70, 75+40+18+15+(Main_width-36)/3, 60, 30);
            _fenlei.frame = CGRectMake(15+70+70, 75+40+18+15+(Main_width-36)/3, Main_width-15-140-15, 30);
        }
    }
    
}
- (void)browerImage:(UITapGestureRecognizer *)tap
{
    XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithImages:self.imgArray currentImageIndex:tap.view.tag];
    browser.browserStyle = XLPhotoBrowserStylePageControl;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
