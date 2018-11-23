//
//  KMTagListView.h
//  HuiShengHuo2.0
//
//  Created by admin on 2018/11/16.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KMTagListView;
@protocol KMTagListViewDelegate<NSObject>

- (void)ptl_TagListView:(KMTagListView*)tagListView didSelectTagViewAtIndex:(NSInteger)index selectContent:(NSString *)content;

@end

@interface KMTagListView : UIScrollView

@property (nonatomic, weak)id<KMTagListViewDelegate> delegate_;

- (void)setupSubViewsWithTitles:(NSArray *)titles;

@end
