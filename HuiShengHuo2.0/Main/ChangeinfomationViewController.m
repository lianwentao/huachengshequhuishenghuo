//
//  ChangeinfomationViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/11/16.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import "ChangeinfomationViewController.h"
#import <AFNetworking.h>
#import "ASBirthSelectSheet.h"
#import "changenameViewController.h"
#import "UIImageView+WebCache.h"
#import "changepasswordViewController.h"

#define kScreen_Height   ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width    ([UIScreen mainScreen].bounds.size.width)
#import "PrefixHeader.pch"

@interface ChangeinfomationViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UITableView *_TableView;
    NSDictionary *dict;
    
    UILabel *_sexlabel;
    UILabel *_birthdaylabel;
    UILabel *fullnamelabel;
    UILabel *nicknamelabel;
    
    UIImageView *imageview; //头像
}

@end

@implementation ChangeinfomationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    dict = nil;
    
    //修改信息通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changefullname:) name:@"changeinfomationfullname" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change:) name:@"changeinfomationnickname" object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self CreateTableView];
    // Do any additional setup after loading the view.
}
- (void)changefullname:(NSNotification *)info
{
    fullnamelabel.text = [[info userInfo] objectForKey:@"name"];
}
- (void)change:(NSNotification *)info
{
    nicknamelabel.text = [[info userInfo] objectForKey:@"name"];
}
#pragma mark ------联网请求---
-(void)post
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
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
   
    NSString *strurl = [API stringByAppendingString:@"userCenter/edit_center"];
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        _DataArr = [[NSMutableArray alloc] init];
//        [_DataArr addObjectsFromArray:[responseObject objectForKey:@"data"]];
        //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
        NSLog(@"success--%@--%@",[responseObject class],responseObject);
        
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeinfomation" object:nil userInfo:nil];
        }else{
            NSLog(@"修改失败");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}

#pragma mark - 创建TableView
- (void)CreateTableView
{
    _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    //_Hometableview.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 0.01f)];
    /** 去除tableview 右侧滚动条 */
    /** 去掉分割线 */
    //_TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _TableView.estimatedRowHeight = 0;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
    _TableView.tableHeaderView = view;
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
    _TableView.tableFooterView = view1;
    _TableView.delegate = self;
    _TableView.dataSource = self;
    [self.view addSubview:_TableView];
}
#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==1) {
        return 3;
    }else{
        return 1;
    }
}

// 分组的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return 105;
    }else{
        return 55;
    }
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
    if (section==2) {
        return 0;
    }else{
        return 10;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"  ";
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        if (indexPath.section!=3) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
        }
    }
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            cell.textLabel.text = @"昵称";
            nicknamelabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width/3, 15, kScreen_Width/3*2-30, 25)];
            [cell.contentView addSubview:nicknamelabel];
            nicknamelabel.textAlignment = NSTextAlignmentRight;

            nicknamelabel.text = _nickname;
        
        }if (indexPath.row==1) {
            cell.textLabel.text = @"性别";
            _sexlabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width/3, 15, kScreen_Width/3*2-30, 25)];
            [cell.contentView addSubview:_sexlabel];
            _sexlabel.textAlignment = NSTextAlignmentRight;
            if ([_sex isEqualToString:@"1"]) {
                _sexlabel.text = @"男";
            }else{
                _sexlabel.text = @"女";
            }
            
        }if (indexPath.row==2) {
            cell.textLabel.text = @"出生日期";
            _birthdaylabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width/3, 15, kScreen_Width/3*2-30, 25)];
            [cell.contentView addSubview:_birthdaylabel];
            _birthdaylabel.textAlignment = NSTextAlignmentRight;
            _birthdaylabel.text = _birthday;
        }
    }if (indexPath.section==0) {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.textLabel.text = @"头像";
        imageview = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width-75-35, 15, 75, 75)];
        imageview.layer.masksToBounds = YES;
        imageview.layer.cornerRadius = 37.5;
        NSString *strurl = [API_img stringByAppendingString:_imagestr];
        
        if ([_imagestr rangeOfString:@"http://"].location == NSNotFound) {
            
            [imageview sd_setImageWithURL:[NSURL URLWithString:strurl] placeholderImage:[UIImage imageNamed:@"facehead1"]];
        } else {
            [imageview sd_setImageWithURL:[NSURL URLWithString:_imagestr] placeholderImage:[UIImage imageNamed:@"facehead1"]];
        }
        
        imageview.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                   action:@selector(alertcontroller:)];
        //给imageView添加手势
        [imageview addGestureRecognizer:singleTap];
        
        [cell.contentView addSubview:imageview];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1) {
        if (indexPath.row==1) {
            //初始化警告框
            UIAlertController*alert = [UIAlertController
                                       alertControllerWithTitle: @"选择性别"
                                       message: nil
                                       preferredStyle:UIAlertControllerStyleActionSheet];
            [alert addAction:[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                dict = @{@"sex":@"1",@"token":[defaults objectForKey:@"token"],@"tokenSecret":[defaults objectForKey:@"tokenSecret"]};
                
                _sexlabel.text = @"男";
                [self post];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                dict = @{@"sex":@"2",@"token":[defaults objectForKey:@"token"],@"tokenSecret":[defaults objectForKey:@"tokenSecret"]};
                _sexlabel.text = @"女";
                [self post];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]] ;
            //弹出提示框
            [self presentViewController:alert
                               animated:YES completion:nil];
        }if (indexPath.row==2) {
            [self createBirthday];
        }if (indexPath.row==0) {
            changenameViewController *fullnickname = [[changenameViewController alloc] init];
            fullnickname.name = _nickname;
            fullnickname.title = @"修改昵称";
            [self.navigationController pushViewController:fullnickname animated:YES];
        }
    }
}
#pragma mark - 生日选择器
- (void)createBirthday
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ASBirthSelectSheet *datesheet = [[ASBirthSelectSheet alloc] initWithFrame:self.view.bounds];
    datesheet.GetSelectDate = ^(NSString *dateStr) {
        _birthdaylabel.text = dateStr;
        dict = @{@"birthday":dateStr,@"token":[defaults objectForKey:@"token"],@"tokenSecret":[defaults objectForKey:@"tokenSecret"]};
        [self post];
    };
    [self.view addSubview:datesheet];
}
#pragma mark - 选取相片
- (void)alertcontroller:(UITapGestureRecognizer *)gesture
{
    NSLog(@"提示框");
    //初始化警告框
    UIAlertController*alert = [UIAlertController
                               alertControllerWithTitle: @"选取照片"
                               message: nil
                               preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self photos];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self xiangji];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]] ;
    //弹出提示框
    [self presentViewController:alert
                       animated:YES completion:nil];
}

- (void)photos
{
    //初始化UIImagePickerController
    UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
    //获取方式1：通过相册（呈现全部相册），UIImagePickerControllerSourceTypePhotoLibrary
    //获取方式2，通过相机，UIImagePickerControllerSourceTypeCamera
    //获取方方式3，通过相册（呈现全部图片），UIImagePickerControllerSourceTypeSavedPhotosAlbum
    PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//方式1
    //允许编辑，即放大裁剪
    PickerImage.allowsEditing = YES;
    //自代理
    PickerImage.delegate = self;
    //页面跳转
    [self presentViewController:PickerImage animated:YES completion:nil];
}
- (void)xiangji
{
    //初始化UIImagePickerController
    UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
    PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;//方式1
    //允许编辑，即放大裁剪
    PickerImage.allowsEditing = YES;
    //自代理
    PickerImage.delegate = self;
    //页面跳转
    [self presentViewController:PickerImage animated:YES completion:nil];
}

//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    //把newPhono设置成头像
    imageview.image = newPhoto;
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self postimage];
}
- (void)postimage
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = @{@"token":[defaults objectForKey:@"token"],@"tokenSecret":[defaults objectForKey:@"tokenSecret"]};
    //formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
    
    NSString *url = [API stringByAppendingString:@"userCenter/edit_center"];
    [manager POST:url parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
//        /* 本地图片上传 */
//        NSURL *imageUrl = [[NSBundle mainBundle] URLForResource:@"" withExtension:@"png"];
//        NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
        
         //直接将图片对象转成 data 也可以
         UIImage *image = imageview.image;
         NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat =@"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
        /* 上传数据拼接 */
        [formData appendPartWithFileData:imageData name:@"avatars" fileName:fileName mimeType:@"image/png"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"上传成功：%@", responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeinfomationtouxiang" object:nil userInfo:nil];
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
