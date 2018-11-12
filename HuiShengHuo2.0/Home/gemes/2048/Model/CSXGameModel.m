//
//  CSXGameModel.m
//  Game2048
//
//  Created by CSX on 2017/1/12.
//  Copyright © 2017年 宗盛商业. All rights reserved.
//

#import "CSXGameModel.h"


@interface CSXGameModel ()

@property(strong,nonatomic)NSMutableArray *firstArr;
@property(strong,nonatomic)NSMutableArray *secondArr;
@property(strong,nonatomic)NSMutableArray *thirdArr;
@property(strong,nonatomic)NSMutableArray *fourArr;

@end


@implementation CSXGameModel




- (NSMutableArray *)firstArr{
    if (!_firstArr) {
        _firstArr = [NSMutableArray array];
    }
    return _firstArr;
}
- (NSMutableArray *)secondArr{
    if (!_secondArr) {
        _secondArr = [NSMutableArray array];
    }
    return _secondArr;
}
- (NSMutableArray *)thirdArr{
    if (!_thirdArr) {
        _thirdArr = [NSMutableArray array];
    }
    return _thirdArr;
}
- (NSMutableArray *)fourArr{
    if (!_fourArr) {
        _fourArr = [NSMutableArray array];
    }
    return _fourArr;
}




- (NSMutableArray *)getRightAdjustForNewQueueWithArr:(NSMutableArray *)oldArr{
    [self getInitDataArr];
    NSMutableArray *arr = [NSMutableArray array];
    
    for (int i = 0; i<oldArr.count; i++) {
        if (i/self.demn == 0) {
            [self.firstArr addObject:oldArr[i]];
        }else if (i/self.demn == 1){
            [self.secondArr addObject:oldArr[i]];
        }else if (i/self.demn == 2){
            [self.thirdArr addObject:oldArr[i]];
        }else if (i/self.demn == 3){
            [self.fourArr addObject:oldArr[i]];
        }
    }
    NSMutableArray *changeFirstArr = [self rankWithDataArr:self.firstArr];
    NSMutableArray *changeSecondArr = [self rankWithDataArr:self.secondArr];
    NSMutableArray *changeThirdArr = [self rankWithDataArr:self.thirdArr];
    NSMutableArray *changeFourArr = [self rankWithDataArr:self.fourArr];
    
    [arr addObjectsFromArray:changeFirstArr];
    [arr addObjectsFromArray:changeSecondArr];
    [arr addObjectsFromArray:changeThirdArr];
    [arr addObjectsFromArray:changeFourArr];
    
    NSMutableArray *resultArr = [self getNewArrWithOldArr:arr];
    
    return resultArr;
}

- (NSMutableArray *)getLeftAdjustForNewQueueWithArr:(NSMutableArray *)oldArr{
    [self getInitDataArr];
    NSMutableArray *arr = [NSMutableArray array];
    
    for (int i = 0; i<oldArr.count; i++) {
        if (i/self.demn == 0) {
            [self.firstArr insertObject:oldArr[i] atIndex:0];
        }else if (i/self.demn == 1){
            [self.secondArr insertObject:oldArr[i] atIndex:0];
        }else if (i/self.demn == 2){
            [self.thirdArr insertObject:oldArr[i] atIndex:0];
        }else if (i/self.demn == 3){
            [self.fourArr insertObject:oldArr[i] atIndex:0];
        }
    }
    
    NSMutableArray *changeFirstArr = [self rankWithDataArr:self.firstArr];
    NSMutableArray *changeSecondArr = [self rankWithDataArr:self.secondArr];
    NSMutableArray *changeThirdArr = [self rankWithDataArr:self.thirdArr];
    NSMutableArray *changeFourArr = [self rankWithDataArr:self.fourArr];
    
    [arr addObjectsFromArray:[self rollbackWithArr:changeFirstArr]];
    [arr addObjectsFromArray:[self rollbackWithArr:changeSecondArr]];
    [arr addObjectsFromArray:[self rollbackWithArr:changeThirdArr]];
    [arr addObjectsFromArray:[self rollbackWithArr:changeFourArr]];
    NSMutableArray *resultArr = [self getNewArrWithOldArr:arr];
    
    return resultArr;
}

- (NSMutableArray *)getUpAdjustForNewQueueWithArr:(NSMutableArray *)oldArr{
    [self getInitDataArr];
    NSMutableArray *arr = [NSMutableArray array];
    
    for (int i = 0; i<oldArr.count; i++) {
        
        if (i%self.demn == 0) {
            [self.firstArr insertObject:oldArr[i] atIndex:0];
        }else if (i%self.demn == 1){
            [self.secondArr insertObject:oldArr[i] atIndex:0];
        }else if (i%self.demn == 2){
            [self.thirdArr insertObject:oldArr[i] atIndex:0];
        }else if (i%self.demn == 3){
            [self.fourArr insertObject:oldArr[i] atIndex:0];
        }
        
    }
    
    NSMutableArray *changeFirstArr = [self rankWithDataArr:self.firstArr];
    NSMutableArray *changeSecondArr = [self rankWithDataArr:self.secondArr];
    NSMutableArray *changeThirdArr = [self rankWithDataArr:self.thirdArr];
    NSMutableArray *changeFourArr = [self rankWithDataArr:self.fourArr];
    
    NSMutableArray *rollbackFirst = [self rollbackWithArr:changeFirstArr];
    NSMutableArray *rollbackSecond = [self rollbackWithArr:changeSecondArr];
    NSMutableArray *rollbackThird = [self rollbackWithArr:changeThirdArr];
    NSMutableArray *rollbackFour = [self rollbackWithArr:changeFourArr];
    
    for (int i = 0; i<self.demn; i++) {
        [arr addObject:rollbackFirst[i]];
        [arr addObject:rollbackSecond[i]];
        [arr addObject:rollbackThird[i]];
        [arr addObject:rollbackFour[i]];
    }
    NSMutableArray *resultArr = [self getNewArrWithOldArr:arr];
    
    return resultArr;

    
}

- (NSMutableArray *)getDownAdjustForNewQueueWithArr:(NSMutableArray *)oldArr{
    
    [self getInitDataArr];
    NSMutableArray *dataArr = [NSMutableArray array];
    
    for (int i = 0; i<oldArr.count; i++) {
        if (i%self.demn == 0) {
            [self.firstArr addObject:oldArr[i]];
        }else if (i%self.demn == 1){
            [self.secondArr addObject:oldArr[i]];
        }else if (i%self.demn == 2){
            [self.thirdArr addObject:oldArr[i]];
        }else if (i%self.demn == 3){
            [self.fourArr addObject:oldArr[i]];
        }
    }
    
    NSMutableArray *changeFirstArr = [self rankWithDataArr:self.firstArr];
    NSMutableArray *changeSecondArr = [self rankWithDataArr:self.secondArr];
    NSMutableArray *changeThirdArr = [self rankWithDataArr:self.thirdArr];
    NSMutableArray *changeFourArr = [self rankWithDataArr:self.fourArr];
    
    for (int i = 0; i<self.demn; i++) {
        [dataArr addObject:changeFirstArr[i]];
        [dataArr addObject:changeSecondArr[i]];
        [dataArr addObject:changeThirdArr[i]];
        [dataArr addObject:changeFourArr[i]];
    }
    
    NSMutableArray *resultArr = [self getNewArrWithOldArr:dataArr];
    
    return resultArr;
    
}


//反向左右数组元素
- (NSMutableArray *)rollbackWithArr:(NSMutableArray *)oldArr{
    
    NSMutableArray *arr = [NSMutableArray array];
    
    for (int i = 0; i<oldArr.count; i++) {
        [arr addObject:oldArr[oldArr.count-1-i]];
    }
    
    return arr;
    
}


//算法(从后面算起)
- (NSMutableArray *)rankWithDataArr:(NSMutableArray *)oldArr{
   static NSUInteger nowTime ;
    nowTime = oldArr.count-1;
    
    for (int i = 0; i<oldArr.count; i++) {
        
        if ([oldArr[oldArr.count-1-i] isEqual:@1]) {
            
            continue;
            
        }else{
            //为移动做准备

            NSNumber *nowNum = oldArr[oldArr.count-1-i];
            [oldArr replaceObjectAtIndex:nowTime withObject:nowNum];
            if (nowTime != oldArr.count-1-i) {
                [oldArr replaceObjectAtIndex:oldArr.count-1-i withObject:@1];
            }
            
            if (nowTime < oldArr.count-1) {
                if ([oldArr[nowTime] isEqual:oldArr[nowTime+1]]) {
                    [oldArr replaceObjectAtIndex:nowTime+1 withObject:[NSNumber numberWithInt:2*[oldArr[nowTime] intValue]]];
                    self.addNumBlock(2*[oldArr[nowTime] intValue]);
                    [oldArr replaceObjectAtIndex:nowTime withObject:@1];
                    
                }else{
                    nowTime--;
                }
            }else{
                nowTime--;
            }
            
        }
        
    }
    
    return oldArr;
}



- (void)addNumberWithBlock:(ReturnBlock)block{
    self.addNumBlock = block;
}



//初始化数据存储
- (void)getInitDataArr{
    [self.firstArr removeAllObjects];
    [self.secondArr removeAllObjects];
    [self.thirdArr removeAllObjects];
    [self.fourArr removeAllObjects];
}


//NO 标示失败，弹出警告框
- (BOOL)getJudgeWithArr:(NSMutableArray *)arr{
    int a = 0;
   
    for (NSNumber *tempNumber in arr) {
        if ([tempNumber isEqual:@1]) {
            a++;
        }
    }
    if (a == 0) {
        //计算是否有相同的
        for (int i = 0; i<arr.count; i++) {
            
            if ([self isequalForGound:arr andWeiZhi:i]) {
                return YES;
//                break;
            }
        }
    }else{
        //有空余的地方不报错
        return YES;
    }
    return NO;
}

- (BOOL)isequalForGound:(NSMutableArray *)arr andWeiZhi:(int)set{
    
    if (set/self.demn == 0) {
        //首行
        if (set%self.demn == 0) {
            if ([self iseQualWithRightWithArr:arr andIndex:set]) {
                return YES;
            }
        }else if (set%self.demn == self.demn-1){
            if ([self iseQualWithLeftWithArr:arr andIndex:set]) {
                return YES;
            }
            
        }else{
            if ([self iseQualWithRightWithArr:arr andIndex:set]) {
                return YES;
            }
            if ([self iseQualWithLeftWithArr:arr andIndex:set]) {
                return YES;
            }
        }
        if ([self iseQualWithDownWithArr:arr andIndex:set]) {
            return YES;
        }
        
    }else if (set/self.demn == self.demn-1){
        if (set%self.demn == 0) {
            if ([self iseQualWithRightWithArr:arr andIndex:set]) {
                return YES;
            }
        }else if (set%self.demn == self.demn-1){
            if ([self iseQualWithLeftWithArr:arr andIndex:set]) {
                return YES;
            }
            
        }else{
            if ([self iseQualWithRightWithArr:arr andIndex:set]) {
                return YES;
            }
            
            if ([self iseQualWithLeftWithArr:arr andIndex:set]) {
                return YES;
            }
        }
        
        if ([self iseQualWithTopWithArr:arr andIndex:set]) {
            return YES;
        }
        
    }else{
        
        if (set%self.demn == 0) {
            if ([self iseQualWithRightWithArr:arr andIndex:set]) {
                return YES;
            }
        }else if (set%self.demn == self.demn-1){
            if ([self iseQualWithLeftWithArr:arr andIndex:set]) {
                return YES;
            }
        }else{
            if ([self iseQualWithLeftWithArr:arr andIndex:set]) {
                return YES;
            }
            if ([self iseQualWithRightWithArr:arr andIndex:set]) {
                return YES;
            }
        }
        
        if ([self iseQualWithTopWithArr:arr andIndex:set]) {
            return YES;
        }
        if ([self iseQualWithDownWithArr:arr andIndex:set]) {
            return YES;
        }
    }
    
    return NO;
}
- (BOOL)iseQualWithLeftWithArr:(NSMutableArray *)arr andIndex:(int)index{
    BOOL isequal = false;
    if ([arr[index-1] isEqual:arr[index]]) {
        isequal = true;
    }
    return isequal;
}
- (BOOL)iseQualWithRightWithArr:(NSMutableArray *)arr andIndex:(int)index{
    BOOL isequal = false;
    
    if ([arr[index+1] isEqual:arr[index]]) {
        isequal = true;
    }
    
    return isequal;
}
- (BOOL)iseQualWithTopWithArr:(NSMutableArray *)arr andIndex:(int)index{
    BOOL isequal = false;
    
    if ([arr[index-self.demn] isEqual:arr[index]]) {
        isequal = true;
    }
    
    return isequal;
}
- (BOOL)iseQualWithDownWithArr:(NSMutableArray *)arr andIndex:(int)index{
    BOOL isequal = false;
    
    if ([arr[index+self.demn] isEqual:arr[index]]) {
        isequal = true;
    }
    
    return isequal;
}





#pragma 随机位置生成随机数
- (NSMutableArray *)getNewArrWithOldArr:(NSMutableArray *)oldArr{
    
    NSMutableArray *tempArr = [NSMutableArray array];
    for (int i = 0; i<oldArr.count; i++) {
        NSNumber *tempNum = oldArr[i];
        if ([tempNum isEqual:@1]) {
            [tempArr addObject:[NSNumber numberWithInt:i]];
        }
    }
    if (tempArr.count>0) {
        int a = [tempArr[arc4random()%tempArr.count] intValue];
        [oldArr replaceObjectAtIndex:a withObject:[self getSuiJi]];
    }
    
    
    return oldArr;
}

- (NSNumber *)getSuiJi{
    NSNumber *ret;
    int a = arc4random()%10;
    if (a == 9) {
        ret = [NSNumber numberWithInt:4];
    }else{
        ret = [NSNumber numberWithInt:2];
    }
    return ret;
}





@end
