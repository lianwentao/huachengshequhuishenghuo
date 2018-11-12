//
//  CSXGamebordView.m
//  Game2048
//
//  Created by CSX on 2017/1/12.
//  Copyright © 2017年 宗盛商业. All rights reserved.
//

#import "CSXGamebordView.h"
#import "CSXTitleView.h"
#import "CSXGameModel.h"


typedef enum :NSInteger{
    cellLabelTags = 10,
}tags;


@interface CSXGamebordView ()<UIAlertViewDelegate>
{
    int _demen;
    int _totalNumber;
    CGFloat _thinPadding;
    CGFloat _viewPadding;
    CGFloat _verticalViewOffset;
    
    CGFloat _widthHeight;
    
    //数据处理
    CSXGameModel *model;
    
    UILabel *scoreLabel;
    
    int a;
    
}
@property(strong,nonatomic)NSMutableArray *dataArr;
@end


@implementation CSXGamebordView

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (instancetype)initWithFrame:(CGRect)frame andContent:(int)demension{
    self = [super initWithFrame:frame];
    if (self) {
        _thinPadding = 3.0;//游戏区里面小块间的间距
        _viewPadding = 10.0;//计分板和游戏区块的间距
        _verticalViewOffset = 0.0;
        
        _widthHeight = frame.size.width;
        
        _totalNumber = demension*demension;
        _demen = demension;

        [self createView];
        
        a = 0;
        model = [[CSXGameModel alloc]init];
        model.demn = _demen;
        [model addNumberWithBlock:^(int addNumber) {
            a = a+addNumber;
            dispatch_async(dispatch_get_main_queue(), ^{
               scoreLabel.text = [NSString stringWithFormat:@"分数：%d",a];
            });

        }];
        
    }
    return self;
}


- (void)createView{
    
    for (int i = 0; i<_totalNumber; i++) {
        UIView *cellView = [[UIView alloc]init];
        cellView.center = CGPointMake(((_widthHeight-(_demen+1)*_thinPadding)/_demen+_thinPadding)*(i%_demen)+((_widthHeight-(_demen+1)*_thinPadding)/_demen/2+_thinPadding), ((_widthHeight-(_demen+1)*_thinPadding)/_demen+_thinPadding)*(i/_demen)+((_widthHeight-(_demen+1)*_thinPadding)/_demen/2+_thinPadding));
        cellView.bounds = CGRectMake(0, 0, (_widthHeight-(_demen+1)*_thinPadding)/_demen, (_widthHeight-(_demen+1)*_thinPadding)/_demen);
        cellView.layer.cornerRadius = 5;
//        cellView.tag = cellLabelTags+i;
        cellView.clipsToBounds = YES;
        cellView.backgroundColor = [UIColor colorWithRed:197/255.0 green:195/255.0 blue:179/255.0 alpha:1];
        [self addSubview:cellView];
        
        CSXTitleView *title = [[CSXTitleView alloc]initWithFrame:cellView.frame];
        title.tag = cellLabelTags+i;
        [self addSubview:title];
    }
    
    scoreLabel = [[UILabel alloc]init];
    scoreLabel.center = CGPointMake(self.frame.size.width/2, -60);
    scoreLabel.bounds = CGRectMake(0, 0, 200, 40);
    scoreLabel.backgroundColor = [UIColor redColor];
    scoreLabel.textAlignment = 1;
    [self addSubview:scoreLabel];
    
    [self getInitialize];
    
    
}
- (void)getInitialize{
    [self.dataArr removeAllObjects];
    scoreLabel.text = @"分数：0";
    int begainA = arc4random()%_totalNumber;
    int begainB = arc4random()%_totalNumber;
    if (begainA == begainB) {
        begainB = (begainA+1)%_totalNumber;
    }
    
    for (int i = 0; i<_totalNumber; i++) {
        if (i == begainA||i == begainB) {
            [self.dataArr addObject:[NSNumber numberWithInt:2*(arc4random()%2+1)]];
        }else{
            [self.dataArr addObject:@1];
        }
    }
    [self getTitle];
}


- (void)getTitle{
    for (int i = 0; i<self.dataArr.count; i++) {
        CSXTitleView *title = [self viewWithTag:cellLabelTags+i];
        [title getTitleChooseWithNewData:self.dataArr[i]];
    }
    
}

- (void)getChangeWithDirection:(int)direct{
    
    switch (direct) {
        case 1:
        {
            self.dataArr = [model getRightAdjustForNewQueueWithArr:self.dataArr];
            if (![model getJudgeWithArr:self.dataArr]) {
                [self getAlertWorning];
            }
            [self getTitle];
            
            NSLog(@"向右");
            
        }
            break;
        case 2:
        {
            
            self.dataArr = [model getLeftAdjustForNewQueueWithArr:self.dataArr];
            if (![model getJudgeWithArr:self.dataArr]) {
                [self getAlertWorning];
            }
            [self getTitle];
            
            NSLog(@"向左");
            
        }
            break;
        case 4:
        {
            self.dataArr = [model getUpAdjustForNewQueueWithArr:self.dataArr];
            if (![model getJudgeWithArr:self.dataArr]) {
                [self getAlertWorning];
            }
            [self getTitle];
            NSLog(@"向上");
            
        }
            break;
        case 8:
        {
            self.dataArr = [model getDownAdjustForNewQueueWithArr:self.dataArr];
            if (![model getJudgeWithArr:self.dataArr]) {
                [self getAlertWorning];
            }
            [self getTitle];
            NSLog(@"向下");
            
        }
            break;
            
        default:
            break;
    }
    
}

- (void)getAlertWorning{
    
    UIAlertView *alet = [[UIAlertView alloc]initWithTitle:@"提示" message:@"失败" delegate:self cancelButtonTitle:@"再来一局" otherButtonTitles:@"知道了", nil];
    [alet show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //数据初始化
        [self getInitialize];
        
    }else{
        //
        
    }
}













/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
