//
//  SBCycleScrollView.h
//  SBCycleScrollView
//
//  Created by luo.h on 15/7/12.
//  Copyright (c) 2015年 l.h. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "NSTimer+Addition.h"
/**  开启定时器 */
static NSString * const SBCycleScrollViewOpenTimerNotiName   = @"BCycleScrollViewOpenTimer";

/**  关闭定时器*/
static NSString * const SBCycleScrollViewCloseTimerNotiName   = @"SBCycleScrollViewCloseTimer";

@class SBCycleScrollView;
@protocol SBCycleScrollViewDelegate <NSObject>
- (void)SBCycleScrollView:(SBCycleScrollView *)cycleScrollView didSelectIndex:(NSInteger)index;
@end


@interface SBCycleScrollView : UIView

-(id)initWithFrame:(CGRect)frame
          Duration:(NSTimeInterval)duration
  pageControlHeight:(NSInteger)height;

@property (nonatomic,weak) id<SBCycleScrollViewDelegate>delegate;

@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel      *titleLabel;

@end
