//
//  fwListModel.h
//  HuiShengHuo2.0
//
//  Created by admin on 2018/11/30.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "JSONModel.h"

@interface fwListModel : JSONModel
@property (nonatomic ,strong)NSString *id;
@property (nonatomic ,strong)NSString *title_img;
@property (nonatomic ,strong)NSString *title;
@property (nonatomic ,strong)NSString *price;
@end
