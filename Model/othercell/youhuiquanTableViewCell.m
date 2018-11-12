//
//  youhuiquanTableViewCell.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/12/6.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import "youhuiquanTableViewCell.h"
#define screen_Width [UIScreen mainScreen].bounds.size.width
#define screen_Height [UIScreen mainScreen].bounds.size.height
@implementation youhuiquanTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 初始化子视图
        [self createui];
    }
    return self;
}
- (void)createui
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, screen_Width-120-70, 20)];
    _titlelabel.font = [UIFont systemFontOfSize:12];
    _titlelabel.alpha = 0.5;
    [self.contentView addSubview:_titlelabel];
    
    _namelabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 35, screen_Width-120-70, 20)];
    _namelabel.font = [UIFont systemFontOfSize:15];
    
    [self.contentView addSubview:_namelabel];
    
    _lineview = [[UIView alloc] initWithFrame:CGRectMake(70, 69, screen_Width-120-70, 0.5)];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:_lineview.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(_lineview.frame) / 2, CGRectGetHeight(_lineview.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:[UIColor blackColor].CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(_lineview.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:3], [NSNumber numberWithInt:1],  nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(_lineview.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [_lineview.layer addSublayer:shapeLayer];
    _lineview.alpha = 0.5;
    [self.contentView addSubview:_lineview];
    
    _timelabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 70, screen_Width-120, 20)];
    _timelabel.font = [UIFont systemFontOfSize:12];
    _timelabel.alpha = 0.5;
    [self.contentView addSubview:_timelabel];
    
    

    _imageview = [[UIImageView alloc] initWithFrame:CGRectMake(screen_Width-120, 0, 120, 90)];
    [self.contentView addSubview:_imageview];
    
    _shiyonglabel = [[UILabel alloc] initWithFrame:CGRectMake(screen_Width-120, 0, 120, 90)];
    _shiyonglabel.textAlignment = NSTextAlignmentCenter;
    _shiyonglabel.textColor = [UIColor whiteColor];
    _shiyonglabel.font = [UIFont systemFontOfSize:25];
    [self.contentView addSubview:_shiyonglabel];
    
    _photo = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    _photo.layer.masksToBounds = YES;
    _photo.layer.cornerRadius = 30;
    [self.contentView addSubview:_photo];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 90, screen_Width, 10)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:view];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
