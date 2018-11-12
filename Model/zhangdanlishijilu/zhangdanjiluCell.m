//
//  zhangdanjiluCell.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/3/23.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "zhangdanjiluCell.h"

@implementation zhangdanjiluCell

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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_width, 55)];
    view.backgroundColor = BackColor;
    [self.contentView addSubview:view];
    
    _TimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(17.5, 15, Main_width-35, 25)];
    [_TimeLabel setFont:font15];
    [view addSubview:_TimeLabel];
    
    _PriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(17.5, view.frame.size.height+20, Main_width-35, 25)];
    [_PriceLabel setFont:font15];
    _PriceLabel.textColor = QIColor;
    [self.contentView addSubview:_PriceLabel];
    
    UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(17.5, _PriceLabel.frame.size.height+_PriceLabel.frame.origin.y+20, 6, 6)];
    circle.layer.masksToBounds = YES;
    circle.layer.cornerRadius = 3;
    circle.backgroundColor = CIrclecolor;
    UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(17.5+6, _PriceLabel.frame.size.height+_PriceLabel.frame.origin.y+20+3-0.25, Main_width-17.5-6, 0.5)];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineview.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineview.frame) / 2, CGRectGetHeight(lineview.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:[UIColor blackColor].CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineview.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:3], [NSNumber numberWithInt:1],  nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(lineview.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineview.layer addSublayer:shapeLayer];
    lineview.alpha = 0.5;
    
    [self.contentView addSubview:lineview];
    [self.contentView addSubview:circle];
    
    _bianhaoLabel = [[UILabel alloc] initWithFrame:CGRectMake(17.5, _PriceLabel.frame.size.height+_PriceLabel.frame.origin.y+20+20, Main_width-35, 25)];
    [_bianhaoLabel setFont:font15];
    [self.contentView addSubview:_bianhaoLabel];
    
    _NameLabel = [[UILabel alloc] initWithFrame:CGRectMake(17.5, _bianhaoLabel.frame.size.height+_bianhaoLabel.frame.origin.y+12.5, Main_width-35, 25)];
    [_NameLabel setFont:font15];
    [self.contentView addSubview:_NameLabel];
    NSLog(@"--%f",_NameLabel.frame.origin.y+25+20);
}
- (void)setModel:(fukuanjilumodel *)model
{
    _TimeLabel.text = model.time;
    _PriceLabel.text = model.price;
    _bianhaoLabel.text = model.biahao;
    _NameLabel.text = model.name;
    NSLog(@"model--%@",model.name);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
