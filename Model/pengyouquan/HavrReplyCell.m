//
//  HavrReplyCell.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/3/21.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "HavrReplyCell.h"
#import "UIImageView+WebCache.h"

@implementation HavrReplyCell

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
    
    _content = [[UILabel alloc] initWithFrame:CGRectMake(15, 75, Main_width-30, 0)];
    _content.alpha = 0.87;
    [self.contentView addSubview:_content];
    
    _name = [[UILabel alloc] initWithFrame:CGRectMake(15+40+15, 20, Main_width*3/4, 40)];
    [_name setFont:biaotifont];
    [self.contentView addSubview:_name];
    
    _deletebut = [UIButton buttonWithType:UIButtonTypeCustom];
    _deletebut.frame = CGRectMake(Main_width-65, 20, 65, 40);
    [_deletebut setTitle:@"删除" forState:UIControlStateNormal];
    [_deletebut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _deletebut.alpha = 0.7;
    [_deletebut.titleLabel setFont:font15];
    [self.contentView addSubview:_deletebut];
    
    _fabutime = [[UILabel alloc] init];
    _fabutime.textAlignment = NSTextAlignmentRight;
    [_fabutime setFont:font15];
    [self.contentView addSubview:_fabutime];
    
    
    
    _fabutime.alpha = 0.7;
    
    _scan = [[UILabel alloc] initWithFrame:CGRectMake(15, 75+40+18+15+(Main_width - 36)/3, 60, 30)];
    [self.contentView addSubview:_scan];
    
    
    _pinglun = [[UILabel alloc] initWithFrame:CGRectMake(15+70, 75+40+18+15+(Main_width - 36)/3, 60, 30)];
    [self.contentView addSubview:_pinglun];
    _pinglun.font = [UIFont systemFontOfSize:13];
    _scan.font = [UIFont systemFontOfSize:13];
    
    _fenlei = [[UILabel alloc] initWithFrame:CGRectMake(15+140, 75+40+18+15+(Main_width - 36)/3, Main_width-155-15, 30)];
    [self.contentView addSubview:_fenlei];
    _fenlei.font = [UIFont systemFontOfSize:13];
    
    UIView *lineview1 = [[UIView alloc] initWithFrame:CGRectMake(0, _fenlei.frame.size.height+_fenlei.frame.origin.y+20, Main_width, 1)];
    lineview1.backgroundColor = HColor(166, 166, 166);
    [self.contentView addSubview:lineview1];
    
    _replynumber = [[UILabel alloc] initWithFrame:CGRectMake(15, lineview1.frame.size.height+lineview1.frame.origin.y+17.5, Main_width/2, 25 )];
    [_replynumber setFont:font18];
    _replynumber.textColor = QIColor;
    [self.contentView addSubview:_replynumber];
    
    _replyimageview = [[UIImageView alloc] initWithFrame:CGRectMake(15, _replynumber.frame.size.height+_replynumber.frame.origin.y+15, 40, 40)];
    _replyimageview.layer.cornerRadius = 20;
    [_replyimageview.layer setMasksToBounds:YES];
    [self.contentView addSubview:_replyimageview];
    
    _replyname = [[UILabel alloc] initWithFrame:CGRectMake(15+40+10, lineview1.frame.origin.y+lineview1.frame.size.height+50, Main_width*3/4, 25)];
    [_replyname setFont:biaotifont];
    [self.contentView addSubview:_replyname];
    
    _replycontent = [[UILabel alloc] initWithFrame:CGRectMake(15+40+10, _replyname.frame.size.height+_replyname.frame.origin.y+10, Main_width-65-15, 25)];
    [_replycontent setFont:biaotifont];
    [self.contentView addSubview:_replycontent];
    
    _replytime = [[UILabel alloc] initWithFrame:CGRectMake(Main_width*2/3, lineview1.frame.origin.y+lineview1.frame.size.height+50, Main_width/3-15, 25)];
    [_replytime setFont:biaotifont];
    _replytime.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_replytime];
}
- (void)delete:(UIButton *)sender
{
    NSLog(@"帖子id===%ld",sender.tag);
    
    NSDictionary *dic = @{@"scoailid":[NSString stringWithFormat:@"%ld",sender.tag]};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shanchuwodetiezi" object:nil userInfo:dic];
}
- (void)setModel:(pengyouquanmodel *)model
{
    _imgArray = [NSMutableArray array];
    for (int i=0; i<model.imageArr.count; i++) {
        NSString *imgurl = [API_img stringByAppendingString:[[model.imageArr objectAtIndex:i] objectForKey:@"img"]];
        [_imgArray addObject:imgurl];
    }
    
    [_deletebut addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    _deletebut.tag = [model.social_id integerValue];
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
    CGSize size = [_content sizeThatFits:CGSizeMake(_content.frame.size.width, MAXFLOAT)];
    _content.frame = CGRectMake(_content.frame.origin.x, _content.frame.origin.y, _content.frame.size.width,            size.height);
    _name.text = model.name;
    _fabutime.text = model.fabutime;
    NSMutableAttributedString *attri =     [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",model.scan]];
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    attch.image = [UIImage imageNamed:@"liulan"];
    attch.bounds = CGRectMake(0, -5, 20, 20);
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [attri insertAttributedString:string atIndex:0];
    _scan.attributedText = attri;
    
    
    _pinglun.alpha = 0.54;
    _scan.alpha = 0.54;
    _fenlei.alpha = 0.54;
    
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
    
    _replynumber.text = [NSString stringWithFormat:@"%@条新评论",model.replynumber];
    
    _replytime.text = model.replytime;
    
    _replyname.text = model.replyname;
    
    _replycontent.text = model.replycontent;
    
    [_replyimageview sd_setImageWithURL:[NSURL URLWithString:model.replytouxiangurl] placeholderImage:[UIImage imageNamed:@"facehead1"]];
    
    NSArray *imagearr = [NSArray array];
    imagearr = model.imageArr;
    if ([imagearr isKindOfClass:[NSArray class]]&&imagearr.count>0) {
        if (![model.guanfang isEqualToString:@"0"]) {
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(15, 75+55, Main_width-30, Main_width/1.5)];
            NSString *url = [[model.imageArr objectAtIndex:0] objectForKey:@"img"];
            [img sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:url]] placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
            [self.contentView addSubview:img];
            img.userInteractionEnabled = YES;
            img.clipsToBounds = YES;
            img.contentMode = UIViewContentModeScaleAspectFill;
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(browerImage:)];
//            [img addGestureRecognizer:tap];
//            [_groupImgArr addObject:img];
            
        }else{
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
                    img.userInteractionEnabled = YES;
                    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(browerImage:)];
                    [img addGestureRecognizer:tap];
                    [_groupImgArr addObject:img];
                }
            }
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
