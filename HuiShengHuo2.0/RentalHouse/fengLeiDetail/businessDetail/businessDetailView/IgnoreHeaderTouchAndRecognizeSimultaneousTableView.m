//
//  IgnoreHeaderTouchAndRecognizeSimultaneousTableView.m
//  HuiShengHuo2.0
//
//  Created by admin on 2018/11/26.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "IgnoreHeaderTouchAndRecognizeSimultaneousTableView.h"

@implementation IgnoreHeaderTouchAndRecognizeSimultaneousTableView

//可以响应多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
