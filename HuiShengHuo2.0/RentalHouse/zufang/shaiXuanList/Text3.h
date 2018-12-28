//
//  Text3.h
//  HuiShengHuo2.0
//
//  Created by admin on 2018/12/28.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Text3;
@protocol Text3Delegate <NSObject>
@optional
- (void)didSelect;
@end

@interface Text3 : UIViewController
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, weak) id<Text3Delegate>delegate;
@end
