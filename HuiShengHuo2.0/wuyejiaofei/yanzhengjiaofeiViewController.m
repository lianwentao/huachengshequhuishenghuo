//
//  yanzhengjiaofeiViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/8/23.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "yanzhengjiaofeiViewController.h"
#import "XiaoquViewController.h"
#import "jiaofeixiangqingViewController.h"
#import "wuyeqianfeiViewController.h"
#import "selectshangpuViewController.h"
#import <AFNetworking.h>
#import "MBProgressHUD+TVAssistant.h"
#import "newselectxiaoquViewController.h"
#import "newselctlouhaoViewController.h"
#import "newselectdanyuanViewController.h"
#import "newselectroomViewController.h"
@interface yanzhengjiaofeiViewController ()
{
    UITextField *textfield;
    
    NSString *community_id;
    NSString *building_id;
    NSString *community_name;
    NSString *building_name;
    NSString *code;
    NSString *units;
    NSString *room_id;
    NSString *name;
    NSString *phone;
    NSString *sign;
    NSString *c_name;
    NSString *company_id;
    NSString *company_name;
    NSString *department_id;
    NSString *department_name;
    NSString *floor;
    
    NSString *fullname;
    NSString *mobeil;
    NSString *is_ym;
    
    UILabel *xiaoqu;
    UILabel *louhao;
    UILabel *danyuan;
    UILabel *roomhao;
    
    NSString *_house_type;
}

@end

@implementation yanzhengjiaofeiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BackColor;
    self.title = @"验证房屋";
    [self createui];
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [[self view] addGestureRecognizer:recognizer];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change:) name:@"changetextfieldyanzheng" object:nil];
    // Do any additional setup after loading the view.
}
//- (void)change:(NSNotification *)userinfo
//{
//    NSLog(@"--dizhi%@",userinfo.userInfo[@"address"]);
//    //houselabel.text = userinfo.userInfo[@"address"];
//    //@"community_id":_community_id,@"building_id":_build_id,@"units":@"",@"room_id":[[_DataArr objectAtIndex:indexPath.row] objectForKey:@"code"]
//    community_id = userinfo.userInfo[@"community_id"];
//    community_name = userinfo.userInfo[@"community_name"];
//    building_id = userinfo.userInfo[@"building_id"];
//    building_name = userinfo.userInfo[@"build_name"];
//    units = userinfo.userInfo[@"units"];
//    room_id = userinfo.userInfo[@"room_id"];
//    code = userinfo.userInfo[@"code"];
//    company_id = userinfo.userInfo[@"company_id"];
//    company_name = userinfo.userInfo[@"company_name"];
//    department_id = userinfo.userInfo[@"department_id"];
//    department_name = userinfo.userInfo[@"department_name"];
//    floor = userinfo.userInfo[@"floor"];
//
////    label.text = userinfo.userInfo[@"address"];
//   // [self post];
//}
- (void)getData
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    dict = @{@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"]};
    NSString *strurl = [API stringByAppendingString:@"property/binding_community"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        NSLog(@"---%@--%@",responseObject,[responseObject objectForKey:@"msg"]);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            fullname = [[responseObject objectForKey:@"data"] objectForKey:@"name"];
            mobeil = [[responseObject objectForKey:@"data"] objectForKey:@"mp1"];
            is_ym = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"is_ym"]];
            [self bangding];
            
        }else{
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
- (void)bangding
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    dict = @{@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"],@"community_id":community_id,@"community_name":community_name,@"company_id":company_id,@"company_name":company_name,@"department_id":department_id,@"department_name":department_name,@"building_id":building_id,@"building_name":building_name,@"unit":units,@"floor":floor,@"code":code,@"room_id":room_id,@"fullname":fullname,@"mobile":mobeil,@"is_ym":is_ym};
    NSString *strurl = [API stringByAppendingString:@"property/pro_bind_user"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"---%@--%@",responseObject,[responseObject objectForKey:@"msg"]);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            if ([is_ym isEqualToString:@"0"]) {
                wuyeqianfeiViewController *qianfei = [[wuyeqianfeiViewController alloc] init];
                qianfei.room_id = room_id;
                [self.navigationController pushViewController:qianfei animated:YES];
            }else{
                jiaofeixiangqingViewController *xiangqing = [[jiaofeixiangqingViewController alloc] init];
                xiangqing.room_id = room_id;
                xiangqing.biaoshi = @"1";//1表示删除这个界面
                [self.navigationController pushViewController:xiangqing animated:YES];
            }
        }else{
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
- (void)createui
{
    if ([_house_type isEqualToString:@"2"]||[_house_type isEqualToString:@"4"]) {
        for (int i=0; i<3; i++) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, RECTSTATUS.size.height+50+58*i, Main_width, 50)];
            view.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:view];
            
            if (i==0) {
                xiaoqu = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, Main_width-20, 50)];
                xiaoqu.text = @"请选择小区";
                xiaoqu.font = font15;
                xiaoqu.alpha = 0.5;
                [view addSubview:xiaoqu];
            }else if (i==1){
                roomhao = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, Main_width-20, 50)];
                roomhao.text = @"请选择房间号";
                roomhao.font = font15;
                roomhao.alpha = 0.5;
                [view addSubview:roomhao];
            }else{
                textfield = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, Main_width-60-10, 50)];
                textfield.placeholder = @"请输入业主姓名或手机号";
                textfield.font = [UIFont systemFontOfSize:15];
                textfield.tag = 1000;
                [view addSubview:textfield];
            }
            if (i<2) {
                
                UIImageView *youjiantou = [[UIImageView alloc] initWithFrame:CGRectMake(Main_width-40, 15, 20, 20)];
                youjiantou.image = [UIImage imageNamed:@"youjiantou"];
                [view addSubview:youjiantou];
                
                UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
                but.frame = CGRectMake(0, 0, Main_width, 50);
                but.tag = i;
                [but addTarget:self action:@selector(selectehouse1:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:but];
            }
        }
    }else{
        for (int i=0; i<5; i++) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, RECTSTATUS.size.height+50+58*i, Main_width, 50)];
            view.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:view];
            
            if (i==0) {
                xiaoqu = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, Main_width-20, 50)];
                xiaoqu.text = @"请选择小区";
                xiaoqu.font = font15;
                xiaoqu.alpha = 0.5;
                [view addSubview:xiaoqu];
            }else if (i==1){
                louhao = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, Main_width-20, 50)];
                louhao.text = @"请选择楼号";
                louhao.font = font15;
                louhao.alpha = 0.5;
                [view addSubview:louhao];
            }else if (i==2){
                danyuan = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, Main_width-20, 50)];
                danyuan.text = @"请选择单元";
                danyuan.font = font15;
                danyuan.alpha = 0.5;
                [view addSubview:danyuan];
            }else if (i==3){
                roomhao = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, Main_width-20, 50)];
                roomhao.text = @"请选择房间号";
                roomhao.font = font15;
                roomhao.alpha = 0.5;
                [view addSubview:roomhao];
            }else{
                textfield = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, Main_width-60-10, 50)];
                textfield.placeholder = @"请输入业主姓名或手机号";
                textfield.font = [UIFont systemFontOfSize:15];
                textfield.tag = 1000;
                [view addSubview:textfield];
            }
            if (i<4) {
                
                UIImageView *youjiantou = [[UIImageView alloc] initWithFrame:CGRectMake(Main_width-40, 15, 20, 20)];
                youjiantou.image = [UIImage imageNamed:@"youjiantou"];
                [view addSubview:youjiantou];
                
                UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
                but.frame = CGRectMake(0, 0, Main_width, 50);
                but.tag = i;
                [but addTarget:self action:@selector(selectehouse:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:but];
            }
        }
    }
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake(40, Main_Height-70, Main_width-80, 45);
    but.backgroundColor = [UIColor colorWithRed:255/255.0 green:87/255.0 blue:34/255.0 alpha:1];
    but.layer.cornerRadius = 5;
    [but setTitle:@"确定" forState:UIControlStateNormal];
    //[but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    but.titleLabel.font = [UIFont systemFontOfSize:20];
    [but addTarget:self action:@selector(suer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];
}
- (void)suer
{
    WBLog(@"-%@-%@-%@-%@",community_id,building_id,units,code);
    if ([_house_type isEqualToString:@"2"]||[_house_type isEqualToString:@"4"]) {
        if (community_id.length == 0) {
            [MBProgressHUD showToastToView:self.view withText:@"请先选择小区"];
        }else if (code.length == 0){
            [MBProgressHUD showToastToView:self.view withText:@"请先选择房间号"];
        }else if (textfield.text.length == 0){
            [MBProgressHUD showToastToView:self.view withText:@"请填写业主姓名或手机号"];
        }else{
            [self bangdingyanzheng];
        }
    }else{
        if (community_id.length == 0) {
            [MBProgressHUD showToastToView:self.view withText:@"请先选择小区"];
        }else if (building_id.length == 0){
            [MBProgressHUD showToastToView:self.view withText:@"请先选择楼号"];
        }else if (units.length == 0){
            [MBProgressHUD showToastToView:self.view withText:@"请先选择单元号"];
        }else if (code.length == 0){
            [MBProgressHUD showToastToView:self.view withText:@"请先选择房间号"];
        }else if (textfield.text.length == 0){
            [MBProgressHUD showToastToView:self.view withText:@"请填写业主姓名或手机号"];
        }else{
            [self bangdingyanzheng];
        }
    }
}
- (void)bangdingyanzheng
{
    NSString *nameorphone = textfield.text;
    //初始化进度框，置于当前的View当中
    static MBProgressHUD *_HUD;
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    
    //如果设置此属性则当前的view置于后台
    //_HUD.dimBackground = YES;
    
    //设置对话框文字
    _HUD.labelText = @"绑定中...";
    _HUD.labelFont = [UIFont systemFontOfSize:14];
    
    //显示对话框
    [_HUD showAnimated:YES whileExecutingBlock:^{
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        //2.封装参数
        NSDictionary *dict = nil;
        NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
        dict = @{@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"],@"room_id":code,@"key_str":nameorphone};
        NSString *strurl = [API stringByAppendingString:@"property/getPersonalInfo"];
        [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSLog(@"---%@--%@",responseObject,[responseObject objectForKey:@"msg"]);
            if ([[responseObject objectForKey:@"status"] integerValue]==1) {
                [self newbangding:[responseObject objectForKey:@"data"]];
            }else{
                [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"failure--%@",error);
        }];
    }// 在HUD被隐藏后的回调
       completionBlock:^{
           //操作执行完后取消对话框
           [_HUD removeFromSuperview];
           _HUD = nil;
       }];
    
}
- (void)newbangding:(NSMutableDictionary *)Dictionary
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    if ([_house_type isEqualToString:@"2"]||[_house_type isEqualToString:@"4"]) {
        dict = @{@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"],@"community_id":[Dictionary objectForKey:@"community_id"],@"community_name":[Dictionary objectForKey:@"community_name"],@"company_id":[Dictionary objectForKey:@"company_id"],@"company_name":[Dictionary objectForKey:@"company_name"],@"department_id":[Dictionary objectForKey:@"department_id"],@"department_name":[Dictionary objectForKey:@"department_name"],@"building_id":[Dictionary objectForKey:@"building_id"],@"building_name":[Dictionary objectForKey:@"building_name"],@"code":[Dictionary objectForKey:@"code"],@"room_id":[Dictionary objectForKey:@"room_id"],@"fullname":[Dictionary objectForKey:@"fullname"],@"mobile":[Dictionary objectForKey:@"mobile"],@"is_ym":[Dictionary objectForKey:@"is_ym"],@"house_type":[Dictionary objectForKey:@"houses_type"]};
    }else{
        dict = @{@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"],@"community_id":[Dictionary objectForKey:@"community_id"],@"community_name":[Dictionary objectForKey:@"community_name"],@"company_id":[Dictionary objectForKey:@"company_id"],@"company_name":[Dictionary objectForKey:@"company_name"],@"department_id":[Dictionary objectForKey:@"department_id"],@"department_name":[Dictionary objectForKey:@"department_name"],@"building_id":[Dictionary objectForKey:@"building_id"],@"building_name":[Dictionary objectForKey:@"building_name"],@"unit":[Dictionary objectForKey:@"unit"],@"floor":[Dictionary objectForKey:@"floor"],@"code":[Dictionary objectForKey:@"code"],@"room_id":[Dictionary objectForKey:@"room_id"],@"fullname":[Dictionary objectForKey:@"fullname"],@"mobile":[Dictionary objectForKey:@"mobile"],@"is_ym":[Dictionary objectForKey:@"is_ym"],@"house_type":[Dictionary objectForKey:@"houses_type"]};
    }
    
    WBLog(@"%@--%@",Dictionary,dict);
    NSString *strurl = [API stringByAppendingString:@"property/pro_bind_user"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSLog(@"---%@--%@",responseObject,[responseObject objectForKey:@"msg"]);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            if ([_gonggongbaoxiu isEqualToString:@"1"]) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shuaxinmyhome" object:nil userInfo:nil];
        }else{
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
- (void)selectehouse:(UIButton *)sender
{
    if (sender.tag==0) {
        newselectxiaoquViewController *vc = [[newselectxiaoquViewController alloc] init];
        vc.returnValueBlock = ^(NSString *c_id,NSString *xiaoquname,NSString *house_type){
            
            _house_type = house_type;
            [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self createui];
            community_id = c_id;
            xiaoqu.text = xiaoquname;
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag==1){
        if (community_id.length == 0) {
            [MBProgressHUD showToastToView:self.view withText:@"请先选择小区"];
        }else{
            newselctlouhaoViewController *vc = [[newselctlouhaoViewController alloc] init];
            vc.returnValueBlock = ^(NSString *blockid,NSString *blockname,NSString *house_type){
                building_id = blockid;
                louhao.text = blockname;
            };
            vc.c_id = community_id;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (sender.tag==2){
        if (community_id.length == 0) {
            [MBProgressHUD showToastToView:self.view withText:@"请先选择小区"];
        }else if (building_id.length == 0){
            [MBProgressHUD showToastToView:self.view withText:@"请先选择楼号"];
        }else{
            newselectdanyuanViewController *vc = [[newselectdanyuanViewController alloc] init];
            vc.returnValueBlock = ^(NSString *blockid,NSString *blockname,NSString *house_type){
                units = blockid;
                danyuan.text = blockname;
            };
            vc.c_id = community_id;
            vc.buildid = building_id;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else {
        if (community_id.length == 0) {
            [MBProgressHUD showToastToView:self.view withText:@"请先选择小区"];
        }else if (building_id.length == 0){
            [MBProgressHUD showToastToView:self.view withText:@"请先选择楼号"];
        }else if (units.length == 0){
            [MBProgressHUD showToastToView:self.view withText:@"请先选择单元号"];
        }else{
            newselectroomViewController *vc = [[newselectroomViewController alloc] init];
            vc.returnValueBlock = ^(NSString *blockid,NSString *blockname,NSString *house_type){
                code = blockid;
                roomhao.text = blockname;
            };
            vc.c_id = community_id;
            vc.buildid = building_id;
            vc.danyuanid = units;
            vc.housetype = _house_type;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
- (void)selectehouse1:(UIButton *)sender
{
    if (sender.tag==0) {
        newselectxiaoquViewController *vc = [[newselectxiaoquViewController alloc] init];
        vc.returnValueBlock = ^(NSString *c_id,NSString *xiaoquname,NSString *house_type){
            
            _house_type = house_type;
            [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self createui];
            community_id = c_id;
            xiaoqu.text = xiaoquname;
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        if (community_id.length == 0) {
            [MBProgressHUD showToastToView:self.view withText:@"请先选择小区"];
        }else{
            newselectroomViewController *vc = [[newselectroomViewController alloc] init];
            vc.returnValueBlock = ^(NSString *blockid,NSString *blockname,NSString *house_type){
                code = blockid;
                roomhao.text = blockname;
            };
            vc.c_id = community_id;
            vc.buildid = building_id;
            vc.danyuanid = units;
            vc.housetype = _house_type;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
#pragma  mark - textField delegate
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"点击空白");
    [textfield endEditing:YES];
}
//点击空白处的手势要实现的方法
-(void)viewTapped:(UISwipeGestureRecognizer *)recognizer
{
    UITextField * field=(UITextField *)[self.view viewWithTag:1000];
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionDown) {
        
        
        
        NSLog(@"swipe down");
        
        
        [field resignFirstResponder];
    }
    
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
