//
//  fabushoufangViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/11/16.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "fabushoufangViewController.h"
#import <AFNetworking.h>
#import "MBProgressHUD+TVAssistant.h"
@interface fabushoufangViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView *TabbleView;
}

@end

@implementation fabushoufangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布房源信息";
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyHiden:) name:UIKeyboardWillHideNotification object:nil];
    [self CreateTableView];
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
    return 10;
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
    static NSString *cellIndetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndetifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
    }
    UIView *upview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_width, 14)];
    upview.backgroundColor = TabbleView.backgroundColor;
    [cell.contentView addSubview:upview];
    if (indexPath.row==0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 24, 70, 30)];
        label.text = @"联系人";
        label.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:label];
        
        UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(125, 24, Main_width-30-140, 30)];
        textfield.placeholder = @"请输入联系人姓名";
        textfield.font = font15;
        textfield.tag = 0;
        textfield.delegate = self;
        [cell.contentView addSubview:textfield];
    }else if (indexPath.row==1){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 24, 70, 30)];
        label.text = @"手机号码";
        label.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:label];
        
        UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(125, 24, Main_width-30-140, 30)];
        textfield.placeholder = @"请输入手机号码";
        textfield.tag = 1;
        textfield.delegate = self;
        textfield.font = font15;
        [cell.contentView addSubview:textfield];
    }else if (indexPath.row==2){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 24, 70, 30)];
        label.text = @"小区名称";
        label.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:label];
        
        UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(125, 24, Main_width-30-140, 30)];
        textfield.placeholder = @"请输入小区名称";
        textfield.tag = 2;
        textfield.delegate = self;
        textfield.font = font15;
        [cell.contentView addSubview:textfield];
    }else if (indexPath.row==3){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 24, 70, 30)];
        label.text = @"户型";
        label.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:label];
    }else if (indexPath.row==4){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 24, 70, 30)];
        label.text = @"楼层";
        label.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:label];
        
        UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(125, 24, Main_width-30-140, 30)];
        textfield.placeholder = @"请输入楼层";
        textfield.tag = 3;
        textfield.delegate = self;
        textfield.font = font15;
        [cell.contentView addSubview:textfield];
        
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
        
        UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(125, 24, Main_width-30-140, 30)];
        textfield.placeholder = @"请输入总楼层";
        textfield.tag = 4;
        textfield.delegate = self;
        textfield.font = font15;
        [cell.contentView addSubview:textfield];
        
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
        
        UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(125, 24, Main_width-30-140, 30)];
        textfield.placeholder = @"请输入房屋面积";
        textfield.tag = 5;
        textfield.delegate = self;
        textfield.font = font15;
        [cell.contentView addSubview:textfield];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(Main_width-90, 24, 75, 30)];
        label1.text = @"平方米";
        label1.font = font15;
        
        label1.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:label1];
    }else if (indexPath.row==7){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 24, 70, 30)];
        label.text = @"单价";
        label.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:label];
        
        UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(125, 24, Main_width-30-140, 30)];
        textfield.placeholder = @"请输入出售单价";
        textfield.tag = 6;
        textfield.delegate = self;
        textfield.font = font15;
        [cell.contentView addSubview:textfield];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(Main_width-90, 24, 75, 30)];
        label1.text = @"元/每平米";
        label1.font = font15;
        label1.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:label1];
    }else if (indexPath.row==8){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 24, 70, 30)];
        label.text = @"售价";
        label.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:label];
        
        UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(125, 24, Main_width-30-140, 30)];
        textfield.placeholder = @"自动计算售价";
        textfield.font = font15;
        [cell.contentView addSubview:textfield];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(Main_width-90, 24, 75, 30)];
        label1.text = @"元";
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
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    dict = @{@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"],@"user_name":@"廉文涛",@"user_phone":@"15901106303",@"community_name":@"商贸",@"room":@"18",@"office":@"5",@"kitchen":@"6",@"guard":@"3",@"floor":@"20",@"house_floor":@"200",@"area":@"400",@"unit_price":@"100",@"total_price":@"40000"};
    NSString *strurl = [API stringByAppendingString:@"personalHouse/housesAddDo"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"---%@--%@",responseObject,[responseObject objectForKey:@"msg"]);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            
        }else{
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
//文本输入框开始输入时调用

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //[self keyHiden];
    if (textField.tag>4) {
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
