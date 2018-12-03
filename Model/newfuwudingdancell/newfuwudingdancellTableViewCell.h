//
//  newfuwudingdancellTableViewCell.h
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/11/26.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "newfuwudingdanmodel.h"
@interface newfuwudingdancellTableViewCell : UITableViewCell

@property (nonatomic,strong)newfuwudingdanmodel *model;

@property(nonatomic,strong)UILabel *namelabel;
@property(nonatomic,strong)UILabel *addresslabel;
@property(nonatomic,strong)UILabel *beizhulabel;
@property(nonatomic,strong)UIImageView *imageview;
@property(nonatomic,strong)UILabel *statuslabel;
@property(nonatomic,strong)UIImageView *statusimg;

@property (nonatomic,strong)UIButton *statusbut;
@end
