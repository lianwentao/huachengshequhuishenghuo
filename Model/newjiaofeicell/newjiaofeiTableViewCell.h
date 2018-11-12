//
//  newjiaofeiTableViewCell.h
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/9/4.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "newjiaofeimodel.h"

@interface newjiaofeiTableViewCell : UITableViewCell

@property (nonatomic,strong)newjiaofeimodel *model;

@property (nonatomic,strong)UILabel *TimeLabel;
@property (nonatomic,strong)UILabel *namelabel;
@property (nonatomic,strong)UILabel *addresslabel;
@property (nonatomic,strong)UILabel *zhangdanhaolabel;
@end
