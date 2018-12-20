//
//  yikatongViewController.h
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/12/21.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface yikatongViewController : UIViewController

@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *price;
@property (nonatomic,strong)NSString *otype;
@property (nonatomic,copy)NSString *prepay;//判断物业工单是否为预付款  1为预付款
@end
