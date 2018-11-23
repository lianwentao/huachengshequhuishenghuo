//
//  ZJTwoChildView.h
//  ZJUIKit
//
//  Created by dzj on 2017/12/8.
//  Copyright © 2017年 kapokcloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZJTwoChildViewDelegate <NSObject>

@optional

/**
 * 选中左边tableview cell 的回调

 @param index 索引
 */
-(void)twoViewTableviewDidSelectedWithIndex:(NSInteger)index;


@end

@interface ZJTwoChildView : UIView

@property(nonatomic ,strong) UITableView *mainTable;

@property(nonatomic ,strong) NSArray *titleArray;

@property(nonatomic ,weak) id<ZJTwoChildViewDelegate> delegate;

@end
