//
//  youhuiquanshiyongjiluViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/1/13.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "youhuiquanshiyongjiluViewController.h"
#import "youhuiquanTableViewCell.h"
#import <AFNetworking.h>
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+TVAssistant.h"
#import "youhuiquanxiangqingViewController.h"
#import "youhuiquanshiyongjiluViewController.h"
#import "UITableView+PlaceHolderView.h"

#define kScreen_Height   ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width    ([UIScreen mainScreen].bounds.size.width)
#import "PrefixHeader.pch"
@interface youhuiquanshiyongjiluViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_TableView;
    NSArray *_DataArr;
}

@end

@implementation youhuiquanshiyongjiluViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"使用记录";
    
    [self createtableview];
    [self post];
    // Do any additional setup after loading the view.
}
- (void)createtableview
{
    _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    _TableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _TableView.delegate = self;
    _TableView.dataSource = self;
    //_TableView.enablePlaceHolderView = YES;
    [self.view addSubview:_TableView];
}
#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_DataArr isKindOfClass:[NSArray class]]) {
        return _DataArr.count+1;
    }else{
        return 0;
    }
}

// 分组的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_DataArr isKindOfClass:[NSArray class]]) {
        if (indexPath.row==0) {
            return 55;
        }else{
            if ([[[_DataArr objectAtIndex:indexPath.row-1] objectForKey:@"utype"] isEqualToString:@"1"]) {
            
                return 102.5+8;
                
            }else{
                return 86+8;
            }
        }
    }else{
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"cell";
    // 从重用队列里查找可重用的cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 判断如果没有可以重用的cell，创建
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.contentView.backgroundColor = BackColor;
    
//    if (indexPath.row==0) {
//        cell.textLabel.text = @"您领取的优惠券";
//    }else{
//        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, Main_width-30, 86)];
//        imageview.image = [UIImage imageNamed:@"jilu1"];//ic_red_bg
//        [cell.contentView addSubview:imageview];
//
//        int i = [[[_DataArr objectAtIndex:indexPath.row-1] objectForKey:@"amount"] intValue];
//        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, imageview.frame.size.width/3.77-20, 86)];
//        label1.text = [NSString stringWithFormat:@"%d",i];
//        label1.font = [UIFont boldSystemFontOfSize:50];
//        label1.textAlignment = NSTextAlignmentCenter;
//        label1.textColor = [UIColor whiteColor];
//        [imageview addSubview:label1];
//
//        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(label1.frame.size.width+label1.frame.origin.x, 50, 20, 20)];
//        label2.textColor = [UIColor whiteColor];
//        label2.font = [UIFont boldSystemFontOfSize:15];
//        label2.text = @"元";
//        [imageview addSubview:label2];
//
//        UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(imageview.frame.size.width-imageview.frame.size.width/5.5, 0, imageview.frame.size.width/5.5, 86)];
//        [imageview addSubview:backview];
////        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake((imageview.frame.size.width/5.5-50)/2, 0, 50, 86)];
////        label3.textColor = [UIColor whiteColor];
////        label3.numberOfLines = 2;
////        label3.textAlignment = NSTextAlignmentCenter;
////        label3.font = [UIFont boldSystemFontOfSize:15];
////        label3.text = @"立即使用";
////        [backview addSubview:label3];
//
//        UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(label2.frame.size.width+label2.frame.origin.x+35, 15, imageview.frame.size.width-label2.frame.size.width-backview.frame.size.width-label2.frame.origin.x-35, 15)];
//        label4.font = [UIFont boldSystemFontOfSize:16];
//        label4.textColor = [UIColor whiteColor];
//        label4.text = [[_DataArr objectAtIndex:indexPath.row-1] objectForKey:@"name"];
//        [imageview addSubview:label4];
//
//        UIView *circle1 = [[UIView alloc] initWithFrame:CGRectMake(label2.frame.size.width+label2.frame.origin.x+35, label4.frame.size.height+label4.frame.origin.y+10+3, 4, 4)];
//        circle1.layer.masksToBounds = YES;
//        circle1.layer.cornerRadius = 2;
//        circle1.backgroundColor = [UIColor whiteColor];
//        [imageview addSubview:circle1];
//        UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(label2.frame.size.width+label2.frame.origin.x+35+5, label4.frame.size.height+label4.frame.origin.y+10, imageview.frame.size.width-label2.frame.size.width-backview.frame.size.width-label2.frame.origin.x-35-5 ,10)];
//        label5.font = [UIFont systemFontOfSize:13];
//        label5.textColor = [UIColor whiteColor];
//        label5.text = [[_DataArr objectAtIndex:indexPath.row-1] objectForKey:@"condition"];
//        label5.alpha = 0.6;
//        [imageview addSubview:label5];
//
//
//        UIView *circle2 = [[UIView alloc] initWithFrame:CGRectMake(label2.frame.size.width+label2.frame.origin.x+25, label5.frame.size.height+label5.frame.origin.y+10+3, 4, 4)];
//        circle2.layer.masksToBounds = YES;
//        circle2.layer.cornerRadius = 2;
//        circle2.backgroundColor = [UIColor whiteColor];
//        [imageview addSubview:circle2];
//        UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(label2.frame.size.width+label2.frame.origin.x+35+5, label5.frame.size.height+label5.frame.origin.y+10, imageview.frame.size.width-label2.frame.size.width-backview.frame.size.width-label2.frame.origin.x-35-5, 10)];
//        label6.font = [UIFont systemFontOfSize:13];
//        label6.alpha = 0.6;
//        label6.textColor = [UIColor whiteColor];
//
//        NSTimeInterval interval    =[[[_DataArr objectAtIndex:indexPath.row-1] objectForKey:@"endtime"] doubleValue];
//        NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
//
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"yyyy-MM-dd"];
//        NSString *dateString       = [formatter stringFromDate: date];
//        label6.text = @"已使用";
//        [imageview addSubview:label6];
    if (indexPath.row==0) {
        cell.textLabel.text = @"您已使用的优惠券";
    }else{
        if ([[[_DataArr objectAtIndex:indexPath.row-1] objectForKey:@"utype"] isEqualToString:@"1"]) {
            UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, Main_width-30, 102.5)];
            imageview.image = [UIImage imageNamed:@"jilu2"];
            [cell.contentView addSubview:imageview];
            
            UIImageView *imageview1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, imageview.frame.size.width/3.77-40, 86-40)];
            NSString *imgstr1 = [[_DataArr objectAtIndex:indexPath.row-1] objectForKey:@"photo"];
            NSString *imgurl1 = [API_img stringByAppendingString:imgstr1];
            [imageview1 sd_setImageWithURL:[NSURL URLWithString:imgurl1]];
            imageview1.userInteractionEnabled = YES;
            imageview1.clipsToBounds = YES;
            imageview1.contentMode = UIViewContentModeScaleAspectFill;
            [imageview addSubview:imageview1];
            
            NSString *amount = [[_DataArr objectAtIndex:indexPath.row-1] objectForKey:@"amount"];
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
            label4.text = [[_DataArr objectAtIndex:indexPath.row-1] objectForKey:@"name"];
            [imageview addSubview:label4];
            
            UIView *circle1 = [[UIView alloc] initWithFrame:CGRectMake(imageview.frame.size.width/3.77+25, label4.frame.size.height+label4.frame.origin.y+10+3, 4, 4)];
            circle1.layer.masksToBounds = YES;
            circle1.layer.cornerRadius = 2;
            circle1.backgroundColor = [UIColor whiteColor];
            [imageview addSubview:circle1];
            UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(imageview.frame.size.width/3.77+25+5, label4.frame.size.height+label4.frame.origin.y+10,  imageview.frame.size.width-imageview.frame.size.width/3.77*2-30,10)];
            label5.font = [UIFont systemFontOfSize:13];
            label5.textColor = [UIColor whiteColor];
            label5.text = [[_DataArr objectAtIndex:indexPath.row-1] objectForKey:@"condition"];
            label5.alpha = 0.6;
            [imageview addSubview:label5];
            
            UILabel *timelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 102.5-22.5, Main_width/5*3, 22.5)];
            NSTimeInterval interval    =[[[_DataArr objectAtIndex:indexPath.row-1] objectForKey:@"endtime"] doubleValue];
            NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *dateString       = [formatter stringFromDate: date];
            timelabel.textColor = [UIColor blackColor];
            timelabel.font = [UIFont systemFontOfSize:12];
            timelabel.alpha = 0.4;
            timelabel.text = @"已使用";
            [imageview addSubview:timelabel];
        }else{
            UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, Main_width-30, 86)];
            imageview.image = [UIImage imageNamed:@"jilu1"];//ic_red_bg
            [cell.contentView addSubview:imageview];
            
            int i = [[[_DataArr objectAtIndex:indexPath.row-1] objectForKey:@"amount"] intValue];
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
            label4.text = [[_DataArr objectAtIndex:indexPath.row-1] objectForKey:@"name"];
            [imageview addSubview:label4];
            
            UIView *circle1 = [[UIView alloc] initWithFrame:CGRectMake(label2.frame.size.width+label2.frame.origin.x+35, label4.frame.size.height+label4.frame.origin.y+10+3, 4, 4)];
            circle1.layer.masksToBounds = YES;
            circle1.layer.cornerRadius = 2;
            circle1.backgroundColor = [UIColor whiteColor];
            [imageview addSubview:circle1];
            UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(label2.frame.size.width+label2.frame.origin.x+35+5, label4.frame.size.height+label4.frame.origin.y+10, imageview.frame.size.width-label2.frame.size.width-backview.frame.size.width-label2.frame.origin.x-35-5 ,10)];
            label5.font = [UIFont systemFontOfSize:13];
            label5.textColor = [UIColor whiteColor];
            label5.text = [[_DataArr objectAtIndex:indexPath.row-1] objectForKey:@"condition"];
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
            
            NSTimeInterval interval    =[[[_DataArr objectAtIndex:indexPath.row-1] objectForKey:@"endtime"] doubleValue];
            NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *dateString       = [formatter stringFromDate: date];
            label6.text = @"已使用";
            [imageview addSubview:label6];
        }
    }
    return cell;
}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    youhuiquanxiangqingViewController *xiangqing = [[youhuiquanxiangqingViewController alloc] init];
////    xiangqing.id = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"id"];
////    xiangqing.c_id = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"c_id"];
////    xiangqing.status = @"2";
////    [self.navigationController pushViewController:xiangqing animated:YES];
//}
#pragma mark ------联网请求---
-(void)post
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    NSDictionary *dict = @{@"apk_token":uid_username,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"],@"hui_community_id":[user objectForKey:@"community_id"]};
    
    NSString *urlstr = [API stringByAppendingString:@"userCenter/coupon_over_40"];
    [manager POST:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _DataArr = [[NSMutableArray alloc] init];
        
        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            _DataArr = [responseObject objectForKey:@"data"];
        }else{
            _DataArr = nil;
            //[MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
        [_TableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
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
