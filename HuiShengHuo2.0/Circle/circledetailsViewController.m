//
//  circledetailsViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/12/9.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import "circledetailsViewController.h"
#import <AFNetworking.h>
#import "UIImageView+WebCache.h"
#import "LoginViewController.h"
#import "HalfCircleActivityIndicatorView.h"
#import "MBProgressHUD+TVAssistant.h"

#import "PrefixHeader.pch"
#define screen_Width [UIScreen mainScreen].bounds.size.width
#define screen_Height [UIScreen mainScreen].bounds.size.height
@interface circledetailsViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView *_TableView;
    NSArray *_DataimgArr;
    NSArray *_DatareplyArr;
    NSDictionary *_Dict;
    
    UIView *_View;
    UITextField *_TextView;
    NSString *huifuneirong;
    
    UIButton *fasongbut;
    
    HalfCircleActivityIndicatorView *LoadingView;
    
    MBProgressHUD *_HUD;
}

@end

@implementation circledetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邻里详情";
    NSLog(@"is_pro--%@",_is_pro);
    self.view.backgroundColor = BackColor;
    
    [self post];
    [self LoadingView];
    [LoadingView startAnimating];
    //添加手势，为了关闭键盘的操作
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap1.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap1];
    
    if ([_jpushstring isEqualToString:@"jpush"]) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    }
    // Do any additional setup after loading the view.
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
- (void)LoadingView
{
    LoadingView = [[HalfCircleActivityIndicatorView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-40)/2, (self.view.frame.size.height-40)/2, 40, 40)];
    
    [self.view addSubview:LoadingView];
}
- (void)Createtableview
{
    _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, RECTSTATUS.size.height+44, screen_Width, screen_Height-55-RECTSTATUS.size.height-44) style:UITableViewStyleGrouped];
    _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _TableView.estimatedRowHeight = 0;
    _TableView.estimatedSectionFooterHeight = 0;
    _TableView.estimatedSectionHeaderHeight = 0;
    _TableView.backgroundColor = BackColor;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
    _TableView.tableHeaderView = view;
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
    _TableView.tableFooterView = view1;
    [self.view addSubview:_TableView];
    _TableView.delegate = self;
    _TableView.dataSource = self;
    _TableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    _View = [[UIView alloc] initWithFrame:CGRectMake(0, screen_Height-55, screen_Width, 55)];
    _View.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_View];
    fasongbut = [UIButton buttonWithType:UIButtonTypeCustom];
    fasongbut.frame = CGRectMake(screen_Width-76+8, 8, 60, 40);
    fasongbut.layer.masksToBounds = YES;
    fasongbut.backgroundColor = BackColor;
    fasongbut.layer.cornerRadius = 5;
    [fasongbut setTitle:@"发送" forState:UIControlStateNormal];
    [fasongbut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [fasongbut addTarget:self action:@selector(huifu) forControlEvents:UIControlEventTouchUpInside];
    [_View addSubview:fasongbut];
    
//    UIImageView *avravsimageview = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 40, 40)];
//    avravsimageview.layer.masksToBounds = YES;
//    avravsimageview.layer.cornerRadius = 20;
//    avravsimageview.backgroundColor = [UIColor lightGrayColor];
//    NSString *imgstr = [_Dict objectForKey:@"avatars"];
//    if ([imgstr isEqualToString:@""]) {
//        avravsimageview.image = [UIImage imageNamed:@"facehead1"];
//        [_View addSubview:avravsimageview];
//    }else{
//        NSString *imgurl = [NSString stringWithFormat:@"%@%@",API,imgstr];
//        [avravsimageview sd_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:[UIImage imageNamed:@"facehead1"]];
//        [_View addSubview:avravsimageview];
//    }
    
    
    _TextView = [[UITextField alloc] initWithFrame:CGRectMake(8, 8, screen_Width-76-8, 40)];
    _TextView.backgroundColor = BackColor;
    _TextView.layer.masksToBounds = YES;
    _TextView.layer.cornerRadius = 5;
    _TextView.delegate = self;
    // _placeholderLabel
    _TextView.placeholder = @"说点什么吧...";
    
    // same font
    _TextView.font = [UIFont systemFontOfSize:15.f];
    
    [_View addSubview:_TextView];
    
    //设置两个通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyHiden:) name: UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyWillAppear:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
- (void)textFieldDidChange:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""]) {
        fasongbut.backgroundColor = BackColor;
        [fasongbut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else{
        fasongbut.backgroundColor = HColor(218, 72, 55);
        [fasongbut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}
#pragma mark-键盘出现隐藏事件
-(void)keyHiden:(NSNotification *)notification
{
    // self.tooBar.frame = rect;
    [UIView animateWithDuration:0.25 animations:^{
        //恢复原样
        _View.transform = CGAffineTransformIdentity;
        //        commentView.hidden = YES;
    }];
}
-(void)keyWillAppear:(NSNotification *)notification
{
    //获得通知中的info字典
    NSDictionary *userInfo = [notification userInfo];
    CGRect rect= [[userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"]CGRectValue];
    // self.tooBar.frame = rect;
    [UIView animateWithDuration:0.25 animations:^{
        _View.transform = CGAffineTransformMakeTranslation(0, -([UIScreen mainScreen].bounds.size.height-rect.origin.y));
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    WBLog(@"点击空白");
    //[_TextView resignFirstResponder];
}
//点击空白处的手势要实现的方法
-(void)viewTapped:(UITapGestureRecognizer*)tap1
{
    //[_TextView endEditing:YES];
}
- (void)huifu
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:@"token"];
    if (str==nil) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self presentViewController:login animated:YES completion:nil];
    }else{
        huifuneirong = _TextView.text;
        if ([huifuneirong isEqualToString:@""]) {
            [MBProgressHUD showToastToView:self.view withText:@"回复内容不能为空"];
        }else{
            [self GeneralButtonAction];
            [self post1];
            //[_TextView resignFirstResponder];
            [_TextView endEditing:YES];
        }
    }
}
- (void)GeneralButtonAction{
    //初始化进度框，置于当前的View当中
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    
    //如果设置此属性则当前的view置于后台
    //_HUD.dimBackground = YES;
    
    //设置对话框文字
    _HUD.labelText = @"回复中,请稍后...";
    _HUD.labelFont = [UIFont systemFontOfSize:14];
    //细节文字
    //_HUD.detailsLabelText = @"请耐心等待";
    
    //显示对话框
    [_HUD showAnimated:YES whileExecutingBlock:^{
        //对话框显示时需要执行的操作
        
        sleep(2);
    }// 在HUD被隐藏后的回调
       completionBlock:^{
           //操作执行完后取消对话框
           [_HUD removeFromSuperview];
           _HUD = nil;
       }];
}
#pragma mark ------联网请求---
-(void)post1{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSDictionary *dict = nil;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    NSData *nsdata = [huifuneirong
                      dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
    dict = @{@"social_id":[_Dict objectForKey:@"id"],@"content":base64Encoded,@"is_pro":_is_pro,@"apk_token":uid_username,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
   
    NSString *strurl = [API stringByAppendingString:@"social/social_reply"];
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@==%@",[responseObject objectForKey:@"msg"],responseObject);
        
        _TextView.text = nil;
        //[_TableView reloadData];
        [self post];
        //[self scrollTableToFoot:YES];
//        NSIndexPath *myIndexPath = [NSIndexPath indexPathForRow: 3 inSection:0];
//        [_TableView selectRowAtIndexPath:myIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
//#pragma mark  - 滑到最底部
//- (void)scrollTableToFoot:(BOOL)animated
//{
//    [_TableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES]; //滚动到最后一行
//}
-(void)post{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSDictionary *dict = nil;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    dict = @{@"id":_id,@"is_pro":_is_pro,@"apk_token":uid_username};
    
    NSString *strurl = [API stringByAppendingString:@"social/get_social"];
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        _Dict = [[NSDictionary alloc] init];
        _Dict = [responseObject objectForKey:@"data"];
        _DataimgArr = [[responseObject objectForKey:@"data"] objectForKey:@"img_list"];
        _DatareplyArr = [[responseObject objectForKey:@"data"] objectForKey:@"reply_list"];
        
        [LoadingView stopAnimating];
        LoadingView.hidden = YES;
        [self Createtableview];
        [_TableView reloadData];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"gengxinmain" object:nil userInfo:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_DatareplyArr isKindOfClass:[NSArray class]]) {
        return _DatareplyArr.count+3;
    }else{
        return 4;
    }
}
// 分组的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    if (indexPath.row==0) {
        cell.contentView.backgroundColor = BackColor;
        tableView.rowHeight = 8;
    }if (indexPath.row==1) {
        UILabel *namelabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 15, screen_Width-70, 40)];
        namelabel.font = [UIFont systemFontOfSize:18];
        NSString *admin = [NSString stringWithFormat:@"%@",[_Dict objectForKey:@"admin_id"]];
        if ([admin isEqualToString:@"0"]) {
            namelabel.textColor = [UIColor blackColor];
        }else{
            namelabel.textColor = admincolor;
        }
        namelabel.text = [_Dict objectForKey:@"nickname"];
        [cell.contentView addSubview:namelabel];
        UILabel *timelabel = [[UILabel alloc] initWithFrame:CGRectMake(Main_width*2/3, 15, Main_width/3-20, 40)];
        timelabel.font = [UIFont systemFontOfSize:15];
        
        timelabel.text = [_Dict objectForKey:@"addtime"];
        timelabel.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:timelabel];
        UILabel *contentlabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 55+15, screen_Width-25, 0)];
        contentlabel.numberOfLines = 0;
        //contentlabel.font = [UIFont systemFontOfSize:16];
        CGSize size;
        
        NSString *base64 = [_Dict objectForKey:@"content"];
        if (base64!=nil) {
            NSData *data1 = [[NSData alloc] initWithBase64EncodedString:base64 options:0];
            NSString *labeltext = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
            NSLog(@"labeltext = %@",labeltext);
            if (![admin isEqualToString:@"0"]) {
                NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[labeltext dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                
                NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithAttributedString: attributedString];
                contentlabel.attributedText = string;
                contentlabel.font = [UIFont systemFontOfSize:16];// weight:10
                size = [contentlabel sizeThatFits:CGSizeMake(contentlabel.frame.size.width, MAXFLOAT)];
                contentlabel.frame = CGRectMake(contentlabel.frame.origin.x, contentlabel.frame.origin.y, size.width,  size.height);
//                [string removeAttribute:NSParagraphStyleAttributeName range: NSMakeRange(0, string.length)];
//                rect = [string boundingRectWithSize:CGSizeMake(Main_width-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
                
            }else{
                contentlabel.font = [UIFont systemFontOfSize:16];
                contentlabel.text = labeltext;
                size = [contentlabel sizeThatFits:CGSizeMake(contentlabel.frame.size.width, MAXFLOAT)];
                contentlabel.frame = CGRectMake(contentlabel.frame.origin.x, contentlabel.frame.origin.y, size.width,  size.height);
            }
        }
        
        
        [cell.contentView addSubview:contentlabel];
        
        UIImageView *avravsimageview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 40, 40)];
        avravsimageview.layer.masksToBounds = YES;
        avravsimageview.layer.cornerRadius = 20;
        avravsimageview.backgroundColor = [UIColor lightGrayColor];
        NSString *imgstr = [_Dict objectForKey:@"avatars"];
        if ([imgstr rangeOfString:@"http://"].location == NSNotFound) {
            NSString *strurl = [API_img stringByAppendingString:imgstr];
            [avravsimageview sd_setImageWithURL:[NSURL URLWithString:strurl] placeholderImage:[UIImage imageNamed:@"facehead1"]];
        } else {
            [avravsimageview sd_setImageWithURL:[NSURL URLWithString:imgstr] placeholderImage:[UIImage imageNamed:@"facehead1"]];
        }
        [cell.contentView addSubview:avravsimageview];
        
        long sizeimg = 0;
        tableView.rowHeight = 60+size.height+15;
        if ([_DataimgArr isKindOfClass:[NSArray class]]) {
            for (int i=0; i<_DataimgArr.count; i++) {
                UIImageView *imageview = [[UIImageView alloc] init];
                NSString *imgstr1 = [[_DataimgArr objectAtIndex:i] objectForKey:@"img"];
                NSString *imgurl1 = [API_img stringByAppendingString:imgstr1];
                [imageview sd_setImageWithURL:[NSURL URLWithString:imgurl1] placeholderImage:[UIImage imageNamed:@"展位图正"]];
                
                //float j = imageview.image.size.width/(screen_Width-20);
                float j = [[[_DataimgArr objectAtIndex:i] objectForKey:@"img_size"] floatValue];
                imageview.frame = CGRectMake(10, 15+65+size.height+sizeimg+5*i, screen_Width-20, (screen_Width-20)/j);
                sizeimg = sizeimg+(screen_Width-20)/j;
                //NSLog(@"%@",NSStringFromCGSize(imageview.frame.size));
                NSLog(@"%f---%ld",j,sizeimg);
                [cell.contentView addSubview:imageview];
                tableView.rowHeight = tableView.rowHeight+5+(screen_Width-20)/j;
            }
        }else {
            tableView.rowHeight = 60+size.height+15;
        }
    }if (indexPath.row==2) {
        cell.backgroundColor = BackColor;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, Main_width, 55-8)];
        label.text = @"   看大家怎么说";
        //label.backgroundColor = [UIColor whiteColor];
        [label setFont:nomalfont];
        [cell.contentView addSubview:label];
        tableView.rowHeight = 55;
    } if (indexPath.row>2){
        cell.contentView.backgroundColor = [UIColor whiteColor];
        if ([_DatareplyArr isKindOfClass:[NSArray class]]) {
            UIImageView *avravsimageview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 40, 40)];
            avravsimageview.layer.masksToBounds = YES;
            avravsimageview.layer.cornerRadius = 20;
            avravsimageview.backgroundColor = [UIColor lightGrayColor];
            NSString *imgstr = [[_DatareplyArr objectAtIndex:indexPath.row-3] objectForKey:@"r_avatars"];
            
            if ([imgstr rangeOfString:@"http://"].location == NSNotFound) {
                NSString *strurl = [API_img stringByAppendingString:imgstr];
                [avravsimageview sd_setImageWithURL:[NSURL URLWithString:strurl] placeholderImage:[UIImage imageNamed:@"facehead1"]];
            } else {
                [avravsimageview sd_setImageWithURL:[NSURL URLWithString:imgstr] placeholderImage:[UIImage imageNamed:@"facehead1"]];
            }
            [cell.contentView addSubview:avravsimageview];
            
            UILabel *timelabel = [[UILabel alloc] initWithFrame:CGRectMake(Main_width*2/3, 15, Main_width/3-20, 20)];
            timelabel.font = font15;
            timelabel.textAlignment = NSTextAlignmentRight;
            timelabel.text = [[_DatareplyArr objectAtIndex:indexPath.row-3] objectForKey:@"addtime"];
            [cell.contentView addSubview:timelabel];
            
            NSString *namestring = [[_DatareplyArr objectAtIndex:indexPath.row-3] objectForKey:@"r_nickname"];
            UILabel *nalelabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 15, Main_width-85, 40)];
            [nalelabel setFont:nomalfont];
            nalelabel.text = namestring;
            [cell.contentView addSubview:nalelabel];
            
            UILabel *contentlabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 70, screen_Width-25, 0)];
            contentlabel.numberOfLines = 0;
            NSString *base64 = [[_DatareplyArr objectAtIndex:indexPath.row-3] objectForKey:@"content"];
            if (![base64 isEqualToString:@""]) {
                NSData *data1 = [[NSData alloc] initWithBase64EncodedString:base64 options:0];
                NSString *labeltext = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
                contentlabel.text = labeltext;
            }else{
                contentlabel.text = @"";
            }
            NSLog(@"*********contentlabeltext------%@-----%@",contentlabel.text,base64);
            CGSize size = [contentlabel sizeThatFits:CGSizeMake(contentlabel.frame.size.width, MAXFLOAT)];
            contentlabel.frame = CGRectMake(contentlabel.frame.origin.x, contentlabel.frame.origin.y, size.width,  size.height);
            contentlabel.font = font15;
            [cell.contentView addSubview:contentlabel];
            
            UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(20, 60+size.height+15+15-6, 6, 6)];
            circle.layer.masksToBounds = YES;
            circle.layer.cornerRadius = 3;
            circle.backgroundColor = CIrclecolor;
            
            UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(26, 60+size.height+15+15-6+3-0.25, Main_width-26, 0.5)];
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            [shapeLayer setBounds:lineview.bounds];
            [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineview.frame) / 2, CGRectGetHeight(lineview.frame))];
            [shapeLayer setFillColor:[UIColor clearColor].CGColor];
            //  设置虚线颜色为blackColor
            [shapeLayer setStrokeColor:[UIColor blackColor].CGColor];
            //  设置虚线宽度
            [shapeLayer setLineWidth:CGRectGetHeight(lineview.frame)];
            [shapeLayer setLineJoin:kCALineJoinRound];
            //  设置线宽，线间距
            [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:3], [NSNumber numberWithInt:1],  nil]];
            //  设置路径
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, NULL, 0, 0);
            CGPathAddLineToPoint(path, NULL, CGRectGetWidth(lineview.frame), 0);
            [shapeLayer setPath:path];
            CGPathRelease(path);
            //  把绘制好的虚线添加上来
            [lineview.layer addSublayer:shapeLayer];
            lineview.alpha = 0.5;
            if ((indexPath.row-2)==_DatareplyArr.count) {
                
            }else{
                [cell.contentView addSubview:lineview];
                [cell.contentView addSubview:circle];
            }
            tableView.rowHeight = 60+size.height+15+15;
        }else{
            tableView.rowHeight = 220;
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 10, Main_width-40, 200)];
            view.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:view];
            
            UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(Main_width/2-70, 30, 100, 100)];
            imageview.image = [UIImage imageNamed:@"pinglunweikong"];
            [view addSubview:imageview];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, Main_width-40, 25)];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"还没有评论呢,快来抢沙发把";
            label.alpha = 0.5;
            [label setFont:font15];
            [view addSubview:label];
        }
    }
    return  cell;
}
- (void)insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
    
}
+ (NSString *)textFromBase64String:(NSString *)base64 {
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:base64 options:0];
    NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return text;
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
