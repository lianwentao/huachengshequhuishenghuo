//
//  GoodsDetailViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/11/22.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import <AFNetworking.h>
#import "UIImageView+WebCache.h"
#import "GouwucheViewController.h"
#import "LoginViewController.h"
#import "PurchaseCarAnimationTool.h"
#import "SuredingdanViewController.h"
#import "GuigeViewController.h"
#import "MBProgressHUD+TVAssistant.h"
#import "HalfCircleActivityIndicatorView.h"
#import "PrefixHeader.pch"
#import "scoreViewController.h"
#import "TimeLabel.h"
#import "CustomActivity.h"
#import "WXApi.h"
#import "WXApiManager.h"
#import <LinkedME_iOS/LinkedME.h>
#import <LinkedME_iOS/LMUniversalObject.h>
#import <LinkedME_iOS/LMLinkProperties.h>
#define screen_Width [UIScreen mainScreen].bounds.size.width
#define screen_Height [UIScreen mainScreen].bounds.size.height


static NSString * LINKEDME_SHORT_URL;
@interface GoodsDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView *_TableView;
    NSMutableDictionary *_DataDic;
    NSMutableArray *_Dataarr;
    NSMutableArray *_scoreArr;
    UIImageView *imageview;
    UIButton *but;//购物车按钮
    UILabel *labelprice;
    
    UILabel *Label;  //商品规格
    
    NSString *blocktagname;
    NSString *blocknum;
    NSString *blocktagid;
    
    NSMutableDictionary *jiarugouwuchedict;
    
    NSString *jsonString;
    
    long _limit;
    
    UIImageView *redcountimage;
    
    NSMutableArray *heightArr;
    HalfCircleActivityIndicatorView *LoadingView;
    
    UIButton *backtopbut;
    
    NSString *wupinprice;
    
    NSString *shaopcate_id;
    
    NSInteger secondsCountDown;//倒计时总时长
    NSTimer *countDownTimer;
    UILabel *daylabel;
    UILabel *hourslabel;
    UILabel *mlabel;
    UILabel *slabel;
}
@property (nonatomic ,strong) UIView *deliverView; //底部View
@property (nonatomic ,strong) UIView *BGView; //遮罩
@property (strong, nonatomic) LMUniversalObject *linkedUniversalObject;

@end


@implementation GoodsDetailViewController{
    BOOL deepLinking;
    NSInteger page;
    NSString *title;
    NSArray *arr;
    NSString * H5_LIVE_URL;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",_IDstring);
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    [self post];
    [self LoadingView];
    [LoadingView startAnimating];
    //修改系统导航栏下一个界面的返回按钮title
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    if ([_jpushstring isEqualToString:@"jpush"]) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gouwuchedonbghua) name:@"jiarugouwuchedonghua" object:nil];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_share"] style:UIBarButtonItemStylePlain target:self action:@selector(shareview)];
    
    
    // Do any additional setup after loading the view.
}
- (void)back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)LoadingView
{
    LoadingView = [[HalfCircleActivityIndicatorView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-40)/2, (self.view.frame.size.height-40)/2, 40, 40)];
    
    [self.view addSubview:LoadingView];
}
- (void)lijigoumai
{
    
    [self lijigoumaipost];
}
- (void)gouwuchedonbghua
{
    
    [self post1];
    [[PurchaseCarAnimationTool shareTool]startAnimationandView:imageview andRect:imageview.frame andFinisnRect:CGPointMake(50, ScreenHeight-49) andFinishBlock:^(BOOL finisn){
        UIView *tabbarBtn = but;
        [PurchaseCarAnimationTool shakeAnimation:tabbarBtn];
    }];
    
}

#pragma mark - 创建底部VIEW
- (void)CreateView
{
    
    NSLog(@"timeout*******%@",_timeout);
    if ([shaopcate_id isEqualToString:@"1"]) {
        if ([_timeout isEqualToString:@"0"]) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-64, self.view.frame.size.width, 64)];
            view.backgroundColor = HColor(244, 247, 248);
            [self.view addSubview:view];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screen_Width, 64)];
            label.text = @"活动即将开始";
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:20];
            [view addSubview:label];
        }else if ([_timeout isEqualToString:@"2"]){
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-64, self.view.frame.size.width, 64)];
            view.backgroundColor = HColor(244, 247, 248);
            [self.view addSubview:view];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screen_Width, 64)];
            label.text = @"活动已结束";
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:20];
            [view addSubview:label];
        } else{
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-64, self.view.frame.size.width, 64)];
            view.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:view];
            
            NSArray *arr = [[NSArray alloc] initWithObjects:@"立即购买",@"加入购物车", nil];
            NSArray *arr1 = [[NSArray alloc] initWithObjects:QIColor,[UIColor whiteColor], nil];
            NSArray *arr2 = [[NSArray alloc] initWithObjects:[UIColor whiteColor],[UIColor blackColor], nil];
            NSArray *arr3 = [[NSArray alloc] initWithObjects:QIColor,[UIColor blackColor], nil];
            for (int i=2; i>0; i--) {
                UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
                but.frame = CGRectMake(self.view.frame.size.width-(self.view.frame.size.width/4+10)*i, 10, self.view.frame.size.width/4, 44);
                [but setTitle:[arr objectAtIndex:i-1] forState:UIControlStateNormal];
                but.layer.cornerRadius = 8;
                [but.layer setBorderWidth:1];
                [but.titleLabel setFont:[UIFont systemFontOfSize:13]];
                but.backgroundColor = [arr1 objectAtIndex:i-1];
                but.tag=i;
                [but addTarget:self action:@selector(butclick:) forControlEvents:UIControlEventTouchUpInside];
                [but setTitleColor:[arr2 objectAtIndex:i-1] forState:UIControlStateNormal];
                [but.layer setBorderColor:[[arr3 objectAtIndex:i-1]CGColor]];
                [view addSubview:but];
            }
            but = [UIButton buttonWithType:UIButtonTypeCustom];
            but.frame = CGRectMake(30, 15, 34, 34);
            [but setImage:[UIImage imageNamed:@"gouwuche"] forState:UIControlStateNormal];
            [but addTarget:self action:@selector(pushgouwuche) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:but];
            
            redcountimage = [[UIImageView alloc] initWithFrame:CGRectMake(61, 18, 6, 6)];
            redcountimage.layer.masksToBounds = YES;
            redcountimage.layer.cornerRadius = 3;
            redcountimage.backgroundColor = [UIColor redColor];
            redcountimage.hidden = YES;
            [view addSubview:redcountimage];
        }
    }else{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-64, self.view.frame.size.width, 64)];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        
        NSArray *arr = [[NSArray alloc] initWithObjects:@"立即购买",@"加入购物车", nil];
        NSArray *arr1 = [[NSArray alloc] initWithObjects:QIColor,[UIColor whiteColor], nil];
        NSArray *arr2 = [[NSArray alloc] initWithObjects:[UIColor whiteColor],[UIColor blackColor], nil];
        NSArray *arr3 = [[NSArray alloc] initWithObjects:QIColor,[UIColor blackColor], nil];
        for (int i=2; i>0; i--) {
            UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
            but.frame = CGRectMake(self.view.frame.size.width-(self.view.frame.size.width/4+10)*i, 10, self.view.frame.size.width/4, 44);
            [but setTitle:[arr objectAtIndex:i-1] forState:UIControlStateNormal];
            but.layer.cornerRadius = 8;
            [but.layer setBorderWidth:1];
            [but.titleLabel setFont:[UIFont systemFontOfSize:13]];
            but.backgroundColor = [arr1 objectAtIndex:i-1];
            but.tag=i;
            [but addTarget:self action:@selector(butclick:) forControlEvents:UIControlEventTouchUpInside];
            [but setTitleColor:[arr2 objectAtIndex:i-1] forState:UIControlStateNormal];
            [but.layer setBorderColor:[[arr3 objectAtIndex:i-1]CGColor]];
            [view addSubview:but];
        }
        but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(30, 15, 34, 34);
        [but setImage:[UIImage imageNamed:@"gouwuche"] forState:UIControlStateNormal];
        [but addTarget:self action:@selector(pushgouwuche) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:but];
        
        redcountimage = [[UIImageView alloc] initWithFrame:CGRectMake(61, 18, 6, 6)];
        redcountimage.layer.masksToBounds = YES;
        redcountimage.layer.cornerRadius = 3;
        redcountimage.backgroundColor = [UIColor redColor];
        redcountimage.hidden = YES;
        [view addSubview:redcountimage];
    }
}
- (void)butclick:(UIButton *)sender
{
    NSString *exitshours = [NSString stringWithFormat:@"%@",[_DataDic objectForKey:@"exist_hours"]];
    NSString *kucun = [NSString stringWithFormat:@"%@",[_DataDic objectForKey:@"inventory"]];
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSString *str = [userinfo objectForKey:@"token"];
    if (str==nil) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self presentViewController:login animated:YES completion:nil];
    }else if ([exitshours isEqualToString:@"2"]){
        [MBProgressHUD showToastToView:self.view withText:@"当前时间不在配送时间范围内"];
    }else if ([kucun isEqualToString:@"0"]){
        [MBProgressHUD showToastToView:self.view withText:@"库存不足"];
    } else{
        if (blocktagname==nil) {
            GuigeViewController *guige = [[GuigeViewController alloc] init];
            
            //赋值Block，并将捕获的值赋值给UILabel
            guige.returnValueBlock = ^(NSString *passedValue,NSString *num,NSString*tagid,long limmit,NSString *price){
                Label.text = [NSString stringWithFormat:@"已选 %@ X%@",passedValue,num];
                blocktagname = passedValue;
                blocknum = num;
                blocktagid  = tagid;
                _limit = limmit;
                wupinprice = price;
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lijigoumai) name:@"lijigoumai" object:nil];
                NSLog(@"%@--%@--%@--%@",blocktagname,blocktagid,blocknum,price);
            };
            
            guige.tagidstring = [_DataDic objectForKey:@"tagid"];
            guige.IDstring = _IDstring;
            guige.tag = [NSString stringWithFormat:@"%ld",sender.tag];
            guige.cunkunstring = [_DataDic objectForKey:@"inventory"];
            guige.image = imageview.image;
            guige.pricestring = [_DataDic objectForKey:@"price"];
            [self.navigationController pushViewController:guige animated:YES];
        }else{
            long ssssss = [blocknum longLongValue];
            if (ssssss==0) {
                [MBProgressHUD showToastToView:self.view withText:@"商品规格不能为0"];
            }else{
                _limit = _limit-ssssss;
                if (_limit<=0) {
                    [MBProgressHUD showToastToView:self.view withText:@"限购次数已到"];
                }else{
                    if (sender.tag == 2) {
                        [self post1];
                        [[PurchaseCarAnimationTool shareTool]startAnimationandView:imageview andRect:imageview.frame andFinisnRect:CGPointMake(50, ScreenHeight-49) andFinishBlock:^(BOOL finisn){
                            UIView *tabbarBtn = but;
                            [PurchaseCarAnimationTool shakeAnimation:tabbarBtn];
                        }];
                        
                    }else{
                        [self lijigoumaipost];
                    }
                    
                }
            }
            }
        }
}
- (void)lijigoumaipost
{
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    [jiarugouwuchedict setObject:blocknum forKey:@"number"];
    [jiarugouwuchedict setObject:blocktagid forKey:@"tagid"];
    [jiarugouwuchedict setObject:[_DataDic objectForKey:@"title"] forKey:@"p_title"];
    NSString *oneprice = wupinprice;
    float pri = [oneprice floatValue];
    [jiarugouwuchedict setObject:[NSString stringWithFormat:@"%.2f",pri*([blocknum intValue])] forKey:@"price"];
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    [arr addObject:jiarugouwuchedict];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@******%@",jiarugouwuchedict,wupinprice);
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[userinfo objectForKey:@"uid"],[userinfo objectForKey:@"username"]]];
    NSString *price = [jiarugouwuchedict objectForKey:@"price"];
    NSDictionary *dict = @{@"m_id":[userinfo objectForKey:@"community_id"],@"para_amount":price,@"products":jsonString,@"apk_token":uid_username,@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"]};
    NSString *strurl = [API stringByAppendingString:@"shop/submit_order_before"];
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *status = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]];
        if ([status isEqualToString:@"1"]) {
            SuredingdanViewController *sure = [[SuredingdanViewController alloc] init];
            sure.Dic = [responseObject objectForKey:@"data"];
            sure.jsonstring = jsonString;
            [self.navigationController pushViewController:sure animated:YES];
            
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"lijigoumai" object:nil];
        }else{
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
        
        //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
#pragma mark - push到购物车
- (void)pushgouwuche
{
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSString *str = [userinfo objectForKey:@"token"];
    if (str==nil) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self presentViewController:login animated:YES completion:nil];
    }else{
        
        GouwucheViewController *gouwuche = [[GouwucheViewController alloc] init];
        gouwuche.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:gouwuche animated:YES];
    }
}
#pragma mark - 创建tableview
- (void)CreateTableview
{
    _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, RECTSTATUS.size.height+44, self.view.bounds.size.width, self.view.bounds.size.height-RECTSTATUS.size.height-44-64)];
    //_TableView.estimatedRowHeight = 0;
    _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _TableView.delegate = self;
    _TableView.dataSource = self;
    [self.view addSubview:_TableView];
    backtopbut = [UIButton buttonWithType:UIButtonTypeCustom];
    backtopbut.frame = CGRectMake(screen_Width-60, screen_Height-64-70, 50, 50);
    [backtopbut addTarget:self action:@selector(backtop) forControlEvents:UIControlEventTouchUpInside];
    [backtopbut setImage:[UIImage imageNamed:@"bt_top"] forState:UIControlStateNormal];
    [self.view addSubview:backtopbut];
    
}
- (void)backtop
{
    [_TableView setContentOffset:CGPointMake(0,0) animated:YES];
}
#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 9;
    }else if (section==1){
        return 2;
    }else if (section==3){
        if (![_scoreArr isKindOfClass:[NSArray class]]) {
            return 1;
        }else{
            return _scoreArr.count+1;
        }
        
    } else{
        return heightArr.count+1;
    }
}

// 分组的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
//headview的高度和内容
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }else{
        return 0;
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @" ";
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"  ";
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"-+-+-+-+%@",_DataDic);
    static NSString *cellIndetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
    }
    NSLog(@"yyyy---%f",_TableView.contentOffset.y);
    if (_TableView.contentOffset.y>screen_Height) {
        backtopbut.hidden = NO;
    }else{
        backtopbut.hidden = YES;
    }
    if (_DataDic!=nil) {
        if (indexPath.section==0) {
            if (indexPath.row==0) {
                tableView.rowHeight = screen_Width;
                imageview = [[UIImageView alloc] init];
                imageview.frame = CGRectMake(0, 0, self.view.frame.size.width, screen_Width);
                NSString *strurl = [API_img stringByAppendingString:[_DataDic objectForKey:@"title_img"]];
                [imageview sd_setImageWithURL:[NSURL URLWithString: strurl]];
                [cell.contentView addSubview:imageview];
                
                
                
            }if(indexPath.row==1){
                UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_width, 55)];
                backview.backgroundColor = QIColor;
                
                
                UIImageView *imageview1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 60, 15)];
                imageview1.image = [UIImage imageNamed:@"bg_timelimit"];
                [backview addSubview:imageview1];
                UILabel *label1 = [[UILabel alloc] init];
                label1.frame = imageview1.frame;
                label1.font = [UIFont systemFontOfSize:12];
                label1.text = @"限时抢购";
                label1.textColor = [UIColor whiteColor];
                [backview addSubview:label1];
                
                UIImageView *imageview2 = [[UIImageView alloc] initWithFrame:CGRectMake(Main_width-160, 0, 160, 55)];
                imageview2.image = [UIImage imageNamed:@"bg_timelimit_interval"];
                
                
                UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, Main_width-150, 30)];
                label2.font = font15;
                label2.text = @"火热进行中,快来抢购,先到先得";
                label2.textAlignment = NSTextAlignmentCenter;
                label2.textColor = [UIColor whiteColor];
                [backview addSubview:label2];
                
                UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 140, 20)];
                NSMutableAttributedString *attri;
                [imageview2 addSubview:label3];
                
                if ([[_DataDic objectForKey:@"shop_cate_stime"] integerValue]-time(NULL)>0) {
                    secondsCountDown = [[_DataDic objectForKey:@"shop_cate_stime"] integerValue]-time(NULL);//倒计时秒数
                    
                    attri = [[NSMutableAttributedString alloc] initWithString:@"距开始还剩"];
                }else if ([[_DataDic objectForKey:@"shop_cate_etime"] integerValue]-time(NULL)<0){
                    secondsCountDown = time(NULL)-[[_DataDic objectForKey:@"shop_cate_etime"] integerValue];//已结束
                }else{
                    secondsCountDown = [[_DataDic objectForKey:@"shop_cate_etime"] integerValue]-time(NULL);
                    attri = [[NSMutableAttributedString alloc] initWithString:@"距结束还剩"];
                }
                
                NSTextAttachment *attch = [[NSTextAttachment alloc] init];
                attch.image = [UIImage imageNamed:@"shijian"];
                attch.bounds = CGRectMake(0, -3, 15, 15);
                NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
                [attri insertAttributedString:string atIndex:0];
                label3.attributedText = attri;
                label3.textColor = [UIColor whiteColor];
                label3.textAlignment = NSTextAlignmentRight;
                label3.font = [UIFont systemFontOfSize:14];
                
                countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES]; //启动倒计时后会每秒钟调用一次方法 countDownAction
                //设置倒计时显示的时间
                NSString *str_day = [NSString stringWithFormat:@"%ld",secondsCountDown/3600/24];
                NSString *str_hour = [NSString stringWithFormat:@"%ld",secondsCountDown/3600%24];//时
                NSString *str_minute = [NSString stringWithFormat:@"%ld",(secondsCountDown%3600)/60];//分
                NSString *str_second = [NSString stringWithFormat:@"%ld",secondsCountDown%60];//秒
                
                daylabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 30, 20, 20)];
                daylabel.backgroundColor = [UIColor whiteColor];
                daylabel.layer.masksToBounds = YES;
                daylabel.layer.cornerRadius = 3;
                daylabel.textColor = QIColor;
                daylabel.textAlignment = NSTextAlignmentCenter;
                daylabel.text = str_day;
                daylabel.font = [UIFont systemFontOfSize:12];
                
                UILabel *labelmaohao = [[UILabel alloc] initWithFrame:CGRectMake(60, 30, 10, 20)];
                labelmaohao.text = @":";
                labelmaohao.textColor = [UIColor whiteColor];
                labelmaohao.textAlignment = NSTextAlignmentCenter;
                labelmaohao.font = [UIFont systemFontOfSize:12];
                
                hourslabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 30, 20, 20)];
                hourslabel.backgroundColor = [UIColor whiteColor];
                hourslabel.layer.masksToBounds = YES;
                hourslabel.layer.cornerRadius = 3;
                hourslabel.textColor = QIColor;
                hourslabel.textAlignment = NSTextAlignmentCenter;
                hourslabel.text = str_hour;
                hourslabel.font = [UIFont systemFontOfSize:12];
                
                UILabel *labelmaohao1 = [[UILabel alloc] initWithFrame:CGRectMake(90, 30, 10, 20)];
                labelmaohao1.text = @":";
                labelmaohao1.textColor = [UIColor whiteColor];
                labelmaohao1.textAlignment = NSTextAlignmentCenter;
                labelmaohao1.font = [UIFont systemFontOfSize:12];
                
                mlabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 30, 20, 20)];
                mlabel.backgroundColor = [UIColor whiteColor];
                mlabel.text = str_minute;
                mlabel.layer.masksToBounds = YES;
                mlabel.layer.cornerRadius = 3;
                mlabel.font = [UIFont systemFontOfSize:12];
                mlabel.textColor = QIColor;
                mlabel.textAlignment = NSTextAlignmentCenter;
                
                UILabel *labelmaohao2 = [[UILabel alloc] initWithFrame:CGRectMake(120, 30, 10, 20)];
                labelmaohao2.text = @":";
                labelmaohao2.textColor = [UIColor whiteColor];
                labelmaohao2.textAlignment = NSTextAlignmentCenter;
                labelmaohao2.font = [UIFont systemFontOfSize:12];
                
                slabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 30, 20, 20)];
                slabel.backgroundColor = [UIColor whiteColor];
                slabel.font = [UIFont systemFontOfSize:12];
                slabel.text = str_second;
                slabel.textAlignment = NSTextAlignmentCenter;
                slabel.layer.cornerRadius = 3;
                slabel.layer.masksToBounds = YES;
                slabel.textColor = QIColor;
                
                [imageview2 addSubview:daylabel];
                [imageview2 addSubview:hourslabel];
                [imageview2 addSubview:slabel];
                [imageview2 addSubview:mlabel];
                [imageview2 addSubview:labelmaohao];
                [imageview2 addSubview:labelmaohao1];
                [imageview2 addSubview:labelmaohao2];
                
                long hour = secondsCountDown/3600%24;
                NSLog(@"hour--%ld--%ld--%ld",hour,[[_DataDic objectForKey:@"shop_cate_stime"] integerValue],time(NULL));
                [backview addSubview:imageview2];
                
                NSString *istime = [NSString stringWithFormat:@"%@",[_DataDic objectForKey:@"discount"]];
                if ([istime isEqualToString:@"1"]) {
                    [cell.contentView addSubview:backview];
                    tableView.rowHeight = 55;
                }else{
                    tableView.rowHeight = 0;
                }
            } if (indexPath.row==2) {
                tableView.rowHeight = 50;
                labelprice = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width/3, 40)];
                labelprice.font = [UIFont boldSystemFontOfSize:24];
                NSString *str = [@"¥" stringByAppendingString:[_DataDic objectForKey:@"price"]];
                labelprice.text = str;
                labelprice.textColor = QIColor;
                [cell.contentView addSubview:labelprice];
                
                UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10+self.view.bounds.size.width/3+10, 10, self.view.bounds.size.width/4, 40)];
                label2.text = [NSString stringWithFormat:@"¥%@",[_DataDic objectForKey:@"original"]];
                label2.font = [UIFont systemFontOfSize:15];
                label2.alpha = 0.5;
                [cell.contentView addSubview:label2];
                //中划线
                NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
                NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:label2.text attributes:attribtDic];
                // 赋值
                label2.attributedText = attribtStr;
                
                UILabel *label3 =[[UILabel alloc] initWithFrame:CGRectMake(screen_Width*3/4-20, 10, self.view.bounds.size.width/4, 40)];
                label3.text = [NSString stringWithFormat:@"剩余:%@%@",[_DataDic objectForKey:@"inventory"],[_DataDic objectForKey:@"unit"]];
                label3.alpha = 0.5;
                label3.textAlignment = NSTextAlignmentRight;             
                label3.font = [UIFont systemFontOfSize:15];
                [cell.contentView addSubview:label3];
            }if (indexPath.row==3) {
                
                UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width, 0)];
                label1.font = [UIFont systemFontOfSize:16.5];
                label1.numberOfLines = 0;
                label1.text = [_DataDic objectForKey:@"title"];
                CGSize size = [label1 sizeThatFits:CGSizeMake(label1.frame.size.width, MAXFLOAT)];
                label1.frame = CGRectMake(label1.frame.origin.x, label1.frame.origin.y, label1.frame.size.width,            size.height);
                tableView.rowHeight = size.height+10;
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, size.height)];
                view.backgroundColor = [UIColor clearColor];
                [cell addSubview:view];
                [view addSubview:label1];
            }if (indexPath.row==5) {
                UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, screen_Width-20, 0)];
                label1.font = [UIFont systemFontOfSize:15];
                label1.numberOfLines = 0;
                label1.text = [_DataDic objectForKey:@"description"];
                label1.alpha = 0.5;
                CGSize size = [label1 sizeThatFits:CGSizeMake(label1.frame.size.width, MAXFLOAT)];
                label1.frame = CGRectMake(label1.frame.origin.x, label1.frame.origin.y, label1.frame.size.width,            size.height);
                tableView.rowHeight = size.height+10;
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_Width, size.height)];
                view.backgroundColor = [UIColor clearColor];
                [cell.contentView  addSubview:view];
                [view addSubview:label1];
            }if (indexPath.row==4) {
                UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width, 30)];
                label1.font = [UIFont systemFontOfSize:13];
                label1.backgroundColor = QIColor;
                label1.numberOfLines = 0;
                label1.text = [_DataDic objectForKey:@"send_shop"];
                label1.textColor = [UIColor whiteColor];
                label1.textAlignment = NSTextAlignmentCenter;
                CGSize size = [label1 sizeThatFits:CGSizeMake(label1.frame.size.width, MAXFLOAT)];
                label1.frame = CGRectMake(label1.frame.origin.x, label1.frame.origin.y, size.width+10, 30);
                label1.layer.cornerRadius = 5;
                [label1.layer setMasksToBounds:YES];
                [cell addSubview:label1];
                
                UILabel *timelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, Main_width-20, 20)];
                timelabel.text = @"当前时间不在配送时间范围内";
                timelabel.textColor = QIColor;
                timelabel.font = [UIFont systemFontOfSize:14];
                NSString *exitshours = [NSString stringWithFormat:@"%@",[_DataDic objectForKey:@"exist_hours"]];
                if ([exitshours isEqualToString:@"2"]) {
                    [cell.contentView addSubview:timelabel];
                    tableView.rowHeight = 70;
                }else{
                    tableView.rowHeight = 40;
                }
            }if (indexPath.row==6) {
                tableView.rowHeight = 0;
//                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, screen_Width-30, 65)];
//                label.layer.borderColor = [HColor(187, 187, 187)CGColor];
//                NSString *labelstring= @"此商品每笔销售，商品将捐赠1%到贫困小学";
//                NSMutableAttributedString *aString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",labelstring]];
//                [aString addAttribute:NSForegroundColorAttributeName value:QIColor range:NSMakeRange(13,2)];
//                label.font = [UIFont systemFontOfSize:15];
//                label.textAlignment = NSTextAlignmentCenter;
//                label.attributedText = aString;
//                label.layer.borderWidth = 0.5;
//                label.layer.masksToBounds = YES;
//                label.layer.cornerRadius = 5;
//                [cell.contentView addSubview:label];
//
//                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(screen_Width/2-50, 10, 100, 20)];
//                view.backgroundColor = [UIColor whiteColor];
//                [cell.contentView addSubview:view];
//                UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
//                label1.text = @"扶贫计划";
//                label1.backgroundColor = [UIColor whiteColor];
//                label1.alpha = 0.5;
//                label1.textAlignment = NSTextAlignmentCenter;
//                [view addSubview:label1];
            }if (indexPath.row==7) {
                tableView.rowHeight = 50;
                UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_width, 10)];
                lineview.backgroundColor = BackColor;
                [cell.contentView addSubview:lineview];
                NSMutableArray *arr = [_DataDic objectForKey:@"goods_tag"];
                for (int i=0; i<arr.count; i++) {
                    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10+i*self.view.frame.size.width/4, 17.5, 25, 25)];
                    NSString *strurl = [API_img stringByAppendingString:[[arr objectAtIndex:i] objectForKey:@"c_img"]];
                    [imageview sd_setImageWithURL:[NSURL URLWithString: strurl]];
                    [cell.contentView addSubview:imageview];
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12+25+self.view.frame.size.width/4*i, 17.5, self.view.frame.size.width/4-25, 25)];
                    label.font = [UIFont systemFontOfSize:13];
                    label.text = [[arr objectAtIndex:i] objectForKey:@"c_name"];
                    [cell.contentView addSubview:label];
                }
            }if (indexPath.row==8) {
                cell.backgroundColor = HColor(244, 247, 248);
                tableView.rowHeight = 10;
            }
        }if (indexPath.section==1) {
            if (indexPath.row==0) {
                tableView.rowHeight = 50;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
                Label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width, 40)];
                Label.text = @"选择商品规格";
                Label.font = [UIFont systemFontOfSize:15];
                [cell.contentView addSubview:Label];
                
                UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
                but.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
                but.backgroundColor = [UIColor clearColor];
                [but addTarget:self action:@selector(butguige) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:but];
            }else{
                cell.backgroundColor = HColor(244, 247, 248);
                tableView.rowHeight = 10;
            }
        }if (indexPath.section==2) {
            if (indexPath.row==0) {
                tableView.rowHeight = 44;
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
                label.text = @"   商品详情";
                [cell.contentView addSubview:label];
            }else{
                NSArray *arr = [_DataDic objectForKey:@"imgs"];
                if ([arr isKindOfClass:[NSArray class]]&&arr.count>0) {
                    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, screen_Width/([[heightArr objectAtIndex:indexPath.row-1] floatValue]))];
                    NSString *strurl = [API_img stringByAppendingString:[[arr objectAtIndex:indexPath.row-1] objectForKey:@"img"]];
                    [imageview sd_setImageWithURL:[NSURL URLWithString: strurl]];
                    [cell.contentView addSubview:imageview];
                    tableView.rowHeight = screen_Width/([[heightArr objectAtIndex:indexPath.row-1] floatValue]);
                    NSLog(@"%@",[heightArr objectAtIndex:indexPath.row-1]);
                }
            }
        }if (indexPath.section==3) {
            if ([_scoreArr isKindOfClass:[NSArray class]]) {
                if (indexPath.row==0) {
                    tableView.rowHeight = 55;
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, screen_Width-30-50, 54)];
                    label.text = @"商品评价";
                    [cell.contentView addSubview:label];
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 54, screen_Width, 0.5)];
                    view.alpha = 0.2;
                    view.backgroundColor = [UIColor blackColor];
                    [cell.contentView addSubview:view];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
                } else{
                    
                    UILabel *namelabel = [[UILabel alloc] initWithFrame:CGRectMake(screen_Width/2, 10, screen_Width/2-15, 25)];
                    namelabel.text = [[_scoreArr objectAtIndex:indexPath.row-1] objectForKey:@"username"];
                    namelabel.font = [UIFont systemFontOfSize:12];
                    namelabel.textAlignment = NSTextAlignmentRight;
                    [cell.contentView addSubview:namelabel];
                    
                    int i = [[[_scoreArr objectAtIndex:indexPath.row-1] objectForKey:@"score"] intValue];
                    for (int j = 0; j<i; j++) {
                        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15+j*35, 10, 20, 20)];
                        imageview.image = [UIImage imageNamed:@"circle_icon_xingxing_dianjihou"];
                        [cell.contentView addSubview:imageview];
                    }
                    
                    UILabel *labelcontent = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, screen_Width-30, 0)];
                    labelcontent.text = [[_scoreArr objectAtIndex:indexPath.row-1] objectForKey:@"description"];
                    labelcontent.font = [UIFont systemFontOfSize:15];
                    labelcontent.numberOfLines = 0;
                    CGSize size = [labelcontent sizeThatFits:CGSizeMake(labelcontent.frame.size.width, MAXFLOAT)];
                    labelcontent.frame = CGRectMake(labelcontent.frame.origin.x, labelcontent.frame.origin.y, labelcontent.frame.size.width,            size.height);
                    [cell.contentView addSubview:labelcontent];
                    
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 40+size.height+4, screen_Width, 0.5)];
                    view.alpha = 0.2;
                    view.backgroundColor = [UIColor blackColor];
                    [cell.contentView addSubview:view];
                    tableView.rowHeight = 40+size.height+5;
                    
                }
            }else{
                tableView.rowHeight=0;
            }
        }
    }
    return cell;
}
-(void) countDownAction{
    
    if ([[_DataDic objectForKey:@"shop_cate_stime"] integerValue]-time(NULL)>0) {
        secondsCountDown = [[_DataDic objectForKey:@"shop_cate_stime"] integerValue]-time(NULL);//倒计时秒数
    }else if ([[_DataDic objectForKey:@"shop_cate_etime"] integerValue]-time(NULL)<0){
        secondsCountDown = time(NULL)-[[_DataDic objectForKey:@"shop_cate_etime"] integerValue];//已结束
    }else{
        secondsCountDown = [[_DataDic objectForKey:@"shop_cate_etime"] integerValue]-time(NULL);
        
    }
    NSString *str_day = [NSString stringWithFormat:@"%ld",secondsCountDown/3600/24];
    NSString *str_hour = [NSString stringWithFormat:@"%ld",secondsCountDown/3600%24];//时
    NSString *str_minute = [NSString stringWithFormat:@"%ld",(secondsCountDown%3600)/60];//分
    NSString *str_second = [NSString stringWithFormat:@"%ld",secondsCountDown%60];//秒
    //修改倒计时标签现实内容
    daylabel.text = str_day;
    hourslabel.text = str_hour;
    mlabel.text = str_minute;
    slabel.text = str_second;
    //当倒计时到0时，做需要的操作，比如验证码过期不能提交
    if(secondsCountDown==0){
        [countDownTimer invalidate];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==3) {
        if (indexPath.row==0) {
            scoreViewController *score = [[scoreViewController alloc] init];
            score.id = [_DataDic objectForKey:@"id"];
            [self.navigationController pushViewController:score animated:YES];
        }
    }
}
- (void)butguige
{
    NSString *exitshours = [NSString stringWithFormat:@"%@",[_DataDic objectForKey:@"exist_hours"]];
    NSString *kucun = [NSString stringWithFormat:@"%@",[_DataDic objectForKey:@"inventory"]];
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSString *str = [userinfo objectForKey:@"username"];
    if (str==nil) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self presentViewController:login animated:YES completion:nil];
    }else if ([exitshours isEqualToString:@"2"]){
        [MBProgressHUD showToastToView:self.view withText:@"当前时间不在配送时间范围内"];
    }else if ([kucun isEqualToString:@"0"]){
        [MBProgressHUD showToastToView:self.view withText:@"库存不足"];
    }else{
        if ([shaopcate_id isEqualToString:@"1"]) {
            if ([_timeout isEqualToString:@"2"]){
                [MBProgressHUD showToastToView:self.view withText:@"活动已结束"];
            }else if ([_timeout isEqualToString:@"0"]){
                [MBProgressHUD showToastToView:self.view withText:@"活动即将开始"];
            }else{
                GuigeViewController *guige = [[GuigeViewController alloc] init];
                
                //赋值Block，并将捕获的值赋值给UILabel
                guige.returnValueBlock = ^(NSString *passedValue,NSString *num,NSString*tagid,long limmit,NSString *price){
                    Label.text = [NSString stringWithFormat:@"已选 %@ X%@",passedValue,num];
                    blocktagname = passedValue;
                    //blocktagname = [_DataDic objectForKey:@"title"];
                    blocknum = num;
                    blocktagid  = tagid;
                    _limit = limmit;
                    wupinprice = price;
                    NSLog(@"%@--%@--%@--%@",blocktagname,blocktagid,blocknum,price);
                };
                
                guige.tagidstring = [_DataDic objectForKey:@"tagid"];
                guige.IDstring = _IDstring;
                guige.cunkunstring = [_DataDic objectForKey:@"inventory"];
                guige.image = imageview.image;
                guige.pricestring = [_DataDic objectForKey:@"price"];
                [self.navigationController pushViewController:guige animated:YES];
            }
        }else{
            GuigeViewController *guige = [[GuigeViewController alloc] init];
            
            //赋值Block，并将捕获的值赋值给UILabel
            guige.returnValueBlock = ^(NSString *passedValue,NSString *num,NSString*tagid,long limmit,NSString *price){
                Label.text = [NSString stringWithFormat:@"已选 %@ X%@",passedValue,num];
                blocktagname = passedValue;
                //blocktagname = [_DataDic objectForKey:@"title"];
                blocknum = num;
                blocktagid  = tagid;
                _limit = limmit;
                wupinprice = price;
                NSLog(@"%@--%@--%@--%@",blocktagname,blocktagid,blocknum,price);
            };
            
            guige.tagidstring = [_DataDic objectForKey:@"tagid"];
            guige.IDstring = _IDstring;
            guige.cunkunstring = [_DataDic objectForKey:@"inventory"];
            guige.image = imageview.image;
            guige.pricestring = [_DataDic objectForKey:@"price"];
            [self.navigationController pushViewController:guige animated:YES];
        }
    }
}
#pragma mark ------联网请求---
-(void)post{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    NSDictionary *dict = @{@"apk_token":uid_username,@"id":_IDstring};
    //3.发送GET请求
    /*
     第一个参数:请求路径(NSString)+ 不需要加参数
     第二个参数:发送给服务器的参数数据
     第三个参数:progress 进度回调
     第四个参数:success  成功之后的回调(此处的成功或者是失败指的是整个请求)
     task:请求任务
     responseObject:注意!!!响应体信息--->(json--->oc))
     task.response: 响应头信息
     第五个参数:failure 失败之后的回调
     */
    NSString *strurl = [API stringByAppendingString:@"shop/goods_details"];
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _DataDic = [[NSMutableDictionary alloc] init];
        _DataDic = [responseObject objectForKey:@"data"];
        NSLog(@"goods--%@",_DataDic);
        heightArr = [[NSMutableArray alloc] init];
        NSArray *arr = [[responseObject objectForKey:@"data"] objectForKey:@"imgs"];
        if ([arr isKindOfClass:[NSArray class]]&&arr.count>0) {
            for (int i=0; i<arr.count; i++) {
                NSString *height = [[arr objectAtIndex:i] objectForKey:@"img_size"];
                [heightArr addObject:height];
            }
        }
        _scoreArr = [[NSMutableArray alloc] init];
        if ([_scoreArr isKindOfClass:[NSArray class]]) {
            _scoreArr = [[responseObject objectForKey:@"data"] objectForKey:@"score"];
        }else{
            _scoreArr = nil;
        }
        NSLog(@"*******---%@",_DataDic);
//        long MMDDSSbefor = [[_DataDic objectForKey:@"shop_cate_stime"] integerValue];
//        long miaobefor = MMDDSSbefor-time(NULL);
//        if (miaobefor>0) {
//            _timeout = @"NO";
//        }else{
//            _timeout = @"YES";
//        }
        
        shaopcate_id = [NSString stringWithFormat:@"%@",[_DataDic objectForKey:@"discount"]];
        
        long MMDDSSbefor = [[_DataDic objectForKey:@"shop_cate_stime"] integerValue];
        long MMDDSSafter = [[_DataDic objectForKey:@"shop_cate_etime"] integerValue];
        long miaobefor = (MMDDSSbefor-time(NULL))%(60*60*24);
        long miaoafter = (MMDDSSafter - time(NULL))%(60*60*24);
        
        NSLog(@"date1时间戳 = %ld==%ld",miaobefor,miaoafter);
        if (MMDDSSafter == 0) {
            _timeout = @"1";
        }else{
            if (miaobefor>0) {
                _timeout = @"0";
            }if (miaobefor<0&&miaoafter>0) {
                _timeout = @"1";
            }if (miaoafter<0) {
                _timeout = @"2";
            }
        }
        NSLog(@"timeout--%@",_timeout);
        [self CreateView];
        self.title = [_DataDic objectForKey:@"title"];
        //blocktagname = [_DataDic objectForKey:@"title"];
        jiarugouwuchedict = [[NSMutableDictionary alloc] init];
        [jiarugouwuchedict setObject:[_DataDic objectForKey:@"id"] forKey:@"p_id"];
        [jiarugouwuchedict setObject:[_DataDic objectForKey:@"title"] forKey:@"p_title"];
        [jiarugouwuchedict setObject:[_DataDic objectForKey:@"title_img"] forKey:@"p_title_img"];
        [jiarugouwuchedict setObject:[_DataDic objectForKey:@"tagid"] forKey:@"tagid"];
        //[jiarugouwuchedict setObject:[_DataDic objectForKey:@"price"] forKey:@"price"];
        [LoadingView stopAnimating];
        LoadingView.hidden = YES;
        [self CreateTableview];
        [_TableView reloadData];
        [self postcount];
        NSLog(@"success--%@--%@",[responseObject class],responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"failure--%@",error);
    }];
}
-(void)post1{
    //1.创建会话管理者
    sleep(1);//未获取到代理返回的tagname，这里延迟一秒是为了获得返回的数据
    NSLog(@"blocktagname--%@",blocktagname);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:uid_username forKey:@"apk_token"];
    //
    [dict setObject:[user objectForKey:@"token"] forKey:@"token"];
    [dict setObject:[user objectForKey:@"tokenSecret"] forKey:@"tokenSecret"];
    [dict setObject:blocktagname forKey:@"tagname"];
    [dict setObject:blocknum forKey:@"number"];
    [dict setObject:[jiarugouwuchedict objectForKey:@"p_id"] forKey:@"p_id"];
    [dict setObject:[jiarugouwuchedict objectForKey:@"p_title"] forKey:@"p_title"];
    [dict setObject:[jiarugouwuchedict objectForKey:@"p_title_img"] forKey:@"p_title_img"];
    [dict setObject:blocktagid forKey:@"tagid"];
    [dict setObject:wupinprice forKey:@"price"];
    
    
    //3.发送GET请求
    /*
     第一个参数:请求路径(NSString)+ 不需要加参数
     第二个参数:发送给服务器的参数数据
     第三个参数:progress 进度回调
     第四个参数:success  成功之后的回调(此处的成功或者是失败指的是整个请求)
     task:请求任务
     responseObject:注意!!!响应体信息--->(json--->oc))
     task.response: 响应头信息
     第五个参数:failure 失败之后的回调
     */
    NSString *strurl = [API stringByAppendingString:@"shop/add_shopping_cart"];
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
    
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"jiarugouwuchedonghua" object:nil];
}
-(void)postcount
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    NSDictionary *dict = @{@"apk_token":uid_username,@"c_id":[user objectForKey:@"community_id"]};
    NSString *strurl = [API stringByAppendingString:@"shop/cart_num"];
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"gouwuche--%@",responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            NSString *cart_num = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"cart_num"]];
            if ([cart_num isEqualToString:@"0"]) {
                redcountimage.hidden = YES;
            }else{
                redcountimage.hidden = NO;
            }
        }
        [_TableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
- (void)shareview
{
    // ------全屏遮罩
    self.BGView                 = [[UIView alloc] init];
    self.BGView.frame           = [[UIScreen mainScreen] bounds];
    self.BGView.tag             = 100;
    self.BGView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    self.BGView.opaque = NO;
    
    //--UIWindow的优先级最高，Window包含了所有视图，在这之上添加视图，可以保证添加在最上面
    UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
    [appWindow addSubview:self.BGView];
    
    // ------给全屏遮罩添加的点击事件
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitClick)];
    gesture.numberOfTapsRequired = 1;
    gesture.cancelsTouchesInView = NO;
    [self.BGView addGestureRecognizer:gesture];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.BGView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        
    }];
    
    // ------底部弹出的View
    self.deliverView                 = [[UIView alloc] init];
    self.deliverView.frame           = CGRectMake(0, Main_Height-120, Main_width, 120);
    self.deliverView.backgroundColor = [UIColor whiteColor];
    [appWindow addSubview:self.deliverView];
    
    NSArray *arr = @[@"shortVideo_share_weixin",@"shortVideo_share_friend"];
    NSArray *labelarr = @[@"微信",@"朋友圈"];
    for (int i=0; i<2; i++) {
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(22.5+90*i, 15, 45, 45)];
        imageview.image = [UIImage imageNamed:[arr objectAtIndex:i]];
        [self.deliverView addSubview:imageview];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15+90*i, 75, 60, 10)];
        label.font = font15;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [labelarr objectAtIndex:i];
        [self.deliverView addSubview:label];
        
        UIButton *sharebut = [UIButton buttonWithType:UIButtonTypeCustom];
        sharebut.frame = CGRectMake(15+90*i, 15, 90, 90);
        //[sharebut setImage:[UIImage imageNamed:[arr objectAtIndex:i]] forState:UIControlStateNormal];
        sharebut.tag = i;
        [sharebut addTarget:self action:@selector(sharegoods:) forControlEvents:UIControlEventTouchUpInside];
        [self.deliverView addSubview:sharebut];
    }
    
    // ------View出现动画
    self.deliverView.transform = CGAffineTransformMakeTranslation(0.01, Main_width);
    [UIView animateWithDuration:0.3 animations:^{
        
        self.deliverView.transform = CGAffineTransformMakeTranslation(0.01, 0.01);
        
    }];
}
- (void)exitClick {
    
    NSLog(@"====");
    [UIView animateWithDuration:0.3 animations:^{
        
        self.deliverView.transform = CGAffineTransformMakeTranslation(0.01, Main_width);
        self.deliverView.alpha = 0.2;
        self.BGView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self.BGView removeFromSuperview];
        [self.deliverView removeFromSuperview];
    }];
    
}

//创建短链
-(void)addPara{
    
    H5_LIVE_URL = @"http://test.hui-shenghuo.cn/home/shop/goods_details/id/";
    
    self.linkedUniversalObject = [[LMUniversalObject alloc] init];
    self.linkedUniversalObject.title = [_DataDic objectForKey:@"title"];//标题
    LMLinkProperties *linkProperties = [[LMLinkProperties alloc] init];
    linkProperties.channel = @"";//渠道(微信,微博,QQ,等...)
    linkProperties.feature = @"Share";//特点
    linkProperties.tags=@[@"LinkedME",@"Demo"];//标签
    linkProperties.stage = @"Live";//阶段
    [linkProperties addControlParam:@"View" withValue:arr[page][@"url"]];//自定义参数，用于在深度链接跳转后获取该数据，这里代表页面唯一标识
    [linkProperties addControlParam:@"LinkedME" withValue:@"Demo"];//自定义参数，用于在深度链接跳转后获取该数据，这里标识是Demo
    //开始请求短链
    [self.linkedUniversalObject getShortUrlWithLinkProperties:linkProperties andCallback:^(NSString *url, NSError *err) {
        if (url) {
            NSLog(@"[LinkedME Info] SDK creates the url is:%@", url);
            //拼接连接
            [H5_LIVE_URL stringByAppendingString:arr[page][@"form"]];
            [H5_LIVE_URL stringByAppendingString:@"?linkedme="];
            H5_LIVE_URL = [NSString stringWithFormat:@"https://www.linkedme.cc/h5/%@?linkedme=",arr[page][@"form"]];
            //前面是Html5页面,后面拼上深度链接https://xxxxx.xxx (html5 页面地址) ?linkedme=(深度链接)
            //https://www.linkedme.cc/h5/feature?linkedme=https://lkme.cc/AfC/mj9H87tk7
            LINKEDME_SHORT_URL = [H5_LIVE_URL stringByAppendingString:url];
        } else {
            LINKEDME_SHORT_URL = H5_LIVE_URL;
        }
    }];
    NSLog(@"linke-------%@",LINKEDME_SHORT_URL);
    //[self sharegoods];
}
- (void)sharegoods:(UIButton *)sender
{
    WXMediaMessage *mediamessage = [WXMediaMessage message];
    mediamessage.title = [_DataDic objectForKey:@"title"];
    mediamessage.description = [_DataDic objectForKey:@"description"];
    NSString *urlString = [API_img stringByAppendingString:[_DataDic objectForKey:@"title_img"]];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:urlString]];
    UIImage *image = [UIImage imageWithData:data];

    [mediamessage setThumbImage:image];
    
    WXWebpageObject *webobj = [WXWebpageObject object];
    webobj.webpageUrl = [NSString stringWithFormat:@"http://test.hui-shenghuo.cn/home/shop/goods_details/id/%@?linkedme=https://lkme.cc/LQD/ONaD0BYuK&from=singlemessage",[_DataDic objectForKey:@"id"]];
    mediamessage.mediaObject =  webobj;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = mediamessage;
    if (sender.tag==0) {
        req.scene = WXSceneSession;
        NSLog(@"0");
    }else{
        NSLog(@"1");
        req.scene = WXSceneTimeline;//朋友圈
    }
    
    [WXApi sendReq:req];
    
//     //1、设置分享的内容，并将内容添加到数组中
//                NSString *shareText = [_DataDic objectForKey:@"title"];
//                UIImage *shareImage = [UIImage imageNamed:@"ic_order5"];
//                NSURL *shareUrl = [NSURL URLWithString:@"http://test.hui-shenghuo.cn/home/shop/goods_details/id/2792?linkedme=https://lkme.cc/LQD/ONaD0BYuK&from=singlemessage"];
//                NSArray *activityItemsArray = @[shareImage,shareUrl];
//
//                // 自定义的CustomActivity，继承自UIActivity
//                CustomActivity *customActivity = [[CustomActivity alloc]initWithTitle:@"wangsk" ActivityImage:[UIImage imageNamed:@"app_logo 5"] URL:[NSURL URLWithString:@"http://blog.csdn.net/flyingkuikui"] ActivityType:@"Custom"];
//                NSArray *activityArray = @[customActivity];
//
//                // 2、初始化控制器，添加分享内容至控制器
//                UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItemsArray applicationActivities:nil];
//                activityVC.modalInPopover = YES;
//                // 3、设置回调
//                if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
//                    // ios8.0 之后用此方法回调
//                    UIActivityViewControllerCompletionWithItemsHandler itemsBlock = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
//                        NSLog(@"activityType == %@",activityType);
//                        if (completed == YES) {
//                            NSLog(@"completed");
//                        }else{
//                            NSLog(@"cancel");
//                        }
//                    };
//                    activityVC.completionWithItemsHandler = itemsBlock;
//                }else{
//                    // ios8.0 之前用此方法回调
//                    UIActivityViewControllerCompletionHandler handlerBlock = ^(UIActivityType __nullable activityType, BOOL completed){
//                        NSLog(@"activityType == %@",activityType);
//                        if (completed == YES) {
//                            NSLog(@"completed");
//                        }else{
//                            NSLog(@"cancel");
//                        }
//                    };
//                    activityVC.completionHandler = handlerBlock;
//                }
//                // 4、调用控制器
//                [self presentViewController:activityVC animated:YES completion:nil];
}

@end
