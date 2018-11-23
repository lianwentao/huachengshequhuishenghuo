//
//  PTLMenuButton.h
//  HuiShengHuo2.0
//
//  Created by admin on 2018/11/16.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PTLMenuButton;
@protocol PTLMenuButtonDelegate <NSObject>

- (void)ptl_menuButton:(PTLMenuButton *)menuButton didSelectMenuButtonAtIndex:(NSInteger)index selectMenuButtonTitle:(NSString *)title listRow:(NSInteger)row rowTitle:(NSString *)rowTitle;

@end

@interface PTLMenuButton : UIView

/** 列对应的数据源 */
@property (nonatomic, strong) NSArray<NSArray *> *listTitles;
@property (nonatomic, weak) id<PTLMenuButtonDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame menuTitles:(NSArray *)menuTitles;

@end

