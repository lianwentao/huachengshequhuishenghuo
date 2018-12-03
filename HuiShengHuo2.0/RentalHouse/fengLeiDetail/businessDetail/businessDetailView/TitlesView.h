//
//  TitlesView.h
//  HuiShengHuo2.0
//
//  Created by admin on 2018/11/26.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitlesView : UIView
- (instancetype)initWithTitleArray:(NSArray *)titleArray;

- (void)setItemSelected:(NSInteger)column;


//点击的第几个按钮
typedef void (^TitleViewClick)(NSInteger);

@property (nonatomic, strong) TitleViewClick titleClickBlock;

@end
