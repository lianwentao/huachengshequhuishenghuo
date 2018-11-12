//
//  youxianjiaofeiTableViewCell.h
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/6/14.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "youxianjiaofeimodel.h"
@interface youxianjiaofeiTableViewCell : UITableViewCell

@property (nonatomic,strong)youxianjiaofeimodel *model;

@property (nonatomic,strong)UILabel *addtimelabel;
@property (nonatomic,strong)UILabel *amountlabel;
@property (nonatomic,strong)UILabel *biaohaolabel;
@property (nonatomic,strong)UILabel *paytypelabel;
@property (nonatomic,strong)UILabel *kahaolabel;
@property (nonatomic,strong)UILabel *fullnamelabel;
@property (nonatomic,strong)UILabel *stauslabel;
@property (nonatomic,strong)UILabel *uptimelabel;
@end
