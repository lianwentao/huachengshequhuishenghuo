//
//  liebiaoTableViewCell.h
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/5/30.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "liebiaomodel.h"
@interface liebiaoTableViewCell : UITableViewCell

@property (nonatomic,strong)liebiaomodel *model;

@property (nonatomic,strong)UIImageView *imageview;
@property (nonatomic,strong)UIImageView *is_hotnewimage;
@property (nonatomic,strong)UILabel *maiwanlemelabel;
@property (nonatomic,strong)UILabel *titlelabel;
@property (nonatomic,strong)UIView *tagview;
@property (nonatomic,strong)UILabel *pricelabel;
@property (nonatomic,strong)UILabel *yuanpricelabel;
@property (nonatomic,strong)UILabel *yishoulabel;

@property (nonatomic,strong)NSDictionary *dic;
@property (nonatomic,strong)UIButton *button;

@end
