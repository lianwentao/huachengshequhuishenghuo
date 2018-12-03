//
//  SubTableView.h
//  NestedTable
//
//  Created by LOLITA on 2017/9/19.
//  Copyright © 2017年 LOLITA0164. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "LolitaTableView.h"
#define getRandomNumberFromAtoB(A,B) (int)(A+(arc4random()%(B-A+1)))

@interface SubTableView : UIView <UITableViewDelegate,UITableViewDataSource>

@property (strong ,nonatomic) LolitaTableView *table;
@property (copy,nonatomic)NSString *num;//判断第几个子view
@property (nonatomic,strong)NSArray *cateArr;
@end
