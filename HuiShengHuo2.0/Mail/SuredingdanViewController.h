//
//  SuredingdanViewController.h
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/11/27.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuredingdanViewController : UIViewController

@property (nonatomic,strong)NSDictionary *Dic;
@property (nonatomic,copy)NSString *jsonstring;

- (BOOL)navigationShouldPopOnBackButton;
@end
