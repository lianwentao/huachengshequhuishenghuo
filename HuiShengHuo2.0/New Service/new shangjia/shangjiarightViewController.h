//
//  shangjiarightViewController.h
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/12/8.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWGesturePenetrationTableView.h"

@interface shangjiarightViewController : UIViewController
@property (nonatomic, strong, readonly) LWGesturePenetrationTableView *tableView;
@property (nonatomic, assign) OffsetType offsetType;
@property (nonatomic, copy) NSString *shopID;
@end
