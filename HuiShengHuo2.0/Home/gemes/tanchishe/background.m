//
//  head.m
//  snake1
//
//  Created by 张 on 2017/6/19.
//  Copyright © 2017年 tx. All rights reserved.
//

#import "background.h"
@interface background ()

@end
@implementation background
-(void)layoutSubviews{
    self.backgroundColor=[UIColor whiteColor];
    self.bodyLength=5;
    self.Direction=SnakeDirectionRight;
    [self foods];
    _color=[UIColor magentaColor];
}


//创建食物
-(UIView *)CreatfFood{
    UIView *food=[[UIView alloc]init];
    CGPoint point=[self random];
    food.frame=CGRectMake(point.x, point.y, 10, 10);
    food.backgroundColor=[UIColor greenColor];
    food.layer.cornerRadius=5;
    [self addSubview:food];
    return food;
}


-(NSMutableArray *)foods{
    if (!_foods) {
        _foods=[NSMutableArray arrayWithCapacity:10];
        for (int i=0; i<8; i++) {
            UIView *food=[self CreatfFood];
            [_foods addObject:food];
        }
    }
    return _foods;
}
//懒加载蛇运动路径
-(NSMutableArray *)points{
    if (!_points) {
        _points=[NSMutableArray arrayWithCapacity:10];
        NSValue *value=[NSValue valueWithCGPoint:CGPointMake(95, 95)];
        [_points addObject:value];
        for (int i=0; i<self.bodyLength; i++) {
            NSValue *value1=[NSValue valueWithCGPoint:CGPointMake(85-i*10, 95)];
            [_points addObject:value1];
        }
        //调换位置
        for (int x=0; x<self.bodyLength; x++) {
            for (int y=0;y<self.bodyLength-x; y++) {
                NSValue *value=(NSValue *)_points[y];
                _points[y]=_points[y+1];
                _points[y+1]=value;
            }
        }
    }
    return _points;
}



- (void)drawRect:(CGRect)rect {
    
    //画蛇头

    UIBezierPath *path=[[UIBezierPath alloc]init];
    [path setLineWidth:2.5];
    CGPoint point=[[self.points lastObject] CGPointValue];
    [path moveToPoint:point];
    [path addArcWithCenter:point radius:5 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    [path setLineCapStyle:kCGLineCapRound];
    [path setLineJoinStyle:kCGLineJoinRound];
    [[UIColor redColor] set];
    [path stroke];
    //画蛇的身体
    for (int i=self.bodyLength-1.0; i>=0; i--) {
        CGContextRef contexRef=UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(contexRef, 10);
        CGPoint point1=[self.points[i] CGPointValue];
        CGContextMoveToPoint(contexRef,point1.x,point1.y);
        CGContextAddLineToPoint(contexRef,point1.x,point1.y);
//        CGContextSetRGBStrokeColor(contexRef, 1, 0, 1, 1);
        CGContextSetStrokeColorWithColor(contexRef, self.color.CGColor);
        CGContextSetLineCap(contexRef, kCGLineCapRound);
        CGContextSetLineJoin(contexRef, kCGLineJoinRound);
        CGContextDrawPath(contexRef, kCGPathStroke);

    }
    //边框
    CGContextRef lineContexRef=UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(lineContexRef, 17);
    CGContextAddRect(lineContexRef, CGRectMake(7.5, 8.5, 360, 650));
    CGContextSetRGBStrokeColor(lineContexRef, 0, 0, 1, 1);
    CGContextDrawPath(lineContexRef, kCGPathStroke);
    
}

//蛇按方向移动
-(void)moveWithDirection:(SnakeDirection)direction{
    [self.points removeObject:self.points[0]];
    CGPoint point=[self.points.lastObject CGPointValue];
    self.headpoint=point;
    switch (direction) {
            case SnakeDirectionLeft:
        {
            if (self.Direction!=SnakeDirectionRight) {
                CGPoint point2=CGPointMake(point.x-10, point.y);
                NSValue *value2=[NSValue valueWithCGPoint:point2];
                [self.points addObject:value2];
                [self setNeedsDisplay];
                self.Direction=SnakeDirectionLeft;
            }
            break;
        }
            case SnakeDirectionup:
        {
            if (self.Direction!=SnakeDirectionNone) {
                CGPoint point3=CGPointMake(point.x, point.y-10);
                NSValue *value3=[NSValue valueWithCGPoint:point3];
                [self.points addObject:value3];
                [self setNeedsDisplay];
                self.Direction=SnakeDirectionup;
            }
            break;
        }
            case SnakeDirectionRight:
        {
            if (self.Direction!=SnakeDirectionLeft) {
                    CGPoint point4=CGPointMake(point.x+10, point.y);
                    NSValue *value4=[NSValue valueWithCGPoint:point4];
                    [self.points addObject:value4];
                    [self setNeedsDisplay];
                    self.Direction=SnakeDirectionRight;
            }
            break;
        }
        default:
        {
            if (self.Direction!=SnakeDirectionup) {
                CGPoint point1=CGPointMake(point.x, point.y+10);
                NSValue *value1=[NSValue valueWithCGPoint:point1];
                [self.points addObject:value1];
                [self setNeedsDisplay];
                self.Direction=SnakeDirectionNone;
            }
        }
    }
    [self eatFood];

}

    
    
//食物的位置
-(CGPoint)random{
    CGFloat x=arc4random_uniform(33)*10+20;
    CGFloat y=arc4random_uniform(62)*10+20;
    return CGPointMake(x, y);
}
-(void)eatFood{
    for (UIView *food in self.foods) {
        [self eatWithFood:food];
    }
}

//蛇吃食物后长大
-(void)eatWithFood:(UIView *)food{
    
    if(self.headpoint.x==food.center.x&&self.headpoint.y==food.center.y){
        CGPoint point=[self random];
        for (NSValue *value in self.points) {
            CGPoint bodyPoint=[value CGPointValue];
            if (bodyPoint.x==point.x&&bodyPoint.y==point.y) {
                CGPoint newpoint=[self random];
                point=CGPointMake(newpoint.x, newpoint.y);
            }
        }
        food.layer.position=CGPointMake(point.x-5, point.y-5);
        self.bodyLength++;
        NSValue *value1=[NSValue valueWithCGPoint:CGPointZero];
        [self.points addObject:value1];
        for (int i=(int)self.bodyLength; i>0; i--) {
            NSValue *value=(NSValue *)_points[i];
            _points[i]=_points[i-1];
            _points[i-1]=value;
        }
     [self setNeedsDisplay];
    }
    
}

@end
