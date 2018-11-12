//
//  AdressViewController.h
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/11/30.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReturnString) (NSString *phone,NSString *name,NSString *address,NSString *addressid);
@interface AdressViewController : UIViewController

@property (nonatomic,strong) NSString *yesnoselecte;
@property(nonatomic, copy) ReturnString returnValueBlock;
@end
