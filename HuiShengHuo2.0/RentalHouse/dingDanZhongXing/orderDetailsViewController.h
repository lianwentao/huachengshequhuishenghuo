//
//  orderDetailsViewController.h
//  HuiShengHuo2.0
//
//  Created by admin on 2018/12/15.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface orderDetailsViewController : UIViewController
@property (nonatomic , assign)NSInteger status;
@property (nonatomic , assign)NSString *stateStr;
@property (nonatomic , strong)NSString *evaluate_status;
@property (nonatomic , strong)NSString *workOrderID;
@end
