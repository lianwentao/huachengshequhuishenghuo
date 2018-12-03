//
//  SubView.m
//  NestedTableView
//

//

#import "SubView.h"
#import "SubTableView.h"

@implementation SubView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _contentView.contentSize = CGSizeMake(frame.size.width*2, frame.size.height);
        _contentView.pagingEnabled = YES;
        _contentView.bounces = YES;
        _contentView.delegate = self;
        _contentView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_contentView];
        _cateArr = [[NSArray alloc] init];
        for (int i=0; i<2; i++) {
            SubTableView *aSubTable = [[SubTableView alloc] initWithFrame:CGRectMake(i*frame.size.width, 0, frame.size.width, frame.size.height)];
            aSubTable.num = [NSString stringWithFormat:@"%d",i];
            aSubTable.cateArr = _cateArr;
            [_contentView addSubview:aSubTable];
        }
        WBLog(@"--%@",_cateArr);
    }
    return self;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger pageNum = offsetX/[UIScreen mainScreen].bounds.size.width;
    if (self.scrollEventBlock) {
        self.scrollEventBlock(pageNum);
    }
}

@end
