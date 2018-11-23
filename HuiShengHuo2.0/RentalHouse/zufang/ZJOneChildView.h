//
//  ZJOneChildView.h
//  ZJUIKit
//
//  Created by dzj on 2017/12/7.
//  Copyright © 2017年 kapokcloud. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ZJOneChildViewDelegate <NSObject>

/**
 * 选中的cell 回调
 
 @param index 索引
 */
-(void)oneViewTableviewDidSelectedWithIndex:(NSInteger)index;

@end


@interface ZJOneChildView : UIView

@property(nonatomic ,strong) UITableView *mainTable;

@property(nonatomic ,strong) NSArray *titleArray;

@property(nonatomic ,weak) id<ZJOneChildViewDelegate> delegate;

@end
