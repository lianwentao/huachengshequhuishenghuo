//
//  fabutieziViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/3/19.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "fabutieziViewController.h"
#import "HXPhotoPicker.h"
#import "CMInputView.h"
#import "MBProgressHUD+TVAssistant.h"
#import <AFNetworking.h>
static const CGFloat kPhotoViewMargin = 230;
@interface fabutieziViewController ()<HXPhotoViewDelegate,UIImagePickerControllerDelegate,UITextViewDelegate,UITextFieldDelegate>
{
    MBProgressHUD *_HUD;
    NSMutableArray*_Imagearr;
    
    UILabel *_categorylabel;
    NSArray *_CategoryArr;
    NSString *_id;
    UIView *categoryview;
    UIView *lineview;
    
    UIImageView *imagviewss;
    
    UIView *backview;
    
    UIButton *_tmpBtn;
}

@property (strong, nonatomic) HXPhotoManager *manager;
@property (strong, nonatomic) HXPhotoView *photoView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) HXDatePhotoToolManager *toolManager;
@property (assign, nonatomic) BOOL original;
@property (copy, nonatomic) NSArray *selectList;

@property (nonatomic,strong) CMInputView *inputView;
@end

@implementation fabutieziViewController

- (HXDatePhotoToolManager *)toolManager {
    if (!_toolManager) {
        _toolManager = [[HXDatePhotoToolManager alloc] init];
    }
    return _toolManager;
}

- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.openCamera = YES;
        _manager.configuration.lookLivePhoto = YES;
        _manager.configuration.photoMaxNum = 12;
        _manager.configuration.videoMaxNum = 0;
        _manager.configuration.maxNum = 12;
        _manager.configuration.videoMaxDuration = 500.f;
        _manager.configuration.saveSystemAblum = NO;
        //        _manager.configuration.reverseDate = YES;
        _manager.configuration.showDateSectionHeader = NO;
        _manager.configuration.selectTogether = NO;
        //        _manager.configuration.rowCount = 3;
        //        _manager.configuration.movableCropBox = YES;
        //        _manager.configuration.movableCropBoxEditSize = YES;
        //        _manager.configuration.movableCropBoxCustomRatio = CGPointMake(1, 1);
        
        __weak typeof(self) weakSelf = self;
        //        _manager.configuration.replaceCameraViewController = YES;
        _manager.configuration.shouldUseCamera = ^(UIViewController *viewController, HXPhotoConfigurationCameraType cameraType, HXPhotoManager *manager) {
            
            // 这里拿使用系统相机做例子
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = (id)weakSelf;
            imagePickerController.allowsEditing = NO;
            NSString *requiredMediaTypeImage = ( NSString *)kUTTypeImage;
            NSString *requiredMediaTypeMovie = ( NSString *)kUTTypeMovie;
            NSArray *arrMediaTypes;
            if (cameraType == HXPhotoConfigurationCameraTypePhoto) {
                arrMediaTypes=[NSArray arrayWithObjects:requiredMediaTypeImage,nil];
            }else if (cameraType == HXPhotoConfigurationCameraTypeVideo) {
                arrMediaTypes=[NSArray arrayWithObjects:requiredMediaTypeMovie,nil];
            }else {
                arrMediaTypes=[NSArray arrayWithObjects:requiredMediaTypeImage, requiredMediaTypeMovie,nil];
            }
            [imagePickerController setMediaTypes:arrMediaTypes];
            // 设置录制视频的质量
            [imagePickerController setVideoQuality:UIImagePickerControllerQualityTypeHigh];
            //设置最长摄像时间
            [imagePickerController setVideoMaximumDuration:60.f];
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
            imagePickerController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
            [viewController presentViewController:imagePickerController animated:YES completion:nil];
        };
    }
    return _manager;
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    [_inputView endEditing:YES];
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    HXPhotoModel *model;
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        model = [HXPhotoModel photoModelWithImage:image];
        if (self.manager.configuration.saveSystemAblum) {
            [HXPhotoTools savePhotoToCustomAlbumWithName:self.manager.configuration.customAlbumName photo:model.thumbPhoto];
        }
    }else  if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        NSURL *url = info[UIImagePickerControllerMediaURL];
        NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                         forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
        AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
        float second = 0;
        second = urlAsset.duration.value/urlAsset.duration.timescale;
        model = [HXPhotoModel photoModelWithVideoURL:url videoTime:second];
        if (self.manager.configuration.saveSystemAblum) {
            [HXPhotoTools saveVideoToCustomAlbumWithName:self.manager.configuration.customAlbumName videoURL:url];
        }
    }
    if (self.manager.configuration.useCameraComplete) {
        self.manager.configuration.useCameraComplete(model);
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布帖子";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    _id = @"";
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.alwaysBounceVertical = YES;
    scrollView.bounces = NO;
    scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    CGFloat width = scrollView.frame.size.width;
    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
    photoView.frame = CGRectMake(12, kPhotoViewMargin, width - 12 * 2, 0);
    photoView.delegate = self;
    photoView.outerCamera = YES;
    photoView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:photoView];
    self.photoView = photoView;
    
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped:)];
//    [_scrollView addGestureRecognizer:tap];
    [self downshoushi];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(savesomes)];
    
    
    [self post];
    
    // Do any additional setup after loading the view.
}
-(void)post{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSDictionary *dict = @{@"sign":@"1"};
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *API = [defaults objectForKey:@"API"];
    NSString *strurl = [API stringByAppendingString:@"social/getSocialCategory"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success--%@--%@",[responseObject class],responseObject);
        _CategoryArr = [[NSArray alloc] init];
        _CategoryArr = [responseObject objectForKey:@"data"];
        
        [self createlabel];
        [self ctratetextview];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
    
}
- (void)createlabel
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(30, 8, Main_width-60, 52)];
    view.backgroundColor = QIColor;
    [_scrollView addSubview:view];
    
    _categorylabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 0, 52)];
    _categorylabel.backgroundColor = HColor(252, 83, 29);
    
    _categorylabel.text = @"请选择发布栏目";
    _categorylabel.font = font18;
    CGSize size = [_categorylabel sizeThatFits:CGSizeMake(MAXFLOAT, 52)];
    _categorylabel.frame = CGRectMake(_categorylabel.frame.origin.x, _categorylabel.frame.origin.y, size.width,  52);
    _categorylabel.textColor = [UIColor whiteColor];
    [view addSubview:_categorylabel];
    
    imagviewss = [[UIImageView alloc] initWithFrame:CGRectMake(_categorylabel.frame.size.width+_categorylabel.frame.origin.x+15, 12.5, 25, 25)];
    imagviewss.image = [UIImage imageNamed:@"backfabutiezi"];
    [view addSubview:imagviewss];
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake(22.5, 8, Main_width-45, 52);
    but.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:but];
    [but addTarget:self action:@selector(popview) forControlEvents:UIControlEventTouchUpInside];
    
    backview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_width, Main_Height)];
    backview.backgroundColor = [UIColor blackColor];
    backview.alpha = 0.2;
    [self.view addSubview:backview];
    backview.hidden = YES;
    
    categoryview = [[UIView alloc] initWithFrame:CGRectMake(15, Main_Height, Main_width-30, 150)];
    [self.view addSubview:categoryview];
    categoryview.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = (Main_width-60-30)/3;
    
    NSLog(@"*******%@",_CategoryArr);
    for (int i=0; i<_CategoryArr.count; i++) {
        UIButton *catebut = [UIButton buttonWithType:UIButtonTypeCustom];

        [categoryview addSubview:catebut];
        [catebut setTitle:[[_CategoryArr objectAtIndex:i] objectForKey:@"c_name"]  forState:UIControlStateNormal];
        if (i<3) {
            catebut.frame = CGRectMake(15+width*i+15*i, 20, width, 40);
        }else{
            catebut.frame = CGRectMake(15+width*(i-3)+15*(i-3), 20+10+40, width, 40);
        }
        catebut.layer.masksToBounds = YES;
        catebut.layer.cornerRadius = 20;
        catebut.tag = i;
        [catebut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [catebut setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [catebut setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [catebut setBackgroundImage:[self createImageWithColor:QIColor] forState:UIControlStateSelected];
        [catebut addTarget:self action:@selector(cateselect:) forControlEvents:UIControlEventTouchUpInside];

        [categoryview addSubview:catebut];
    }
    
    lineview = [[UIView alloc] initWithFrame:CGRectMake(15, Main_Height+150, Main_width-30, 3)];
    [self.view addSubview:lineview];
    lineview.backgroundColor = HColor(252, 83, 29);
}
-(UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
- (void)cateselect:(UIButton *)sender
{
    
    
    if (_tmpBtn == nil){
        
        sender.selected = YES;
        
        _tmpBtn = sender;
        //_tmpBtn.backgroundColor = QIColor;
    }
    else if (_tmpBtn !=nil && _tmpBtn == sender){
        
        //_tmpBtn.backgroundColor = QIColor;
        sender.selected = YES;
        
    }
    else if (_tmpBtn!= sender && _tmpBtn!=nil){
        
        
        _tmpBtn.selected = NO;
        sender.selected = YES;
        _tmpBtn = sender;
    }
    _id = [[_CategoryArr objectAtIndex:sender.tag] objectForKey:@"id"];
    NSString *attri = [NSString stringWithFormat:@"%@",[[_CategoryArr objectAtIndex:sender.tag] objectForKey:@"c_name"]];
    
    _categorylabel.text = attri;
    CGSize size = [_categorylabel sizeThatFits:CGSizeMake(MAXFLOAT, 52)];
    _categorylabel.frame = CGRectMake(_categorylabel.frame.origin.x, _categorylabel.frame.origin.y, size.width,  52);
    _categorylabel.textColor = [UIColor whiteColor];
    
    imagviewss = [[UIImageView alloc] initWithFrame:CGRectMake(_categorylabel.frame.size.width+_categorylabel.frame.origin.x+15, 12.5, 25, 25)];
    imagviewss.image = [UIImage imageNamed:@"backfabutiezi"];
    [self dismissview];
}
- (void)popview
{
    [_inputView endEditing:YES];
    
    backview.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        // 设置view弹出来的位置
        categoryview.frame = CGRectMake(15, Main_Height-150, Main_width-30, 150);
        lineview.frame = CGRectMake(15, Main_Height-3, Main_width-30, 3);
    }];
}
- (void)dismissview
{
    backview.hidden = YES;
    [UIView animateWithDuration:0.5 animations:^{
        
        categoryview.frame = CGRectMake(15, Main_Height, Main_width-30, 150);
        lineview.frame = CGRectMake(15, Main_Height+150, Main_width-30, 3);
    }];
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
    _Imagearr = [[NSMutableArray alloc] init];
    if ([_id isEqualToString:@""]){
        [MBProgressHUD showToastToView:self.view withText:@"请选择发帖种类"];
    }else if ([_inputView.text isEqualToString:@""]) {
        [MBProgressHUD showToastToView:self.view withText:@"内容不能为空"];
    } else{
        [self GeneralButtonAction];
        __weak typeof(self) weakSelf = self;
        HXDatePhotoToolManagerRequestType requestType;
        if (self.original) {
            requestType = HXDatePhotoToolManagerRequestTypeOriginal;
        }else {
            requestType = HXDatePhotoToolManagerRequestTypeHD;
        }
        [self.toolManager writeSelectModelListToTempPathWithList:self.selectList requestType:requestType success:^(NSArray<NSURL *> *allURL, NSArray<NSURL *> *photoURL, NSArray<NSURL *> *videoURL) {
            NSLog(@"\nall : %@ \nimage : %@ \nvideo : %@",allURL,photoURL,videoURL);
            
            for (int i=0; i<photoURL.count; i++) {
                NSURL *url = [photoURL objectAtIndex:i];
                if (url) {
                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                    NSLog(@"%@",image);
                    [_Imagearr addObject:image];
                }
            }
            NSLog(@"imgarr----%@--%ld",_Imagearr,_Imagearr.count);
            [weakSelf.view handleLoading];
            
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
            //formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
            NSString *imfnumstr = [NSString stringWithFormat:@"%ld",_Imagearr.count];
            NSData *nsdata = [_inputView.text
                              dataUsingEncoding:NSUTF8StringEncoding];
            NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
            NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
            NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[userinfo objectForKey:@"uid"],[userinfo objectForKey:@"username"]]];
            NSDictionary *dic = @{@"community_id":[userinfo objectForKey:@"community_id"],@"c_id":_id,@"content":base64Encoded,@"img_num":imfnumstr,@"apk_token":uid_username,@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"]};
            NSLog(@"%@",dic);
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *API = [defaults objectForKey:@"API"];
            NSString *url = [API stringByAppendingString:@"social/social_save"];
            [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                for (int i=0; i<_Imagearr.count; i++)
                {
                    UIImageView *imageview = [[UIImageView alloc] init];
                    imageview.image = [_Imagearr objectAtIndex:i];
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
            
        } failed:^{
            [weakSelf.view handleLoading];
            [weakSelf.view showImageHUDText:@"写入失败"];
            NSSLog(@"写入失败");
        }];
        
    }

}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma  mark - textField delegate
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"点击空白");
    [_inputView endEditing:YES];
    [self dismissview];
}
- (void)downshoushi{
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [[self view] addGestureRecognizer:recognizer];
} 
//点击空白处的手势要实现的方法
-(void)viewTapped:(UISwipeGestureRecognizer *)recognizer
{
    CMInputView * field3=(CMInputView *)[self.view viewWithTag:1000];
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionDown) {
        
        
        
        NSLog(@"swipe down");
        
        
        [field3 resignFirstResponder];
    }
    
}
#pragma mark - 创建textview
- (void)ctratetextview
{
    _inputView = [[CMInputView alloc]initWithFrame:CGRectMake(10, 60, Main_width-20, 169)];
    _inputView.font = [UIFont systemFontOfSize:15];
    _inputView.delegate = self;
    _inputView.placeholder = @"与大家说说最近发生了什么事...";
    _inputView.tag = 1000;
    _inputView.placeholderColor = BackColor;
    _inputView.placeholderFont = [UIFont systemFontOfSize:15];
    //设置文本框最大行数
//    [_inputView textValueDidChanged:^(NSString *text, CGFloat textHeight) {
//        CGRect frame = _inputView.frame;
//        frame.size.height = textHeight;
//        _inputView.frame = frame;
//    }];
//
    _inputView.maxNumberOfLines = 10;
    [_scrollView addSubview:_inputView];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    NSLog(@"++++++++select");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {
    NSLog(@"所有:%ld - 照片:%ld - 视频:%ld",allList.count,photos.count,videos.count);
    NSLog(@"所有:%@ - 照片:%@ - 视频:%@",allList,photos,videos);
    
    [HXPhotoTools selectListWriteToTempPath:allList requestList:^(NSArray *imageRequestIds, NSArray *videoSessions) {
        
        NSLog(@"requestIds - image : %@ \nsessions - video : %@",imageRequestIds,videoSessions);
    } completion:^(NSArray<NSURL *> *allUrl, NSArray<NSURL *> *imageUrls, NSArray<NSURL *> *videoUrls) {
        NSLog(@"allUrl - %@\nimageUrls - %@\nvideoUrls - %@",allUrl,imageUrls,videoUrls);
    } error:^{
        NSLog(@"失败");
    }];
    
    self.original = isOriginal;
    self.selectList = allList;
}
- (void)photoView:(HXPhotoView *)photoView deleteNetworkPhoto:(NSString *)networkPhotoUrl {
    NSLog(@"----%@",networkPhotoUrl);
}

- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
    NSLog(@"%@",NSStringFromCGRect(frame));
    _scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(frame) + kPhotoViewMargin);
    
}

- (void)photoView:(HXPhotoView *)photoView currentDeleteModel:(HXPhotoModel *)model currentIndex:(NSInteger)index {
    NSLog(@"%@ --> index - %ld",model,index);
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
