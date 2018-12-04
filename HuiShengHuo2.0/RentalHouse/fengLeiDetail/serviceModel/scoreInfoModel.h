//
//  scoreInfoModel.h
//  HuiShengHuo2.0
//
//  Created by admin on 2018/11/30.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "JSONModel.h"

@interface scoreInfoModel : JSONModel
@property (nonatomic ,strong)NSString *uid;
@property (nonatomic ,strong)NSString *s_id;
@property (nonatomic ,strong)NSString *id;
@property (nonatomic ,strong)NSString *score;
@property (nonatomic ,strong)NSString *anonymous;
@property (nonatomic ,strong)NSString *nickname;
@property (nonatomic ,strong)NSString *evaluatime;
@property (nonatomic ,strong)NSString *score_num;
@property (nonatomic ,strong)NSString *evaluate;
@property (nonatomic ,strong)NSString *avatars;
@end
