//
//  LSXAlertInputView.m
//  wxf
//
//  Created by 医联通 on 17/9/6.
//  Copyright © 2017年 lsx. All rights reserved.
//

#import "LSXAlertInputView.h"
#import "UIColor+YMHex.h"
#import "LSXPlacehoderTextView.h"
#import "UIView+SDAutoLayout.h"
@interface LSXAlertInputView()<UITextViewDelegate>{
    
    //备注文本View高度
    float noteTextHeight;
    NSString * _title;
    NSString * _PlaceholderText;
    LSXKeyboardType  _type;
   
    UIView * alertView;
    UILabel * titLa;
    UIView *leftview;
    UIView *rightview;
    LSXPlacehoderTextView * _textView;
    UIButton * qxbtn;
    UIButton * okbtn;
}
typedef void(^doneBlock)(NSString *);
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic,strong)doneBlock doneBlock;

@end

@implementation LSXAlertInputView

-(instancetype)initWithTitle:(NSString *)title PlaceholderText:(NSString *)PlaceholderText WithKeybordType:(LSXKeyboardType)bordtype CompleteBlock:(void(^)(NSString * contents))completeBlock{
    
    if([super init]){
        
         _title=title;
         _PlaceholderText=PlaceholderText;
        _type=bordtype;
         self.frame=CGRectMake(0, 0, Main_width, Main_Height);
        NSLog(@"------%f--%f",SCREEN_WIDTH,SCREEN_HEIGHT);
         [self insertSubview:self.shadowView belowSubview:self];
         [self CreatUI];
        
         if (completeBlock) {
            self.doneBlock = ^(NSString * contents) {
                completeBlock(contents);
            };
         }
    }
    return self;
}
-(void)CreatUI{
    
    alertView=[UIView new];
    alertView.backgroundColor=[UIColor whiteColor];
    alertView.sd_cornerRadius=[NSNumber numberWithInt:8];
    [_shadowView addSubview:alertView];
   
    
    
    titLa=[UILabel new];
    titLa.text=_title;
    titLa.textAlignment=NSTextAlignmentCenter;
    titLa.font=[UIFont systemFontOfSize:17];
    [alertView addSubview:titLa];
    
    leftview = [[UIView alloc] init];
    //leftview.backgroundColor = QIColor;
    [titLa addSubview:leftview];
    
    rightview = [[UIView alloc] init];
    //rightview.backgroundColor = QIColor;
    [titLa addSubview:rightview];
    
    _textView=[LSXPlacehoderTextView new];
    if(_type==0){
        _textView.keyboardType=UIKeyboardTypeDefault;
    }else if (_type==1){
         _textView.keyboardType=UIKeyboardTypeURL;
    }else if (_type==2){
        _textView.keyboardType=UIKeyboardTypeNumberPad;
    }else if (_type==3){
        _textView.keyboardType=UIKeyboardTypePhonePad;
    }else{
        _textView.keyboardType=UIKeyboardTypeNamePhonePad;
    }
    _textView.font=[UIFont systemFontOfSize:15];
    _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _textView.placeholder=_PlaceholderText;
//    _textView.layer.borderColor=[UIColor colorWithHexString:@"#E3E3E5"].CGColor;
//    _textView.layer.borderWidth=0.5;
    _textView.delegate=self;
    [alertView addSubview:_textView];
    
    qxbtn=[UIButton new];
    qxbtn.backgroundColor=QIColor;
    [qxbtn addTarget:self action:@selector(qxTap) forControlEvents:UIControlEventTouchUpInside];
    [qxbtn setTitle:@"取消" forState:UIControlStateNormal];
    [alertView addSubview:qxbtn];
    
    okbtn=[UIButton new];
    [okbtn addTarget:self action:@selector(okTap) forControlEvents:UIControlEventTouchUpInside];
    okbtn.backgroundColor=QIColor;
    [okbtn setTitle:@"下一步" forState:UIControlStateNormal];
    [alertView addSubview:okbtn];
   
    [self updateViewsFrame];
}
/**
 *  界面布局 frame
 */
- (void)updateViewsFrame{
    
    if (!noteTextHeight) {
        noteTextHeight = 35;
    }
    alertView.sd_layout.centerXIs(self.centerX).centerYIs(self.centerY-60).autoHeightRatio(0).widthIs(SCREEN_WIDTH-80);
    
    titLa.sd_layout.topSpaceToView(alertView,20).leftSpaceToView(alertView,0).heightIs(20).rightSpaceToView(alertView,0);
    
    leftview.frame = CGRectMake(30, 0, (alertView.frame.size.width-60-100)/2, titLa.frame.size.height);
    
    UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(leftview.frame.size.width-6, leftview.frame.size.height/2-3, 6, 6)];
    circle.layer.masksToBounds = YES;
    circle.layer.cornerRadius = 3;
    circle.backgroundColor = CIrclecolor;
    UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(0, leftview.frame.size.height/2, leftview.frame.size.width-6, 0.5)];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineview.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineview.frame) / 2, CGRectGetHeight(lineview.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:[UIColor blackColor].CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineview.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:3], [NSNumber numberWithInt:1],  nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(lineview.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineview.layer addSublayer:shapeLayer];
    lineview.alpha = 0.5;
    
    [leftview addSubview:circle];
    [leftview addSubview:lineview];
    
    rightview.frame = CGRectMake(leftview.frame.origin.x+100+leftview.frame.size.width, 0, (alertView.frame.size.width-60-100)/2, titLa.frame.size.height);
    
    UIView *circle1 = [[UIView alloc] initWithFrame:CGRectMake(0, leftview.frame.size.height/2-3, 6, 6)];
    circle1.layer.masksToBounds = YES;
    circle1.layer.cornerRadius = 3;
    circle1.backgroundColor = CIrclecolor;
    UIView *lineview1 = [[UIView alloc] initWithFrame:CGRectMake(0, leftview.frame.size.height/2, leftview.frame.size.width-6, 0.5)];
    CAShapeLayer *shapeLayer1 = [CAShapeLayer layer];
    [shapeLayer1 setBounds:lineview1.bounds];
    [shapeLayer1 setPosition:CGPointMake(CGRectGetWidth(lineview1.frame) / 2, CGRectGetHeight(lineview1.frame))];
    [shapeLayer1 setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer1 setStrokeColor:[UIColor blackColor].CGColor];
    //  设置虚线宽度
    [shapeLayer1 setLineWidth:CGRectGetHeight(lineview1.frame)];
    [shapeLayer1 setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer1 setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:3], [NSNumber numberWithInt:1],  nil]];
    //  设置路径
    CGMutablePathRef path1 = CGPathCreateMutable();
    CGPathMoveToPoint(path1, NULL, 0, 0);
    CGPathAddLineToPoint(path1, NULL, CGRectGetWidth(lineview1.frame), 0);
    [shapeLayer1 setPath:path1];
    CGPathRelease(path1);
    //  把绘制好的虚线添加上来
    [lineview1.layer addSublayer:shapeLayer1];
    lineview1.alpha = 0.5;
    [rightview addSubview:lineview1];
    [rightview addSubview:circle1];
    
    
    _textView.sd_layout.topSpaceToView(titLa,15).leftSpaceToView(alertView,15).heightIs(noteTextHeight).rightSpaceToView(alertView,15);
    
    UIView *bomlinview = [[UIView alloc] initWithFrame:CGRectMake(0, _textView.frame.origin.y+_textView.frame.size.height-0.5, _textView.frame.size.width, 0.5)];
    bomlinview.backgroundColor = [UIColor blackColor];
    bomlinview.alpha = 0.5;
    [_textView addSubview:bomlinview];

    qxbtn.sd_layout.topSpaceToView(_textView,25).leftSpaceToView(alertView,0).heightIs(40).widthIs(0);

    okbtn.sd_layout.topSpaceToView(_textView,25).leftSpaceToView(qxbtn,0).heightIs(40).rightSpaceToView(alertView,0);
    
    [alertView setupAutoHeightWithBottomView:okbtn bottomMargin:0];
}
#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    [self textChanged];
    return YES;
}
/**
 *  文本高度自适应
 */
-(void)textChanged{
    
    CGRect orgRect = _textView.frame;//获取原始UITextView的frame
    
    //获取尺寸
    CGSize size = [_textView sizeThatFits:CGSizeMake(_textView.frame.size.width, MAXFLOAT)];
    
    orgRect.size.height=size.height+5;//获取自适应文本内容高度
    
    //如果文本框没字了恢复初始尺寸
    if (orgRect.size.height > 40) {
        noteTextHeight = orgRect.size.height;
    }else{
        noteTextHeight = 40;
    }
    [self updateViewsFrame];
}
-(int)num{
    if(!_num){
        _num=0;
    }
    return _num;
}
//文本框每次输入文字都会调用  -> 更改文字个数提示框
- (void)textViewDidChangeSelection:(UITextView *)textView{
    if(_num>0){
        if (textView.text.length > _num){
            textView.text = [textView.text substringToIndex:_num];
        }
    }
    [self textChanged];
}
#pragma mark - LazyLoad
- (UIView *)shadowView {
    
    if (!_shadowView) {
        _shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _shadowView.backgroundColor = [UIColor blackColor];
        _shadowView.backgroundColor  = RGBA(0, 0, 0, 0.4);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToDismissNinaView)];
        [self.shadowView addGestureRecognizer:tap];
    }
    return _shadowView;
}
- (void)tapToDismissNinaView {
    [_textView resignFirstResponder];
    
    [UIView animateWithDuration:.3 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    }];
}
-(void)dismiss{
    
    [UIView animateWithDuration:.3 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    }];
}
//显示
-(void)show {
    
    [UIView animateWithDuration:.3 animations:^{
        //[self layoutIfNeeded];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }];
}
-(void)qxTap{
    [self dismiss];
}
-(void)okTap{
    self.doneBlock(_textView.text);
    [self dismiss];
}


@end
