//
//  newFwDetailModel.h
//  HuiShengHuo2.0
//
//  Created by admin on 2018/12/1.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "JSONModel.h"

@interface newFwDetailModel : JSONModel
@property (nonatomic ,strong)NSDictionary *ins_info;
@property (nonatomic ,strong)NSString *title;
@property (nonatomic ,strong)NSArray *img_list;
@property (nonatomic ,strong)NSArray *tag_list;
@property (nonatomic ,strong)NSString *title_img;
@end
