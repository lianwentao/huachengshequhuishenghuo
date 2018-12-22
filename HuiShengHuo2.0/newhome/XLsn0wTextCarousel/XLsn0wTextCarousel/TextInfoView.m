/*********************************************************************************************
 *   __      __   _         _________     _ _     _    _________   __         _         __   *
 *	 \ \    / /  | |        | _______|   | | \   | |  |  ______ |  \ \       / \       / /   *
 *	  \ \  / /   | |        | |          | |\ \  | |  | |     | |   \ \     / \ \     / /    *
 *     \ \/ /    | |        | |______    | | \ \ | |  | |     | |    \ \   / / \ \   / /     *
 *     /\/\/\    | |        |_______ |   | |  \ \| |  | |     | |     \ \ / /   \ \ / /      *
 *    / /  \ \   | |______   ______| |   | |   \ \ |  | |_____| |      \ \ /     \ \ /       *
 *   /_/    \_\  |________| |________|   |_|    \__|  |_________|       \_/       \_/        *
 *                                                                                           *
 *********************************************************************************************/

#import "TextInfoView.h"

#define kFit6PWidth  ([UIScreen mainScreen].bounds.size.width / 414)
#define kFit6PHeight ([UIScreen mainScreen].bounds.size.height / 736)
#define iPhone4s    ([[UIScreen mainScreen] bounds].size.height == 480)
#define iPhone5     ([[UIScreen mainScreen] bounds].size.height == 568)
#define iPhone6     ([[UIScreen mainScreen] bounds].size.height == 667)
#define iPhone6Plus ([[UIScreen mainScreen] bounds].size.height == 736)

@interface TextInfoView ()

@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *bottomLabel;

@property (nonatomic, strong) UILabel *topTitleLabel;
@property (nonatomic, strong) UILabel *bottomTitleLabel;

@property (nonatomic, strong) UIButton *topButton;
@property (nonatomic, strong) UIButton *bottomButton;

@property (nonatomic, strong) UILabel *topTimeLabel;
@property (nonatomic, strong) UILabel *bottomTimeLabel;

@end

@implementation TextInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        CAGradientLayer *layer = [CAGradientLayer layer];
        layer.frame = CGRectMake(0, 0, Main_width, 70);
        layer.startPoint = CGPointMake(0,0);
        layer.endPoint = CGPointMake(1, 0);
        layer.colors = @[(id)[UIColor colorWithHexString:@"#ff8a24"].CGColor,(id)[UIColor colorWithHexString:@"#ff6257"].CGColor];
        [self.layer addSublayer:layer];
        [self drawUI];
    }
    return self;
}

- (void)drawUI {

//    self.topLabel = [UILabel new];
//    [self addSubview:self.topLabel];
//    [self.topLabel setFrame:(CGRectMake(70, 16, 30, 15))];
//    self.topLabel.backgroundColor = [UIColor whiteColor];
//    self.topLabel.textColor = [UIColor colorWithHexString:@"#FF5722"];
//    self.topLabel.layer.cornerRadius = 2;
//    self.topLabel.layer.masksToBounds = YES;
//    self.topLabel.textAlignment = NSTextAlignmentCenter;
//    self.topLabel.font = [UIFont systemFontOfSize:10];
    
//    self.bottomLabel = [UILabel new];
//    [self addSubview:self.bottomLabel];
//    [self.bottomLabel setFrame:(CGRectMake(70, 44, 30, 15))];
//    self.bottomLabel.backgroundColor = [UIColor whiteColor];
//    self.bottomLabel.textColor = [UIColor colorWithHexString:@"#FF5722"];
//    self.bottomLabel.layer.cornerRadius = 2;
//    self.bottomLabel.layer.masksToBounds = YES;
//    self.bottomLabel.textAlignment = NSTextAlignmentCenter;
//    self.bottomLabel.font = [UIFont systemFontOfSize:10];
    
//    self.topButton = [UIButton new];
//    [self addSubview:self.topButton];
//    [self.topButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.topButton setFrame:(CGRectMake(110, 17, 155, 13))];
//    self.topButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
//    [self.topButton addTarget:self action:@selector(topButtonEvent:) forControlEvents:(UIControlEventTouchUpInside)];
//    self.topButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
//    [self.topButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
//
//    self.bottomButton = [UIButton new];
//    [self addSubview:self.bottomButton];
//    [self.bottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.bottomButton setFrame:(CGRectMake(110, 44, 155, 13))];
//    self.bottomButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
//    [self.bottomButton addTarget:self action:@selector(bottomButtonEvent:) forControlEvents:(UIControlEventTouchUpInside)];
//    self.bottomButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
//    [self.bottomButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    
    self.topTitleLabel = [UILabel new];
    [self addSubview:self.topTitleLabel];
    [self.topTitleLabel setFrame:(CGRectMake(110, 17, 155, 13))];
    self.topTitleLabel.textColor = [UIColor whiteColor];
    self.topTitleLabel.layer.masksToBounds = YES;
    self.topTitleLabel.textAlignment = NSTextAlignmentLeft;
    self.topTitleLabel.font = [UIFont systemFontOfSize:13];
    
    self.bottomTitleLabel = [UILabel new];
    [self addSubview:self.bottomTitleLabel];
    [self.bottomTitleLabel setFrame:(CGRectMake(110, 44, 155, 13))];
    self.bottomTitleLabel.textColor = [UIColor whiteColor];
    self.bottomTitleLabel.layer.masksToBounds = YES;
    self.bottomTitleLabel.textAlignment = NSTextAlignmentLeft;
    self.bottomTitleLabel.font = [UIFont systemFontOfSize:13];
    
    self.topTimeLabel = [UILabel new];
    [self addSubview:self.topTimeLabel];
    [self.topTimeLabel setFrame:(CGRectMake(275, 16, 70, 15))];
    self.topTimeLabel.textColor = [UIColor whiteColor];
    self.topTimeLabel.layer.masksToBounds = YES;
    self.topTimeLabel.textAlignment = NSTextAlignmentLeft;
    self.topTimeLabel.font = [UIFont systemFontOfSize:13];
    
    self.bottomTimeLabel = [UILabel new];
    [self addSubview:self.bottomTimeLabel];
    [self.bottomTimeLabel setFrame:(CGRectMake(275, 44, 70, 15))];
    self.bottomTimeLabel.textColor = [UIColor whiteColor];
    self.bottomTimeLabel.layer.masksToBounds = YES;
    self.bottomTimeLabel.textAlignment = NSTextAlignmentLeft;
    self.bottomTimeLabel.font = [UIFont systemFontOfSize:13];
    
    UIButton *dianjibut = [UIButton buttonWithType:UIButtonTypeCustom];
    dianjibut.frame = CGRectMake(0, 0, Main_width, 70);
    [dianjibut addTarget:self action:@selector(topButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:dianjibut];
    
//    if (iPhone6Plus) {
//        self.topButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
//        self.bottomButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
//    } else if (iPhone6) {
//        self.topButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
//        self.bottomButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
//    } else if (iPhone5) {
//        self.topButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
//        self.bottomButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
//    } else {
//        self.topButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
//        self.bottomButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
//    }
}

- (void)topButtonEvent:(UIButton *)topButton {
    [self.xlsn0wDelegate handleTopEventWithURLString:self.topModel.URLString];
}

- (void)bottomButtonEvent:(UIButton *)bottomButton {
    [self.xlsn0wDelegate handleBottomEventWithURLString:self.bottomModel.URLString];
}

- (void)setTopModel:(DataSourceModel *)topModel {
    _topModel = topModel;
    //  去掉\n
    NSString *title = [NSString stringWithFormat:@"%@", [topModel.title stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"]];
    self.topTitleLabel.text = topModel.title;
    self.topTimeLabel.text = topModel.time;
    [self.xlsn0wDelegate getTopDataSourceModel:topModel];
}

- (void)setBottomModel:(DataSourceModel *)bottomModel {
    _bottomModel = bottomModel;
    NSString *title = [NSString stringWithFormat:@"%@", [bottomModel.title stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"]];
    self.bottomTitleLabel.text = bottomModel.title;
    self.bottomTimeLabel.text = bottomModel.time;
    [self.xlsn0wDelegate getBottomDataSourceModel:bottomModel];
}

@end
