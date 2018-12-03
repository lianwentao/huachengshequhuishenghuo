//
//  cancledingdanViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/11/26.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "cancledingdanViewController.h"
#import "CMInputView.h"
@interface cancledingdanViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    NSArray *dataarr;
    UITableView *_TableView;
    UIButton *_tmpBtn;
    CMInputView *TextView;
    UILabel *lbRemainCount;
    UIView *_View;
}

@end

@implementation cancledingdanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"取消订单";
    dataarr = [[NSArray alloc] init];
    
    
    //设置两个通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyHiden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyWillAppear:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [self getdata];
    // Do any additional setup after loading the view.
}
- (void)getdata
{
    //初始化进度框，置于当前的View当中
    static MBProgressHUD *_HUD;
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    
    //如果设置此属性则当前的view置于后台
    //_HUD.dimBackground = YES;
    
    //设置对话框文字
    _HUD.labelText = @"加载中...";
    _HUD.labelFont = [UIFont systemFontOfSize:14];
    
    //显示对话框
    [_HUD showAnimated:YES whileExecutingBlock:^{
        //对话框显示时需要执行的操作
        //1.创建会话管理者
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        //2.封装参数
        NSDictionary *dict = nil;
        NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
        dict = @{@"c_alias":@"HC_cancel",@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"]};
        NSString *strurl = [API_NOAPK stringByAppendingString:@"/Service/order/abortList"];
        [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            WBLog(@"---%@--%@",responseObject,[responseObject objectForKey:@"msg"]);
            if ([[responseObject objectForKey:@"status"] integerValue]==1) {
                dataarr = [responseObject objectForKey:@"data"];
            }else{
                dataarr = nil;
            }
            [self createtableview];
            [self createUI];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            WBLog(@"failure--%@",error);
            [MBProgressHUD showToastToView:self.view withText:@"加载失败"];
        }];
    }// 在HUD被隐藏后的回调
       completionBlock:^{
           //操作执行完后取消对话框
           [_HUD removeFromSuperview];
           _HUD = nil;
       }];
}
- (void)createUI
{
    _View = [[UIView alloc] initWithFrame:CGRectMake(0, Main_Height-50, Main_width, 50)];
    _View.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_View];
    
    UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_width, 1)];
    lineview.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.05];
    [_View addSubview:lineview];
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake(Main_width/2-75, 5, 150, 40);
    but.clipsToBounds = YES;
    but.layer.cornerRadius = 10;
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = but.bounds;
    layer.startPoint = CGPointMake(1, 0);
    layer.endPoint = CGPointMake(0, 1);
    layer.colors = @[(id)[UIColor colorWithHexString:@"FF5722"].CGColor,(id)[UIColor colorWithHexString:@"FF9502"].CGColor];
    [but.layer addSublayer:layer];
    [but setTitle:@"确认取消" forState:UIControlStateNormal];
    [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    but.titleLabel.font = Font(15);
    [but addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    [_View addSubview:but];
    
}
- (void)cancle
{
    NSString *cancel_other = TextView.text;
    long i = _tmpBtn.tag;
    
    if (_tmpBtn == nil&&[TextView.text isEqualToString:@""]) {
        [MBProgressHUD showToastToView:self.view withText:@"取消原因不能为空"];
    }else{
        //初始化进度框，置于当前的View当中
        static MBProgressHUD *hud;
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:hud];
        
        //如果设置此属性则当前的view置于后台
        //_HUD.dimBackground = YES;
        
        //设置对话框文字
        hud.labelText = @"取消中...";
        hud.labelFont = [UIFont systemFontOfSize:14];
        
        //显示对话框
        [hud showAnimated:YES whileExecutingBlock:^{
            //对话框显示时需要执行的操作
            //1.创建会话管理者
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
            //2.封装参数
            NSDictionary *dict = nil;
            NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
            NSString *c_name;
            NSString *c_text;
            
            if (_tmpBtn==nil) {
                c_name = @"";
                c_text = @"";
            }else{
                c_name = [[dataarr objectAtIndex:i] objectForKey:@"id"];
                
            }
            dict = @{@"id":_dingdanid,@"cancel_type":c_name,@"cancel_other":cancel_other,@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"]};
            NSString *strurl = [API_NOAPK stringByAppendingString:@"/Service/order/abortSave"];
            [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                WBLog(@"---%@--%@",responseObject,[responseObject objectForKey:@"msg"]);
                if ([[responseObject objectForKey:@"status"] integerValue]==1) {
                    [self.navigationController popViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"newquxiaodingdan" object:nil userInfo:nil];
                }else{
                    
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                WBLog(@"failure--%@",error);
                [MBProgressHUD showToastToView:self.view withText:@"加载失败"];
            }];
        }// 在HUD被隐藏后的回调
          completionBlock:^{
              //操作执行完后取消对话框
              [hud removeFromSuperview];
              hud = nil;
          }];
    }
}

#pragma mark-键盘出现隐藏事件
-(void)keyHiden:(NSNotification *)notification
{
    WBLog(@"键盘下滑");
    // 键盘动画时间
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        _TableView.frame = CGRectMake(0, 0, _TableView.frame.size.width, _TableView.frame.size.height);
        _View.transform = CGAffineTransformIdentity;
    }];
}
-(void)keyWillAppear:(NSNotification *)notification
{
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGRect rect= [[notification.userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"]CGRectValue];
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    CGFloat offset = (_TableView.frame.size.height - kbHeight)-(TextView.frame.origin.y+TextView.frame.size.height+50);
    NSLog(@"offset---%f",offset);
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //将视图上移计算好的偏移
    if(offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            _TableView.frame = CGRectMake(0.0f, -offset, _TableView.frame.size.width, _TableView.frame.size.height);
            _View.transform = CGAffineTransformMakeTranslation(0, -([UIScreen mainScreen].bounds.size.height-rect.origin.y));
        }];
    }else{
//        [UIView animateWithDuration:duration animations:^{
//            _View.transform = CGAffineTransformMakeTranslation(0, -([UIScreen mainScreen].bounds.size.height-rect.origin.y));
//            self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
//        }];
    }
}
- (void)createtableview
{
    _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_width, Main_Height-50)];
    _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _TableView.delegate = self;
    _TableView.dataSource = self;
    _TableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_TableView];
}
#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 70;
    }else if (indexPath.row==1){
        return 55*dataarr.count-15;
    }else if (indexPath.row==2){
        return 70;
    }else{
        return 110;
    }
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
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_width, 1)];
        line1.backgroundColor = [UIColor blackColor];
        line1.alpha = 0.05;
        [cell.contentView addSubview:line1];
        
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 80, 30)];
        imageview.image = [UIImage imageNamed:@"取消原因"];
        [cell.contentView addSubview:imageview];
    }else if (indexPath.row==1){
        for (int i=0; i<dataarr.count; i++) {
            UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(15, 55*i, Main_width-30, 40)];
            backview.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1];
            backview.layer.cornerRadius = 10;
            [cell.contentView addSubview:backview];
            
            kuodabuttondianjifanwei *but = [[kuodabuttondianjifanwei alloc] init];
            but.frame = CGRectMake(15, 12, 16, 16);
            [but setEnlargeEdgeWithTop:12 right:Main_width-30-15-16 bottom:12 left:15];
            [but setImage:[UIImage imageNamed:@"选择未"] forState:UIControlStateNormal];
            [but setImage:[UIImage imageNamed:@"选择"] forState:UIControlStateSelected];
            but.tag = i;
            [but addTarget:self action:@selector(xuanze:) forControlEvents:UIControlEventTouchUpInside];
            [backview addSubview:but];
            
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15+16+15, 12, Main_width/3, 16)];
            label1.text = [[dataarr objectAtIndex:i] objectForKey:@"c_name"];
            label1.font = Font(14);
            [backview addSubview:label1];
            
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake((Main_width-30)-15-Main_width/2, 12, Main_width/2, 16)];
            label2.font = Font(12);
            label2.alpha = 0.54;
            label2.text = [[dataarr objectAtIndex:i] objectForKey:@"c_text"];
            label2.textAlignment = NSTextAlignmentRight;
            [backview addSubview:label2];
        }
    }else if (indexPath.row==2){
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 80, 30)];
        imageview.image = [UIImage imageNamed:@"其他"];
        [cell.contentView addSubview:imageview];
    }else{
        TextView = [[CMInputView alloc] initWithFrame:CGRectMake(15, 0, Main_width-30, 110)];
        TextView.delegate = self;
        TextView.clipsToBounds = YES;
        TextView.layer.cornerRadius = 10;
        TextView.placeholder = @"说说你的想法吧";
        TextView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1];
        [cell.contentView addSubview:TextView];
        
        lbRemainCount = [[UILabel alloc] initWithFrame:CGRectMake(Main_width-30-65, 110-24, 50, 12)];
        lbRemainCount.font = Font(12);
        lbRemainCount.text = @"0/150";
        lbRemainCount.textAlignment = NSTextAlignmentRight;
        lbRemainCount.alpha = 0.54;
        [TextView addSubview:lbRemainCount];
    }
    return cell;
}
//TextView限制输入字数150
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //如果是删除减少字数，都返回允许修改
    if ([text isEqualToString:@""]) {
        return YES;
    }
    if (range.location>= 150)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}
- (void)textViewDidChange:(UITextView *)textView {
    [self updateRemainCount];
}
- (void)updateRemainCount {
    //long count = MAX(0, (int)(150 - TextView.text.length));
    lbRemainCount.text = [NSString stringWithFormat:@"%ld/150",TextView.text.length];
}


- (void)xuanze:(UIButton *)sender
{
    if (_tmpBtn == nil){
        sender.selected = YES;
        _tmpBtn = sender;
    }
    else if (_tmpBtn !=nil && _tmpBtn == sender){
        sender.selected = YES;
    }
    else if (_tmpBtn!= sender && _tmpBtn!=nil){
        _tmpBtn.selected = NO;
        sender.selected = YES;
        _tmpBtn = sender;
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
