//
//  shangjialevelListview.h
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/12/8.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol shangjialevelListviewDelegate <NSObject>

-(void)selectedButton:(BOOL)isLeftButton;

@end
@interface shangjialevelListview : UIView

@property(nonatomic, strong)UIButton *leftButton;
@property(nonatomic, strong)UIButton *rightButton;
@property(nonatomic, weak)id<shangjialevelListviewDelegate>delegate;
@property(nonatomic, assign)NSInteger selectedIndex;
-(void)changeLineViewOffsetX:(CGFloat)offsetX;
@end
