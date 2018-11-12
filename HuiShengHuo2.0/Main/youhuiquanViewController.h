//
//  youhuiquanViewController.h
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/12/6.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ Returnyouhuiquan) (NSString *detail,NSString *price,NSString *id);
@interface youhuiquanViewController : UIViewController
@property (nonatomic,strong)NSString *category_id;
@property (nonatomic,strong)NSString *shop_id_str;
@property (nonatomic,strong)NSString *amount;
@property (nonatomic,strong)NSString *jpushstring;

@property (nonatomic,strong)NSString *shiyong;

@property(nonatomic, copy) Returnyouhuiquan returnValueBlock;
@end
