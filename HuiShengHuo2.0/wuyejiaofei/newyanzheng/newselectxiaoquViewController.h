//
//  newselectxiaoquViewController.h
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/12/25.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ReturnString) (NSString *c_id,NSString *xiaoqu);
@interface newselectxiaoquViewController : UIViewController
@property(nonatomic, copy) ReturnString returnValueBlock;
@end