//
//  UIView+Frame.h
//  TimeLabel
//
//  Created by coolead on 2017/12/12.
//  Copyright © 2017年 JustCompareThin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

@property (nonatomic, assign) CGFloat mkX;
@property (nonatomic, assign) CGFloat mkY;
@property (nonatomic, assign) CGFloat mkWidth;
@property (nonatomic, assign) CGFloat mkHeight;
@property (nonatomic, assign) CGFloat mkMaxX;
@property (nonatomic, assign) CGFloat mkMaxY;
@property (nonatomic, assign) CGFloat mkCenterX;
@property (nonatomic, assign) CGFloat mkCenterY;
@property (nonatomic, assign, readonly) CGFloat mkBoundWidth;
@property (nonatomic, assign, readonly) CGFloat mkBoundHeight;

@property (nonatomic) CGSize mkSize;

@property (nonatomic) CGFloat mkBottom;

@property (nonatomic) CGFloat mkRight;

//11.23新加
/*
 分类里只能声明方法，不能声成员变量
 在分类声明属性是没有成员变量的，只有getter和setter方法
 */
@property CGFloat yj_x;
// y值
@property CGFloat yj_y;
// 宽度
@property CGFloat yj_width;
// 高度
@property CGFloat yj_height;
// centerX
@property CGFloat yj_centerX;
// centerY
@property CGFloat yj_centerY;

@end
