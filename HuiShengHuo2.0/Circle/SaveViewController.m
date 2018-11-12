//
//  SaveViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/12/2.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import "SaveViewController.h"
#import "CMInputView.h"
#import "WPhotoViewController.h"
#import <AFNetworking.h>
#import "HalfCircleActivityIndicatorView.h"
#import "MBProgressHUD+TVAssistant.h"
#import "PrefixHeader.pch"
#define screen_Width [UIScreen mainScreen].bounds.size.width
#define screen_Height [UIScreen mainScreen].bounds.size.height
@interface SaveViewController ()
{
    UIButton *_AddBut;
    UIButton *_Savebut;
    NSMutableArray *_photosArr;
    UIScrollView *_scrollview;
    NSMutableArray *_DataArr;
    UITableView *_tableview;
    
    MBProgressHUD *_HUD;
    
    HalfCircleActivityIndicatorView *LoadingView;
}
@property (nonatomic,strong) CMInputView *inputView;

@end

@implementation SaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self LoadingView];
    LoadingView.hidden = YES;
    self.title = @"发圈子";
    self.view.backgroundColor = [UIColor whiteColor];
    [self ctratetextview];
    // Do any additional setup after loading the view.
}
#pragma mark - LoadingView
- (void)LoadingView
{
    LoadingView = [[HalfCircleActivityIndicatorView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-40)/2, (self.view.frame.size.height-40)/2, 40, 40)];
    [self.view addSubview:LoadingView];
}
#pragma mark - 创建textview
- (void)ctratetextview
{
    _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 230, Main_width, (screen_Width-15-15)/4)];
    [self.view addSubview:_scrollview];
    
    _inputView = [[CMInputView alloc]initWithFrame:CGRectMake(5, 100, screen_Width-10, 120)];
    
    _inputView.font = [UIFont systemFontOfSize:18];
    _inputView.placeholder = @"说点什么吧~~";
    
    _inputView.cornerRadius = 4;
    _inputView.placeholderColor = [UIColor groupTableViewBackgroundColor];
    //_inputView.placeholderFont = [UIFont systemFontOfSize:22];
     //设置文本框最大行数
    [_inputView textValueDidChanged:^(NSString *text, CGFloat textHeight) {
        CGRect frame = _inputView.frame;
        frame.size.height = textHeight;
        _inputView.frame = frame;
    }];
    
    _inputView.maxNumberOfLines = 4;
    [self.view addSubview:_inputView];
    
    //加号按钮
    _AddBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [_scrollview addSubview:_AddBut];
    _AddBut.frame = CGRectMake(7.5, 0, (screen_Width-15-15)/4, (screen_Width-15-15)/4);
    [_AddBut setImage:[UIImage imageNamed:@"tianjia"] forState:UIControlStateNormal];
    [_AddBut addTarget:self action:@selector(Addphotos) forControlEvents:UIControlEventTouchUpInside];
    
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake((screen_Width-(screen_Width-15-15)/4)/2, 10+(screen_Width-15-15)/4+230, (screen_Width-15-15)/4, 50)];
    _tableview.backgroundColor = [UIColor whiteColor];
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableview];
    
    _Savebut = [UIButton buttonWithType:UIButtonTypeCustom];
    [_tableview addSubview:_Savebut];
    _Savebut.frame = CGRectMake(0, 0, (screen_Width-15-15)/4, 50);
    [_Savebut setTitle:@"发布" forState:UIControlStateNormal];
    [_Savebut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _Savebut.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_Savebut addTarget:self action:@selector(savesomes) forControlEvents:UIControlEventTouchUpInside];
}
#pragma  mark - textField delegate
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"点击空白");
    [_inputView resignFirstResponder];
    
}
//点击空白处的手势要实现的方法
-(void)viewTapped:(UITapGestureRecognizer*)tap1
{
    [_inputView resignFirstResponder];
}
- (void)Addphotos
{
    WPhotoViewController *Wphotovc = [[WPhotoViewController alloc] init];
    //选择图片的最大数
    Wphotovc.selectPhotoOfMax = 12;
    [Wphotovc setSelectPhotosBack:^(NSMutableArray *phostsArr) {
        [_tableview reloadData];
        [_scrollview setContentSize:CGSizeMake( ((screen_Width-15-15)/4+5)*(phostsArr.count+1)+5, _scrollview.bounds.size.height)];
        _scrollview.showsHorizontalScrollIndicator = NO;
        _scrollview.pagingEnabled = NO;
        for (int i=0; i<phostsArr.count; i++) {
            UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(i*(screen_Width-15-15)/4+5+5*i, 0, (screen_Width-15-15)/4, (screen_Width-15-15)/4)];
            imageview.image = [[phostsArr objectAtIndex:i] objectForKey:@"image"];
            [_scrollview addSubview:imageview];
        }
        _photosArr = phostsArr;
        _AddBut.frame = CGRectMake(((screen_Width-15-15)/4+5)*(_photosArr.count+1)+5, 0, (screen_Width-15-15)/4, (screen_Width-15-15)/4);
        [phostsArr removeAllObjects];
    }];
    [self presentViewController:Wphotovc animated:YES completion:nil];
}

- (void)GeneralButtonAction{
    //初始化进度框，置于当前的View当中
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    
    //如果设置此属性则当前的view置于后台
    //_HUD.dimBackground = YES;
    
    //设置对话框文字
    _HUD.labelText = @"发布中,请稍后...";
    _HUD.labelFont = [UIFont systemFontOfSize:14];
    //细节文字
    //_HUD.detailsLabelText = @"请耐心等待";
    
    //显示对话框
    [_HUD showAnimated:YES whileExecutingBlock:^{
        //对话框显示时需要执行的操作
        sleep(3);
    }// 在HUD被隐藏后的回调
       completionBlock:^{
           //操作执行完后取消对话框
           [_HUD removeFromSuperview];
           _HUD = nil;
       }];
}
- (void)savesomes
{
    if ([_inputView.text isEqualToString:@""]) {
        [MBProgressHUD showToastToView:self.view withText:@"内容不能为空"];
    }else{
        [self GeneralButtonAction];
        NSLog(@"==%@",_photosArr);
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
        //formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
        NSString *imfnumstr = [NSString stringWithFormat:@"%lu",_photosArr.count];
        NSData *nsdata = [_inputView.text
                          dataUsingEncoding:NSUTF8StringEncoding];
        NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
        NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
        NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[userinfo objectForKey:@"uid"],[userinfo objectForKey:@"username"]]];
        NSDictionary *dic = @{@"community_id":[userinfo objectForKey:@"community_id"],@"c_id":@"85",@"content":base64Encoded,@"img_num":imfnumstr,@"apk_token":uid_username,@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"]};
        NSLog(@"%@",dic);
        NSString *url = [API stringByAppendingString:@"social/SocialSave"];
        [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
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
                [formData  appendPartWithFileData:imageData name:[NSString stringWithFormat:@"img%d",i] fileName:fileName mimeType:@"jpg/png/jpeg"];
            }
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSLog(@"%@==%@",[responseObject objectForKey:@"data"], [responseObject objectForKey:@"msg"]);
            
            //[MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changequnzishouye" object:nil userInfo:nil];
            [self performSelector:@selector(back) withObject:nil afterDelay:1];
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"上传失败：%@", error);
            
            [MBProgressHUD showToastToView:self.view withText:@"发布失败"];
        }];
    }
    
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
