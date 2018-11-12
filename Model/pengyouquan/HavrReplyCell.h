//
//  HavrReplyCell.h
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/3/21.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pengyouquanmodel.h"
#import "XLPhotoBrowser.h"
#import "UIView+XLExtension.h"
@interface HavrReplyCell : UITableViewCell<XLPhotoBrowserDelegate,XLPhotoBrowserDatasource>

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

@property (nonatomic,strong)UILabel *replynumber;
@property (nonatomic,strong)UILabel *replyname;
@property (nonatomic,strong)UILabel *replycontent;
@property (nonatomic,strong)UILabel *replytime;

@property(nonatomic ,strong)UIImageView *replyimageview;
@end
