//
//  IgnoreHeaderTouchTableView.m
//  HuiShengHuo2.0
//
//  Created by admin on 2018/11/26.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "IgnoreHeaderTouchTableView.h"

@implementation IgnoreHeaderTouchTableView

//忽略tab的头部点击事件
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    if (self.tableHeaderView && CGRectContainsPoint(self.tableHeaderView.frame, point)) {
        return NO;
    }
    return [super pointInside:point withEvent:event];
}

@end
