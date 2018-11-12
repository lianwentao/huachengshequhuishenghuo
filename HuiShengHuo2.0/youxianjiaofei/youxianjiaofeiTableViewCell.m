//
//  youxianjiaofeiTableViewCell.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/6/14.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "youxianjiaofeiTableViewCell.h"

@implementation youxianjiaofeiTableViewCell

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
    
    _addtimelabel = [[UILabel alloc] initWithFrame:CGRectMake(17.5, 15, Main_width-35, 25)];
    [_addtimelabel setFont:font15];
    [view addSubview:_addtimelabel];
    
    _amountlabel = [[UILabel alloc] initWithFrame:CGRectMake(17.5, view.frame.size.height+20, Main_width-35, 25)];
    [_amountlabel setFont:font15];
    _amountlabel.textColor = QIColor;
    [self.contentView addSubview:_amountlabel];
    
    UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(17.5, _amountlabel.frame.size.height+_amountlabel.frame.origin.y+20, 6, 6)];
    circle.layer.masksToBounds = YES;
    circle.layer.cornerRadius = 3;
    circle.backgroundColor = CIrclecolor;
    UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(17.5+6, _amountlabel.frame.size.height+_amountlabel.frame.origin.y+20+3-0.25, Main_width-17.5-6, 0.5)];
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
    
    _biaohaolabel = [[UILabel alloc] initWithFrame:CGRectMake(17.5, _amountlabel.frame.size.height+_amountlabel.frame.origin.y+20+20, Main_width-35, 25)];
    [_biaohaolabel setFont:font15];
    [self.contentView addSubview:_biaohaolabel];
    
    _paytypelabel = [[UILabel alloc] initWithFrame:CGRectMake(17.5, _biaohaolabel.frame.size.height+_biaohaolabel.frame.origin.y+12.5, Main_width-35, 25)];
    [_paytypelabel setFont:font15];
    [self.contentView addSubview:_paytypelabel];
    
    _kahaolabel = [[UILabel alloc] initWithFrame:CGRectMake(17.5, _paytypelabel.frame.size.height+_paytypelabel.frame.origin.y+12.5, Main_width-35, 25)];
    [_kahaolabel setFont:font15];
    [self.contentView addSubview:_kahaolabel];
    
    _fullnamelabel = [[UILabel alloc] initWithFrame:CGRectMake(17.5, _kahaolabel.frame.size.height+_kahaolabel.frame.origin.y+12.5, Main_width-35, 25)];
    [_fullnamelabel setFont:font15];
    [self.contentView addSubview:_fullnamelabel];
    
    UIView *circle1 = [[UIView alloc] initWithFrame:CGRectMake(17.5, _fullnamelabel.frame.size.height+_fullnamelabel.frame.origin.y+20, 6, 6)];
    circle1.layer.masksToBounds = YES;
    circle1.layer.cornerRadius = 3;
    circle1.backgroundColor = CIrclecolor;
    UIView *lineview1 = [[UIView alloc] initWithFrame:CGRectMake(17.5+6, _fullnamelabel.frame.size.height+_fullnamelabel.frame.origin.y+20+3-0.25, Main_width-17.5-6, 0.5)];
    CAShapeLayer *shapeLayer1 = [CAShapeLayer layer];
    [shapeLayer1 setBounds:lineview1.bounds];
    [shapeLayer1 setPosition:CGPointMake(CGRectGetWidth(lineview1.frame) / 2, CGRectGetHeight(lineview1.frame))];
    [shapeLayer1 setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer1 setStrokeColor:[UIColor blackColor].CGColor];
    //  设置虚线宽度
    [shapeLayer1 setLineWidth:CGRectGetHeight(lineview1.frame)];
    [shapeLayer1 setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer1 setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:3], [NSNumber numberWithInt:1],  nil]];
    //  设置路径
    CGMutablePathRef path1 = CGPathCreateMutable();
    CGPathMoveToPoint(path1, NULL, 0, 0);
    CGPathAddLineToPoint(path1, NULL, CGRectGetWidth(lineview1.frame), 0);
    [shapeLayer1 setPath:path1];
    CGPathRelease(path1);
    //  把绘制好的虚线添加上来
    [lineview1.layer addSublayer:shapeLayer1];
    lineview1.alpha = 0.5;
    
    [self.contentView addSubview:lineview1];
    [self.contentView addSubview:circle1];
    
    _stauslabel = [[UILabel alloc] initWithFrame:CGRectMake(17.5, _fullnamelabel.frame.size.height+_fullnamelabel.frame.origin.y+40, Main_width-35, 25)];
    [_stauslabel setFont:font15];
    [self.contentView addSubview:_stauslabel];
    
    _uptimelabel = [[UILabel alloc] init];
    [_uptimelabel setFont:font15];
    [self.contentView addSubview:_uptimelabel];
    
    NSLog(@"--%f",_uptimelabel.frame.origin.y+25+20);
}
- (void)setModel:(youxianjiaofeimodel *)model
{
    _addtimelabel.text = model.addtime;
    _amountlabel.text = model.amount;
    _biaohaolabel.text = [NSString stringWithFormat:@"付款编号:%@",model.order_number];
    NSString *paytype;
    if ([model.pay_type isEqualToString:@"wxpay"]) {
        paytype = @"微信支付";
    }else if ([model.pay_type isEqualToString:@"alipay"]){
        paytype = @"支付宝";
    }else if ([model.pay_type isEqualToString:@"bestpay"]){
        paytype = @"翼支付";
    }else{
        paytype = @"华晟一卡通";
    }
    _paytypelabel.text = [NSString stringWithFormat:@"缴费方式:%@",paytype];
    _kahaolabel.text = [NSString stringWithFormat:@"卡号:%@",model.wired_num];
    _fullnamelabel.text = [NSString stringWithFormat:@"姓名:%@",model.fullname];;
    if ([model.staus isEqualToString:@"2"]) {
        _stauslabel.text = @"开通状态:已开通";
        _stauslabel.textColor = QIColor;
        
        _uptimelabel.text = [NSString stringWithFormat:@"开通时间:%@",model.uptime];
        _uptimelabel.textColor = QIColor;
        _uptimelabel.frame = CGRectMake(17.5, _stauslabel.frame.size.height+_stauslabel.frame.origin.y+12.5, Main_width-35, 25);
    }else{
        _stauslabel.text = @"开通状态:待开通";
        _stauslabel.textColor = CIrclecolor;
        
        _uptimelabel.text = @"";
        _uptimelabel.textColor = [UIColor clearColor];
        _uptimelabel.frame = CGRectMake(17.5, _stauslabel.frame.size.height+_stauslabel.frame.origin.y+12.5, Main_width-35, 0);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
