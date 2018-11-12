//
//  circleCell.h
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/3/17.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pengyouquanmodel.h"
#import "XLPhotoBrowser.h"
#import "UIView+XLExtension.h"
#import "AppDelegate.h"

@interface circleCell : UITableViewCell <XLPhotoBrowserDelegate,XLPhotoBrowserDatasource>

@property (nonatomic,strong) pengyouquanmodel * model;
@property(nonatomic ,strong)UIImageView *touxiangimageview;
@property (nonatomic,copy)UILabel *content;
@property (nonatomic,strong)UIImageView *contentimageview;
@property (nonatomic,strong)UILabel *name;

@property (nonatomic,strong)UIButton *deletebut;
@property (nonatomic,strong)UILabel *fabutime;
@property (nonatomic,strong)UILabel *scan;
@property (nonatomic,strong)UILabel *pinglun;
@property (nonatomic,strong)UILabel *fenlei;
@property (nonatomic,strong) NSMutableArray * imgArray;
@property (nonatomic,strong) NSMutableArray * groupImgArr;



@end
