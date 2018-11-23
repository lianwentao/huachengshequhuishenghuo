//
//  UIView+Frame.m
//  TimeLabel
//
//  Created by coolead on 2017/12/12.
//  Copyright © 2017年 JustCompareThin. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)
- (void)setMkX:(CGFloat)xValue {
    CGRect frame = self.frame;
    frame.origin.x = xValue;
    self.frame = frame;
}//

- (CGFloat)mkX {
    return self.frame.origin.x;
}//

- (void)setMkY:(CGFloat)yValue {
    CGRect frame = self.frame;
    frame.origin.y = yValue;
    self.frame = frame;
}//

- (CGFloat)mkY {
    return self.frame.origin.y;
}//

- (void)setMkWidth:(CGFloat)widthValue {
    CGRect frame = self.frame;
    frame.size.width = widthValue;
    self.frame = frame;
}//

- (CGFloat)mkWidth {
    return self.frame.size.width;
}//

- (void)setMkHeight:(CGFloat)heightValue {
    CGRect frame = self.frame;
    frame.size.height = heightValue;
    self.frame = frame;
}//

- (CGFloat)mkHeight {
    return self.frame.size.height;
}//

- (void)setMkMaxX:(CGFloat)MaxX
{
    CGRect frame = self.frame;
    frame.origin.x = ceilf(MaxX-frame.size.width);
    self.frame = frame;
}//

- (CGFloat)mkMaxX
{
    return self.frame.origin.x + self.frame.size.width;
}//

- (void)setMkMaxY:(CGFloat)MaxY
{
    CGRect frame = self.frame;
    frame.origin.y = ceilf(MaxY-frame.size.height);
    self.frame = frame;
}//

- (CGFloat)mkMaxY
{
    return self.frame.origin.y + self.frame.size.height;
}//

- (void)setMkCenterX:(CGFloat)centerX
{
    self.center = CGPointMake(centerX, self.center.y);
}//

- (void)setMkCenterY:(CGFloat)centerY
{
    self.center = CGPointMake(self.center.x, centerY);
}//

- (CGFloat)mkCenterX {
    return self.center.x;
}//

- (CGFloat)mkCenterY {
    return self.center.y;
}//

- (CGFloat)mkBoundWidth
{
    return self.bounds.size.width;
}//

- (CGFloat)mkBoundHeight
{
    return self.bounds.size.height;
}

- (CGSize)mkSize {
    return self.frame.size;
}

- (void)setMkSize:(CGSize)size{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)mkBottom{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setMkBottom:(CGFloat)bottom{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)mkRight{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setMkRight:(CGFloat)mkRight{
    CGRect frame = self.frame;
    frame.origin.x = mkRight - frame.size.width;
    self.frame = frame;
}

//11.23 新加
- (void)setYj_x:(CGFloat)yj_x
{
    CGRect frame = self.frame;
    frame.origin.x = yj_x;
    // 设置UIView的x值
    self.frame = frame;
}

- (CGFloat)yj_x
{
    // 返回UIView的x值
    return self.frame.origin.x;
}

- (void)setYj_y:(CGFloat)yj_y
{
    CGRect frame = self.frame;
    frame.origin.y = yj_y;
    self.frame = frame;
}

- (CGFloat)yj_y
{
    return self.frame.origin.y;
}

- (void)setYj_width:(CGFloat)yj_width
{
    CGRect frame = self.frame;
    frame.size.width = yj_width;
    self.frame = frame;
}

- (CGFloat)yj_width
{
    return self.frame.size.width;
}

- (void)setYj_height:(CGFloat)yj_height
{
    CGRect frame = self.frame;
    frame.size.height = yj_height;
    self.frame = frame;
}

- (CGFloat)yj_height
{
    return self.frame.size.height;
}

- (void)setYj_centerX:(CGFloat)yj_centerX
{
    CGPoint center = self.center;
    center.x = yj_centerX;
    self.center = center;
}

- (CGFloat)yj_centerX
{
    return self.center.x;
}

- (void)setYj_centerY:(CGFloat)yj_centerY
{
    CGPoint center = self.center;
    center.y = yj_centerY;
    self.center = center;
}

- (CGFloat)yj_centerY
{
    return self.center.y;
}

@end
