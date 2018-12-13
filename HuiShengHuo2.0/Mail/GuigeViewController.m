//
//  GuigeViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/12/2.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import "GuigeViewController.h"
#import <AFNetworking.h>
#import "MBProgressHUD+TVAssistant.h"
#import "GouwucheViewController.h"
#import "dingdanViewController.h"

#import "PrefixHeader.pch"
#define screen_Width [UIScreen mainScreen].bounds.size.width
#define screen_Height [UIScreen mainScreen].bounds.size.height
@interface GuigeViewController ()<UINavigationControllerDelegate>
{
    NSMutableArray *_Dataarr;
    UILabel *_Labelyixuan;
    UILabel *labelkucun;
    UILabel *labelnum;
    UIButton *tagnamebut;
    UIButton *_tmpBtn;
    long _Limit;
    long _LimitAll;
    long _limtcart;
    long _limitord;
    
    long height;
    
    UILabel *twolabel;
    CGFloat height1;
}

@end

@implementation GuigeViewController
- (void)viewDidLayoutSubviews{
    CGFloat phoneVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (phoneVersion >= 11.0) {
        height1 = self.view.safeAreaInsets.bottom;
    }else{
        height1 = 0;
    }
    WBLog(@"h = %lf",height1);
    [self createui];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择商品规格";
    _tmpBtn=nil;
    _Limit = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self post1];
    
    // Do any additional setup after loading the view.
}
- (void)createui
{
//    UIButton *backbut = [UIButton buttonWithType:UIButtonTypeCustom];
//    backbut.frame = CGRectMake(10, 25, 40, 40);
//    [backbut setTitle:@"返回" forState:UIControlStateNormal];
//    [backbut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [self.view addSubview:backbut];
//    [backbut addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    //
//    UILabel *labelguige = [[UILabel alloc] initWithFrame:CGRectMake(10, 75, screen_Width-20, 40)];
//    [self.view addSubview:labelguige];
//    labelguige.text = @"选择商品类型";
//    labelguige.font = [UIFont systemFontOfSize:22];
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(20, 80, screen_Width/4, screen_Width/4)];
    imageview.image = _image;
    [self.view addSubview:imageview];
    
    _Labelyixuan = [[UILabel alloc] initWithFrame:CGRectMake(screen_Width/4+20+5+50, 85, screen_Width-screen_Width/4-15, 40)];
    [self.view addSubview:_Labelyixuan];
    _Labelyixuan.font = [UIFont systemFontOfSize:15];
    _Labelyixuan.text = _pricestring;
    UILabel *pricelabel = [[UILabel alloc] initWithFrame:CGRectMake(screen_Width/4+20+5, 85, 50, 40)];
    pricelabel.text = [NSString stringWithFormat:@"价格¥:"];
    pricelabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:pricelabel];
    
    labelkucun = [[UILabel alloc] initWithFrame:CGRectMake(screen_Width/4+25+50, 130, 50, 40)];
    [self.view addSubview:labelkucun];
    labelkucun.text = _cunkunstring;
    UILabel *cklabel = [[UILabel alloc] initWithFrame:CGRectMake(screen_Width/4+25, 130, screen_Width-screen_Width/4-15, 40)];
    cklabel.text = [NSString stringWithFormat:@"库存:"];
    cklabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:cklabel];
    labelkucun.font = [UIFont systemFontOfSize:15];
    
    UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(0, 85+screen_Width/4+30, screen_Width, 0.5)];
    lineview.backgroundColor = [UIColor blackColor];
    lineview.alpha = 0.2;
    [self.view addSubview:lineview];
    
    NSArray *labelarr = @[@"属性",@"数量"];
    NSArray *butarr = @[@"shop_icon_jian_dianjiqian",@"shop_icon_jia_dianjiqian"];
    for (int i=0; i<2; i++) {
        twolabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 85+screen_Width/4+50+i*(height-(85+screen_Width/4+50)), 100, 40)];
        twolabel.text = [labelarr objectAtIndex:i];
        [self.view addSubview:twolabel];
        twolabel.font = [UIFont systemFontOfSize:18];
        
        UIButton *addanjianbut = [[UIButton alloc] initWithFrame:CGRectMake(20+i*120, 85+screen_Width/4+50+50+(height-(85+screen_Width/4+50)), 40, 40)];
        [addanjianbut setImage:[UIImage imageNamed:[butarr objectAtIndex:i]] forState:UIControlStateNormal];
        [self.view addSubview:addanjianbut];
        [addanjianbut addTarget:self action:@selector(addjian:) forControlEvents:UIControlEventTouchUpInside];
        addanjianbut.tag = i;
    }
    labelnum = [[UILabel alloc] initWithFrame:CGRectMake(60, 85+screen_Width/4+50+50+(height-(85+screen_Width/4+50)), 80, 40)];
    
    [self.view addSubview:labelnum];
    labelnum.textAlignment = NSTextAlignmentCenter;
    
    UIButton *butsure = [UIButton buttonWithType:UIButtonTypeCustom];
    [butsure setTitle:@"确定" forState:UIControlStateNormal];
    [self.view addSubview:butsure];
    butsure.frame = CGRectMake(0, screen_Height-49-height1, screen_Width, 49);
    butsure.backgroundColor = QIColor;
    [butsure addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self post];
}
- (void)sure
{
    
    __weak typeof(self) weakself = self;
    NSString *tagstrimg = [[_Dataarr objectAtIndex:_tmpBtn.tag] objectForKey:@"id"];
    if (weakself.returnValueBlock) {
        if (_Limit==0) {
            weakself.returnValueBlock(_tmpBtn.titleLabel.text,labelnum.text,tagstrimg,[labelkucun.text longLongValue],_Labelyixuan.text);
        }else{
            //将自己的值传出去，完成传值
            weakself.returnValueBlock(_tmpBtn.titleLabel.text,labelnum.text,tagstrimg,_Limit-_LimitAll,_Labelyixuan.text);
        }
    }
    long i = [labelnum.text longLongValue];
    if (i==0) {
        if (_limtcart>0) {
            GouwucheViewController *gouwuche = [[GouwucheViewController alloc] init];
            [self.navigationController pushViewController:gouwuche animated:YES];
        }if (_limtcart==0&&_limitord>0) {
            dingdanViewController *dingdan = [[dingdanViewController alloc] init];
            [self.navigationController pushViewController:dingdan animated:YES];
        }
    }else{
        if ([_tag isEqualToString:@"1"]) {
            //[self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"lijigoumai" object:nil userInfo:nil];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"jiarugouwuchedonghua" object:nil userInfo:nil];
        }
    }
}
- (void)addjian:(UIButton *)sender
{
    int i = [labelnum.text intValue];
    long j = [labelkucun.text longLongValue];
    if (j==i) {
        if (sender.tag==0) {
            i--;
        }if(sender.tag==1){
            [MBProgressHUD showToastToView:self.view withText:@"库存不足"];
        }
        NSString *stringInt = [NSString stringWithFormat:@"%d",i];
        labelnum.text = stringInt;
    }else{
        if (sender.tag==0) {
            if (i==0) {
                i=0;
            }if (i>1) {
                i--;
            }
        }if(sender.tag==1){
            if (i==0) {
                [MBProgressHUD showToastToView:self.view withText:@"此商品为限购商品，您购物车或无付款订单有此商品，请前往购买"];
            }else{
                if ((i+_LimitAll)==_Limit) {
                    [MBProgressHUD showToastToView:self.view withText:[NSString stringWithFormat:@"此商品为限购商品,您剩余限购次数为%d",i]];
                }else{
                    i++;
                }
            }
        }
        NSString *stringInt = [NSString stringWithFormat:@"%d",i];
        labelnum.text = stringInt;
    }
}
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)post{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    NSDictionary *dict = @{@"p_id":_IDstring,@"tagid":[NSString stringWithFormat:@"%@",_tagidstring],@"apk_token":uid_username,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
    NSLog(@"%@",dict);
    NSString *strurl = [API stringByAppendingString:@"shop/check_shop_limit"];
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"111---success--%@--%@",responseObject,[responseObject objectForKey:@"msg"]);
        _Limit = [[[responseObject objectForKey:@"data"] objectForKey:@"limit"] integerValue];
        long cartnum = [[[responseObject objectForKey:@"data"] objectForKey:@"cart_num"] integerValue];
        long ordernum = [[[responseObject objectForKey:@"data"] objectForKey:@"order_num"] integerValue];
        _limtcart = cartnum;
        _limitord = ordernum;
        _LimitAll = cartnum+ordernum;
        if (_LimitAll==_Limit&&_Limit>0) {
            labelnum.text = @"0";
        }else{
            labelnum.text = @"1";
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"failure--%@",error);
    }];
}
-(void)post1{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    NSDictionary *dict = @{@"id":_IDstring,@"apk_token":uid_username,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
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
    NSString *strurl = [API stringByAppendingString:@"shop/goods_tags"];
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        _Dataarr = [[NSMutableArray alloc] init];
        _Dataarr = [responseObject objectForKey:@"data"];
        //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
        NSLog(@"222---success--%@--%@",responseObject,[responseObject objectForKey:@"msg"]);
        
        CGFloat w = 0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
        CGFloat h = 85+screen_Width/4+50+40;//用来控制button距离父视图的高
        for (int i=0; i<_Dataarr.count; i++) {
            tagnamebut = [UIButton buttonWithType:UIButtonTypeCustom];
            //tagnamebut.frame = CGRectMake(20+i*(screen_Width/2), 85+screen_Width/4+50+40, screen_Width/2-20, 40);
            [self.view addSubview:tagnamebut];
            tagnamebut.layer.cornerRadius = 25;
            [tagnamebut.layer setBorderWidth:1];
            [tagnamebut.layer setBorderColor:[HColor(204, 204, 204)CGColor]];
            [tagnamebut setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            [tagnamebut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            //[tagnamebut setTitle:[[_Dataarr objectAtIndex:i] objectForKey:@"tagname"] forState:UIControlStateNormal];
            [tagnamebut.titleLabel setFont:[UIFont systemFontOfSize:15]];
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
            CGFloat length = [[[_Dataarr objectAtIndex:i] objectForKey:@"tagname"] boundingRectWithSize:CGSizeMake(screen_Width, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
            //为button赋值
            [tagnamebut setTitle:[[_Dataarr objectAtIndex:i] objectForKey:@"tagname"] forState:UIControlStateNormal];
            //设置button的frame
            tagnamebut.frame = CGRectMake(20 + w, h, length + 100 , 50);
            //当button的位置超出屏幕边缘时换行 320 只是button所在父视图的宽度
            if(20 + w + length + 100 > screen_Width){
                w = 0; //换行时将w置为0
                h = h + tagnamebut.frame.size.height + 10;//距离父视图也变化
                tagnamebut.frame = CGRectMake(20 + w, h, length + 100, 50);//重设button的frame
            }
            if (i==(_Dataarr.count-1)) {
                height = h+60;
            }
            w = tagnamebut.frame.size.width + tagnamebut.frame.origin.x;
            [tagnamebut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            tagnamebut.tag = i;
            if (i==0) {
                tagnamebut.selected = YES;
                _tmpBtn = tagnamebut;
            }
            [tagnamebut addTarget:self action:@selector(selectshuxing:) forControlEvents:UIControlEventTouchUpInside];
        }
        NSLog(@"%ld",height);
        [self createui];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"failure--%@",error);
    }];
}
- (void)selectshuxing:(UIButton *)sender
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
    
    NSString *kuxun = [[_Dataarr objectAtIndex:sender.tag] objectForKey:@"inventory"];
    labelkucun.text = kuxun;
    
    NSString *price = [[_Dataarr objectAtIndex:sender.tag] objectForKey:@"price"];
    _Labelyixuan.text = price;
    
    labelnum.text = @"1";
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
