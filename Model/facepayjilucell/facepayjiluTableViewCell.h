//
//  facepayjiluTableViewCell.h
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/3/30.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "facepaymodel.h"

@interface facepayjiluTableViewCell : UITableViewCell


@property (nonatomic,strong)facepaymodel *model;

@property (nonatomic,strong)UILabel *TimeLabel;
@property (nonatomic,strong)UILabel *PriceLabel;
@property (nonatomic,strong)UILabel *bianhaoLabel;
@property (nonatomic,strong)UILabel *NameLabel;
@property (nonatomic,strong)UILabel *houselabel;
@property (nonatomic,strong)UILabel *noticelabel;
@property (nonatomic,strong)UILabel *m_namelabel;
@end
