//
//  ZJChooseShowView.m
//  ZJUIKit
//
//  Created by dzj on 2017/12/8.
//  Copyright © 2017年 kapokcloud. All rights reserved.
//

#import "ZJChooseShowView.h"
#import "ZJOneChildView.h"
#import "ZJTwoChildView.h"
#import "ZJThreeChildView.h"
#import "ZJFourChildView.h"
#import "ZJChooseModel.h"
#import <AFNetworking.h>
#import "oneTitleModel.h"
typedef enum : NSUInteger {
    ChooseViewShowOne,
    ChooseViewShowTwo,
    ChooseViewShowThree,
    ChooseViewShowFour
} ChooseViewShow;

@interface ZJChooseShowView()<ZJOneChildViewDelegate,ZJTwoChildViewDelegate,ZJThreeChildViewDelegate,ZJFourChildViewDelegate>

@property(nonatomic ,strong) ZJOneChildView         *oneView;
@property(nonatomic ,strong) ZJTwoChildView         *twoView;
@property(nonatomic ,strong) ZJThreeChildView       *threeView;
@property(nonatomic ,strong) ZJFourChildView        *fourView;
@property(nonatomic ,strong) NSArray                *viewArray;
// 记录弹出的是哪一个视图
@property(nonatomic ,assign) ChooseViewShow         chooseView;
@property(nonatomic ,strong) UIButton               *seleBtn;

@property(nonatomic ,strong) NSMutableArray        *onetitleArr;
@property(nonatomic ,strong) NSMutableArray        *titleArr;
//@property(nonatomic ,strong) NSArray                *twoTitleArr;
@property(nonatomic ,strong) NSArray                *threeTitleArr;


@end

@implementation ZJChooseShowView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self loadData];
        [self setUpAllView];
        
    }
    return self;
}
-(void)loadData{
    
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSString *www = [userinfo objectForKey:@"token"];
    NSLog(@"www = %@",www);
    
    NSDictionary *dict = @{@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"],@"houses_type":@"1"};
    
    NSLog(@"dict = %@",dict);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSLog(@"dict = %@",dict);
    NSString *strurl = [API stringByAppendingString:@"secondHouseType/getmoney"];
    NSLog(@"strurl = %@",strurl);
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"dataStr = %@",dataStr);
        
        NSArray *dataArr = responseObject[@"data"];
        _onetitleArr = [NSMutableArray array];
        
        for (NSDictionary *oneDic in dataArr) {
            
            oneTitleModel *oneModel = [[oneTitleModel alloc]initWithDictionary:oneDic error:NULL];
            [_onetitleArr addObject:oneModel];
           
           
        }
        
        NSLog(@"_onetitleArr = %@",_onetitleArr);
//         [self setUpAllView];
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
    
}
-(void)setUpAllView{
    
    self.backgroundColor = [UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:0.0];

    self.threeTitleArr = @[@"智能排序",@"离我最近",@"星级最高",@"人气最高",@"价格最低",@"价格最高"];
    self.viewArray = @[self.oneView,self.twoView,self.threeView,self.fourView];
    [self addSubview:self.hiddenView];
    UITapGestureRecognizer *tap= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideViewAction:)];
    [self.hiddenView addGestureRecognizer:tap];
}

-(void)oneViewTableviewDidSelectedWithIndex:(NSInteger)index{
    
    [self.seleBtn setTitle:self.threeTitleArr[index] forState:UIControlStateNormal];
    [self hideViewAction:nil];
    if ([self.delegate respondsToSelector:@selector(chooseThreeViewCellDidSelectedWithIndex:)]) {
        [self.delegate chooseThreeViewCellDidSelectedWithIndex:index];
    }
}
-(void)twoViewTableviewDidSelectedWithIndex:(NSInteger)index{
    
    [self.seleBtn setTitle:self.threeTitleArr[index] forState:UIControlStateNormal];
    [self hideViewAction:nil];
    if ([self.delegate respondsToSelector:@selector(chooseTwoViewCellDidSelectedWithIndex:)]) {
        [self.delegate chooseTwoViewCellDidSelectedWithIndex:index];
    }
}

-(void)threeViewTableviewDidSelectedWithIndex:(NSInteger)index{
    [self.seleBtn setTitle:self.threeTitleArr[index] forState:UIControlStateNormal];
    [self hideViewAction:nil];
    if ([self.delegate respondsToSelector:@selector(chooseThreeViewCellDidSelectedWithIndex:)]) {
        [self.delegate chooseThreeViewCellDidSelectedWithIndex:index];
    }
}

-(void)fourViewBtnSelectedWithIsProm:(BOOL)isprom isVer:(BOOL)isVer{
    [self hideViewAction:nil];
    
    if ([self.delegate respondsToSelector:@selector(chooseFourViewBtnResultWithIsProm:isVer:)]) {
        [self.delegate chooseFourViewBtnResultWithIsProm:isprom isVer:isVer];
    }
}


#pragma mark - 隐藏当前视图
-(void)hideViewAction:(UITapGestureRecognizer *)gesture{
    
    // 改变按钮的状态
    self.seleBtn.selected = !self.seleBtn.isSelected;
    // 隐藏视图
    switch (self.chooseView) {
        case 0:
            [self hideOneView];
            break;
        case 1:
            [self hideTwoView];
            break;
        case 2:
            [self hideThreeView];
            break;
        case 3:
            [self hideFourView];
            break;
        default:
            break;
    }
    
}

#pragma mark -  点击筛选按钮
-(void)chooseControlViewBtnArray:(NSArray *)btnArr Action:(UIButton *)sender{
    self.seleBtn = sender;
    for (int i = 0; i<btnArr.count; i++) {
        UIButton *btn = btnArr[i];
        if (btn.tag == sender.tag) {
            
        }else{
            
            btn.selected = NO;
        }
    }
    self.chooseView = sender.tag;
    switch (sender.tag) {
        case 0:
        {
            if (sender.selected) {
                [self hideOtherChilView:self.oneView];
                [self showOneView];
            }else{
                [self hideOneView];
            }
        }
            break;
        case 1:
            if (sender.selected) {
                [self hideOtherChilView:self.twoView];
                [self showTwoView];
            }else{
                [self hideTwoView];
            }
            break;
        case 2:
            if (sender.selected) {
                [self hideOtherChilView:self.threeView];
                [self showThreeView];
            }else{
                [self hideThreeView];
            }
            break;
        case 3:
            if (sender.selected) {
                [self hideOtherChilView:self.fourView];
                [self showFourView];
            }else{
                [self hideFourView];
            }
            break;
            
        default:
            break;
    }
}

#pragma mark - 隐藏其他视图
-(void)hideOtherChilView:(UIView *)view{
    
    
    for (int i = 0; i<self.viewArray.count; i++) {
        UIView *childView = self.viewArray[i];
        if (view == childView) {
            
        }else{
            childView.hidden = YES;
            childView.frame = CGRectMake(0, 0, Main_width, 0);
            for (UITableView *tabView in childView.subviews) {
                tabView.frame = CGRectMake(0, 0, Main_width, 0);
            }
        }
    }
    
    
}


-(void)layoutSubviews{
    [super layoutSubviews];
    if (self.oneView.isHidden) {
        CGFloat hiddY = CGRectGetMaxY(self.oneView.frame);
        self.hiddenView.frame = CGRectMake(0, hiddY, Main_width, Main_Height - hiddY);
    }else if (self.twoView.isHidden){
        CGFloat hiddY = CGRectGetMaxY(self.twoView.frame);
        self.hiddenView.frame = CGRectMake(0, hiddY, Main_width, Main_Height - hiddY);
    }else if (self.threeView.isHidden){
        CGFloat hiddY = CGRectGetMaxY(self.threeView.frame);
        self.hiddenView.frame = CGRectMake(0, hiddY, Main_width, Main_Height - hiddY);
    }else if (self.fourView.isHidden){
        CGFloat hiddY = CGRectGetMaxY(self.fourView.frame);
        self.hiddenView.frame = CGRectMake(0, hiddY, Main_width, Main_Height - hiddY);
    }
}

#pragma mark - OneView
-(void)showOneView{
    
    [self addSubview:self.oneView];
    _oneView.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        _oneView.frame = CGRectMake(0, 0, Main_width, 280);
        _oneView.mainTable.frame = CGRectMake(0, 0, Main_width, 280);
        self.backgroundColor = [UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:0.3];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)hideOneView{
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.25 animations:^{
        _oneView.frame = CGRectMake(0, 0, Main_width, 0);
        _oneView.mainTable.frame = CGRectMake(0, 0, Main_width, 0);
    } completion:^(BOOL finished) {
        _oneView.hidden = YES;
        self.hidden = YES;
    }];
}

#pragma mark - twoView
-(void)showTwoView{
    
    [self addSubview:self.twoView];
    _twoView.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        _twoView.frame = CGRectMake(0, 0, Main_width, 280);
        _twoView.mainTable.frame = CGRectMake(0, 0, Main_width, 280);
        self.backgroundColor = [UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:0.3];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)hideTwoView{
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.25 animations:^{
        _twoView.frame = CGRectMake(0, 0, Main_width, 0);
        _twoView.mainTable.frame = CGRectMake(0, 0, Main_width, 0);
    } completion:^(BOOL finished) {
        _twoView.hidden = YES;
        self.hidden = YES;
    }];
}


#pragma mark - ThreeView
-(void)showThreeView{
    
    [self addSubview:self.threeView];
    _threeView.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        _threeView.frame = CGRectMake(0, 0, Main_width, 280);
        _threeView.mainTable.frame = CGRectMake(0, 0, Main_width, 280);
        self.backgroundColor = [UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:0.3];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)hideThreeView{
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.25 animations:^{
        _threeView.frame = CGRectMake(0, 0, Main_width, 0);
        _threeView.mainTable.frame = CGRectMake(0, 0, Main_width, 0);
    } completion:^(BOOL finished) {
        _threeView.hidden = YES;
        self.hidden = YES;
    }];
}


#pragma mark - FourView
-(void)showFourView{
    
    [self addSubview:self.fourView];
    _fourView.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        _fourView.frame = CGRectMake(0, 0, Main_width, 145);
        
        self.backgroundColor = [UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:0.3];
    } completion:^(BOOL finished) {
        for (UIView *view in self.fourView.subviews) {
            view.hidden = NO;
        }
    }];
}

-(void)hideFourView{
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.25 animations:^{
        _fourView.frame = CGRectMake(0, 0, Main_width, 0);
        for (UIView *view in self.fourView.subviews) {
            view.hidden = YES;
        }
    } completion:^(BOOL finished) {
        _fourView.hidden = YES;
        self.hidden = YES;
    }];
}


-(ZJOneChildView *)oneView{
    if (!_oneView) {
        _oneView = [[ZJOneChildView alloc]initWithFrame:CGRectMake(0, 0, Main_width, 0)];
        _oneView.hidden = YES;
        _oneView.delegate = self;
        _oneView.titleArray = self.threeTitleArr;
        _oneView.backgroundColor = [UIColor whiteColor];
        
    }
    return _oneView;
}

-(ZJTwoChildView *)twoView{
    if (!_twoView) {
        _twoView = [[ZJTwoChildView alloc]initWithFrame:CGRectMake(0, 0, Main_width, 0)];
        _twoView.hidden = YES;
        _twoView.delegate = self;
        _twoView.backgroundColor = [UIColor whiteColor];
    }
    return _twoView;
}

-(ZJThreeChildView *)threeView{
    if (!_threeView) {
        _threeView = [[ZJThreeChildView alloc]initWithFrame:CGRectMake(0, 0, Main_width, 0)];
        _threeView.hidden = YES;
        _threeView.delegate = self;
        _threeView.titleArray = self.threeTitleArr;
        _threeView.backgroundColor = [UIColor whiteColor];
        
    }
    return _threeView;
}

-(ZJFourChildView *)fourView{
    if (!_fourView) {
        _fourView = [[ZJFourChildView alloc]initWithFrame:CGRectMake(0, 0, Main_width, 0)];
        _fourView.hidden = YES;
        _fourView.delegate = self;
        _fourView.backgroundColor = [UIColor whiteColor];
    }
    return _fourView;
}
-(UIView *)hiddenView{
    if (!_hiddenView) {
        _hiddenView = [[UIView alloc]init];
    }
    return _hiddenView;
}

@end
