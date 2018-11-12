//
//  Common.h
//  CommunityWisdomLife
//
//  Created by apple on 16/8/24.
//  Copyright © 2016年 华晟众慧. All rights reserved.
//

//  为提高开发效率，对于SDK中的常用方法 定义为宏
// 1.公共定义注意定义名称
// 2.公共常量定义 +"k"

/*<--------------------------------定义系统常用宏-------------------------------->*/

#define iOS8                           ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
#define AppShareDelegate               ((AppDelegate*)[[UIApplication sharedApplication] delegate])
#define UserDefaults                   [NSUserDefaults standardUserDefaults]
#define SharedApplication              [UIApplication sharedApplication]
#define RGB(r, g, b)                   [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]
#define RGBA(r, g, b, a)                   [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:(a)]
#define StatusBarH                     [[UIApplication sharedApplication] statusBarFrame].size.height
#define Poin                           CGPointMake(x, y)
#define Size(w, h)                     CGSizeMake(w, h)
#define Rect(x, y, w, h)               CGRectMake(x, y, w, h)
#define Bundle                         [NSBundle mainBundle]
#define ScreenH                        [[UIScreen mainScreen]bounds].size.height
#define ScreenW                        [[UIScreen mainScreen]bounds].size.width
#define ScreenRect                     [[UIScreen mainScreen] bounds]
#define ViewWidth(v)                   v.frame.size.width
#define ViewHeight(v)                  v.frame.size.height
#define ViewX(v)                       v.frame.origin.x
#define ViewY(v)                       v.frame.origin.y
#define RectX(f)                       f.origin.x
#define RectY(f)                       f.origin.y
#define RectWidth(f)                   f.size.width
#define RectHeight(f)                  f.size.height
#define ViewMaxY(v)                    CGRectGetMaxY(v)
#define ViewMinY(v)                    CGRectGetMinY(v)
#define ViewMaxX(v)                    CGRectGetMaxX(v)
#define ViewMinX(v)                    CGRectGetMinX(v)


#define RectSetX(f, x)                 Rect(x, RectY(f), RectWidth(f), RectHeight(f))
#define RectSetY(f, y)                 Rect(RectX(f), y, RectWidth(f), RectHeight(f))
#define RectSetSize(f, w, h)           Rect(RectX(f), RectY(f), w, h)
#define RectSetOrigin(f, x, y)         Rect(x, y, RectWidth(f), RectHeight(f))
#define kFont(f)                       [UIFont systemFontOfSize:(f)]
#define AS(A,B)                        [(A) stringByAppendingString:(B)]
#define kNavBarBottomY                  0


//#define ScreenWidth                     ([UIScreen mainScreen].bounds.size.width)
//#define ScreenHeight                    ([UIScreen mainScreen].bounds.size.height)
#define ScaleWidth5                     (ScreenWidth / 320)
#define ScaleHeight5                    (ScreenHeight / 568)
#define CommonCellHeight (40 * ScaleHeight5)
//#define SystemFontOfSize(size)         [UIFont systemFontOfSize:size]
//导航标题
#define ImportFontSize1 (18 * ScaleHeight5)
//二级导航、栏目标题
#define ImportFontSize2 (15 * ScaleHeight5)
//一般
//普通文字、正文
#define NormalFontSize1 (14 * ScaleHeight5)
//备注、提示语
#define NormalFontSize2 (12 * ScaleHeight5)
//较弱 底部导航拦文字、交互语言
#define WeakFontSize2 (10 * ScaleHeight5)
#define WeakFontSize3 (8 * ScaleHeight5)
//重要
//导航栏背景色、按钮、icon
#define ImportColor1 [UIColor colorWithHexString:@"ff3d33"]
//重要文字信息，类目、标题等
#define ImportColor2 [UIColor colorWithHexString:@"333333"]
//一般 普通文字信息、文章等
#define NormalColor1 [UIColor colorWithHexString:@"666666"]
//辅助文字，提示语、交互语言等
#define NormalColor2 [UIColor colorWithHexString:@"999999"]
//分割线
#define NormalColor3 [UIColor colorWithHexString:@"e4e4e4"]
//较弱
#define WeakColor1 [UIColor colorWithHexString:@"f0f0f0"]

/*<--------------------------------日志输出宏定义-------------------------------->*/
#ifdef DEBUG
// 调试状态
#define MyLog(...)      NSLog(__VA_ARGS__)
#define DISTRUBISHION_STATUS   0
#else
// 发布状态
#define MyLog(...)
#define DISTRUBISHION_STATUS   2
#endif


