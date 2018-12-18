//
//  gongdanadressViewController.h
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/12/18.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface gongdanadressViewController : UIViewController
typedef void(^ReturnString) (NSDictionary *datadic);

@property(nonatomic, copy) ReturnString returnValueBlock;
@end
