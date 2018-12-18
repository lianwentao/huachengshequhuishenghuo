//
//  ziyonggongdanViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/12/15.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "ziyonggongdanViewController.h"
#import "CMInputView.h"
#import "HXPhotoPicker.h"
#import "gongdanadressViewController.h"
#import "mywuyegongdanViewController.h"
#import "AllPayViewController.h"
@interface ziyonggongdanViewController ()<HXPhotoViewDelegate,UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>{
    UITableView *_TableView;
    CMInputView *TextView;
    UITextField *Textfield1;
    UITextField *Textfield2;
    UILabel *homelabel;
    
    NSString *blockadress;
    NSString *blockadressid;
    NSString *blockname;
    NSString *blockphone;
    NSDictionary *blockdic;
    
    NSMutableArray*_Imagearr;
}
@property (strong, nonatomic) HXPhotoManager *manager;
@property (strong, nonatomic) HXPhotoView *photoView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) HXDatePhotoToolManager *toolManager;
@property (assign, nonatomic) BOOL original;
@property (copy, nonatomic) NSArray *selectList;
@end

@implementation ziyonggongdanViewController

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
        _manager.configuration.photoMaxNum = 4;
        _manager.configuration.videoMaxNum = 0;
        _manager.configuration.maxNum = 4;
        _manager.configuration.videoMaxDuration = 500.f;
        _manager.configuration.saveSystemAblum = NO;
        //        _manager.configuration.reverseDate = YES;
        _manager.configuration.showDateSectionHeader = NO;
        _manager.configuration.selectTogether = NO;
        _manager.configuration.rowCount = 3;
        _manager.configuration.movableCropBox = YES;
        _manager.configuration.movableCropBoxEditSize = YES;
        _manager.configuration.movableCropBoxCustomRatio = CGPointMake(1, 1);
        
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
    [TextView endEditing:YES];
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
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createtableview];
    // Do any additional setup after loading the view.
}
- (void)createtableview
{
    _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_width, Main_Height)];
    _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _TableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _TableView.delegate = self;
    _TableView.dataSource = self;
    _TableView.backgroundColor = BackColor;
    //_TableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(post1)];
    [self.view addSubview:_TableView];
}
#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

// 分组的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//headview的高度和内容
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"   ";
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
    NSString *cellIndetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
    }
    if (indexPath.row==0) {
        cell.backgroundColor = BackColor;
        tableView.rowHeight = 8;
    }else if (indexPath.row==1){
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, Main_width-40, 50)];
        label.text = [NSString stringWithFormat:@"保修类型  %@",_type];
        label.font = Font(15);
        [cell.contentView addSubview:label];
        tableView.rowHeight = 50;
    }else if (indexPath.row==2){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, Main_width-30, 40)];
        label.text = [NSString stringWithFormat:@"预付费用：%@元（此费用包含在订单总价内)",_entry_fee];
        label.font = Font(13);
        label.textColor = [UIColor colorWithHexString:@"#FF5722"];
        [cell.contentView addSubview:label];
        cell.backgroundColor = BackColor;
        tableView.rowHeight = 40;
    }else if (indexPath.row==3){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, Main_width-30, 15)];
        label.text = @"维修备注";
        label.font = Font(15);
        [cell.contentView addSubview:label];
        
        TextView = [[CMInputView alloc] initWithFrame:CGRectMake(15, 15+15+13, Main_width-30, 106)];
        TextView.delegate = self;
        TextView.clipsToBounds = YES;
        TextView.layer.borderWidth = 1;
        TextView.layer.borderColor = [UIColor colorWithHexString:@"#D2D2D2"].CGColor;
        TextView.layer.cornerRadius = 5;
        TextView.placeholder = @"请描述维修问题";
        [cell.contentView addSubview:TextView];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, TextView.frame.size.height+TextView.frame.origin.y+25, Main_width-30, 15)];
        label1.text = @"上传故障图片";
        label1.font = Font(15);
        [cell.contentView addSubview:label1];
        
        CGFloat width = Main_width-30;
        HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
        photoView.frame = CGRectMake(15, label1.frame.size.height+label1.frame.origin.y+15, width, 0);
        photoView.delegate = self;
        photoView.outerCamera = YES;
        photoView.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:photoView];
        self.photoView = photoView;
        self.photoView.lineCount = 4;
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(15, label1.frame.size.height+label1.frame.origin.y+10+15+(Main_width-30-9)/4, Main_width-30, 15)];
        label2.text = @"最多上传4张";
        label2.font = Font(13);
        label2.textColor = [UIColor colorWithHexString:@"#9C9C9C"];
        [cell.contentView addSubview:label2];
        tableView.rowHeight = label2.frame.size.height+label2.frame.origin.y+10;
    }else if (indexPath.row==4){
        cell.backgroundColor = BackColor;
        tableView.rowHeight = 8;
    }else if (indexPath.row==5){
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, Main_width-40, 50)];
        label.text = @"选择房屋";
        label.font = Font(15);
        [cell.contentView addSubview:label];
        
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(0, 0, Main_width, 50);
        [but addTarget:self action:@selector(xuanzedizhi) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:but];
        tableView.rowHeight = 50;
    }else if (indexPath.row==6){
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(12, 15+10, 60, 15)];
        label1.text = @"姓名";
        label1.font = Font(15);
        [cell.contentView addSubview:label1];
        
        Textfield1 = [[UITextField alloc] initWithFrame:CGRectMake(label1.frame.size.width+label1.frame.origin.x, 15, 150, 35)];
        Textfield1.clipsToBounds = YES;
        Textfield1.layer.borderWidth = 1;
        Textfield1.layer.cornerRadius = 5;
        Textfield1.font = Font(15);
        Textfield1.layer.borderColor = [UIColor colorWithHexString:@"#D2D2D2"].CGColor;
        [cell.contentView addSubview:Textfield1];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(12, label1.frame.size.height+label1.frame.origin.y+30, 60, 15)];
        label2.text = @"手机号";
        label2.font = Font(15);
        [cell.contentView addSubview:label2];
        
        Textfield2 = [[UITextField alloc] initWithFrame:CGRectMake(label1.frame.size.width+label1.frame.origin.x, label1.frame.size.height+label1.frame.origin.y+20, 150, 35)];
        Textfield2.clipsToBounds = YES;
        Textfield2.layer.cornerRadius = 5;
        Textfield2.layer.borderWidth = 1;
        Textfield2.font = Font(15);
        Textfield2.layer.borderColor = [UIColor colorWithHexString:@"#D2D2D2"].CGColor;
        [cell.contentView addSubview:Textfield2];
        
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(12, label2.frame.size.height+label2.frame.origin.y+30, 60, 15)];
        label3.text = @"房屋";
        label3.font = Font(15);
        [cell.contentView addSubview:label3];
        
        homelabel = [[UILabel alloc] initWithFrame:CGRectMake(label3.frame.size.width+label3.frame.origin.x, label2.frame.size.height+label2.frame.origin.y+20, Main_width-60-15, 40)];
        homelabel.font = Font(15);
        homelabel.numberOfLines = 3;
        [cell.contentView addSubview:homelabel];
        tableView.rowHeight = homelabel.frame.size.height+homelabel.frame.origin.y+15;
        
    }else{
        cell.contentView.backgroundColor = BackColor;
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(40, 25, Main_width-80, 45);
        but.backgroundColor = [UIColor colorWithRed:255/255.0 green:87/255.0 blue:34/255.0 alpha:1];
        but.layer.cornerRadius = 20;
        [but setTitle:@"提交订单" forState:UIControlStateNormal];
        //[but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        but.titleLabel.font = [UIFont systemFontOfSize:20];
        [but addTarget:self action:@selector(suer) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:but];
        tableView.rowHeight = 95;
    }
    return cell;
}
- (void)suer
{
    if (homelabel.text.length == 0) {
        [MBProgressHUD showToastToView:self.view withText:@"请选择房屋"];
    }else{
        _Imagearr = [NSMutableArray arrayWithCapacity:0];
        NSString *content = TextView.text;
        NSString *name = Textfield1.text;
        NSString *phone = Textfield2.text;
        //初始化进度框，置于当前的View当中
        static MBProgressHUD *_HUD;
        _HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_HUD];
        
        //如果设置此属性则当前的view置于后台
        //_HUD.dimBackground = YES;
        
        //设置对话框文字
        _HUD.labelText = @"发布中...";
        _HUD.labelFont = [UIFont systemFontOfSize:14];
        
        //显示对话框
        [_HUD showAnimated:YES whileExecutingBlock:^{
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
                NSString *string2 = [NSString stringWithFormat:@"%@%@%@%@",[blockdic objectForKey:@"community_name"],[blockdic objectForKey:@"building_name"],[blockdic objectForKey:@"unit"],[blockdic objectForKey:@"code"]];
                NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
                NSDictionary *dic = @{@"work_type":@"1",@"type_id":_type_id,@"type_name":_type,@"community_id":[blockdic objectForKey:@"community_id"],@"room_id":[blockdic objectForKey:@"room_id"],@"company_id":[blockdic objectForKey:@"company_id"],@"contact":name,@"userphone":phone,@"address":string2,@"type_pid":_type_pid,@"img_num":imfnumstr,@"content":content,@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"]};
                NSLog(@"%@",dic);
                NSString *url = [API stringByAppendingString:@"propertyWork/workSave"];
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
                    
                    NSLog(@"%@==%@",responseObject, [responseObject objectForKey:@"msg"]);
                    NSString *status = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]];
                    if ([status isEqualToString:@"1"]) {
                        [self zhiFuAction:[[responseObject objectForKey:@"data"] objectForKey:@"id"]:[[responseObject objectForKey:@"data"] objectForKey:@"entry_fee"]];
                    }else{
                        [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
                    }
                    
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    NSLog(@"上传失败：%@", error);
                    
                    [MBProgressHUD showToastToView:self.view withText:@"发布失败"];
                }];
                
            } failed:^{
                [weakSelf.view handleLoading];
                [weakSelf.view showImageHUDText:@"写入失败"];
                NSSLog(@"写入失败");
            }];
            
        }// 在HUD被隐藏后的回调
           completionBlock:^{
               //操作执行完后取消对话框
               [_HUD removeFromSuperview];
               _HUD = nil;
           }];
    }
}
#pragma mark - 支付预付款
-(void)zhiFuAction:(NSString *)ordid :(NSString *)price
{
    NSString *str = price;
    NSArray *array = [str componentsSeparatedByString:@"."]; //从字符.中分隔成2个元素的数组
    SpecialAlertView *fuKuan = [[SpecialAlertView alloc]initWithMessageTitle:@"您需要支付预付费用" messageString:[NSString stringWithFormat:@"%@.",array[0]] messageString1:array[1]  sureBtnTitle:@"立即支付" sureBtnColor:[UIColor blueColor]];
    [fuKuan withSureClick:^(NSString *string) {
        AllPayViewController *allpay = [[AllPayViewController alloc] init];
        allpay.order_id = ordid;
        allpay.type = @"wuyegongdanfukuan";
        allpay.rukoubiaoshi = @"wuyegongdanfukuan";
        allpay.price = price;
        allpay.prepay = @"1";//预付款
        [self.navigationController pushViewController:allpay animated:YES];
    }];
}
- (void)xuanzedizhi
{
    gongdanadressViewController *address = [[gongdanadressViewController alloc] init];
    
    //赋值Block，并将捕获的值赋值给UILabel
    address.returnValueBlock = ^(NSDictionary *datadic){
        NSString *string = [NSString stringWithFormat:@"%@ %@号楼%@单元%@",[datadic objectForKey:@"community_name"],[datadic objectForKey:@"building_name"],[datadic objectForKey:@"unit"],[datadic objectForKey:@"code"]];
        homelabel.text = string;
        
        Textfield1.text = [datadic objectForKey:@"fullname"];
        Textfield2.text = [datadic objectForKey:@"mobile"];
        blockdic = datadic;
    };
    [self.navigationController pushViewController:address animated:YES];
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
