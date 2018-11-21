//
//  newjiaofeiTableViewCell.h
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/9/4.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "newjiaofeimodel.h"

@interface newjiaofeiTableViewCell : UITableViewCell <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *TableView;

@property (nonatomic,strong)newjiaofeimodel *model;

@property (nonatomic,strong)NSArray *wuyearr;
@property (nonatomic,strong)UILabel *TimeLabel;
@property (nonatomic,strong)UILabel *namelabel;
@property (nonatomic,strong)UILabel *addresslabel;
@property (nonatomic,strong)UILabel *zhangdanhaolabel;
@property (nonatomic,strong)UILabel *sumvaluelabel;
@end
