//
//  evaluateViewController.m
//  HuiShengHuo2.0
//
//  Created by admin on 2018/12/17.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "evaluateViewController.h"
#import "SpecialAlertView.h"
#import <AFNetworking.h>
#import "UIImageView+WebCache.h"
#import "WPhotoViewController.h"
#import "MBProgressHUD+TVAssistant.h"
#define kScreen_Height   ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width    ([UIScreen mainScreen].bounds.size.width)
#import "PrefixHeader.pch"
#import "orderDetailsViewController.h"
@interface evaluateViewController ()
{
    UITextView *_textview;
    
    UIButton *_AddBut;
    UIButton *_Savebut;
    NSMutableArray *_photosArr;
    UIImageView *_imageview;
    
    UIView *backview;
    
    UIButton *starbut;
    NSMutableArray *butarr;
    
    NSString *_score;
}
@end
@implementation evaluateViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评价";
    self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    
    [self createui];
    
}

- (void)createui{
    
    backview = [[UIView alloc] initWithFrame:CGRectMake(0, 84, kScreen_Width, 300)];
    backview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backview];
    
//    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//    NSString *strurl = [API_img stringByAppendingString:_imageurl];
//    [imageview sd_setImageWithURL:[NSURL URLWithString: strurl]];
//    [backview addSubview:imageview];
//
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(  110, 15, kScreen_Width-120, 25)];
//    label.text = _name;
//    [backview addSubview:label];
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.frame = CGRectMake(10, 10, Main_width/2, 20);
    titleLab.text = @"服务评价";
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.font = [UIFont systemFontOfSize:15];
    titleLab.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
    [backview addSubview:titleLab];
    
    butarr = [[NSMutableArray alloc] init];
    for (int i = 0; i<5; i++) {
        starbut = [UIButton buttonWithType:UIButtonTypeCustom];
        starbut.frame = CGRectMake(10+35*i, CGRectGetMaxY(titleLab.frame)+10, 30, 30);
        [starbut setImage:[UIImage imageNamed:@"pingjiahui1"] forState:UIControlStateNormal];
        [starbut setImage:[UIImage imageNamed:@"pingjia1"] forState:UIControlStateSelected];
        starbut.tag = i+2;
        [starbut addTarget:self action:@selector(score:) forControlEvents:UIControlEventTouchUpInside];
        [backview addSubview:starbut];
        [butarr addObject:starbut];
    }
    
    _textview = [[UITextView alloc] initWithFrame:CGRectMake(10, 110, kScreen_Width-20, 150)];
    _textview.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
    _textview.layer.borderWidth =1.0;
    _textview.layer.cornerRadius =5.0;
    _textview.tag=1000;
    [_textview setBackgroundColor:[UIColor whiteColor]];
    
    // _placeholderLabel
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = @"说点什么吧";
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = [UIColor lightGrayColor];
    [placeHolderLabel sizeToFit];
    [_textview addSubview:placeHolderLabel];
    
    // same font
    _textview.font = [UIFont systemFontOfSize:15.f];
    placeHolderLabel.font = [UIFont systemFontOfSize:15.f];
    
    [_textview setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    [backview addSubview:_textview];
    
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [[self view] addGestureRecognizer:recognizer];
    
   
    UIButton *tijiaobut = [UIButton buttonWithType:UIButtonTypeCustom];
    tijiaobut.frame = CGRectMake(40,420, Main_width-80, 40);
    tijiaobut.backgroundColor = [UIColor colorWithRed:255/255.0 green:87/255.0 blue:34/255.0 alpha:1];
    tijiaobut.layer.cornerRadius = 15;
    [tijiaobut.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [tijiaobut setTitle:@"提交" forState:UIControlStateNormal];
    [tijiaobut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tijiaobut.layer setBorderColor:[[UIColor blackColor]CGColor]];
    [tijiaobut addTarget:self action:@selector(tijiao) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tijiaobut];
}
- (void)Addphotos
{
    WPhotoViewController *Wphotovc = [[WPhotoViewController alloc] init];
    //选择图片的最大数
    Wphotovc.selectPhotoOfMax = 4;
    [Wphotovc setSelectPhotosBack:^(NSMutableArray *phostsArr) {
        _photosArr = phostsArr;
        //        [_TableView reloadData];
        //        _DataArr = nil;
        for (int i=0; i<_photosArr.count; i++) {
            _imageview = [[UIImageView alloc] initWithFrame:CGRectMake(i*(kScreen_Width-15-15)/4+5+5*i, 270, (kScreen_Width-15-15)/4, (kScreen_Width-15-15)/4)];
            _imageview.image = [[_photosArr objectAtIndex:i] objectForKey:@"image"];
            [backview addSubview:_imageview];
        }
        if (_photosArr.count<4) {
            _AddBut.frame = CGRectMake(7.5+_photosArr.count*(5+(kScreen_Width-15-15)/4), 270, (kScreen_Width-15-15)/4, (kScreen_Width-15-15)/4);
            UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(10, 270+(kScreen_Width-15-15)/4+4, kScreen_Width-20, 0.5)];
            lineview.backgroundColor = [UIColor blackColor];
            lineview.alpha = 0.2;
            //[backview addSubview:lineview];
        }else{
            _AddBut.frame = CGRectMake(7.5, 270+5+(kScreen_Width-15-15)/4, (kScreen_Width-15-15)/4, (kScreen_Width-15-15)/4);
            //            _tableview.frame = CGRectMake((screen_Width-(screen_Width-15-15)/4)/2, 10+(screen_Width-15-15)/2+230, (screen_Width-15-15)/4, 50);
            UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(10, 270+(kScreen_Width-15-15)/4*2+9, kScreen_Width-20, 0.5)];
            lineview.backgroundColor = [UIColor blackColor];
            lineview.alpha = 0.2;
            //[backview addSubview:lineview];
        }
    }];
    [self presentViewController:Wphotovc animated:YES completion:nil];
}
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    
    UITextView * textview1=(UITextView *)[self.view viewWithTag:1000];
    if(recognizer.direction==UISwipeGestureRecognizerDirectionDown) {
        NSLog(@"swipe down");
        [textview1 resignFirstResponder];
    }
}
- (void)score:(UIButton *)sender
{
    for (UIButton *btn in butarr){
        if (btn.tag >= sender.tag) {
            //[sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            btn.selected = NO;
            sender.selected = YES;
            _score = [NSString stringWithFormat:@"%zi",sender.tag-1];
            NSLog(@"%zi----%zi",btn.tag,sender.tag);
        } else {
            //[sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.selected = YES;
        }
    }
}
- (void)tijiao
{
    [self post];
}
-(void)post{
    NSLog(@"_score = %@",_score);
    if (![_score isKindOfClass:[NSString class]]) {
        
         [MBProgressHUD showToastToView:self.view withText:@"评分不能为空"];
    }else if ([_textview.text isEqualToString:@""]){
        [MBProgressHUD showToastToView:self.view withText:@"评价不能为空"];
    }else{
        //1.创建会话管理者
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSDictionary *dict = @{@"id":_orderID,@"level":_score,@"evaluate_content":_textview.text,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
        NSLog(@"dict = %@",dict);
        
        NSString *urlstr = [API stringByAppendingString:@"propertyWork/WorkScore"];
        [manager POST:urlstr parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
            NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"dataStr = %@",dataStr);
            
            NSInteger status = [responseObject[@"status"] integerValue];
            if (status == 1) {
                
                SpecialAlertView *pjwcView = [[SpecialAlertView alloc]initWithImage:@"xiaolian" messageTitle:@"谢谢您的评价" messageString:@"您的评价是我们最大的动力" messageString1:@"会继续努力滴" sureBtnTitle:@"返回订单" sureBtnColor:nil];
                [pjwcView withSureClick:^(NSString *string) {
                    for (UIViewController *controller in self.navigationController.viewControllers) {
                        if ([controller isKindOfClass:[orderDetailsViewController class]]) {
                            orderDetailsViewController *vc =(orderDetailsViewController *)controller;
                            vc.evaluate_status = @"1";
                            [self.navigationController popToViewController:vc animated:YES];
                        }
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"shuaxinwuyegongdanxiangqing" object:nil userInfo:nil];
                }];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
    
}

@end
