//
//  activitydetailsViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/12/4.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import "activitydetailsViewController.h"
#import <AFNetworking.h>
#import "UIImageView+WebCache.h"
#import "TimeLabel.h"
#import "AllPayViewController.h"
#import "LoginViewController.h"
#import "MBProgressHUD+TVAssistant.h"
#import "HalfCircleActivityIndicatorView.h"
#import "WebViewJavascriptBridge.h"
#import "PrefixHeader.pch"
#define kScreen_Height   ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width    ([UIScreen mainScreen].bounds.size.width)
@interface activitydetailsViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,WKUIDelegate,WKNavigationDelegate>
{
    UITableView *_TableView;
    NSMutableDictionary *_Dic;
    NSMutableDictionary *diccccc;
    
    NSMutableArray *_DataArr;
    NSMutableArray *heightArr;
    
    UIButton *kefubut;
    UIButton *yudingbut;
    
    UITextField *userNameTextField;
    UITextField *passwordTextField;
    
    HalfCircleActivityIndicatorView *LoadingView;
    WKWebView *wkwebview;
}

@end

@implementation activitydetailsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self post];
    [self LoadingView];
    [LoadingView startAnimating];
    
    if ([_jpushstring isEqualToString:@"jpush"]) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    }
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
#pragma mark ------联网请求---
-(void)post
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    NSDictionary *dict = @{@"m_id":[user objectForKey:@"community_id"],@"apk_token":uid_username,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
    NSString *strurl = [API stringByAppendingString:_url];
    NSLog(@"----------------------------%@",strurl);
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        _Dic = [[NSMutableDictionary alloc] init];
        _DataArr = [[NSMutableArray alloc] init];
        
        if ([[responseObject objectForKey:@"status"] integerValue]==1){
            _Dic = [responseObject objectForKey:@"data"];
            diccccc = [[responseObject objectForKey:@"data"] objectForKey:@"introduction"];
//            _DataArr = [_Dic objectForKey:@"introduction"];diccccc
            self.title = [_Dic objectForKey:@"title"];
            
//            NSArray *arr = [NSArray array];
//            arr = [_Dic objectForKey:@"introduction"];
//            heightArr = [[NSMutableArray alloc] init];
//            for (int i=0; i < arr.count; i++) {
//                NSString *imgstr1 = [[arr objectAtIndex:i] objectForKey:@"img"];
//                NSString *imgurl1 = [API stringByAppendingString:imgstr1];
//                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgurl1]];
//                UIImage *image = [UIImage imageWithData:data];
//                NSLog(@"w = %.3f,h = %.3f",image.size.width,image.size.height);
//                //float j = image.size.width/kScreen_Width;
//                //float j = 1;
//                //NSLog(@"%@",imageview.image);
//                int height = image.size.height/(image.size.width/kScreen_Width);
//                NSLog(@"---%d",height);
//                [heightArr addObject:[NSString stringWithFormat:@"%d",height]];
//
//            }
            [LoadingView stopAnimating];
            LoadingView.hidden = YES;
            [self CreateTableview];
            [self CreateView];
        }else{
            _DataArr = nil;
            _Dic = nil;
        }
        NSNumber *pay = [_Dic objectForKey:@"pay_over"];
        NSString *pay_over = [NSString stringWithFormat:@"%@",pay];
        NSLog(@"---%@",pay_over);
        if ([pay_over isEqualToString:@"1"]) {
            [yudingbut setTitle:@"去支付" forState:UIControlStateNormal];
        }else if ([pay_over isEqualToString:@"2"]) {
            [yudingbut setTitle:@"已报名" forState:UIControlStateNormal];
        }else if ([pay_over isEqualToString:@"0"]){
            [yudingbut setTitle:@"预定" forState:UIControlStateNormal];
        }
        NSLog(@"heightarr-----%@",heightArr);
        
        [_TableView reloadData];
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
    NSDictionary *dict = @{@"community_id":[user objectForKey:@"community_id"],@"a_id":[_Dic objectForKey:@"id"],@"name":userNameTextField.text,@"phone":passwordTextField.text,@"cost":[_Dic objectForKey:@"cost"],@"apk_token":uid_username,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
    NSString *strurl = [API stringByAppendingString:@"activity/activity_enroll"];
    NSLog(@"----------------------------%@",strurl);
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1){
            AllPayViewController *allpay = [[AllPayViewController alloc] init];
            allpay.order_id = [[responseObject objectForKey:@"data"] objectForKey:@"order_id"];
            allpay.price = [_Dic objectForKey:@"cost"];
            allpay.type = @"aciti";
            allpay.c_id = [_Dic objectForKey:@"c_id"];
            if ([[_Dic objectForKey:@"cost"] integerValue]>0) {
                [self.navigationController pushViewController:allpay animated:YES];
            }else{
                
            }
            [self post];
            [_TableView reloadData];
        }else{
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
#pragma mark - 创建底部VIEW
- (void)CreateView
{
    long MMDDSSbefor = [[_Dic objectForKey:@"enroll_start"] integerValue];
    long MMDDSSafter = [[_Dic objectForKey:@"enroll_end"] integerValue];
    long miaobefor = (MMDDSSbefor-time(NULL))%(60*60*24);
    long miaoafter = (MMDDSSafter - time(NULL))%(60*60*24);
    
    NSLog(@"date1时间戳 = %ld==%ld",miaobefor,miaoafter);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-64, self.view.frame.size.width, 64)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    if (miaobefor>0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 64)];
        label.text = @"活动即将开始";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:20];
        [view addSubview:label];
    }if (miaobefor<0&&miaoafter>0) {
        kefubut = [UIButton buttonWithType:UIButtonTypeCustom];
        kefubut.frame = CGRectMake(10, 10, kScreen_Width/3, 44);
        NSMutableAttributedString *attri =  [[NSMutableAttributedString alloc] initWithString:@"客服"];
        
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        attch.image = [UIImage imageNamed:@"iv_activity_phone"];
        attch.bounds = CGRectMake(0, -5, 25, 25);
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
        [attri insertAttributedString:string atIndex:0];
        [kefubut setAttributedTitle:attri forState:UIControlStateNormal];
        kefubut.layer.cornerRadius = 5;
        [kefubut.layer setBorderWidth:1];
        kefubut.titleLabel.textColor = [UIColor blackColor];
        [kefubut.titleLabel setFont:[UIFont systemFontOfSize:20]];
        [kefubut addTarget:self action:@selector(butclick:) forControlEvents:UIControlEventTouchUpInside];
        kefubut.backgroundColor = [UIColor whiteColor];
        kefubut.tag=1;
        [view addSubview:kefubut];
        
        yudingbut = [UIButton buttonWithType:UIButtonTypeCustom];
        yudingbut.frame = CGRectMake(kScreen_Width*2/3-10, 10, kScreen_Width/3, 44);
        
        yudingbut.layer.cornerRadius = 5;
        [yudingbut.titleLabel setFont:[UIFont systemFontOfSize:20]];
        [yudingbut setBackgroundColor:QIColor];
        yudingbut.tag=2;
        [yudingbut addTarget:self action:@selector(butclick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:yudingbut];
    }if (miaoafter<0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 64)];
        label.text = @"活动已结束";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:20];
        [view addSubview:label];
    }
}
- (void)butclick:(UIButton *)sender
{
    if (sender.tag==1) {
        
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",[_Dic objectForKey:@"phone"]];
        UIWebView *callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    }else{
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        NSString *str = [userdefaults objectForKey:@"token"];
        if (str==nil) {
            LoginViewController *login = [[LoginViewController alloc] init];
            [self presentViewController:login animated:YES completion:nil];
        }else{
            NSNumber *pay = [_Dic objectForKey:@"pay_over"];
            NSString *pay_over = [NSString stringWithFormat:@"%@",pay];
            NSLog(@"---%@",pay_over);
            if ([pay_over isEqualToString:@"1"]) {
                AllPayViewController *allpay = [[AllPayViewController alloc] init];
                allpay.order_id = [_Dic objectForKey:@"order_id"];
                allpay.price = [_Dic objectForKey:@"cost"];
                allpay.type = @"aciti";
                allpay.c_id = [_Dic objectForKey:@"c_id"];
                NSLog(@"orderid---%@--%@",[_Dic objectForKey:@"order_id"],[_Dic objectForKey:@"cost"]);
                [self.navigationController pushViewController:allpay animated:YES];
            }else if ([pay_over isEqualToString:@"2"]) {
                //[yudingbut setTitle:@"已报名" forState:UIControlStateNormal];
            }else if ([pay_over isEqualToString:@"0"]){
                NSString *cost = [_Dic objectForKey:@"cost"];
                UIAlertController *alertController;
                if ([cost intValue]>0) {
                    alertController = [UIAlertController alertControllerWithTitle:@"信息确认" message:@"本次活动为付费内容,付款成功即报名成功" preferredStyle:UIAlertControllerStyleAlert];
                }else{
                    alertController = [UIAlertController alertControllerWithTitle:@"信息确认" message:@"本次活动免费" preferredStyle:UIAlertControllerStyleAlert];
                }
                
                //增加取消按钮；
                [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
                //增加确定按钮；
                [alertController addAction:[UIAlertAction actionWithTitle:@"支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //获取第1个输入框；
                    alertController.textFields.firstObject.frame = CGRectMake(0, 0, kScreen_Width-20, 50);
                    userNameTextField = alertController.textFields.firstObject;
                    //获取第2个输入框；
                    passwordTextField = alertController.textFields.lastObject;
                    
                    NSString *phoneNumber =passwordTextField.text;
                    
                    if(userNameTextField.text.length==0)
                    {
                        [MBProgressHUD showToastToView:self.view withText:@"请输入姓名"];
                    }else if (![self isValidateMobile:phoneNumber]){
                        [MBProgressHUD showToastToView:self.view withText:@"手机号格式错误"];
                    } else{
                      [self post1];
                    }
                    
                }]];
                
                
                
                //定义第一个输入框；
                [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    textField.placeholder = @"姓名";
                }];
                //定义第二个输入框；
                [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    textField.placeholder = @"电话";
                }];
                
                [self presentViewController:alertController animated:true completion:nil];
            }
        }
    }
}
/*手机号码验证 MODIFIED BY LYH*/
-(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex =@"^1[3,8]\\d{9}|14[5,7,9]\\d{8}|15[^4]\\d{8}|17[^2,4,9]\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

- (CGSize)getImageSizeWithURL:(NSURL *)url
{
    CGImageSourceRef imageSource = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    CGFloat width = 0.0f, height = 0.0f;
    
    if (imageSource)
    {
        CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, NULL);
        if (imageProperties != NULL)
        {
            CFNumberRef widthNum  = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelWidth);
            if (widthNum != NULL) {
                CFNumberGetValue(widthNum, kCFNumberFloatType, &width);
            }
            
            CFNumberRef heightNum = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
            if (heightNum != NULL) {
                CFNumberGetValue(heightNum, kCFNumberFloatType, &height);
            }
            
            CFRelease(imageProperties);
        }
        CFRelease(imageSource);
        NSLog(@"Image dimensions: %.0f x %.0f px", width, height);
    }
    return CGSizeMake(width, height);
}

#pragma mark - 创建tableview
- (void)CreateTableview
{
    _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, kScreen_Height-64-64)];
    //_TableView.estimatedRowHeight = 0;
    _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _TableView.delegate = self;
    _TableView.dataSource = self;
    [_TableView reloadData];
    [self.view addSubview:_TableView];
}
#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }else {
        return 2;
    }
}

// 分组的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
//headview的高度和内容
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
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

 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     if (indexPath.section==0) {
         return 115+kScreen_Width/(2.5)+10;
     }else{
         if (indexPath.row==0) {
             return 55;
         }else {
             
             UILabel *contentlabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, Main_width-25, 0)];
             contentlabel.numberOfLines = 0;
             NSString *base64 = [_Dic objectForKey:@"introduction"];
             NSLog(@"*************%@",base64);
//             NSData *data1 = [[NSData alloc] initWithBase64EncodedString:base64 options:0];
//             NSString *labeltext = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
             
             

            
            // NSString *html = [self autoWebAutoImageSize:base64];
             NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[base64 dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSFontAttributeName:[UIFont systemFontOfSize:16] } documentAttributes:nil error:nil];
             
             NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithAttributedString: attributedString];
             contentlabel.attributedText = string;
             //contentlabel.font = [UIFont systemFontOfSize:16];// weight:10
             CGSize size = [contentlabel sizeThatFits:CGSizeMake(Main_width-25, MAXFLOAT)];
             contentlabel.frame = CGRectMake(contentlabel.frame.origin.x, contentlabel.frame.origin.y, Main_width-25,  size.height);
             return contentlabel.frame.origin.y+contentlabel.frame.size.height+10;
             
         }
     }
 }
// 自适应尺寸大小
- (NSString *)autoWebAutoImageSize:(NSString *)html{
    
    NSString * regExpStr = @"<img\\s+.*?\\s+(style\\s*=\\s*.+?\")";
    NSRegularExpression *regex=[NSRegularExpression regularExpressionWithPattern:regExpStr options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray *matches=[regex matchesInString:html
                                    options:0
                                      range:NSMakeRange(0, [html length])];
    
    
    NSMutableArray * mutArray = [NSMutableArray array];
    for (NSTextCheckingResult *match in matches) {
        NSString* group1 = [html substringWithRange:[match rangeAtIndex:1]];
        [mutArray addObject: group1];
    }
    
    NSUInteger len = [mutArray count];
    for (int i = 0; i < len; i++) {
        html = [html stringByReplacingOccurrencesOfString:mutArray[i] withString: @"style=\"width:90%; height:auto;\""];
    }
    
    return html;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"-+-+-+-+%@",_DataDic);
    static NSString *cellIndetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        //cell.userInteractionEnabled = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
    }
    if (indexPath.section==0) {
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Width/(2.5))];
        NSString *image = [_Dic objectForKey:@"picture"];
        NSString *strurl = [NSString stringWithFormat:@"%@%@",API_img,image];
        [imageview sd_setImageWithURL:[NSURL URLWithString:strurl]];
        [cell.contentView addSubview:imageview];
        
        TimeLabel *timeLabel = [[TimeLabel alloc]  initWityFrame:CGRectMake(kScreen_Width/4, 17.5+kScreen_Width/(2.5), kScreen_Width/8*5, 20) type:TIME_HOUR_MINUTE_SECOND timeChange:^(NSInteger time) {
            //NSLog(@"%ld",(long)time);
        } timeEnd:^{
            NSLog(@"倒计时结束");
        }];
        [cell.contentView addSubview:timeLabel];
        
        long MMDDSSbefor = [[_Dic objectForKey:@"enroll_start"] integerValue];
        long MMDDSSafter = [[_Dic objectForKey:@"enroll_end"] integerValue];
        long miaobefor = (MMDDSSbefor-time(NULL))%(60*60*24);
        long miaoafter = (MMDDSSafter - time(NULL))%(60*60*24);
        
//        long MMDDSSbefor = [[_Dic objectForKey:@"enroll_start"] integerValue];
//        long MMDDSSafter = [[_Dic objectForKey:@"enroll_end"] integerValue];
//        long miaobefor = (MMDDSSbefor-time(NULL))%(60*60*24);
//        long miaoafter = (MMDDSSafter - time(NULL))%(60*60*24);
        
        long daybefor = (MMDDSSbefor-time(NULL))/(60*60*24);
        long dayafter = (MMDDSSafter - time(NULL))/(60*60*24);
        
        NSLog(@"date1时间戳 = %ld==%ld",miaobefor,miaoafter);
        
        UILabel *timelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15+kScreen_Width/(2.5), 100, 25)];
        timelabel.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:timelabel];
        
        if (miaobefor>0) {
            [timeLabel setcurentTime:miaobefor];
            timelabel.text = [NSString stringWithFormat:@"距开始 %ld天",daybefor];
        }if (miaobefor<0&&miaoafter>0) {
            [timeLabel setcurentTime:miaoafter];
            timelabel.text = [NSString stringWithFormat:@"距结束 %ld天",dayafter];
        }if (miaoafter<0) {
            timelabel.text = [NSString stringWithFormat:@"已结束 %ld天",dayafter];
        }
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, kScreen_Width/(2.5)+50, kScreen_Width, 25)];
        NSString *personalnum = [_Dic objectForKey:@"personal_num"];
        label.font = [UIFont systemFontOfSize:15];
        if ([personalnum isEqualToString:@"0"]) {
            label.text = @"名额: 不限";
        }else{
            label.text = [NSString stringWithFormat:@"名额: %@人",personalnum];
        }
        [cell.contentView addSubview:label];
        
        UILabel *pricelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, kScreen_Width/(2.5)+80, kScreen_Width-20, 25)];
        int i = [[_Dic objectForKey:@"cost"] intValue];
        NSString *cost_cn = [_Dic objectForKey:@"cost_cn"];
        NSString *price;
        price = cost_cn;
        pricelabel.text = [NSString stringWithFormat:@"价格: %@",price];
        pricelabel.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:pricelabel];
        NSLog(@"%@",[[_Dic objectForKey:@"cost"] class]);
        
        UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Width/(2.5)+80+25+10, kScreen_Width, 10)];
        lineview.backgroundColor = [UIColor blackColor];
        lineview.alpha = 0.05;
        [cell.contentView addSubview:lineview];
    }if (indexPath.section==1){
        if (indexPath.row==0) {
            cell.textLabel.text = @"  活动介绍";
        }else{
            UILabel *contentlabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, Main_width-25, 0)];
            contentlabel.numberOfLines = 0;
            NSString *base64 = [_Dic objectForKey:@"introduction"];
            
//            NSData *data1 = [[NSData alloc] initWithBase64EncodedString:base64 options:0];
//            NSString *labeltext = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
            NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[base64 dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];

            NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithAttributedString: attributedString];
            contentlabel.attributedText = string;
            contentlabel.font = [UIFont systemFontOfSize:16];// weight:10
            CGSize size = [contentlabel sizeThatFits:CGSizeMake(contentlabel.frame.size.width, MAXFLOAT)];
            contentlabel.frame = CGRectMake(contentlabel.frame.origin.x, contentlabel.frame.origin.y, size.width,  size.height);

            [cell.contentView addSubview:contentlabel];
            
            
            
//            wkwebview = [[WKWebView alloc] init];
//            //wkwebview.frame = self.view.frame;
//            wkwebview.UIDelegate = self;
//            wkwebview.navigationDelegate = self;
//            [cell.contentView addSubview:wkwebview];
            
//            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://m.hui-shenghuo.cn/apk/%@",_url]];
//            NSURLRequest *request =[NSURLRequest requestWithURL:url];
            //[wkwebview loadHTMLString:base64 baseURL:nil];
           
//            NSString *headerString = @"<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>";
//            [wkwebview loadHTMLString:[headerString stringByAppendingString:base64] baseURL:nil];
            
            
        }
    }
    return cell;
}
// 页面加载完成之后调用 此方法会调用多次
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    __block CGFloat webViewHeight;
    
    //获取内容实际高度（像素）@"document.getElementById(\"content\").offsetHeight;"
    [webView evaluateJavaScript:@"document.body.scrollHeight;" completionHandler:^(id _Nullable result,NSError * _Nullable error) {
        // 此处js字符串采用scrollHeight而不是offsetHeight是因为后者并获取不到高度，看参考资料说是对于加载html字符串的情况下使用后者可以(@"document.getElementById(\"content\").offsetHeight;")，但如果是和我一样直接加载原站内容使用前者更合适
        //获取页面高度，并重置webview的frame
        webViewHeight = [result doubleValue];
        webView.frame = CGRectMake(10, 10, Main_width-20, webViewHeight);
        wkwebview.frame = webView.frame;
        NSLog(@"%f",webViewHeight);
    }];
    
    NSLog(@"结束加载");
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
