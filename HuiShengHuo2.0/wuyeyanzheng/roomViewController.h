//
//  roomViewController.h
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/12/25.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface roomViewController : UIViewController

@property (nonatomic,strong)NSString *community_id;
@property (nonatomic,strong)NSString *build_id;
@property (nonatomic,strong)NSString *units;
@property (nonatomic,strong)NSString *community_name;
@property (nonatomic,strong)NSString *build_name;

@property (nonatomic,copy)NSString *company_id;
@property (nonatomic,copy)NSString *company_name;
@property (nonatomic,copy)NSString *department_id;
@property (nonatomic,copy)NSString *department_name;

@property (nonatomic,strong)NSString *address;
@property (nonatomic,strong)NSString *lou;


@property (nonatomic,copy)NSString *biaoshi;
@end
