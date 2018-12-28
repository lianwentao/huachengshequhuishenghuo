//
//  Text1.h
//  HuiShengHuo2.0
//
//  Created by admin on 2018/12/28.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Text1;
@protocol Text1Delegate <NSObject>
@optional
- (void)didSelect;
@end

@interface Text1 : UIViewController
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, weak) id<Text1Delegate>delegate;
@end
