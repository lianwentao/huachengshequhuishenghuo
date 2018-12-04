//
//  BaseView.h
//  HuiShengHuo2.0
//
//  Created by admin on 2018/11/26.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, assign)BOOL canScroll;
@property (nonatomic, strong)NSDictionary *info;

- (void)renderUIWithInfo:(NSDictionary *)info;

@end
