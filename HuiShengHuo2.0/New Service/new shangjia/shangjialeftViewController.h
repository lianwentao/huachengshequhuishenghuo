//
//  shangjialeftViewController.h
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/12/8.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWGesturePenetrationTableView.h"

@interface shangjialeftViewController : UIViewController


@property(nonatomic, strong,readonly)LWGesturePenetrationTableView *rightTableView;
@property (nonatomic, assign) OffsetType offsetType;
@property(nonatomic, assign) BOOL rightTVScrollDown;
@property (nonatomic,copy)NSString *sssss;
@end
