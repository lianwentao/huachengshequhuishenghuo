//
//  newsuerViewController.h
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/9/5.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface newsuerViewController : UIViewController

@property (nonatomic,copy)NSString *ordid;
@property (nonatomic,copy)NSString *ordnum;
@property (nonatomic,copy)NSString *timevavle;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *address;
@property (nonatomic,copy)NSString *samount;
@property (nonatomic,copy)NSString *type;

@property (nonatomic,copy)NSString *biaoshi;//标识是物业费还是水电费,1标识物业费，2水电费

@property (nonatomic,strong)NSDictionary *DataDic;
@property (nonatomic,strong)NSArray *listArr;
@end
