//
//  liebiaomodel.h
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/5/30.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface liebiaomodel : NSObject

@property (nonatomic,copy)NSString *imagestring;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,strong)NSArray *tagArr;
@property (nonatomic,copy)NSString *nowprice;
@property (nonatomic,copy)NSString *yuanprice;
@property (nonatomic,copy)NSString *yishou;
@property (nonatomic,copy)NSString *unit;
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *tagname;
@property (nonatomic,copy)NSString *title_img;
@property (nonatomic,copy)NSString *tagid;

@property (nonatomic,copy)NSString *is_start;
@property (nonatomic,copy)NSString *is_hot;
@property (nonatomic,copy)NSString *is_new;
@property (nonatomic,copy)NSString *kucun;
@property (nonatomic,copy)NSString *is_time;
@property (nonatomic,copy)NSString *exihours;
@property (nonatomic,copy)NSString *biaoshi;//标识是否为限时抢购

@end
