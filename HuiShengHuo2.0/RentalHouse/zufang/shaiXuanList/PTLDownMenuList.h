//
//  PTLDownMenuList.h
//  HuiShengHuo2.0
//
//  Created by admin on 2018/11/16.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DismissBlock)(void);

@class PTLMaskingView;

@interface PTLDownMenuList : UIView
/** 蒙版 */
@property (nonatomic, strong) PTLMaskingView *maskingView;
/** <#注释#> */
@property (nonatomic, copy)DismissBlock dismissBlock;
@end
