//
//  CSXGameModel.h
//  Game2048
//
//  Created by CSX on 2017/1/12.
//  Copyright © 2017年 宗盛商业. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ReturnBlock)(int addNumber);

@interface CSXGameModel : NSObject

@property(copy,nonatomic)ReturnBlock addNumBlock;

@property(assign,nonatomic)int demn;


- (void)addNumberWithBlock:(ReturnBlock)block;



- (NSMutableArray *)getRightAdjustForNewQueueWithArr:(NSMutableArray *)oldArr;

- (NSMutableArray *)getLeftAdjustForNewQueueWithArr:(NSMutableArray *)oldArr;

- (NSMutableArray *)getUpAdjustForNewQueueWithArr:(NSMutableArray *)oldArr;

- (NSMutableArray *)getDownAdjustForNewQueueWithArr:(NSMutableArray *)oldArr;


//判断是否失败
- (BOOL)getJudgeWithArr:(NSMutableArray *)arr;




@end
