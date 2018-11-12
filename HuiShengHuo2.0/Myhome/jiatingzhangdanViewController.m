//
//  jiatingzhangdanViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/3/21.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "jiatingzhangdanViewController.h"
#import <AFNetworking.h>
#import "jiatingjiaofeijiluViewController.h"
#import "AllPayViewController.h"
#import "MBProgressHUD+TVAssistant.h"

#import "shuidianfeiViewController.h"
@interface jiatingzhangdanViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_TabelView;
    NSArray *wuyeArr;
    NSDictionary *dianfeiDic;
    NSDictionary *shuifeiDic;
    NSDictionary *roominfodic;
    
    NSString *is_available;
}

@end

@implementation jiatingzhangdanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"家庭账单";
    self.view.backgroundColor = [UIColor whiteColor];
    
    wuyeArr = [NSArray array];
    dianfeiDic = [[NSDictionary alloc] init];
    shuifeiDic = [[NSDictionary alloc] init];
    roominfodic = [[NSDictionary alloc] init];
    
    [self getData];
    [self createUI];
    // Do any additional setup after loading the view.
}

- (void)getData
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[userinfo objectForKey:@"uid"],[userinfo objectForKey:@"username"]]];
    dict = @{@"room_id":_room_id,@"apk_token":uid_username,@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"]};
    NSString *strurl = [API stringByAppendingString:@"property/get_room_bill"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"---%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            wuyeArr = [[responseObject objectForKey:@"data"] objectForKey:@"wuye"];
            dianfeiDic = [[responseObject objectForKey:@"data"] objectForKey:@"dianfei"];
            shuifeiDic = [[responseObject objectForKey:@"data"] objectForKey:@"shuifei"];
            roominfodic = [[responseObject objectForKey:@"data"] objectForKey:@"room_info"];
            is_available = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"is_available"]];
        }
        
        [_TabelView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}

- (void)createUI
{
    _TabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_width, Main_Height)];
    _TabelView.delegate = self;
    _TabelView.dataSource = self;
    _TabelView.estimatedRowHeight = 0;
    _TabelView.estimatedSectionFooterHeight = 0;
    _TabelView.estimatedSectionHeaderHeight = 0;
    _TabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _TabelView.backgroundColor = BackColor;
    [self.view addSubview:_TabelView];
}
#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }else if (section==1){
        return 1;
    }else if (section==2){
        if ([wuyeArr isKindOfClass:[NSArray class]]) {
            return 2+wuyeArr.count;
        }else{
            return 3;
        }
    }else{
        return 2;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 157.5;
    }else if (indexPath.section==1){
        return 0;
    }else if (indexPath.section==2){
        if (indexPath.row==0) {
            return 62.5;
        }else{
            return 65;
        }
    }else if (indexPath.section==3){
        if ([shuifeiDic  isKindOfClass:[NSDictionary class]]) {
            if (indexPath.row == 0) {
                return 10;
            }else{
                return 55;
            }
        }else{
            return 0;
        }
    }else{
        if ([dianfeiDic  isKindOfClass:[NSDictionary class]]) {
            if (indexPath.row == 0) {
                return 10;
            }else{
                return 55;
            }
        }else{
            return 0;
        }
    }
    /*else{
    if (indexPath.row==0) {
        return 62.5;
    }else{
        return 90.25;
    }*/
}
// 分组的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    if (indexPath.section==0) {
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Main_width, 157.5)];
        imageview.image = [UIImage imageNamed:@"myhomeback"];
        [cell.contentView addSubview:imageview];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(55, 20, Main_width-110, 157.5-40)];
        label.layer.borderColor = [[UIColor whiteColor]CGColor];
        label.layer.borderWidth = 0.5;
        label.layer.masksToBounds = YES;
        [imageview addSubview:label];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(65, 30, Main_width-130, 97.5)];
        view.backgroundColor = [UIColor whiteColor];
        view.alpha = 0.8;
        [imageview addSubview:view];
        
        NSDictionary *room_info = [[NSDictionary alloc] init];
        room_info = roominfodic;
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(17.5, 10, view.frame.size.width, 25)];
        label1.text = [room_info objectForKey:@"community_name"];
        [label1 setFont:font18];
        [view addSubview:label1];
        
        UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(17.5, 47, 6, 6)];
        circle.layer.masksToBounds = YES;
        circle.layer.cornerRadius = 3;
        circle.backgroundColor = CIrclecolor;
        [view addSubview:circle];
        
        UIView *circle1 = [[UIView alloc] initWithFrame:CGRectMake(17.5, 72, 6, 6)];
        circle1.layer.masksToBounds = YES;
        circle1.layer.cornerRadius = 3;
        circle1.backgroundColor = CIrclecolor;
        [view addSubview:circle1];
        
        UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(20, 53, 1, 19)];
        lineview.backgroundColor = CIrclecolor;
        [view addSubview:lineview];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(17.5+16, 40, view.frame.size.width, 20)];
        label2.text = [room_info objectForKey:@"address"];
        [label2 setFont:nomalfont];
        [view addSubview:label2];
        
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(17.5+16, 65, view.frame.size.width, 20)];
        label3.text = [NSString stringWithFormat:@"%@人已绑定房屋",[room_info objectForKey:@"count"]];
        [label3 setFont:nomalfont];
        [view addSubview:label3];
    }else if (indexPath.section==1){
//        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
//        but.frame = CGRectMake(0, 0, Main_width, 72.5);
//        but.backgroundColor = QIColor;
//        [but addTarget:self action:@selector(facepay) forControlEvents:UIControlEventTouchUpInside];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
//        [cell.contentView addSubview:but];
    }else if (indexPath.section==2){
        if (indexPath.row==0) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, 25, Main_width/2, 25)];
            label.text = @"家庭账单";
            [label setFont:font18];
            cell.backgroundColor = BackColor;
            [cell.contentView addSubview:label];
            
            UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
            [but setImage:[UIImage imageNamed:@"ic_order5"] forState:UIControlStateNormal];
            but.frame = CGRectMake(Main_width-70, 15, 35, 35);
            [but addTarget:self action:@selector(zhandanjulu) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:but];
        }else if (indexPath.row==1){
            UIImageView *touxiangimageview = [[UIImageView alloc] initWithFrame:CGRectMake(20, 11.5, 42.5, 42.5)];
            touxiangimageview.image = [UIImage imageNamed:@"wuyejiaofei1"];//
            touxiangimageview.layer.masksToBounds = YES;
            touxiangimageview.layer.cornerRadius = 21.25;
            [cell.contentView addSubview:touxiangimageview];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20+42.5+15, 11.5, Main_width-77.5-15, 42.5)];
            label.text = @"物业费";
            [label setFont:nomalfont];
            [cell.contentView addSubview:label];
            
        } else{
            if ([wuyeArr isKindOfClass:[NSArray class]]) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(62.5+15, 22.5, Main_width*3/5-50, 20)];
                label.text = [NSString stringWithFormat:@"%@-%@",[[wuyeArr objectAtIndex:indexPath.row-2] objectForKey:@"startdate"],[[wuyeArr objectAtIndex:indexPath.row-2] objectForKey:@"enddate"]];
                [label setFont:nomalfont];
                [cell.contentView addSubview:label];
                
                UILabel *pricelabel = [[UILabel alloc] initWithFrame:CGRectMake(Main_width-Main_width/3-30, 22.5, Main_width/3, 20)];
                pricelabel.text = [NSString stringWithFormat:@"-%@元",[[wuyeArr objectAtIndex:indexPath.row-2] objectForKey:@"sumvalue"]];
                pricelabel.textColor = QIColor;
                pricelabel.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:pricelabel];
                
                if (indexPath.row>2) {
                    UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(77.5, 0, 6, 6)];
                    circle.layer.masksToBounds = YES;
                    circle.layer.cornerRadius = 3;
                    circle.backgroundColor = CIrclecolor;
                    UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(77.5+6, 3-0.25, Main_width-77.5-6, 0.5)];
                    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
                    [shapeLayer setBounds:lineview.bounds];
                    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineview.frame) / 2, CGRectGetHeight(lineview.frame))];
                    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
                    //  设置虚线颜色为blackColor
                    [shapeLayer setStrokeColor:[UIColor blackColor].CGColor];
                    //  设置虚线宽度
                    [shapeLayer setLineWidth:CGRectGetHeight(lineview.frame)];
                    [shapeLayer setLineJoin:kCALineJoinRound];
                    //  设置线宽，线间距
                    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:3], [NSNumber numberWithInt:1],  nil]];
                    //  设置路径
                    CGMutablePathRef path = CGPathCreateMutable();
                    CGPathMoveToPoint(path, NULL, 0, 0);
                    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(lineview.frame), 0);
                    [shapeLayer setPath:path];
                    CGPathRelease(path);
                    //  把绘制好的虚线添加上来
                    [lineview.layer addSublayer:shapeLayer];
                    lineview.alpha = 0.5;
                    
                    [cell.contentView addSubview:lineview];
                    [cell.contentView addSubview:circle];
                }
            }else{
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(62.5+15, 22.5, Main_width, 20)];
                label.text = @"物业费已结清";
                [label setFont:nomalfont];
                [cell.contentView addSubview:label];
            }
        }
    }else if (indexPath.section==3){
        if ([shuifeiDic  isKindOfClass:[NSDictionary class]]) {
            if (indexPath.row==0) {
                cell.backgroundColor = BackColor;
            }else{
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
                UIImageView *touxiangimageview = [[UIImageView alloc] initWithFrame:CGRectMake(20, 6.5, 42.5, 42.5)];
                touxiangimageview.image = [UIImage imageNamed:@"shuifei"];
                touxiangimageview.layer.masksToBounds = YES;
                touxiangimageview.layer.cornerRadius = 21.25;
                [cell.contentView addSubview:touxiangimageview];

                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20+42.5+15, 6.5, Main_width-77.5-15, 42.5)];
                label.text = @"水费";
                [label setFont:nomalfont];
                [cell.contentView addSubview:label];

                UILabel *pricelabe = [[UILabel alloc] initWithFrame:CGRectMake(Main_width-Main_width/3-30, 6.5, Main_width/3, 42.5)];
                pricelabe.text = [NSString stringWithFormat:@"余额:%@",[[shuifeiDic objectForKey:@"info"] objectForKey:@"SMay_acc"]];
                [pricelabe setFont:nomalfont];
                pricelabe.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:pricelabe];
            }
        }
    }else {
        if ([dianfeiDic  isKindOfClass:[NSDictionary class]]) {
            if (indexPath.row==0) {
                cell.backgroundColor = BackColor;
            }else{
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
                UIImageView *touxiangimageview = [[UIImageView alloc] initWithFrame:CGRectMake(20, 6.5, 42.5, 42.5)];
                touxiangimageview.image = [UIImage imageNamed:@"dianfei"];
                touxiangimageview.layer.masksToBounds = YES;
                touxiangimageview.layer.cornerRadius = 21.25;
                [cell.contentView addSubview:touxiangimageview];

                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20+42.5+15, 6.5, Main_width-77.5-15, 42.5)];
                label.text = @"电费";
                [label setFont:nomalfont];
                [cell.contentView addSubview:label];

                UILabel *pricelabe = [[UILabel alloc] initWithFrame:CGRectMake(Main_width-Main_width/3-30, 6.5, Main_width/3, 42.5)];
                
                pricelabe.text = [NSString stringWithFormat:@"余额:%@",[[dianfeiDic objectForKey:@"info"] objectForKey:@"DMay_acc"]];
                [pricelabe setFont:nomalfont];
                pricelabe.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:pricelabe];
            }
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([is_available isEqualToString:@"1"]) {
        [MBProgressHUD showToastToView:self.view withText:@"暂未开放"];
    }else{
        if (indexPath.section==2){
            if ([wuyeArr isKindOfClass:[NSArray class]]) {
                if (indexPath.row>1) {
                    [self postpay];
                }
            }
        }else if (indexPath.section==3){
            if ([shuifeiDic  isKindOfClass:[NSDictionary class]]) {
                
                if (indexPath.row==0) {
                    
                }else{
                    if ([wuyeArr isKindOfClass:[NSArray class]]) {
                        [MBProgressHUD showToastToView:self.view withText:@"请先缴清物业费"];
                    }else{
                        shuidianfeiViewController *shuidian = [[shuidianfeiViewController alloc] init];
                        shuidian.biaoshi = @"shui";
                        shuidian.shuidic = shuifeiDic;
                        shuidian.room_infodic = roominfodic;
                        [self.navigationController pushViewController:shuidian animated:YES];
                    }
                }
            }
        }else if (indexPath.section==4){
            if ([dianfeiDic isKindOfClass:[NSDictionary class]]) {
                
                if (indexPath.row==0) {
                    
                }else{
                    if ([wuyeArr isKindOfClass:[NSArray class]]) {
                        [MBProgressHUD showToastToView:self.view withText:@"请先缴清物业费"];
                    }else{
                        shuidianfeiViewController *shuidian = [[shuidianfeiViewController alloc] init];
                        shuidian.biaoshi = @"dian";
                        shuidian.diandic = dianfeiDic;
                        shuidian.room_infodic = roominfodic;
                        [self.navigationController pushViewController:shuidian animated:YES];
                        
                    }
                }
            }
        }
    }
}

-(void)postpay{
    //is_available
    if ([is_available isEqualToString:@"1"]) {
        [MBProgressHUD showToastToView:self.view withText:@"暂未开放"];
    }else{
        //1.创建会话管理者
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        //2.封装参数
        NSString *bill_id = [[wuyeArr objectAtIndex:0] objectForKey:@"bill_id"];
        NSString *room_id = [[wuyeArr objectAtIndex:0] objectForKey:@"room_id"];
        NSString *community_id = [[wuyeArr objectAtIndex:0] objectForKey:@"community_id"];
        NSString *community_name = [[wuyeArr objectAtIndex:0] objectForKey:@"community_name"];
        NSString *unit = [[wuyeArr objectAtIndex:0] objectForKey:@"unit"];
        NSString *code = [[wuyeArr objectAtIndex:0] objectForKey:@"code"];
        NSString *charge_type = [[wuyeArr objectAtIndex:0] objectForKey:@"charge_type"];
        NSString *sumvalue = [[wuyeArr objectAtIndex:0] objectForKey:@"sumvalue"];
        NSString *time = [[wuyeArr objectAtIndex:0] objectForKey:@"time"];
        NSString *startdate = [[wuyeArr objectAtIndex:0] objectForKey:@"startdate"];
        NSString *enddate = [[wuyeArr objectAtIndex:0] objectForKey:@"enddate"];
        NSDictionary *dict = @{@"bill_id":bill_id,@"room_id":room_id,@"community_id":community_id,@"community_name":community_name,@"unit":unit,@"code":code,@"charge_type":charge_type,@"sumvalue":sumvalue,@"bill_time":time,@"startdate":startdate,@"enddate":enddate};
        NSString *strurl = [API stringByAppendingString:@"property/make_property_order"];
        [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
            NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
            //_Dic = [[NSMutableDictionary alloc] init];
            if ([[responseObject objectForKey:@"status"] integerValue]==1) {
                AllPayViewController *pay = [[AllPayViewController alloc] init];
                pay.order_id = [[responseObject objectForKey:@"data"] objectForKey:@"id"];
                pay.price = [[responseObject objectForKey:@"data"] objectForKey:@"sumvalue"];
                pay.type = @"2";
                pay.rukoubiaoshi = @"jiatingzhangdan";
                [self.navigationController pushViewController:pay animated:YES];
            }else{
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"failure--%@",error);
        }];
    }
}
#pragma mark - 账单记录
- (void)zhandanjulu
{
    if ([is_available isEqualToString:@"1"]) {
        [MBProgressHUD showToastToView:self.view withText:@"暂未开放"];
    }else{
        jiatingjiaofeijiluViewController *jilu = [[jiatingjiaofeijiluViewController alloc] init];
        jilu.room_id = _room_id;
        [self.navigationController pushViewController:jilu animated:YES];
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
