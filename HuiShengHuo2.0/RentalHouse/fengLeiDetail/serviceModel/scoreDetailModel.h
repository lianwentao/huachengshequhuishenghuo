//
//  scoreDetailModel.h
//  HuiShengHuo2.0
//
//  Created by admin on 2018/12/1.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "JSONModel.h"

@interface scoreDetailModel : JSONModel
@property (nonatomic ,strong)NSString *total_Pages;
@property (nonatomic ,strong)NSString *s_id;
@property (nonatomic ,strong)NSString *id;
@property (nonatomic ,strong)NSString *uid;
@property (nonatomic ,strong)NSString *score;
@property (nonatomic ,strong)NSString *anonymous;
@property (nonatomic ,strong)NSString *nickname;
@property (nonatomic ,strong)NSString *evaluatime;
@property (nonatomic ,strong)NSString *evaluate;
@property (nonatomic ,strong)NSString *avatars;
@end