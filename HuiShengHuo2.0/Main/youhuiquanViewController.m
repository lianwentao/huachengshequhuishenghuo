//
//  youhuiquanViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/12/6.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import "youhuiquanViewController.h"
#import "youhuiquanTableViewCell.h"
#import <AFNetworking.h>
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+TVAssistant.h"
#import "youhuiquanxiangqingViewController.h"
#import "youhuiquanshiyongjiluViewController.h"
#import "UITableView+PlaceHolderView.h"
#import "LSPPageView.h"
#import "MBProgressHUD+TVAssistant.h"
#import "UITableView+PlaceHolderView.h"
#import "GoodsDetailViewController.h"
#import "shangpinerjiViewController.h"
#define kScreen_Height   ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width    ([UIScreen mainScreen].bounds.size.width)
#import "PrefixHeader.pch"
@interface youhuiquanViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    UITableView *_TableView0;
    UITableView *_TableView1;
    NSMutableArray *_DataArr;
    NSMutableArray *_DataArr1;
    
    NSArray *youhuiquanweilingqu;
    NSArray *youhuiquanweishiyong;
    
    NSArray *daodianfuweilingqu;
    NSArray *daodianfuweishiyong;
    
    UIScrollView *smallscrollview;
    UIScrollView *bigscrollview;
    UIViewController *vc;
    UIButton *_tmpbut;
    UIButton *but;
    UIButton *but1;
}

@end

@implementation youhuiquanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"优惠券";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    daodianfuweilingqu = [[NSArray alloc] init];
    daodianfuweishiyong = [[NSArray alloc] init];
    youhuiquanweilingqu = [[NSArray alloc] init];
    youhuiquanweishiyong = [[NSArray alloc] init];
    
    [self createui];
    [self post];
    [self post1];
    [self createtableview];
    [self addRightBtn];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shiyongyouhuiquan) name:@"shiyongyouhuiquan" object:nil];
    // Do any additional setup after loading the view.
}
- (void)createui
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(Main_width/2-60, 0, 120, 44)];
    [self.navigationItem setTitleView:view];
    
    but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but setTitle:@"优惠券" forState:UIControlStateNormal];
    [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[but setTitleColor:admincolor forState:UIControlStateSelected];
    but.frame = CGRectMake(0, 0, 60, 42);
    [but addTarget:self action:@selector(huadong:) forControlEvents:UIControlEventTouchUpInside];
    but.tag = 0;
    [but.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [view addSubview:but];
    
//    but.selected = YES;
//    _tmpbut = but;
    
    but1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [but1 setTitle:@"到店券" forState:UIControlStateNormal];
    [but1 addTarget:self action:@selector(huadong:) forControlEvents:UIControlEventTouchUpInside];
    [but1.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [but1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[but1 setTitleColor:QIColor forState:UIControlStateSelected];
    but1.frame = CGRectMake(60, 0, 60, 42);
    but1.tag = 1;
    [view addSubview:but1];
    
    
    
    
    
//    smallscrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 15, 120, 15)];
//    smallscrollview.contentSize = CGSizeMake(120, 2);
//    smallscrollview.pagingEnabled = YES;
//    [view addSubview:smallscrollview];
//
//    UIView *blackview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 15)];
//    blackview.backgroundColor = [UIColor blackColor];
//    [smallscrollview addSubview:blackview];
}
- (void)huadong:(UIButton *)sender
{
    if (sender.tag==1) {
        //[smallscrollview setContentOffset:CGPointMake(60,0) animated:YES];
        [bigscrollview setContentOffset:CGPointMake(Main_width, 0) animated:YES];
        [but1.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [but.titleLabel setFont:[UIFont systemFontOfSize:16]];
    }else{
        //[smallscrollview setContentOffset:CGPointMake(0,0) animated:YES];
        [bigscrollview setContentOffset:CGPointMake(0, 0) animated:YES];
        [but.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [but1.titleLabel setFont:[UIFont systemFontOfSize:16]];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSLog(@"scrollViewDidScroll");
    CGPoint point=scrollView.contentOffset;
    NSLog(@"%f,%f",point.x,point.y);
    // 从中可以读取contentOffset属性以确定其滚动到的位置。
    
    // 注意：当ContentSize属性小于Frame时，将不会出发滚动
    if (point.x>=Main_width) {
        [but1.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [but.titleLabel setFont:[UIFont systemFontOfSize:16]];
    }else{
        [but.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [but1.titleLabel setFont:[UIFont systemFontOfSize:16]];
    }
    
    
}
#pragma mark - 导航栏rightbutton
- (void)addRightBtn
{
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"记录" style:UIBarButtonItemStylePlain target:self action:@selector(shiyongjilu)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    if ([_jpushstring isEqualToString:@"jpush"]) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    }
}
- (BOOL)navigationShouldPopOnBackButton{
    UIViewController *viewc = self.navigationController.viewControllers[self.navigationController.viewControllers.count-1];
    [self.navigationController popToViewController:viewc animated:YES];
    return YES;
}
- (void)back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)shiyongjilu
{
    youhuiquanshiyongjiluViewController *jilu = [[youhuiquanshiyongjiluViewController alloc] init];
    [self.navigationController pushViewController:jilu animated:YES];
}
- (void)shiyongyouhuiquan
{
    [self post];
    [self post1];
}
- (void)createtableview
{
    bigscrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, RECTSTATUS.size.height+44, Main_width, Main_Height-(RECTSTATUS.size.height+44))];
    bigscrollview.contentSize = CGSizeMake(Main_width*2, Main_Height-(RECTSTATUS.size.height+44));
    bigscrollview.showsVerticalScrollIndicator = NO;
    bigscrollview.showsHorizontalScrollIndicator = NO;
    bigscrollview.bounces = NO;
    bigscrollview.delegate = self;
    bigscrollview.pagingEnabled = YES;
    [self.view addSubview:bigscrollview];
    
    _TableView0 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_width, Main_Height-(RECTSTATUS.size.height+44))];
    
    _TableView0.estimatedRowHeight = 0;
    _TableView0.estimatedSectionFooterHeight = 0;
    _TableView0.estimatedSectionHeaderHeight = 0;
    _TableView0.tag = 0;
    _TableView0.delegate = self;
    _TableView0.dataSource = self;
    _TableView0.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    _TableView1 = [[UITableView alloc] initWithFrame:CGRectMake(Main_width, 0, Main_width, Main_Height-(RECTSTATUS.size.height+44))];
    
    _TableView1.estimatedRowHeight = 0;
    _TableView1.estimatedSectionFooterHeight = 0;
    _TableView1.estimatedSectionHeaderHeight = 0;
    _TableView1.tag = 1;
    _TableView1.delegate = self;
    _TableView1.dataSource = self;
    _TableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _TableView0.backgroundColor = BackColor;
    _TableView1.backgroundColor = BackColor;
    [bigscrollview addSubview:_TableView0];
    [bigscrollview addSubview:_TableView1];
}
#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==0) {
        if (section==0) {
            if ([youhuiquanweishiyong isKindOfClass:[NSArray class]]) {
                return youhuiquanweishiyong.count+1;
            }else{
                return 0;
            }
        }else{
            if ([youhuiquanweilingqu isKindOfClass:[NSArray class]]) {
                return youhuiquanweilingqu.count+1;
            }else{
                return 0;
            }
        }
    }else{
        if (section==0) {
            if ([daodianfuweishiyong isKindOfClass:[NSArray class]]) {
                return daodianfuweishiyong.count+1;
            }else{
                return 0;
            }
        }else{
            if ([daodianfuweilingqu isKindOfClass:[NSArray class]]) {
                return daodianfuweilingqu.count+1;
            }else{
                return 0;
            }
        }
    }
}

// 分组的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==0) {
        if (indexPath.section==0) {
            if ([youhuiquanweishiyong isKindOfClass:[NSArray class]]) {
                if (indexPath.row==0) {
                    return 55;
                }else{
                    return 94;
                }
            }else{
                return 0;
            }
        }else{
            if ([youhuiquanweilingqu isKindOfClass:[NSArray class]]) {
                if (indexPath.row==0) {
                    return 55;
                }else{
                    return 94;
                }
            }else{
                return 0;
            }
        }
    }else{
        if (indexPath.section==0) {
            if ([daodianfuweishiyong isKindOfClass:[NSArray class]]) {
                if (indexPath.row==0) {
                    return 55;
                }else{
                    return 102.5+8;
                }
            }else{
                return 0;
            }
        }else{
            if ([daodianfuweilingqu isKindOfClass:[NSArray class]]) {
                if (indexPath.row==0) {
                    return 55;
                }else{
                    return 102.5+8;
                }
            }else{
                return 0;
            }
        }
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag==0) {
        NSString *identifier = @"cell";
        // 从重用队列里查找可重用的cell
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        // 判断如果没有可以重用的cell，创建
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.contentView.backgroundColor = BackColor;
        if (indexPath.section==0) {
            if ([youhuiquanweishiyong isKindOfClass:[NSArray class]]) {
                if (indexPath.row==0) {
                    cell.textLabel.text = @"您领取的优惠券";
                }else{
                    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, Main_width-30, 86)];
                    imageview.image = [UIImage imageNamed:@"ic_orange_bg"];//ic_red_bg
                    [cell.contentView addSubview:imageview];
                    
                    int i = [[[youhuiquanweishiyong objectAtIndex:indexPath.row-1] objectForKey:@"amount"] intValue];
                    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, imageview.frame.size.width/3.77-20, 86)];
                    label1.text = [NSString stringWithFormat:@"%d",i];
                    label1.font = [UIFont boldSystemFontOfSize:50];
                    label1.textAlignment = NSTextAlignmentCenter;
                    label1.textColor = [UIColor whiteColor];
                    [imageview addSubview:label1];
                    
                    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(label1.frame.size.width+label1.frame.origin.x, 50, 20, 20)];
                    label2.textColor = [UIColor whiteColor];
                    label2.font = [UIFont boldSystemFontOfSize:15];
                    label2.text = @"元";
                    [imageview addSubview:label2];
                    
                    UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(imageview.frame.size.width-imageview.frame.size.width/5.5, 0, imageview.frame.size.width/5.5, 86)];
                    [imageview addSubview:backview];
                    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake((imageview.frame.size.width/5.5-50)/2, 0, 50, 86)];
                    label3.textColor = [UIColor whiteColor];
                    label3.numberOfLines = 2;
                    label3.textAlignment = NSTextAlignmentCenter;
                    label3.font = [UIFont boldSystemFontOfSize:15];
                    label3.text = @"立即使用";
                    [backview addSubview:label3];
                    
                    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(label2.frame.size.width+label2.frame.origin.x+35, 15, imageview.frame.size.width-label2.frame.size.width-backview.frame.size.width-label2.frame.origin.x-35, 15)];
                    label4.font = [UIFont boldSystemFontOfSize:16];
                    label4.textColor = [UIColor whiteColor];
                    label4.text = [[youhuiquanweishiyong objectAtIndex:indexPath.row-1] objectForKey:@"name"];
                    [imageview addSubview:label4];
                    
                    UIView *circle1 = [[UIView alloc] initWithFrame:CGRectMake(label2.frame.size.width+label2.frame.origin.x+35, label4.frame.size.height+label4.frame.origin.y+10+3, 4, 4)];
                    circle1.layer.masksToBounds = YES;
                    circle1.layer.cornerRadius = 2;
                    circle1.backgroundColor = [UIColor whiteColor];
                    [imageview addSubview:circle1];
                    UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(label2.frame.size.width+label2.frame.origin.x+35+5, label4.frame.size.height+label4.frame.origin.y+10, imageview.frame.size.width-label2.frame.size.width-backview.frame.size.width-label2.frame.origin.x-35-5 ,10)];
                    label5.font = [UIFont systemFontOfSize:13];
                    label5.textColor = [UIColor whiteColor];
                    label5.text = [[youhuiquanweishiyong objectAtIndex:indexPath.row-1] objectForKey:@"condition"];
                    label5.alpha = 0.6;
                    [imageview addSubview:label5];
                    
                    
                    UIView *circle2 = [[UIView alloc] initWithFrame:CGRectMake(label2.frame.size.width+label2.frame.origin.x+25, label5.frame.size.height+label5.frame.origin.y+10+3, 4, 4)];
                    circle2.layer.masksToBounds = YES;
                    circle2.layer.cornerRadius = 2;
                    circle2.backgroundColor = [UIColor whiteColor];
                    [imageview addSubview:circle2];
                    UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(label2.frame.size.width+label2.frame.origin.x+35+5, label5.frame.size.height+label5.frame.origin.y+10, imageview.frame.size.width-label2.frame.size.width-backview.frame.size.width-label2.frame.origin.x-35-5, 10)];
                    label6.font = [UIFont systemFontOfSize:13];
                    label6.alpha = 0.6;
                    label6.textColor = [UIColor whiteColor];
                    
                    NSTimeInterval interval    =[[[youhuiquanweishiyong objectAtIndex:indexPath.row-1] objectForKey:@"endtime"] doubleValue];
                    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
                    
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy-MM-dd"];
                    NSString *dateString       = [formatter stringFromDate: date];
                    label6.text = [NSString stringWithFormat:@"有效期至 %@",dateString];
                    [imageview addSubview:label6];
                }
            }
        }else{
            if ([youhuiquanweilingqu isKindOfClass:[NSArray class]]) {
                if (indexPath.row==0) {
                    cell.textLabel.text = @"请领取以下优惠券";
                }else{
                    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, Main_width-30, 86)];
                    imageview.image = [UIImage imageNamed:@"ic_orange_bg"];//ic_red_bg
                    [cell.contentView addSubview:imageview];
                    
                    int i = [[[youhuiquanweilingqu objectAtIndex:indexPath.row-1] objectForKey:@"amount"] intValue];
                    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, imageview.frame.size.width/3.77-20, 86)];
                    label1.text = [NSString stringWithFormat:@"%d",i];
                    label1.font = [UIFont boldSystemFontOfSize:50];
                    label1.textAlignment = NSTextAlignmentCenter;
                    label1.textColor = [UIColor whiteColor];
                    [imageview addSubview:label1];
                    
                    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(label1.frame.size.width+label1.frame.origin.x, 50, 20, 20)];
                    label2.textColor = [UIColor whiteColor];
                    label2.font = [UIFont boldSystemFontOfSize:15];
                    label2.text = @"元";
                    [imageview addSubview:label2];
                    
                    UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(imageview.frame.size.width-imageview.frame.size.width/5.5, 0, imageview.frame.size.width/5.5, 86)];
                    [imageview addSubview:backview];
                    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake((imageview.frame.size.width/5.5-50)/2, 0, 50, 86)];
                    label3.textColor = [UIColor whiteColor];
                    label3.numberOfLines = 2;
                    label3.textAlignment = NSTextAlignmentCenter;
                    label3.font = [UIFont boldSystemFontOfSize:15];
                    label3.text = @"立即领取";
                    [backview addSubview:label3];
                    
                    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(label2.frame.size.width+label2.frame.origin.x+25, 15, imageview.frame.size.width-label2.frame.size.width-backview.frame.size.width-label2.frame.origin.x-25, 15)];
                    label4.font = [UIFont boldSystemFontOfSize:16];
                    label4.textColor = [UIColor whiteColor];
                    label4.text = [[youhuiquanweilingqu objectAtIndex:indexPath.row-1] objectForKey:@"name"];
                    [imageview addSubview:label4];
                    
                    UIView *circle1 = [[UIView alloc] initWithFrame:CGRectMake(label2.frame.size.width+label2.frame.origin.x+25, label4.frame.size.height+label4.frame.origin.y+10+3, 4, 4)];
                    circle1.layer.masksToBounds = YES;
                    circle1.layer.cornerRadius = 2;
                    circle1.backgroundColor = [UIColor whiteColor];
                    [imageview addSubview:circle1];
                    UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(label2.frame.size.width+label2.frame.origin.x+25+5, label4.frame.size.height+label4.frame.origin.y+10, imageview.frame.size.width-label2.frame.size.width-backview.frame.size.width-label2.frame.origin.x-25-5 ,10)];
                    label5.font = [UIFont systemFontOfSize:13];
                    label5.textColor = [UIColor whiteColor];
                    label5.text = [[youhuiquanweilingqu objectAtIndex:indexPath.row-1] objectForKey:@"condition"];
                    label5.alpha = 0.6;
                    [imageview addSubview:label5];
                    
                    
                    UIView *circle2 = [[UIView alloc] initWithFrame:CGRectMake(label2.frame.size.width+label2.frame.origin.x+25, label5.frame.size.height+label5.frame.origin.y+10+3, 4, 4)];
                    circle2.layer.masksToBounds = YES;
                    circle2.layer.cornerRadius = 2;
                    circle2.backgroundColor = [UIColor whiteColor];
                    [imageview addSubview:circle2];
                    UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(label2.frame.size.width+label2.frame.origin.x+25+5, label5.frame.size.height+label5.frame.origin.y+10, imageview.frame.size.width-label2.frame.size.width-backview.frame.size.width-label2.frame.origin.x-25-5, 10)];
                    label6.font = [UIFont systemFontOfSize:13];
                    label6.alpha = 0.6;
                    label6.textColor = [UIColor whiteColor];
                    
                    NSTimeInterval interval    =[[[youhuiquanweilingqu objectAtIndex:indexPath.row-1] objectForKey:@"endtime"] doubleValue];
                    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
                    
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy-MM-dd"];
                    NSString *dateString       = [formatter stringFromDate: date];
                    label6.text = [NSString stringWithFormat:@"有效期至 %@",dateString];
                    [imageview addSubview:label6];
                }
            }
        }
        return cell;
    }else{
        NSString *identifier = @"cellaaa";
        // 从重用队列里查找可重用的cell
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        // 判断如果没有可以重用的cell，创建
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.contentView.backgroundColor = BackColor;
        if (indexPath.section==0) {
            if ([daodianfuweishiyong isKindOfClass:[NSArray class]]) {
                if (indexPath.row==0) {
                    cell.textLabel.text = @"您领取的到店优惠券";
                }else{
                    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, Main_width-30, 102.5)];
                    imageview.image = [UIImage imageNamed:@"ic_red_bg"];
                    [cell.contentView addSubview:imageview];
                    
                    UIImageView *imageview1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, imageview.frame.size.width/3.77-40, 86-40)];
                    NSString *imgstr1 = [[daodianfuweishiyong objectAtIndex:indexPath.row-1] objectForKey:@"photo"];
                    NSString *imgurl1 = [API_img stringByAppendingString:imgstr1];
                    [imageview1 sd_setImageWithURL:[NSURL URLWithString:imgurl1]];
                    imageview1.userInteractionEnabled = YES;
                    imageview1.clipsToBounds = YES;
                    imageview1.contentMode = UIViewContentModeScaleAspectFill;
                    [imageview addSubview:imageview1];
                    
                    NSString *amount = [[daodianfuweishiyong objectAtIndex:indexPath.row-1] objectForKey:@"amount"];
                    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(imageview.frame.size.width-imageview.frame.size.width/3.77, 0, imageview.frame.size.width/3.77-20, 102.5-22.5)];
                    float i = [amount floatValue];
                    int j = [amount intValue];
                    if (i<1) {
                        label1.text = [NSString stringWithFormat:@"%.1f",[amount floatValue]*10];
                    }else{
                        label1.text = [NSString stringWithFormat:@"%d",j];
                    }
                    label1.font = [UIFont boldSystemFontOfSize:25];
                    label1.textAlignment = NSTextAlignmentRight;
                    label1.textColor = [UIColor whiteColor];
                    [imageview addSubview:label1];

                    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(label1.frame.size.width+label1.frame.origin.x, 40, 20, 20)];
                    label2.textColor = [UIColor whiteColor];
                    label2.font = [UIFont boldSystemFontOfSize:15];
                    if (i<1) {
                        label2.text = @"折";
                    }else{
                        label2.text = @"元";
                    }
                    [imageview addSubview:label2];
                    
                    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(imageview.frame.size.width/3.77+25, 20, imageview.frame.size.width-imageview.frame.size.width/3.77*2-25, 15)];
                    label4.font = [UIFont boldSystemFontOfSize:16];
                    label4.textColor = [UIColor whiteColor];
                    label4.text = [[daodianfuweishiyong objectAtIndex:indexPath.row-1] objectForKey:@"name"];
                    [imageview addSubview:label4];
                    
                    UIView *circle1 = [[UIView alloc] initWithFrame:CGRectMake(imageview.frame.size.width/3.77+25, label4.frame.size.height+label4.frame.origin.y+10+3, 4, 4)];
                    circle1.layer.masksToBounds = YES;
                    circle1.layer.cornerRadius = 2;
                    circle1.backgroundColor = [UIColor whiteColor];
                    [imageview addSubview:circle1];
                    UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(imageview.frame.size.width/3.77+25+5, label4.frame.size.height+label4.frame.origin.y+10,  imageview.frame.size.width-imageview.frame.size.width/3.77*2-30,10)];
                    label5.font = [UIFont systemFontOfSize:13];
                    label5.textColor = [UIColor whiteColor];
                    label5.text = [[daodianfuweishiyong objectAtIndex:indexPath.row-1] objectForKey:@"condition"];
                    label5.alpha = 0.6;
                    [imageview addSubview:label5];
                    
                    UILabel *timelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 102.5-22.5, Main_width/5*3, 22.5)];
                    NSTimeInterval interval    =[[[daodianfuweishiyong objectAtIndex:indexPath.row-1] objectForKey:@"endtime"] doubleValue];
                    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
                    
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy-MM-dd"];
                    NSString *dateString       = [formatter stringFromDate: date];
                    timelabel.textColor = [UIColor blackColor];
                    timelabel.font = [UIFont systemFontOfSize:12];
                    timelabel.alpha = 0.4;
                    timelabel.text = [NSString stringWithFormat:@"有效期至 %@",dateString];
                    [imageview addSubview:timelabel];
                    
                    UILabel *labelrule = [[UILabel alloc] initWithFrame:CGRectMake(imageview.frame.size.width-imageview.frame.size.width/3.77, 102.5-22.5, imageview.frame.size.width/3.77, 22.5)];
                    labelrule.text = @"点击使用";
                    labelrule.textColor = [UIColor blackColor];
                    labelrule.font = [UIFont systemFontOfSize:12];
                    labelrule.textAlignment = NSTextAlignmentCenter;
                    labelrule.alpha = 0.4;
                    [imageview addSubview:labelrule];
                }
            }
        }else{
            if ([daodianfuweilingqu isKindOfClass:[NSArray class]]) {
                if (indexPath.row==0) {
                    cell.textLabel.text = @"请领取以下到店优惠券";
                }else{
                    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, Main_width-30, 102.5)];
                    imageview.image = [UIImage imageNamed:@"ic_red_bg"];//ic_red_bg
                    [cell.contentView addSubview:imageview];
                    
                    UIImageView *imageview1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, imageview.frame.size.width/3.77-7.5-40, 86-40)];
                    NSString *imgstr1 = [[daodianfuweilingqu objectAtIndex:indexPath.row-1] objectForKey:@"photo"];
                    NSString *imgurl1 = [API_img stringByAppendingString:imgstr1];
                    imageview1.userInteractionEnabled = YES;
                    imageview1.clipsToBounds = YES;
                    imageview1.contentMode = UIViewContentModeScaleAspectFill;
                    [imageview1 sd_setImageWithURL:[NSURL URLWithString:imgurl1]];
                    [imageview addSubview:imageview1];
                    
                    NSString *amount = [[daodianfuweilingqu objectAtIndex:indexPath.row-1] objectForKey:@"amount"];
                    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(imageview.frame.size.width-imageview.frame.size.width/3.77, 0, imageview.frame.size.width/3.77-20, 86-7.5)];
                    float i = [amount floatValue];
                    int j = [amount intValue];
                    if (i<1) {
                        label1.text = [NSString stringWithFormat:@"%.1f",[amount floatValue]*10];
                    }else{
                        label1.text = [NSString stringWithFormat:@"%d",j];
                    }
                    label1.font = [UIFont boldSystemFontOfSize:25];
                    label1.textAlignment = NSTextAlignmentRight;
                    label1.textColor = [UIColor whiteColor];
                    [imageview addSubview:label1];
                    
                    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(label1.frame.size.width+label1.frame.origin.x, 40, 20, 20)];
                    label2.textColor = [UIColor whiteColor];
                    label2.font = [UIFont boldSystemFontOfSize:15];
                    if (i<1) {
                        label2.text = @"折";
                    }else{
                        label2.text = @"元";
                    }
                    [imageview addSubview:label2];
                    
                    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(imageview.frame.size.width/3.77+25, 20, imageview.frame.size.width-imageview.frame.size.width/3.77*2-25, 15)];
                    label4.font = [UIFont boldSystemFontOfSize:16];
                    label4.textColor = [UIColor whiteColor];
                    label4.text = [[daodianfuweilingqu objectAtIndex:indexPath.row-1] objectForKey:@"name"];
                    [imageview addSubview:label4];
                    
                    UIView *circle1 = [[UIView alloc] initWithFrame:CGRectMake(imageview.frame.size.width/3.77+25, label4.frame.size.height+label4.frame.origin.y+10+3, 4, 4)];
                    circle1.layer.masksToBounds = YES;
                    circle1.layer.cornerRadius = 2;
                    circle1.backgroundColor = [UIColor whiteColor];
                    [imageview addSubview:circle1];
                    UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(imageview.frame.size.width/3.77+25+5, label4.frame.size.height+label4.frame.origin.y+10,  imageview.frame.size.width-imageview.frame.size.width/3.77*2-30,10)];
                    label5.font = [UIFont systemFontOfSize:13];
                    label5.textColor = [UIColor whiteColor];
                    label5.text = [[daodianfuweilingqu objectAtIndex:indexPath.row-1] objectForKey:@"condition"];
                    label5.alpha = 0.6;
                    [imageview addSubview:label5];
                    
                    UILabel *timelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 102.5-22.5, Main_width/5*3, 22.5)];
                    NSTimeInterval interval    =[[[daodianfuweilingqu objectAtIndex:indexPath.row-1] objectForKey:@"endtime"] doubleValue];
                    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
                    
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy-MM-dd"];
                    NSString *dateString       = [formatter stringFromDate: date];
                    timelabel.textColor = [UIColor blackColor];
                    timelabel.alpha = 0.4;
                    timelabel.font = [UIFont systemFontOfSize:12];
                    timelabel.text = [NSString stringWithFormat:@"有效期至 %@",dateString];
                    [imageview addSubview:timelabel];
                    
                    UILabel *labelrule = [[UILabel alloc] initWithFrame:CGRectMake(imageview.frame.size.width-imageview.frame.size.width/3.77, 102.5-22.5, imageview.frame.size.width/3.77, 22.5)];
                    labelrule.text = @"点击领取";
                    labelrule.textColor = [UIColor blackColor];
                    labelrule.font = [UIFont systemFontOfSize:12];
                    labelrule.alpha = 0.4;
                    labelrule.textAlignment = NSTextAlignmentCenter;
                    [imageview addSubview:labelrule];
                }
            }
        }
        return cell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==0) {
        if (indexPath.section==0&&indexPath.row>0) {
            if ([_shiyong isEqualToString:@"1"]) {
                __weak typeof(self) weakself = self;
                
                if (weakself.returnValueBlock) {
                    NSString *stringprice = [[youhuiquanweishiyong objectAtIndex:indexPath.row-1] objectForKey:@"amount"];
                    NSString *stringdetail = [[youhuiquanweishiyong objectAtIndex:indexPath.row-1] objectForKey:@"name"];
                    NSString *youhuiquanid = [[youhuiquanweishiyong objectAtIndex:indexPath.row-1] objectForKey:@"m_c_id"];
                    //将自己的值传出去，完成传值
                    weakself.returnValueBlock(stringprice,stringdetail,youhuiquanid);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                //跳转商城等
                NSString *shop_id = [NSString stringWithFormat:@"%@",[[youhuiquanweishiyong objectAtIndex:indexPath.row-1] objectForKey:@"shop_id"]];
                NSString *shop_cate = [NSString stringWithFormat:@"%@",[[youhuiquanweishiyong objectAtIndex:indexPath.row-1] objectForKey:@"shop_cate"]];
                if (![shop_id isEqualToString:@"0"]){
                    //跳转到商品详情页
                    GoodsDetailViewController *goodsdetail = [[GoodsDetailViewController alloc] init];
                    goodsdetail.IDstring = shop_id;
                    [self.navigationController pushViewController:goodsdetail animated:YES];
                }else if (![shop_cate isEqualToString:@"0"]){
                    //跳转到商城列表相应的分类列表页
                    shangpinerjiViewController *erji = [[shangpinerjiViewController alloc] init];
                    erji.id = shop_cate;
                    [self.navigationController pushViewController:erji animated:YES];
                }else{
                    //跳转到商城列表所有商品列表页
                    shangpinerjiViewController *erji = [[shangpinerjiViewController alloc] init];
                    erji.rokou = @"2";
                    [self.navigationController pushViewController:erji animated:YES];
                }
            }
        }if (indexPath.section==1&&indexPath.row>0){
            //领取优惠券
            NSString *id = [[youhuiquanweilingqu objectAtIndex:indexPath.row-1] objectForKey:@"id"];
            NSString *biaoshi = @"0";
            [self lingqu:id :biaoshi];
        }
    }else{
        if (indexPath.section==0&&indexPath.row>0) {
            if ([_shiyong isEqualToString:@"1"]) {
                //无响应
            }else{
                //跳转详情
                youhuiquanxiangqingViewController *xiangqing = [[youhuiquanxiangqingViewController alloc] init];
                xiangqing.id = [[daodianfuweishiyong objectAtIndex:indexPath.row-1] objectForKey:@"id"];
                xiangqing.title = [[daodianfuweishiyong objectAtIndex:indexPath.row-1] objectForKey:@"name"];
                [self.navigationController pushViewController:xiangqing animated:YES];
            }
        }if (indexPath.section==1&&indexPath.row>0){
            //领取到店卷
            NSString *id = [[daodianfuweilingqu objectAtIndex:indexPath.row-1] objectForKey:@"id"];
            NSString *biaoshi = @"1";
            [self lingqu:id :biaoshi];
        }
    }
}
#pragma mark ------联网请求---
-(void)post
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    NSDictionary *dict = [[NSDictionary alloc] init];
    if ([_shiyong isEqualToString:@"1"]) {
        dict = @{@"apk_token":uid_username,@"category_id":@"54",@"shop_id_str":_shop_id_str,@"amount":_amount,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
    }else{
        dict = @{@"apk_token":uid_username,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
    }
    NSString *urlstr = [API stringByAppendingString:@"userCenter/my_coupon_40"];
    [manager POST:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        

        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            youhuiquanweilingqu = [[responseObject objectForKey:@"data"] objectForKey:@"coupon_list"];
            youhuiquanweishiyong = [[responseObject objectForKey:@"data"] objectForKey:@"my_coupon_list"];
        }else{
            youhuiquanweishiyong = nil;
            youhuiquanweilingqu = nil;
            ///[MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
        [_TableView0 reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
-(void)post1
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    NSDictionary *dict = [[NSDictionary alloc] init];
    if ([_shiyong isEqualToString:@"1"]) {
        dict = @{@"apk_token":uid_username,@"category_id":@"54",@"shop_id_str":_shop_id_str,@"amount":_amount,@"coupon_type":@"1",@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
    }else{
        dict = @{@"apk_token":uid_username,@"coupon_type":@"1",@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
    }
    NSString *urlstr = [API stringByAppendingString:@"userCenter/my_coupon_40"];
    [manager POST:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            daodianfuweilingqu = [[responseObject objectForKey:@"data"] objectForKey:@"coupon_list"];
            daodianfuweishiyong = [[responseObject objectForKey:@"data"] objectForKey:@"my_coupon_list"];
        }else{
            daodianfuweilingqu = nil;
            daodianfuweishiyong = nil;
        }
        [_TableView1 reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
-(void)lingqu:(NSString *)coupon_id :(NSString *)biaoshi
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    NSDictionary *dict = [[NSDictionary alloc] init];
    dict = @{@"coupon_id":coupon_id,@"apk_token":uid_username,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
    NSString *urlstr = [API stringByAppendingString:@"userCenter/coupon_add"];
    [manager POST:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            if ([biaoshi isEqualToString:@"0"]) {
                [self post];
            }else{
                [self post1];
            }
        }else{
            
        }
        [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
        [MBProgressHUD showToastToView:self.view withText:@"领取失败"];
    }];
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
