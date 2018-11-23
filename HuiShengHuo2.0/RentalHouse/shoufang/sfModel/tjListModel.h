//
//  tjListModel.h
//  HuiShengHuo2.0
//
//  Created by admin on 2018/11/19.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "JSONModel.h"

@interface tjListModel : JSONModel
@property (nonatomic ,strong)NSString *id;
@property (nonatomic ,strong)NSString *total_price;
@property (nonatomic ,strong)NSArray *label;
@property (nonatomic ,strong)NSString *house_floor;
@property (nonatomic ,strong)NSString *kitchen;
@property (nonatomic ,strong)NSString *guard;
@property (nonatomic ,strong)NSString *head_img;
@property (nonatomic ,strong)NSString *area;
@property (nonatomic ,strong)NSString *unit_price;
@property (nonatomic ,strong)NSString *office;
@property (nonatomic ,strong)NSString *community_name;
@property (nonatomic ,strong)NSString *room;
@property (nonatomic ,strong)NSString *label_id;
@property (nonatomic ,strong)NSString *house_type;
@property (nonatomic ,strong)NSString *floor;
@property (nonatomic ,strong)NSString *status;
@end
