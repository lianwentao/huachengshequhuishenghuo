//
//  searchBusinessModel.h
//  HuiShengHuo2.0
//
//  Created by admin on 2018/12/11.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "JSONModel.h"

@interface searchBusinessModel : JSONModel
@property (nonatomic ,strong)NSArray *service;
@property (nonatomic ,strong)NSString *id;
@property (nonatomic ,strong)NSString *total_Pages;
@property (nonatomic ,strong)NSString *name;
@property (nonatomic ,strong)NSString *logo;
@end
