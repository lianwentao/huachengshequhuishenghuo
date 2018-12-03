//
//  pingjiadingdanViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/11/27.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "pingjiadingdanViewController.h"
#import "CMInputView.h"
@interface pingjiadingdanViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    UIView *_View;
    UITableView *_TableView;
    CMInputView *TextView;
    UILabel *lbRemainCount;
    UILabel *labelshifouniming;
    kuodabuttondianjifanwei *nimingbut;
    UIButton *starbut;
    NSMutableArray *butarr;
    NSString *_score;
}
@property (nonatomic ,assign) BOOL selected;
@end

@implementation pingjiadingdanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"发表评价";
    self.view.backgroundColor = [UIColor whiteColor];
    
   
    
    
    [self createtableview];
    [self createUI];
    //设置两个通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyHiden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyWillAppear:) name:UIKeyboardWillChangeFrameNotification object:nil];
    // Do any additional setup after loading the view.
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
    return 3;
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
        return 110;
    }else{
        return 55;
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
        imageview.image = [UIImage imageNamed:@"服务评价"];
        [cell.contentView addSubview:imageview];
        
        butarr = [[NSMutableArray alloc] init];
        for (int i = 0; i<5; i++) {
            starbut = [UIButton buttonWithType:UIButtonTypeCustom];
            starbut.frame = CGRectMake(110+35*i, 20, 30, 30);
            [starbut setImage:[UIImage imageNamed:@"星灰"] forState:UIControlStateNormal];
            [starbut setImage:[UIImage imageNamed:@"星橙"] forState:UIControlStateSelected];
            starbut.tag = i+2;
            [starbut addTarget:self action:@selector(score:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:starbut];
            [butarr addObject:starbut];
        }
    }else if (indexPath.row==1){
        TextView = [[CMInputView alloc] initWithFrame:CGRectMake(15, 0, Main_width-30, 110)];
        TextView.delegate = self;
        TextView.clipsToBounds = YES;
        TextView.layer.cornerRadius = 10;
        TextView.placeholder = @"说说您对这次服务的想法吧";
        TextView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1];
        [cell.contentView addSubview:TextView];
        
        lbRemainCount = [[UILabel alloc] initWithFrame:CGRectMake(Main_width-30-65, 110-24, 50, 12)];
        lbRemainCount.font = Font(12);
        lbRemainCount.text = @"0/150";
        lbRemainCount.textAlignment = NSTextAlignmentRight;
        lbRemainCount.alpha = 0.54;
        [TextView addSubview:lbRemainCount];
    }else{
        nimingbut = [kuodabuttondianjifanwei buttonWithType:UIButtonTypeCustom];
        nimingbut.frame = CGRectMake(15, 20, 15, 15);
        [nimingbut setEnlargeEdgeWithTop:20 right:50 bottom:20 left:15];
        [nimingbut setImage:[UIImage imageNamed:@"选择未"] forState:UIControlStateNormal];
        [nimingbut addTarget:self action:@selector(niming) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:nimingbut];
        
        UILabel *labelniming = [[UILabel alloc] initWithFrame:CGRectMake(15+15+10, 20, 50, 15)];
        labelniming.text = @"匿名";
        labelniming.font = Font(13);
        [cell.contentView addSubview:labelniming];
        
        labelshifouniming = [[UILabel alloc] initWithFrame:CGRectMake(Main_width-15-Main_width*3/5, 20, Main_width*3/5, 15)];
        labelshifouniming.text = @"您写的评价会以实名的方式展示";
        labelshifouniming.textAlignment = NSTextAlignmentRight;
        labelshifouniming.font = Font(12);
        labelshifouniming.alpha = 0.54;
        [cell.contentView addSubview:labelshifouniming];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 54, Main_width, 1)];
        line.backgroundColor = [UIColor blackColor];
        line.alpha = 0.05;
        [cell.contentView addSubview:line];
    }
    return cell;
}
- (void)score:(UIButton *)sender
{
    for (UIButton *btn in butarr){
        if (btn.tag >= sender.tag) {
            //[sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            btn.selected = NO;
            sender.selected = YES;
            _score = [NSString stringWithFormat:@"%zi",sender.tag-1];
            WBLog(@"%zi----%zi",btn.tag,sender.tag);
        } else {
            //[sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.selected = YES;
        }
    }
}
- (void)niming
{
    WBLog(@"%d",_selected);
    _selected = !_selected;
    if (_selected) {
        labelshifouniming.text = @"您写的评价会以匿名的方式展示";
        [nimingbut setImage:[UIImage imageNamed:@"选择"] forState:UIControlStateNormal];
    }else{
        labelshifouniming.text = @"您写的评价会以实名的方式展示";
        [nimingbut setImage:[UIImage imageNamed:@"选择未"] forState:UIControlStateNormal];
    }
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
    [but setTitle:@"发表评价" forState:UIControlStateNormal];
    [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    but.titleLabel.font = Font(15);
    [but addTarget:self action:@selector(fabiaopingjia) forControlEvents:UIControlEventTouchUpInside];
    [_View addSubview:but];
    
}
- (void)fabiaopingjia
{
    NSString *evaluate = TextView.text;
    NSString *anonymous;
    if (_selected) {
        anonymous = @"1";
    }else{
        anonymous = @"2";
    }
    WBLog(@"score---%@--%@",_score,evaluate);
    if (_score == nil||[evaluate isEqualToString:@""]) {
        [MBProgressHUD showToastToView:self.view withText:@"星级或评价不能为空"];
    }else{
        //初始化进度框，置于当前的View当中
        static MBProgressHUD *hud;
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:hud];
        
        //如果设置此属性则当前的view置于后台
        //_HUD.dimBackground = YES;
        
        //设置对话框文字
        hud.labelText = @"发表中...";
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
    
            dict = @{@"id":_dingdanid,@"score":_score,@"anonymous":anonymous,@"evaluate":evaluate,@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"]};
            NSString *strurl = [API_NOAPK stringByAppendingString:@"/Service/order/critial"];
            [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                WBLog(@"---%@--%@",responseObject,[responseObject objectForKey:@"msg"]);
                if ([[responseObject objectForKey:@"status"] integerValue]==1) {
                    [self.navigationController popViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"newpingjiadingdan" object:nil userInfo:nil];
                }else{
                    [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                WBLog(@"failure--%@",error);
                [MBProgressHUD showToastToView:self.view withText:@"发表失败"];
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
        
        _View.transform = CGAffineTransformIdentity;
    }];
}
-(void)keyWillAppear:(NSNotification *)notification
{
    WBLog(@"键盘上滑");
//    //获取键盘高度，在不同设备上，以及中英文下是不同的
//    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGRect rect= [[notification.userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"]CGRectValue];
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
//    CGFloat offset = (_TableView.frame.size.height - kbHeight)-(TextView.frame.origin.y+TextView.frame.size.height+50);
//    NSLog(@"offset---%f",offset);
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        _View.transform = CGAffineTransformMakeTranslation(0, -([UIScreen mainScreen].bounds.size.height-rect.origin.y));
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
