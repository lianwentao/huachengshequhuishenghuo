//
//  TooBox.h
//  TextOne
//
//  Created by Mac on 16/6/28.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import <MAMapKit/MAMapKit.h>
//#import <AMapSearchKit/AMapSearchKit.h>

typedef void(^alertControlHandler)(BOOL sure);

typedef void(^actionSheetControlHandler)(NSInteger tag);
@interface TooBox : NSObject

/**
 拨打电话
 */
+ (void)call:(NSString *)phoneNum;

#pragma mark - 字符串转化为数组 数组转化为字符串
/**
 字符串转化为数组(不包含@"")
 */
+ (NSArray *)arrWithSting:(NSString *)string;
/**
 数组转化为字符串(!!末尾有',')
 */
+ (NSString *)jointStringWithArr:(NSArray *)arr;


#pragma mark - lable自适应高度
/**
 lable自适应高度
 */
+ (CGSize)labelAutoCalculateRectWithText:(NSString *)text FontSize:(CGFloat)fontSize maxWidth:(CGFloat)maxWidth;
//+ (CGSize)lableSizeWithText:(NSString *)text font:(CGFloat)font size:(CGSize)size widthConstant:(BOOL)widthConstant;

#pragma mark - AlertShow && ActionSheetShow
/**
 AlertShow
 */
+ (void)alertShowWithViewController:(UIViewController *)vc Title:(NSString *)title message:(NSString *)message handler:(alertControlHandler )handler;
/**
 AlertShow(根据当前屏幕，可能不准确)
 */
+ (void)alertShowWithTitle:(NSString *)title message:(NSString *)message handler:(alertControlHandler )handler;
/**
 ActionSheetShow
 */
+ (void)actionSheetShowWithViewController:(UIViewController *)vc Titles:(NSArray *)titlesArr handler:(actionSheetControlHandler)handler;
/**
 ActionSheetShow(根据当前屏幕，可能不准确)
 */
+ (void)actionSheetShowWithTitles:(NSArray *)titlesArr handler:(actionSheetControlHandler)handler;


#pragma mark - CurrentViewController
/**
 CurrentViewController
 */
+ (UIViewController *)currentViewController;

#pragma mark - APIStr
+ (NSString *)apiPathStringWithApi:(NSString *)api;

#pragma mark - ShareMapView && ShareSearchAPI
//+ (MAMapView *)shareMapView;
//+ (AMapSearchAPI *)shareSearchApi;


#pragma mark - IsMobileNumber
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

#pragma mark - Response
+ (id)firstResponder;
+ (BOOL)resignFirstResponder;


#pragma mark - LineView
+ (UIView *)lineViewWithFrame:(CGRect)frame backGroundColor:(UIColor *)color;


#pragma mark - Image
/**
 根据颜色和大小绘制图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;


#pragma mark - 将汉字转化为拼音
/**
 将汉字转化为拼音
 */
+ (NSString *)transformToPinyin:(NSString *)string ;


#pragma mark - 星View
+ (UIView *)starViewWithFrame:(CGRect)frame Count:(NSInteger)starCount;

#pragma mark - 判断当前页面是否Apper
+ (BOOL)isApperWithViewController:(UIViewController *)vc;


+ (NSArray *)arrWithStingAboutEmpity:(NSString *)string;

@end
