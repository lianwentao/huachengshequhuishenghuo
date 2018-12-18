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
-(instancetype) initWithImage:(NSString *)backImage messageTitle:(NSString *)titleStr messageString:(NSString *)contentStr messageString1:(NSString *)contentStr1 sureBtnTitle:(NSString *)titleString sureBtnColor:(UIColor *)BtnColor{
    self = [super init];
    if (self) {
        
        self.frame = [UIScreen mainScreen].bounds;
        self.alertView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_width,Main_Height)];
        self.alertView.backgroundColor = [UIColor whiteColor];
//        self.alertView.layer.cornerRadius=5.0;
        self.alertView.layer.masksToBounds=YES;
        self.alertView.userInteractionEnabled=YES;
        [self addSubview:self.alertView];
        
        if (backImage) {
            UIImageView *titleImage = [[UIImageView alloc]initWithFrame:CGRectMake((self.alertView.frame.size.width/2)-75, 150, 150, 150)];
            titleImage.layer.cornerRadius=75;
            titleImage.backgroundColor = [UIColor yellowColor];
//            titleImage.image = [UIImage imageNamed:backImage];
            [self.alertView addSubview:titleImage];
        }
        if (titleStr) {
            UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(MARGIN, 320, self.alertView.frame.size.width-40, 30)];
            titleLab.text = titleStr;
            titleLab.textColor = [UIColor colorWithRed:255/255.0 green:87/255.0 blue:34/255.0 alpha:1];
            titleLab.font = [UIFont systemFontOfSize:24];
            titleLab.textAlignment = NSTextAlignmentCenter;
            [self.alertView addSubview:titleLab];
        }
        if (contentStr) {
            UILabel *contentLab = [[UILabel alloc]initWithFrame:CGRectMake(MARGIN, 370, self.alertView.frame.size.width-40, 20)];
            contentLab.text = contentStr;
            contentLab.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
            contentLab.font = [UIFont systemFontOfSize:18];
            contentLab.numberOfLines = 0;
            contentLab.textAlignment = NSTextAlignmentCenter;
            contentLab.textColor = [UIColor lightGrayColor];
            [self.alertView addSubview:contentLab];
        }
        if (contentStr1) {
            UILabel *contentLab1 = [[UILabel alloc]initWithFrame:CGRectMake(MARGIN, 390, self.alertView.frame.size.width-40, 20)];
            contentLab1.text = contentStr1;
            contentLab1.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
            contentLab1.font = [UIFont systemFontOfSize:18];
            contentLab1.numberOfLines = 0;
            contentLab1.textAlignment = NSTextAlignmentCenter;
            contentLab1.textColor = [UIColor lightGrayColor];
            [self.alertView addSubview:contentLab1];
        }
        if (titleString) {
            UIButton *sureBtn= [[UIButton alloc]initWithFrame:CGRectMake(80, 470, self.alertView.frame.size.width-160, 40)];
            [sureBtn setTitle:titleString forState:UIControlStateNormal];
            sureBtn.clipsToBounds = YES;
            sureBtn.layer.cornerRadius = 20;
            sureBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:87/255.0 blue:34/255.0 alpha:1];
            sureBtn.layer.cornerRadius=20.0;
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

-(instancetype) initWithMessageTitle:(NSString *)titleStr messageString:(NSString *)contentStr messageString1:(NSString *)contentStr1 messageString2:(NSString *)contentStr2 messageString3:(NSString *)contentStr3 messageString4:(NSString *)contentStr4 sureBtnTitle:(NSString *)titleString sureBtnColor:(UIColor *)BtnColor{
    self = [super init];
    if (self) {
        
        self.frame = [UIScreen mainScreen].bounds;
        self.alertView = [[UIView alloc]initWithFrame:CGRectMake(MARGIN, HEIGHT/2-ALERTVIEW_HEIGHT/2, WIDTH-40, ALERTVIEW_HEIGHT+40)];
        self.alertView.backgroundColor = [UIColor whiteColor];
        self.alertView.layer.cornerRadius=5.0;
        self.alertView.layer.masksToBounds=YES;
        self.alertView.userInteractionEnabled=YES;
        [self addSubview:self.alertView];
        
        if (titleStr) {
            UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(MARGIN, 20, self.alertView.frame.size.width-40, 30)];
            titleLab.text = titleStr;
            titleLab.textColor = [UIColor colorWithRed:2/255.0 green:2/255.0 blue:2/255.0 alpha:1];
            titleLab.font = [UIFont systemFontOfSize:20];
            titleLab.textAlignment = NSTextAlignmentCenter;
            [self.alertView addSubview:titleLab];
        }
        UILabel *contentLab = [[UILabel alloc]init];
        if (contentStr) {
            contentLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, self.alertView.frame.size.width-100, 100)];
            contentLab.text = contentStr;
            contentLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:60];
            contentLab.numberOfLines = 0;
            contentLab.textAlignment = NSTextAlignmentRight;
            contentLab.textColor = [UIColor colorWithRed:255/255.0 green:87/255.0 blue:34/255.0 alpha:1];
            [self.alertView addSubview:contentLab];
        }
        
        if (contentStr1) {
            UILabel *contentLab1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(contentLab.frame), CGRectGetMaxY(contentLab.frame)-70, self.alertView.frame.size.width/2, 50)];
            contentLab1.text = contentStr1;
            contentLab1.font = [UIFont fontWithName:@"Helvetica-Bold" size:40];
            contentLab1.numberOfLines = 0;
            contentLab1.textAlignment = NSTextAlignmentLeft;
            contentLab1.textColor = [UIColor colorWithRed:255/255.0 green:87/255.0 blue:34/255.0 alpha:1];
            [self.alertView addSubview:contentLab1];
        }
        if (contentStr2) {
            UILabel *contentLab2 = [[UILabel alloc]initWithFrame:CGRectMake(MARGIN, 150, self.alertView.frame.size.width-40, 20)];
            contentLab2.text = contentStr2;
            contentLab2.font = [UIFont systemFontOfSize:14];
            contentLab2.numberOfLines = 0;
            contentLab2.textAlignment = NSTextAlignmentCenter;
            contentLab2.textColor = [UIColor colorWithRed:99/255.0 green:99/255.0 blue:99/255.0 alpha:1];
            [self.alertView addSubview:contentLab2];
        }
        if (contentStr3) {
            UILabel *contentLab3 = [[UILabel alloc]initWithFrame:CGRectMake(MARGIN, 220, self.alertView.frame.size.width-40, 20)];
            contentLab3.text = contentStr3;
            contentLab3.font = [UIFont systemFontOfSize:17];
            contentLab3.numberOfLines = 0;
            contentLab3.textAlignment = NSTextAlignmentCenter;
            contentLab3.textColor = [UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1];
            [self.alertView addSubview:contentLab3];
        }
        
        UIView *line = [[UIView alloc]init];
        line.frame = CGRectMake(15, ALERTVIEW_HEIGHT-90, self.alertView.frame.size.width-30, 1);
        line.backgroundColor = [UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1];
        [self.alertView addSubview:line];
        
        if (contentStr4) {
            UILabel *contentLab4 = [[UILabel alloc]initWithFrame:CGRectMake(MARGIN, 260, self.alertView.frame.size.width-40, 20)];
            contentLab4.text = contentStr4;
            contentLab4.font = [UIFont systemFontOfSize:14];
            contentLab4.numberOfLines = 0;
            contentLab4.textAlignment = NSTextAlignmentCenter;
            contentLab4.textColor = [UIColor colorWithRed:99/255.0 green:99/255.0 blue:99/255.0 alpha:1];
            [self.alertView addSubview:contentLab4];
        }
        if (titleString) {
            UIButton *sureBtn= [[UIButton alloc]initWithFrame:CGRectMake(80, ALERTVIEW_HEIGHT-40, self.alertView.frame.size.width-160, 40)];
            [sureBtn setTitle:titleString forState:UIControlStateNormal];
            sureBtn.clipsToBounds = YES;
            sureBtn.layer.cornerRadius = 20;
//            CAGradientLayer *layer = [CAGradientLayer layer];
//            layer.frame = sureBtn.bounds;
//            layer.startPoint = CGPointMake(0,0);
//            layer.endPoint = CGPointMake(1, 0);
//            layer.colors = @[(id)[UIColor colorWithHexString:@"FF9502"].CGColor,(id)[UIColor colorWithHexString:@"FF5722"].CGColor];
//            [sureBtn.layer addSublayer:layer];
            sureBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:87/255.0 blue:34/255.0 alpha:1];
            sureBtn.layer.cornerRadius=20.0;
            sureBtn.layer.masksToBounds=YES;
            [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [sureBtn addTarget:self action:@selector(SureClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.alertView addSubview:sureBtn];
        }
        
    }
    
    
    [self showAnimation];
    return self;
}
-(instancetype) initWithMessageTitle:(NSString *)titleStr messageString:(NSString *)contentStr messageString1:(NSString *)contentStr1 sureBtnTitle:(NSString *)titleString sureBtnColor:(UIColor *)BtnColor{
    
    self = [super init];
    if (self) {
        
        self.frame = [UIScreen mainScreen].bounds;
        self.alertView = [[UIView alloc]initWithFrame:CGRectMake(MARGIN, HEIGHT/2-ALERTVIEW_HEIGHT/2, WIDTH-40, ALERTVIEW_HEIGHT)];
        self.alertView.backgroundColor = [UIColor whiteColor];
        self.alertView.layer.cornerRadius=5.0;
        self.alertView.layer.masksToBounds=YES;
        self.alertView.userInteractionEnabled=YES;
        [self addSubview:self.alertView];
        
        if (titleStr) {
            UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(MARGIN, 40, self.alertView.frame.size.width-40, 30)];
            titleLab.text = titleStr;
            titleLab.textColor = [UIColor colorWithRed:2/255.0 green:2/255.0 blue:2/255.0 alpha:1];
            titleLab.font = [UIFont systemFontOfSize:20];
            titleLab.textAlignment = NSTextAlignmentCenter;
            [self.alertView addSubview:titleLab];
        }
        UILabel *contentLab = [[UILabel alloc]init];
        if (contentStr) {
            contentLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 80, self.alertView.frame.size.width/2, 100)];
            contentLab.text = contentStr;
            contentLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:60];
            contentLab.numberOfLines = 0;
            contentLab.textAlignment = NSTextAlignmentRight;
            contentLab.textColor = [UIColor colorWithRed:255/255.0 green:87/255.0 blue:34/255.0 alpha:1];
            [self.alertView addSubview:contentLab];
        }
        
        if (contentStr1) {
            UILabel *contentLab1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(contentLab.frame), CGRectGetMaxY(contentLab.frame)-70, self.alertView.frame.size.width/2-20, 50)];
            contentLab1.text = contentStr1;
            contentLab1.font = [UIFont fontWithName:@"Helvetica-Bold" size:40];
            contentLab1.numberOfLines = 0;
            contentLab1.textAlignment = NSTextAlignmentLeft;
            contentLab1.textColor = [UIColor colorWithRed:255/255.0 green:87/255.0 blue:34/255.0 alpha:1];
            [self.alertView addSubview:contentLab1];
        }
        if (titleString) {
            UIButton *sureBtn= [[UIButton alloc]initWithFrame:CGRectMake(80, ALERTVIEW_HEIGHT-100, self.alertView.frame.size.width-160, 40)];
            [sureBtn setTitle:titleString forState:UIControlStateNormal];
            sureBtn.clipsToBounds = YES;
            sureBtn.layer.cornerRadius = 20;
            //            CAGradientLayer *layer = [CAGradientLayer layer];
            //            layer.frame = sureBtn.bounds;
            //            layer.startPoint = CGPointMake(0,0);
            //            layer.endPoint = CGPointMake(1, 0);
            //            layer.colors = @[(id)[UIColor colorWithHexString:@"FF9502"].CGColor,(id)[UIColor colorWithHexString:@"FF5722"].CGColor];
            //            [sureBtn.layer addSublayer:layer];
            sureBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:87/255.0 blue:34/255.0 alpha:1];
            sureBtn.layer.cornerRadius=20.0;
            sureBtn.layer.masksToBounds=YES;
            [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [sureBtn addTarget:self action:@selector(SureClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.alertView addSubview:sureBtn];
        }
        
    }
    
    [self showAnimation];
    return self;
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
