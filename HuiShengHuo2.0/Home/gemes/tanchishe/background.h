//
//  head.h
//  snake1
//
//  Created by 张 on 2017/6/19.
//  Copyright © 2017年 tx. All rights reserved.
//

#define bounds [UIscreen mainScreen].bounds;

#import <UIKit/UIKit.h>
typedef NS_ENUM(int, SnakeDirection) {
    SnakeDirectionNone,
    SnakeDirectionLeft,
    SnakeDirectionup,
    SnakeDirectionRight,
    
};

@interface background : UIView

@property (nonatomic,assign)CGPoint  headpoint;
@property (nonatomic,strong)NSMutableArray * points;
@property (nonatomic,assign)NSInteger  bodyLength;
@property (nonatomic,assign)SnakeDirection  Direction;
@property (nonatomic,strong)NSMutableArray * foods;
//蛇身颜色
@property (nonatomic,weak)UIColor *color;



-(void)moveWithDirection:(SnakeDirection)direction;

@end
