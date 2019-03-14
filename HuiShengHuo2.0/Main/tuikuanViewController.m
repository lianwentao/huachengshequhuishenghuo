//
//  tuikuanViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/1/20.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "tuikuanViewController.h"
#import <AFNetworking.h>
#import "UIImageView+WebCache.h"
#import "WPhotoViewController.h"
#import "MBProgressHUD+TVAssistant.h"
#define kScreen_Height   ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width    ([UIScreen mainScreen].bounds.size.width)
#import "PrefixHeader.pch"
@interface tuikuanViewController (){
    UITextView *_textview;
    
    UIButton *_AddBut;
    UIButton *_Savebut;
    NSMutableArray *_photosArr;
    UIImageView *_imageview;
    
    UIView *backview;
    
    UIButton *starbut;
    NSMutableArray *butarr;
}
@end

@implementation tuikuanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"退款";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createui];
    // Do any additional setup after loading the view.
}
- (void)createui{
    backview = [[UIView alloc] initWithFrame:CGRectMake(0, RECTSTATUS.size.height+44, kScreen_Width, kScreen_Height)];
    [self.view addSubview:backview];
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    NSString *strurl = [API_img stringByAppendingString:_imageurl];
    [imageview sd_setImageWithURL:[NSURL URLWithString: strurl]];
    [backview addSubview:imageview];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(  110, 15, kScreen_Width-120, 25)];
    label.text = _name;
    [backview addSubview:label];
    
    UILabel *pricelabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 60, kScreen_Width-130, 25)];
    pricelabel.text = [NSString stringWithFormat:@"¥:%@",_price];
    pricelabel.textColor = [UIColor redColor];
    [backview addSubview:pricelabel];
    
    _textview = [[UITextView alloc] initWithFrame:CGRectMake(10, 110, kScreen_Width-20, 150)];
    _textview.tag=1000;
    [_textview setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
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
    
    _AddBut = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _AddBut.frame = CGRectMake(7.5, 270, (kScreen_Width-15-15)/4, (kScreen_Width-15-15)/4);
    [_AddBut setImage:[UIImage imageNamed:@"tianjia"] forState:UIControlStateNormal];
    [_AddBut addTarget:self action:@selector(Addphotos) forControlEvents:UIControlEventTouchUpInside];
    [backview addSubview:_AddBut];
    
    UIButton *tijiaobut = [UIButton buttonWithType:UIButtonTypeCustom];
    tijiaobut.frame = CGRectMake(kScreen_Width/2-((kScreen_Width-15-15)/3)/2, 270+(kScreen_Width-15-15)/4+40, (kScreen_Width-15-15)/3, 50);
    tijiaobut.layer.cornerRadius = 15;
    [tijiaobut.layer setBorderWidth:0.6];
    [tijiaobut.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [tijiaobut setTitle:@"提交" forState:UIControlStateNormal];
    [tijiaobut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [tijiaobut.layer setBorderColor:[[UIColor blackColor]CGColor]];
    [tijiaobut addTarget:self action:@selector(tijiao) forControlEvents:UIControlEventTouchUpInside];
    [backview addSubview:tijiaobut];
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
- (void)tijiao
{
    [self post];
}
-(void)post
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    NSDictionary *dict = @{@"oid":_oid,@"order_info_id":_order_info_id,@"cancel_reason":_textview.text,@"pic_num":[NSString stringWithFormat:@"%ld",_photosArr.count],@"apk_token":uid_username,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
    NSLog(@"%@",dict);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *API = [defaults objectForKey:@"API"];
    NSString *urlstr = [API stringByAppendingString:@"userCenter/refund"];
    [manager POST:urlstr parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i=0; i<_photosArr.count; i++)
        {
            UIImageView *imageview = [[UIImageView alloc] init];
            imageview.image = [[_photosArr objectAtIndex:i] objectForKey:@"image"];
            UIImage *image = imageview.image;
            NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat =@"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
            [formData  appendPartWithFileData:imageData name:[NSString stringWithFormat:@"refundimg%d",i] fileName:fileName mimeType:@"jpg/png/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@==%@",[responseObject objectForKey:@"data"], [responseObject objectForKey:@"msg"]);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changepingjiatuikuanzhuangtai" object:nil userInfo:nil];
            [self.navigationController popViewControllerAnimated:YES];
            //[MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }else{
            
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"上传失败：%@", error);
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
