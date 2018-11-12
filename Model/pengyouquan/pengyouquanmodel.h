//
//  pengyouquanmodel.h
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/3/17.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface pengyouquanmodel : NSObject


@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *content;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *touxiangurl;
@property (nonatomic,strong)NSArray *imageArr;

@property (nonatomic,strong)NSString *fabutime;
@property (nonatomic,strong)NSString *scan;
@property (nonatomic,strong)NSString *pinglun;
@property (nonatomic,strong)NSString *fenlei;

@property (nonatomic,strong)NSString *guanfang;

@property (nonatomic,strong)NSString *replynumber;
@property (nonatomic,strong)NSString *replyname;
@property (nonatomic,strong)NSString *replycontent;
@property (nonatomic,strong)NSString *replytime;
@property (nonatomic,strong)NSString *replytouxiangurl;
@property (nonatomic,strong)NSString *community_name;

@property (nonatomic,copy)NSString *uid;
@property (nonatomic,copy)NSString *social_id;
@property (nonatomic,copy)NSString *qufenwodelinli;//用来区分在我的邻里删除还是邻里里删除
@end
