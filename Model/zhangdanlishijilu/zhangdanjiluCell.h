//
//  zhangdanjiluCell.h
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/3/23.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "fukuanjilumodel.h"

@interface zhangdanjiluCell : UITableViewCell

@property (nonatomic,strong)fukuanjilumodel *model;

@property (nonatomic,strong)UILabel *TimeLabel;
@property (nonatomic,strong)UILabel *PriceLabel;
@property (nonatomic,strong)UILabel *bianhaoLabel;
@property (nonatomic,strong)UILabel *NameLabel;

@end
