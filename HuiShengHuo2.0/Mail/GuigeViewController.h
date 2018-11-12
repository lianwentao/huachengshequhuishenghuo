//
//  GuigeViewController.h
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/12/2.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import <UIKit/UIKit.h>
//typedef void (^ReturnValueBlock) (NSString *strValue);
typedef void(^ReturnString) (NSString *tagname,NSString *num,NSString *tagid,long limitnum,NSString *price);
@interface GuigeViewController : UIViewController
@property (nonatomic,strong)NSString *IDstring;
@property (nonatomic,strong)UIImage *image;
@property (nonatomic,strong)NSString *pricestring;
@property (nonatomic,strong)NSString *tagidstring;
@property (nonatomic,strong)NSString *cunkunstring;

@property (nonatomic,strong)NSString *tag;

@property(nonatomic, copy) ReturnString returnValueBlock;
@end
