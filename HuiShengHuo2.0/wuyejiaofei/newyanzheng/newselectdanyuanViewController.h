//
//  newselectdanyuanViewController.h
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/12/25.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ReturnString) (NSString *c_id,NSString *xiaoqu,NSString *house_type);

@interface newselectdanyuanViewController : UIViewController
@property(nonatomic, strong) ReturnString returnValueBlock;

@property (nonatomic,copy)NSString *c_id;
@property (nonatomic,copy)NSString *buildid;
@end
