//
//  orderDetailModel.h
//  HuiShengHuo2.0
//
//  Created by admin on 2018/12/17.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "JSONModel.h"

@interface orderDetailModel : JSONModel
@property (nonatomic , strong)NSString *address;
@property (nonatomic , strong)NSString *complete_content;
@property (nonatomic , strong)NSString *content;
@property (nonatomic , strong)NSString *degree;
@property (nonatomic , strong)NSString *distribute_at;
@property (nonatomic , strong)NSString *entry_fee;
@property (nonatomic , strong)NSString *id;

@property (nonatomic , strong)NSString *labor_cost;
@property (nonatomic , strong)NSString *material_cost;
@property (nonatomic , strong)NSString *order_number;
@property (nonatomic , strong)NSString *order_time;
@property (nonatomic , strong)NSString *order_total_time;
@property (nonatomic , strong)NSString *prepay_is_pay;
@property (nonatomic , strong)NSString *release_at;

@property (nonatomic , strong)NSString *send_at;
@property (nonatomic , strong)NSString *send_content;
@property (nonatomic , strong)NSString *total_fee;
@property (nonatomic , strong)NSString *total_fee_at;

@property (nonatomic , strong)NSString *total_fee_content;
@property (nonatomic , strong)NSString *type_name;
@property (nonatomic , strong)NSString *username;
@property (nonatomic , strong)NSString *userphone;
@property (nonatomic , strong)NSString *work_status;
@property (nonatomic , strong)NSString *work_type;
//@property (nonatomic , strong)NSString *score;
@property (nonatomic , strong)NSArray *repairImg;//报修图片
@property (nonatomic , strong)NSArray *distributeUser;//派单人信息
@property (nonatomic , strong)NSArray *completeImg;//师傅完成提交图片

@end
