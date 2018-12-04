//
//  tagListModel.h
//  HuiShengHuo2.0
//
//  Created by admin on 2018/11/30.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "JSONModel.h"

@interface tagListModel : JSONModel
@property (nonatomic ,strong)NSString *s_id;
@property (nonatomic ,strong)NSString *id;
@property (nonatomic ,strong)NSString *original;
@property (nonatomic ,strong)NSString *price;
@property (nonatomic ,strong)NSString *tagname;
@end
