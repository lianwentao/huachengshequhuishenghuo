//
//  shangjialevelListview.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/12/8.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "shangjialevelListview.h"

typedef  NS_ENUM(NSInteger,ButtonTag)
{
    LeftButtonTag = 101,
    RightButtonTag = 102,
    
};

@implementation shangjialevelListview
{
    
    UIView *_lineView;
    BOOL _isClickButton;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/




-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createSubView];
    }
    return self;
}
-(void)createSubView
{
    
    CGFloat width = 80;
    CGFloat x = self.bounds.size.width/4-width/2;
    CGFloat height = self.bounds.size.height;
    
    //button
    for (int i = 0; i < 2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self addSubview:button];
        //添加响应事件
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        //设置button其他属性
        button.frame = CGRectMake(x+(width/2+self.bounds.size.width/3)*i, 0, width, height);
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitle:(i==0?@"服务":@"评论") forState:   UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.54] forState: UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#FF5722"] forState: UIControlStateSelected];
        switch (i) {
            case 0:
                
                button.selected = YES;
                button.tag = LeftButtonTag;
                _leftButton = button;
                
                break;
            case 1:
                button.tag = RightButtonTag;
                _rightButton = button;
                break;
            default:
                break;
        }
    }
    //lineView
    CGFloat  y = self.bounds.size.height - 2;
    x = _leftButton.frame.origin.x;
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(x, y, width, 2)];
    [self addSubview:_lineView];
    _lineView.backgroundColor = [UIColor colorWithHexString:@"#FF5722"];
    
    UIView *bottomLineView = [[UIView alloc]initWithFrame:CGRectMake(0, height-0.5, Main_width, 0.5)];
    bottomLineView.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [self addSubview:bottomLineView];
    
}

-(void)clickButton:(UIButton *)sender
{
    
    BOOL isLeftButton =  _leftButton==sender  ? YES : NO;//判断点击的是否是LeftButton
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(selectedButton:)]) {
        [self.delegate selectedButton:isLeftButton];
    }
    ;
    //    [self changeLineViewFrame];
}


-(void)changeLineViewOffsetX:(CGFloat)offsetX
{
    CGFloat width = 80;
    CGRect linViewFrame = _lineView.frame;
    CGFloat x = self.bounds.size.width/4-width/2 + (width/2+self.bounds.size.width/3)*(offsetX/Main_width);
    
    //修改_lineView.frame
    
    linViewFrame.origin.x = x;    //
    _lineView.frame =  linViewFrame;
    
    if (offsetX==0||offsetX==Main_width) {
        _leftButton.selected = offsetX/Main_width ==0 ? YES : NO;
        _rightButton.selected = !_leftButton.selected;
    }
    
    
    
    
}


@end
