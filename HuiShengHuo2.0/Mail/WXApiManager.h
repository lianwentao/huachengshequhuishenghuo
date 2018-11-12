//
//  WXApiManager.h
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/11/27.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

@interface WXApiManager : NSObject<WXApiDelegate>

+ (instancetype)sharedManager;

@end
