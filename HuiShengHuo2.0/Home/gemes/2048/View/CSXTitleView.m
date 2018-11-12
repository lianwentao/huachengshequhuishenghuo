//
//  CSXTitleView.m
//  Game2048
//
//  Created by CSX on 2017/1/12.
//  Copyright © 2017年 宗盛商业. All rights reserved.
//

#import "CSXTitleView.h"
//#import "AMConfig.h"
#import "UIColor+ColorHex.h"


@interface CSXTitleView ()
{
    UILabel *detailTitlelabel;
    NSDictionary *context_Dic;
    NSDictionary *ColorDic;
}
@end


@implementation CSXTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        context_Dic = @{@2:@"曹",@4:@"世",@8:@"鑫",@16:@"预",@32:@"祝",@64:@"大",@128:@"家",@256:@"新",@512:@"年",@1024:@"快",@2048:@"乐"};
        ColorDic = @{@2:[UIColor colorWithHexString:@"AEEEEE"],@4:[UIColor colorWithHexString:@"C0FF3E"],@8:[UIColor colorWithHexString:@"FFEC8B"],@16:[UIColor colorWithHexString:@"FFDAB9"],@32:[UIColor colorWithHexString:@"FFC125"],@64:[UIColor colorWithHexString:@"FFB6C1"],@128:[UIColor colorWithHexString:@"FF83FA"],@256:[UIColor colorWithHexString:@"FF7F24"],@512:[UIColor colorWithHexString:@"FF6A6A"],@1024:[UIColor colorWithHexString:@"FF4040"],@2048:[UIColor colorWithHexString:@"FF0000"]};
        [self createView];
    }
    return self;
}

- (void)createView{
    
    detailTitlelabel = [[UILabel alloc]init];
    detailTitlelabel.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    detailTitlelabel.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    detailTitlelabel.backgroundColor = [UIColor clearColor];
    detailTitlelabel.textAlignment = 1;
    detailTitlelabel.textColor = [UIColor whiteColor];
    [self addSubview:detailTitlelabel];
}


- (void)getTitleChooseWithNewData:(NSNumber *)data{
    
    detailTitlelabel.text = [context_Dic objectForKey:data];
    detailTitlelabel.backgroundColor = [ColorDic objectForKey:data];
    
}






/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
