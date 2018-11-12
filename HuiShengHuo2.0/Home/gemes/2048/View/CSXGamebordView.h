//
//  CSXGamebordView.h
//  Game2048
//
//  Created by CSX on 2017/1/12.
//  Copyright © 2017年 宗盛商业. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSXGamebordView : UIView

- (instancetype)initWithFrame:(CGRect)frame andContent:(int)demension;


- (void)getChangeWithDirection:(int)direct;


@end
