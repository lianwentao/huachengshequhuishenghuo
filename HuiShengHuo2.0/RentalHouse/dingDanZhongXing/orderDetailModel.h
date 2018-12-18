//
//  orderDetailModel.h
//  HuiShengHuo2.0
//
//  Created by admin on 2018/12/17.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "JSONModel.h"

@interface orderDetailModel : JSONModel
@property (nonatomic , strong)NSString *id;
@property (nonatomic , strong)NSString *content;//维修备注
@property (nonatomic , strong)NSString *distribute_at;
@property (nonatomic , strong)NSString *send_content;
@property (nonatomic , strong)NSString *total_fee_content;
@property (nonatomic , strong)NSString *order_time;
@property (nonatomic , strong)NSString *send_at;
//@property (nonatomic , strong)NSArray *repairImg;
//@property (nonatomic , strong)NSString *score;
@property (nonatomic , strong)NSString *complete_content;
@property (nonatomic , strong)NSString *release_at;
@property (nonatomic , strong)NSString *work_type;
@property (nonatomic , strong)NSString *order_number;
@property (nonatomic , strong)NSString *degree;
@property (nonatomic , strong)NSString *total_fee_at;

@property (nonatomic , strong)NSString *total_fee;
//@property (nonatomic , strong)NSArray *distributeUser;
@property (nonatomic , strong)NSString *work_status;
@property (nonatomic , strong)NSString *userphone;
@property (nonatomic , strong)NSString *type_name;
@property (nonatomic , strong)NSString *complete_at;
@property (nonatomic , strong)NSString *labor_cost;
//@property (nonatomic , strong)NSArray *completeImg;
@property (nonatomic , strong)NSString *order_total_time;
@property (nonatomic , strong)NSString *material_cost;
@property (nonatomic , strong)NSString *address;
@property (nonatomic , strong)NSString *username;

@end
