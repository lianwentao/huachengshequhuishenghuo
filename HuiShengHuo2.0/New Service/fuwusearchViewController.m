//
//  fuwusearchViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/12/7.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "fuwusearchViewController.h"
#import "fuwusearchchildViewController.h"
@interface fuwusearchViewController ()<FSPageContentViewDelegate,FSSegmentTitleViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) FSPageContentView *pageContentView;
@property (nonatomic, strong) FSSegmentTitleView *titleView;

@end

@implementation fuwusearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setui];
    [self setTitlebar];
    // Do any additional setup after loading the view.
}
-(void)setTitlebar
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 0, self.view.frame.size.width-100, 44)];
    [self.navigationItem setTitleView:view];
    UIImageView *bgimg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7, Main_width-100-30, 30)];
    bgimg.backgroundColor = [UIColor whiteColor];
    bgimg.layer.cornerRadius = 15;
    bgimg.layer.borderColor = [[UIColor grayColor] CGColor];
    bgimg.layer.borderWidth = 1;
    [bgimg.layer setMasksToBounds:YES];
    bgimg.userInteractionEnabled = YES;
    [view addSubview:bgimg];
    //
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 16, 16)];
    img.image = [UIImage imageNamed:@"common_btn_search"];
    [bgimg addSubview:img];
    
    UITextField *text = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(img.frame)+10, 0, bgimg.frame.size.width-20, 30)];
    text.placeholder = @"请输入搜索内容";
    text.textColor = [UIColor blackColor];
    text.font = [UIFont systemFontOfSize:14];
    text.delegate = self;
    [text becomeFirstResponder];
    text.returnKeyType = UIReturnKeySearch;
    [bgimg addSubview:text];
    
}
// return按钮操作
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.view endEditing:YES];
    
    WBLog(@"----1111-----");
    
    return YES;
}


-(void)rightmengbutClick{
    WBLog(@"asd");
}
- (void)setui
{
    NSMutableArray *childVCs = [[NSMutableArray alloc]init];
    for (NSString *title in @[@"sj",@"fw"]) {
        fuwusearchchildViewController *vc = [[fuwusearchchildViewController alloc]init];
        vc.shangjiaorfuwu = title;
        [childVCs addObject:vc];
    }
    self.titleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, RECTSTATUS.size.height+44, CGRectGetWidth(self.view.bounds), 50) titles:@[@"商家",@"服务"] delegate:self indicatorType:FSIndicatorTypeEqualTitle];
    self.titleView.titleSelectFont = [UIFont systemFontOfSize:17];
    self.titleView.backgroundColor = [UIColor colorWithRed:(244)/255.0 green:(247)/255.0 blue:(248)/255.0 alpha:0.54];
    self.titleView.titleNormalColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.54];
    self.titleView.selectIndex = 0;
    
    [self.view addSubview:_titleView];
    
    self.pageContentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, RECTSTATUS.size.height+44+50, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 90) childVCs:childVCs parentVC:self delegate:self];
    self.pageContentView.contentViewCurrentIndex = 0;
    //self.pageContentView.contentViewCanScroll = YES;//设置滑动属性
    [self.view addSubview:_pageContentView];
}
#pragma mark --
- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.pageContentView.contentViewCurrentIndex = endIndex;
}

- (void)FSContenViewDidEndDecelerating:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.titleView.selectIndex = endIndex;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
