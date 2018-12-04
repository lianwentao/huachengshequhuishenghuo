//
//  insinfoModel.h
//  HuiShengHuo2.0
//
//  Created by admin on 2018/11/30.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "JSONModel.h"

@interface insinfoModel : JSONModel
@property (nonatomic ,strong)NSString *telphone;
@property (nonatomic ,strong)NSString *id;
@property (nonatomic ,strong)NSArray *service_list;
@property (nonatomic ,strong)NSString *service_num;
@property (nonatomic ,strong)NSArray *cate_list;
@property (nonatomic ,strong)NSString *name;
@property (nonatomic ,strong)NSString *logo;
@property (nonatomic ,strong)NSString *coupon_num;
@end

