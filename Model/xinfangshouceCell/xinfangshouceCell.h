//
//  xinfangshouceCell.h
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/3/27.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "xinfangshoucemolde.h"

@interface xinfangshouceCell : UITableViewCell

@property (nonatomic,strong)xinfangshoucemolde *model;

@property (nonatomic,strong)UIImageView *imageview;
@property (nonatomic,strong)UILabel *content;
@end
