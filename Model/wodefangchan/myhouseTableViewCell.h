//
//  myhouseTableViewCell.h
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/11/20.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myhousemodel.h"

@interface myhouseTableViewCell : UITableViewCell

@property (nonatomic,strong)myhousemodel *model;

@property(nonatomic,strong)UILabel *detailslabel;
@property(nonatomic,strong)UILabel *pricelabel;
@property(nonatomic,strong)UILabel *statuslabel;
@property(nonatomic,strong)UIImageView *imageview;
@end
