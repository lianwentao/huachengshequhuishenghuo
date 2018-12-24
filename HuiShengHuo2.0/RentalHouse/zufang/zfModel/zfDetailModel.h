//
//  zfDetailModel.h
//  HuiShengHuo2.0
//
//  Created by admin on 2018/11/21.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "JSONModel.h"

@interface zfDetailModel : JSONModel
@property (nonatomic ,strong)NSArray *house_img;
@property (nonatomic ,strong)NSString *head_img;
@property (nonatomic ,strong)NSString *release_time;
@property (nonatomic ,strong)NSString *adminid;
@property (nonatomic ,strong)NSString *house_floor;

@property (nonatomic ,strong)NSString *check_in;
@property (nonatomic ,strong)NSString *pay_type;
@property (nonatomic ,strong)NSArray *label;
@property (nonatomic ,strong)NSString *name;
@property (nonatomic ,strong)NSString *office;

@property (nonatomic ,strong)NSString *phone;
@property (nonatomic ,strong)NSString *guard;
@property (nonatomic ,strong)NSString *unit_price;
//@property (nonatomic ,strong)NSArray *recommend;
@property (nonatomic ,strong)NSString *room;

@property (nonatomic ,strong)NSString *administrator_img;
@property (nonatomic ,strong)NSString *area;
@property (nonatomic ,strong)NSString *community_name;
@property (nonatomic ,strong)NSString *floor;
@property (nonatomic ,strong)NSString *kitchen;
@property (nonatomic ,strong)NSString *houseid;
@property (nonatomic ,strong)NSString *elevator;
@property (nonatomic ,strong)NSString *lease_term;
@end
