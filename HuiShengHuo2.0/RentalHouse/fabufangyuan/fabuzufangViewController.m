//
//  fabuzufangViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/11/16.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "fabuzufangViewController.h"
#import "myhouseViewController.h"
@interface fabuzufangViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView *TabbleView;
    UITextField *textfieldname;
    UITextField *textfieldphone;
    UITextField *textfieldxaoqu;
    UITextField *textfieldlouceng;
    UITextField *textfieldzonglouceng;
    UITextField *textfieldmianji;
    UITextField *textfielddanjia;
    UITextField *totaltextfield;
    UITextField *textfieldzujin;
    
    UITextField *textfield1;
    UITextField *textfield2;
    UITextField *textfield3;
    UITextField *textfield4;
}

@end

@implementation fabuzufangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发布房源信息";
    
    [self CreateTableView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyHiden:) name:UIKeyboardWillHideNotification object:nil];
    // Do any additional setup after loading the view.
}
#pragma mark - 创建TableView
- (void)CreateTableView
{
    TabbleView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    //_Hometableview.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 0.01f)];
    /** 去除tableview 右侧滚动条 */
    TabbleView.estimatedRowHeight = 0;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
    TabbleView.tableHeaderView = view;
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
    TabbleView.tableFooterView = view1;
    TabbleView.showsVerticalScrollIndicator = YES;
    /** 去掉分割线 */
    TabbleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    TabbleView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    TabbleView.delegate = self;
    TabbleView.dataSource = self;
    [self.view addSubview:TabbleView];
}
#pragma mark - TableView的代理方法

//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

// 分组的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
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
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"  ";
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
    UIView *upview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_width, 14)];
    upview.backgroundColor = TabbleView.backgroundColor;
    [cell.contentView addSubview:upview];
    if (indexPath.row==0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 24, 70, 30)];
        label.text = @"联系人";
        label.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:label];
        
        textfieldname = [[UITextField alloc] initWithFrame:CGRectMake(125, 24, Main_width-30-140, 30)];
        textfieldname.placeholder = @"请输入联系人姓名";
        textfieldname.font = font15;
        textfieldname.tag = 0;
        textfieldname.delegate = self;
        [cell.contentView addSubview:textfieldname];
    }else if (indexPath.row==1){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 24, 70, 30)];
        label.text = @"手机号码";
        label.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:label];
        
        textfieldphone = [[UITextField alloc] initWithFrame:CGRectMake(125, 24, Main_width-30-140, 30)];
        textfieldphone.placeholder = @"请输入手机号码";
        textfieldphone.font = font15;
        textfieldphone.tag = 1;
        textfieldphone.delegate = self;
        [cell.contentView addSubview:textfieldphone];
    }else if (indexPath.row==2){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 24, 70, 30)];
        label.text = @"小区名称";
        label.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:label];
        
        textfieldxaoqu = [[UITextField alloc] initWithFrame:CGRectMake(125, 24, Main_width-30-140, 30)];
        textfieldxaoqu.placeholder = @"请输入小区名称";
        textfieldxaoqu.font = font15;
        textfieldxaoqu.tag = 2;
        textfieldxaoqu.delegate = self;
        [cell.contentView addSubview:textfieldxaoqu];
    }else if (indexPath.row==3){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 24, 70, 30)];
        label.text = @"户型";
        label.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:label];
        
        textfield1 = [[UITextField alloc] initWithFrame:CGRectMake(125, 24, 30, 30)];
        textfield1.font = font15;
        [cell.contentView addSubview:textfield1];
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(125+30, 24, 15, 30)];
        label1.text = @"室";
        label1.font = Font(15);
        [cell.contentView addSubview:label1];
        UIView *lineview1 = [[UIView alloc] initWithFrame:CGRectMake(125, textfield1.frame.size.height+textfield1.frame.origin.y, 30, 1)];
        lineview1.backgroundColor = [UIColor colorWithHexString:@"#D2D2D2"];
        [cell.contentView addSubview:lineview1];
        
        textfield2 = [[UITextField alloc] initWithFrame:CGRectMake(125+30+15, 24, 30, 30)];
        textfield2.font = font15;
        [cell.contentView addSubview:textfield2];
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(125+30+15+30, 24, 15, 30)];
        label2.text = @"厅";
        label2.font = Font(15);
        [cell.contentView addSubview:label2];
        UIView *lineview2 = [[UIView alloc] initWithFrame:CGRectMake(125+30+15, textfield2.frame.size.height+textfield2.frame.origin.y, 30, 1)];
        lineview2.backgroundColor = [UIColor colorWithHexString:@"#D2D2D2"];
        [cell.contentView addSubview:lineview2];
        
        textfield3 = [[UITextField alloc] initWithFrame:CGRectMake(125+30+15+45, 24, 30, 30)];
        textfield3.font = font15;
        [cell.contentView addSubview:textfield3];
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(125+30+15+45+30, 24, 15, 30)];
        label3.text = @"厨";
        label3.font = Font(15);
        [cell.contentView addSubview:label3];
        UIView *lineview3 = [[UIView alloc] initWithFrame:CGRectMake(125+30+15+45, textfield3.frame.size.height+textfield3.frame.origin.y, 30, 1)];
        lineview3.backgroundColor = [UIColor colorWithHexString:@"#D2D2D2"];
        [cell.contentView addSubview:lineview3];
        
        textfield4 = [[UITextField alloc] initWithFrame:CGRectMake(125+30+15+45*2, 24, 30, 30)];
        textfield4.font = font15;
        [cell.contentView addSubview:textfield4];
        UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(125+30+15+45*2+30, 24, 15, 30)];
        label4.text = @"卫";
        label4.font = Font(15);
        [cell.contentView addSubview:label4];
        UIView *lineview4 = [[UIView alloc] initWithFrame:CGRectMake(125+30+15+45*2, textfield4.frame.size.height+textfield4.frame.origin.y, 30, 1)];
        lineview4.backgroundColor = [UIColor colorWithHexString:@"#D2D2D2"];
        [cell.contentView addSubview:lineview4];
    }else if (indexPath.row==4){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 24, 70, 30)];
        label.text = @"楼层";
        label.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:label];
        
        textfieldlouceng = [[UITextField alloc] initWithFrame:CGRectMake(125, 24, Main_width-30-140, 30)];
        textfieldlouceng.placeholder = @"请输入楼层";
        textfieldlouceng.font = font15;
        textfieldlouceng.tag = 3;
        textfieldlouceng.delegate = self;
        [cell.contentView addSubview:textfieldlouceng];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(Main_width-90, 24, 75, 30)];
        label1.text = @"层";
        label1.font = font15;
        label1.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:label1];
    }else if (indexPath.row==5){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 24, 70, 30)];
        label.text = @"总楼层";
        label.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:label];
        
        textfieldzonglouceng = [[UITextField alloc] initWithFrame:CGRectMake(125, 24, Main_width-30-140, 30)];
        textfieldzonglouceng.placeholder = @"请输入总楼层";
        textfieldzonglouceng.font = font15;
        textfieldzonglouceng.tag = 4;
        textfieldzonglouceng.delegate = self;
        [cell.contentView addSubview:textfieldzonglouceng];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(Main_width-90, 24, 75, 30)];
        label1.text = @"层";
        label1.font = font15;
        label1.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:label1];
    }else if (indexPath.row==6){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 24, 70, 30)];
        label.text = @"面积";
        label.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:label];
        
        textfieldmianji = [[UITextField alloc] initWithFrame:CGRectMake(125, 24, Main_width-30-140, 30)];
        textfieldmianji.placeholder = @"请输入房屋面积";
        textfieldmianji.font = font15;
        textfieldmianji.tag = 5;
        textfieldmianji.delegate = self;
        [cell.contentView addSubview:textfieldmianji];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(Main_width-90, 24, 75, 30)];
        label1.text = @"平方米";
        label1.font = font15;
        label1.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:label1];
    } else if (indexPath.row==7){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 24, 70, 30)];
        label.text = @"租金";
        label.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:label];
        
        textfieldzujin = [[UITextField alloc] initWithFrame:CGRectMake(125, 24, Main_width-30-140, 30)];
        textfieldzujin.placeholder = @"请输入租金";
        textfieldzujin.font = font15;
        textfieldzujin.tag = 6;
        textfieldzujin.delegate = self;
        [cell.contentView addSubview:textfieldzujin];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(Main_width-90, 24, 75, 30)];
        label1.text = @"元/月";
        label1.font = font15;
        label1.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:label1];
    }else{
        cell.contentView.backgroundColor = tableView.backgroundColor;
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(40, 19, Main_width-80, 45);
        but.backgroundColor = [UIColor colorWithRed:255/255.0 green:87/255.0 blue:34/255.0 alpha:1];
        but.layer.cornerRadius = 5;
        [but setTitle:@"确认发布" forState:UIControlStateNormal];
        //[but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        but.titleLabel.font = [UIFont systemFontOfSize:20];
        [but addTarget:self action:@selector(suer) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:but];
    }
    return cell;
}
- (void)suer
{
    if (textfieldname.text.length==0) {
        [MBProgressHUD showToastToView:self.view withText:@"请输入联系人"];
    }else if (textfieldphone.text.length==0){
        [MBProgressHUD showToastToView:self.view withText:@"请输入联系电话"];
    }else if (textfieldxaoqu.text.length==0){
        [MBProgressHUD showToastToView:self.view withText:@"请输入小区"];
    }else if (textfield1.text.length==0){
        [MBProgressHUD showToastToView:self.view withText:@"请输入户型"];
    }else if (textfield2.text.length==0){
        [MBProgressHUD showToastToView:self.view withText:@"请输入户型"];
    }else if (textfield3.text.length==0){
        [MBProgressHUD showToastToView:self.view withText:@"请输入户型"];
    }else if (textfield4.text.length==0){
        [MBProgressHUD showToastToView:self.view withText:@"请输入户型"];
    }else if (textfieldlouceng.text.length==0){
        [MBProgressHUD showToastToView:self.view withText:@"请输入楼层"];
    }else if (textfieldzonglouceng.text.length==0){
        [MBProgressHUD showToastToView:self.view withText:@"请输入总楼层"];
    }else if (textfieldmianji.text.length==0){
        [MBProgressHUD showToastToView:self.view withText:@"请输入面积"];
    }else if (textfieldzujin.text.length==0){
        [MBProgressHUD showToastToView:self.view withText:@"请输入租金"];
    } else{
        [self post];
    }
}

- (void)post
{
    NSString *user_name = textfieldname.text;
    NSString *phoneStr = textfieldphone.text;
    NSString *roomStr = textfield1.text;
    NSString *officeStr = textfield2.text;
    NSString *kitchenStr = textfield3.text;
    NSString *guardStr = textfield4.text;
    NSString *floorStr = textfieldlouceng.text;
    NSString *house_floorStr = textfieldzonglouceng.text;
    NSString *areaStr = textfieldmianji.text;
    NSString *unit_priceStr = textfieldzujin.text;
   
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
        
        //1.创建会话管理者
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        //2.封装参数
        NSDictionary *dict = nil;
        NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];

        dict = @{@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"],@"user_name":user_name,@"user_phone":phoneStr,@"community_name":[userinfo objectForKey:@"community_name"],@"room":roomStr,@"office":officeStr,@"kitchen":kitchenStr,@"guard":guardStr,@"floor":floorStr,@"house_floor":house_floorStr,@"area":areaStr,@"unit_price":unit_priceStr};

        NSString *strurl = [API stringByAppendingString:@"personalHouse/housesLeaseAddDo"];
        [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSLog(@"---%@--%@",responseObject,[responseObject objectForKey:@"msg"]);
            if ([[responseObject objectForKey:@"status"] integerValue]==1) {
                
                myhouseViewController *zfVC = [[myhouseViewController alloc]init];
                zfVC.selectindex = @"1";
                [self.navigationController pushViewController:zfVC animated:YES];
                
            }else{
                [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"failure--%@",error);
            [MBProgressHUD showToastToView:self.view withText:@"发布失败"];
        }];
    }// 在HUD被隐藏后的回调
       completionBlock:^{
           //操作执行完后取消对话框
           [_HUD removeFromSuperview];
           _HUD = nil;
       }];
}

//文本输入框开始输入时调用

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //[self keyHiden];
    if (textField.tag>2) {
        [self keyWillAppear];
    }
}
#pragma mark-键盘出现隐藏事件
-(void)keyHiden:(NSNotification *)notification
{
    WBLog(@"键盘下滑");
    // 键盘动画时间
    double duration = 0.25;
    
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        TabbleView.frame = CGRectMake(0, 0, TabbleView.frame.size.width, TabbleView.frame.size.height);
    }];
}
-(void)keyWillAppear
{
    //    //获取键盘高度，在不同设备上，以及中英文下是不同的
    //    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    ////    CGRect rect= [[notification.userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"]CGRectValue];
    //    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    //    //float height =
    
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = 0.25;
    [UIView animateWithDuration:duration animations:^{
        TabbleView.frame = CGRectMake(0.0f, -290, TabbleView.frame.size.width, TabbleView.frame.size.height);
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
