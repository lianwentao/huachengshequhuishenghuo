//
//  PTLDownMenuList.m
//  HuiShengHuo2.0
//
//  Created by admin on 2018/11/16.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "PTLDownMenuList.h"

#import "PTLMaskingView.h"

@interface PTLDownMenuList()


@end

@implementation PTLDownMenuList


-(PTLMaskingView *)maskingView {
    if (!_maskingView) {
        _maskingView = [[PTLMaskingView alloc]init];
        _maskingView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return _maskingView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
    [self.maskingView dismiss];
    
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (void)setupUI {
    
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.maskingView];
    
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.maskingView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
}


@end
