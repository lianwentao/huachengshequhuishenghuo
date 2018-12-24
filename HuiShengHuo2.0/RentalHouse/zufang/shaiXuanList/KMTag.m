//
//  KMTag.m
//  HuiShengHuo2.0
//
//  Created by admin on 2018/11/16.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "KMTag.h"

@implementation KMTag

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textAlignment = NSTextAlignmentLeft;
    }
    return self;
}

- (void)setupWithText:(NSString*)text {
    
    self.text = text;
    self.textColor = [UIColor colorWithRed:255/255.0 green:87/255.0 blue:34/255.0 alpha:1];
    self.backgroundColor = [UIColor colorWithRed:255/255.0 green:247/255.0 blue:247/255.0 alpha:1];
    self.font = [UIFont systemFontOfSize:13];
    UIFont* font = self.font;
    
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName: font}];
    
    CGRect frame = self.frame;
    frame.size = CGSizeMake(size.width, size.height);
    
    self.frame = frame;
    
    self.layer.cornerRadius = 2;
//    self.layer.borderColor = self.textColor.CGColor;
    self.layer.borderColor = [UIColor redColor].CGColor;
//    self.layer.borderWidth = 1.0;
    
}



@end
