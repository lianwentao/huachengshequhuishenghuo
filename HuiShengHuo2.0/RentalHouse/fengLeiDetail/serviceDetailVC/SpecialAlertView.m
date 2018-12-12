//
//  SpecialAlertView.m
//  自定义弹框
//
//  Created by Mrjia on 2018/7/4.
//  Copyright © 2018年 Mrjia. All rights reserved.
//
#define ALERTVIEW_HEIGHT [UIScreen mainScreen].bounds.size.height/2
#define ALERTVIEW_WIDTH  [UIScreen mainScreen].bounds.size.width-50
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define WIDTH  [UIScreen mainScreen].bounds.size.width
#define MARGIN  20

#import "SpecialAlertView.h"

@interface SpecialAlertView()

@property(nonatomic,strong)UIView *alertView;

@end

@implementation SpecialAlertView


-(instancetype) initWithTitleImage:(NSString *)backImage messageTitle:(NSString *)titleStr messageString:(NSString *)contentStr sureBtnTitle:(NSString *)titleString sureBtnColor:(UIColor *)BtnColor{

    self = [super init];
    if (self) {

        self.frame = [UIScreen mainScreen].bounds;
        self.alertView = [[UIView alloc]initWithFrame:CGRectMake(MARGIN, HEIGHT/2-ALERTVIEW_HEIGHT/2, WIDTH-40, ALERTVIEW_HEIGHT+40)];
        self.alertView.backgroundColor = [UIColor whiteColor];
        self.alertView.layer.cornerRadius=5.0;
        self.alertView.layer.masksToBounds=YES;
        self.alertView.userInteractionEnabled=YES;
        [self addSubview:self.alertView];

        if (backImage) {
            UIImageView *titleImage = [[UIImageView alloc]initWithFrame:CGRectMake((self.alertView.frame.size.width/2)-50, 50, 100, 100)];
            titleImage.image = [UIImage imageNamed:backImage];
            [self.alertView addSubview:titleImage];
        }
        if (titleStr) {
            UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(MARGIN, 160, self.alertView.frame.size.width-40, 30)];
            titleLab.text = titleStr;
            titleLab.textColor = [UIColor colorWithRed:215/255.0 green:145/255.0 blue:57/255.0 alpha:1];
            titleLab.font = [UIFont systemFontOfSize:17];
            titleLab.textAlignment = NSTextAlignmentCenter;
            [self.alertView addSubview:titleLab];
        }
        if (contentStr) {
            UILabel *contentLab = [[UILabel alloc]initWithFrame:CGRectMake(MARGIN, 175, self.alertView.frame.size.width-40, 70)];
            contentLab.text = contentStr;
            contentLab.font = [UIFont systemFontOfSize:14];
            contentLab.numberOfLines = 0;
            contentLab.textAlignment = NSTextAlignmentCenter;
            contentLab.textColor = [UIColor lightGrayColor];
            [self.alertView addSubview:contentLab];
        }
        if (titleString) {
            UIButton *sureBtn= [[UIButton alloc]initWithFrame:CGRectMake(80, ALERTVIEW_HEIGHT-50, self.alertView.frame.size.width-160, 40)];
            [sureBtn setTitle:titleString forState:UIControlStateNormal];
            sureBtn.clipsToBounds = YES;
            sureBtn.layer.cornerRadius = 10;
            CAGradientLayer *layer = [CAGradientLayer layer];
            layer.frame = sureBtn.bounds;
            layer.startPoint = CGPointMake(0,0);
            layer.endPoint = CGPointMake(1, 0);
            layer.colors = @[(id)[UIColor colorWithHexString:@"FF9502"].CGColor,(id)[UIColor colorWithHexString:@"FF5722"].CGColor];
            [sureBtn.layer addSublayer:layer];
//            [sureBtn setBackgroundColor:@[(id)[UIColor colorWithHexString:@"FF5722"].CGColor,(id)[UIColor colorWithHexString:@"FF9502"].CGColor]];
            sureBtn.layer.cornerRadius=5.0;
            sureBtn.layer.masksToBounds=YES;
            [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [sureBtn addTarget:self action:@selector(SureClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.alertView addSubview:sureBtn];
        }
    }
    [self showAnimation];
    return self;
}

-(void)showAnimation{
    
    self.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self];

    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);

    self.alertView.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.2,0.2);
    self.alertView.alpha = 0;
    [UIView animateWithDuration:0.2 delay:0.1 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.4f];
        self.alertView.transform = transform;
        self.alertView.alpha = 1;
    } completion:^(BOOL finished) {

    }];
}

-(void)SureClick:(UIButton *)sender{

    if (self.sureClick) {
        self.sureClick(nil);
    }

    [UIView animateWithDuration:0.3 animations:^{
        [self removeFromSuperview];
    }];
}

-(void)withSureClick:(sureBlock)block{
    _sureClick = block;
}

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [UIView animateWithDuration:0.3 animations:^{
//        [self removeFromSuperview];
//    }];
//
//}








@end
