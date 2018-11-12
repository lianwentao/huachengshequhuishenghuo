//
//  AllPayViewController.h
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/11/27.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllPayViewController : UIViewController

@property (nonatomic,copy)NSString *order_id;
@property (nonatomic,strong)NSString *price;
@property (nonatomic,strong)NSString *type;
@property (nonatomic,strong)NSString *c_id;

@property (nonatomic,copy)NSString *rukoubiaoshi;
@property (nonatomic,copy)NSString *shuidianfei;
- (BOOL)navigationShouldPopOnBackButton;
@end
