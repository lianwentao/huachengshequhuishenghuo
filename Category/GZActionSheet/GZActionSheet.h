//
//  代码地址: https://github.com/Gfengwei/GZActionSheet.git
//
//  GZActionSheet.h
//  GZActionSheet
//
//  Created by guifengwei on 2017/3/21.
//  Copyright © 2017年 Gfengwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GZActionSheet : UIView

@property (nonatomic,copy) void (^ClickAction) (NSInteger index);

/** 传入title数组 */
- (instancetype)initWithTitleArray:(NSArray *)titleArr;

@end
