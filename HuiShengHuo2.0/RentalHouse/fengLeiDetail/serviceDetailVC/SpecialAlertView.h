//
//  SpecialAlertView.h
//  自定义弹框
//
//  Created by Mrjia on 2018/7/4.
//  Copyright © 2018年 Mrjia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^sureBlock)(NSString *string);

@interface SpecialAlertView : UIView

-(instancetype) initWithTitleImage:(NSString *)backImage messageTitle:(NSString *)titleStr messageString:(NSString *)contentStr sureBtnTitle:(NSString *)titleString sureBtnColor:(UIColor *)BtnColor;

@property(nonatomic,copy)sureBlock sureClick;

-(void)withSureClick:(sureBlock)block;

-(instancetype) initWithMessageTitle:(NSString *)titleStr messageString:(NSString *)contentStr messageString1:(NSString *)contentStr1 messageString2:(NSString *)contentStr2 messageString3:(NSString *)contentStr3 messageString4:(NSString *)contentStr4 sureBtnTitle:(NSString *)titleString sureBtnColor:(UIColor *)BtnColor;
-(instancetype) initWithMessageTitle:(NSString *)titleStr messageString:(NSString *)contentStr messageString1:(NSString *)contentStr1 sureBtnTitle:(NSString *)titleString sureBtnColor:(UIColor *)BtnColor;
-(instancetype) initWithImage:(NSString *)backImage messageTitle:(NSString *)titleStr messageString:(NSString *)contentStr messageString1:(NSString *)contentStr1 sureBtnTitle:(NSString *)titleString sureBtnColor:(UIColor *)BtnColor;

@end
