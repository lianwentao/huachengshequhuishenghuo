//
//  PTLMaskingView.h
//  HuiShengHuo2.0
//
//  Created by admin on 2018/11/16.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectRowBlock)(NSInteger row, NSString *rowTitle);

@interface PTLMaskingView : UIView

/** <#注释#> */
@property (nonatomic, copy) SelectRowBlock selectRowBlock;

- (void)getDataSource:(NSArray *)arr menuIndex:(NSInteger)menuIndex;

- (void)reloadData;
- (void)dismiss;
- (void)show:(UIView *)superView;
@end
