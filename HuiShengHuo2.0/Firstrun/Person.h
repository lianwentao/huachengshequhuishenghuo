//
//  Person.h
//  YUChineseSorting
//
//  Created by LZW on 16/2/18.
//  Copyright © 2016年 BruceYu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (strong , nonatomic) NSString * name;
@property (assign , nonatomic) NSInteger number;
@property (strong , nonatomic)NSString * city_id;
@property (strong , nonatomic)NSString * id;
@property (strong , nonatomic)NSString * region_id;
@property (nonatomic,copy)NSString *company_id;
@property (nonatomic,copy)NSString *company_name;
@property (nonatomic,copy)NSString *department_id;
@property (nonatomic,copy)NSString *department_name;
@property (nonatomic,copy)NSString *is_new;
@end
