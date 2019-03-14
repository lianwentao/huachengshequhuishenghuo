//
//  youxianjiaofeiViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/5/18.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "youxianjiaofeiViewController.h"
#import "MBProgressHUD+TVAssistant.h"
#import <AFNetworking.h>

#import "youxianjiaofeisussessViewController.h"
#import "youxianjiaofeijiluViewController.h"
@interface youxianjiaofeiViewController ()<UITextFieldDelegate>
{
    UIScrollView *_scrollview;
    
    UITextField *pricetextfield;
    UITextField *leimuLabel;
    UITextField *houselabel;
    UILabel *namephonelabel;
    UILabel *selecthouse;
}

@end

@implementation youxianjiaofeiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"有线电视缴费";
    [self createrightbutton];
    [self createUI];
    // Do any additional setup after loading the view.
}
- (void)createrightbutton
{
    //自定义一个导航条右上角的一个button
    UIImage *issueImage = [UIImage imageNamed:@"ic_order5"];
    
    UIButton *issueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    issueButton.frame = CGRectMake(0, 0, 25, 25);
    [issueButton setBackgroundImage:issueImage forState:UIControlStateNormal];
    issueButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [issueButton addTarget:self action:@selector(issueBton) forControlEvents:UIControlEventTouchUpInside];
    //添加到导航条
    UIBarButtonItem *leftBarButtomItem = [[UIBarButtonItem alloc]initWithCustomView:issueButton];
    self.navigationItem.rightBarButtonItem = leftBarButtomItem;
}
- (BOOL)navigationShouldPopOnBackButton{
    UIViewController *viewc = self.navigationController.viewControllers[self.navigationController.viewControllers.count-1];
    [self.navigationController popToViewController:viewc animated:YES];
    return YES;
}
- (void)issueBton
{
    [self.navigationController pushViewController:[youxianjiaofeijiluViewController new] animated:YES];
}
- (void)createUI
{
    _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Main_width, Main_Height)];
    _scrollview.alwaysBounceVertical = YES;
    _scrollview.showsVerticalScrollIndicator = NO;
    _scrollview.showsHorizontalScrollIndicator = NO;
    _scrollview.bounces = NO;
    _scrollview.backgroundColor = BackColor;
    [self.view addSubview:_scrollview];
    _scrollview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self downshoushi];
    
    _scrollview.contentSize = CGSizeMake(Main_width, Main_Height+64);
    
    UILabel *jiaofeijine = [[UILabel alloc] initWithFrame:CGRectMake(15, 25, Main_width-30, 25)];
    [jiaofeijine setFont:nomalfont];
    jiaofeijine.text = @"请输入编号";
    [_scrollview addSubview:jiaofeijine];
    
    UIView *priceview = [[UIView alloc] initWithFrame:CGRectMake(15, jiaofeijine.frame.size.height+jiaofeijine.frame.origin.y+12.5, Main_width-30, 50)];
    priceview.backgroundColor = [UIColor whiteColor];
    [_scrollview addSubview:priceview];
    
    pricetextfield = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, Main_width-30-30, 50)];
    pricetextfield.tag = 1000;
    pricetextfield.delegate = self;
    //pricetextfield.placeholder = @"输入金额";
    //pricetextfield.keyboardType = UIKeyboardTypeNumberPad;
    pricetextfield.backgroundColor = [UIColor whiteColor];
    [priceview addSubview:pricetextfield];
    
    UILabel *selectleimu = [[UILabel alloc] initWithFrame:CGRectMake(15, priceview.frame.size.height+priceview.frame.origin.y+25, Main_width-30, 25)];
    selectleimu.text = @"请输入姓名";
    [selectleimu setFont:nomalfont];
    [_scrollview addSubview:selectleimu];
    
    UIView *nameview = [[UIView alloc] initWithFrame:CGRectMake(15, selectleimu.frame.size.height+selectleimu.frame.origin.y+12.5, Main_width-30, 50)];
    nameview.backgroundColor = [UIColor whiteColor];
    [_scrollview addSubview:nameview];
    
    leimuLabel = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, Main_width-30-30, 50)];
    leimuLabel.backgroundColor = [UIColor whiteColor];
    [leimuLabel setFont:font15];
    leimuLabel.tag = 1001;
    leimuLabel.delegate = self;
    [nameview addSubview:leimuLabel];
    
    selecthouse = [[UILabel alloc] initWithFrame:CGRectMake(15, nameview.frame.size.height+nameview.frame.origin.y+25, Main_width-30, 25)];
    selecthouse.text = @"请输入金额";
    [selecthouse setFont:nomalfont];
    [_scrollview addSubview:selecthouse];
    
    
    UIView *jineview = [[UIView alloc] initWithFrame:CGRectMake(15, selecthouse.frame.size.height+selecthouse.frame.origin.y+12.5, Main_width-30, 50)];
    jineview.backgroundColor = [UIColor whiteColor];
    [_scrollview addSubview:jineview];
    houselabel = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, Main_width-30-30, 50)];
    houselabel.backgroundColor = [UIColor whiteColor];
    [houselabel setFont:font15];
    houselabel.tag = 1002;
    houselabel.delegate = self;
    [jineview addSubview:houselabel];
    
    UILabel *zhuyi = [[UILabel alloc] initWithFrame:CGRectMake(15, jineview.frame.size.height+jineview.frame.origin.y+50, Main_width-30, 100)];
    zhuyi.font = font15;
    zhuyi.numberOfLines = 3;
    zhuyi.text = @"  注:\n    1.请正确填写信息确认无误后支付。\n    2.支付成功后,请等待开通";
    zhuyi.backgroundColor = [UIColor whiteColor];
    [_scrollview addSubview:zhuyi];
    
    UIButton *suer = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:suer];
    suer.backgroundColor = QIColor;
    [suer setTitle:@"下一步" forState:UIControlStateNormal];
    suer.frame = CGRectMake(0, Main_Height-49, Main_width, 49);
    [suer addTarget:self action:@selector(suer) forControlEvents:UIControlEventTouchUpInside];
}
- (void)suer
{
    NSString *bianhao = pricetextfield.text;
    NSString *xingming = leimuLabel.text;
    NSString *jine = houselabel.text;
    if ([bianhao isEqualToString:@""]) {
        [MBProgressHUD showToastToView:self.view withText:@"请填写编号"];
    }else if ([xingming isEqualToString:@""]){
        [MBProgressHUD showToastToView:self.view withText:@"请填写姓名"];
    }else if ([jine isEqualToString:@""]){
        [MBProgressHUD showToastToView:self.view withText:@"请填写金额"];
    }else{
        [self next];
    }
}
- (void)next
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    NSDictionary *dict = nil;
    NSString *bianhao = pricetextfield.text;
    NSString *xingming = leimuLabel.text;
    NSString *jine = houselabel.text;
    dict = @{@"fullname":xingming,@"amount":jine,@"wired_num":bianhao,@"c_id":[user objectForKey:@"community_id"],@"c_name":[user objectForKey:@"community_name"],@"apk_token":uid_username,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *API = [defaults objectForKey:@"API"];
    NSString *urlstr = [API stringByAppendingString:@"property/add_wired_order"];
    [manager POST:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            youxianjiaofeisussessViewController *suer = [[youxianjiaofeisussessViewController alloc] init];
            suer.order_number = [[responseObject objectForKey:@"data"] objectForKey:@"order_number"];
            suer.name = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"fullname"]];
            suer.time = [[responseObject objectForKey:@"data"] objectForKey:@"addtime"];
            suer.price = [[responseObject objectForKey:@"data"] objectForKey:@"amount"];
            suer.c_name = bianhao;
            suer.id = [[responseObject objectForKey:@"data"] objectForKey:@"id"];
            [self.navigationController pushViewController:suer animated:YES];
        }else{
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
    
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
    UITextField * field=(UITextField *)[self.view viewWithTag:1000];
    UITextField * field1=(UITextField *)[self.view viewWithTag:1001];
    UITextField * field2=(UITextField *)[self.view viewWithTag:1002];
    if(recognizer.direction==UISwipeGestureRecognizerDirectionDown) {

        NSLog(@"swipe down");

        [field resignFirstResponder];
        [field1 resignFirstResponder];
        [field2 resignFirstResponder];
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
