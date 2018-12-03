//
//  businessVCModel.h
//  HuiShengHuo2.0
//
//  Created by admin on 2018/11/30.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "JSONModel.h"

@interface businessVCModel : JSONModel
@property (nonatomic ,strong)NSArray *service;
@property (nonatomic ,strong)NSString *id;
@property (nonatomic ,strong)NSString *total_Pages;
@property (nonatomic ,strong)NSString *name;
@property (nonatomic ,strong)NSArray *category;
@property (nonatomic ,strong)NSString *logo;
@end
