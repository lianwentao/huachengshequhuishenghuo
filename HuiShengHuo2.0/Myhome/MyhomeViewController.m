//
//  MyhomeViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/3/21.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "MyhomeViewController.h"
#import <AFNetworking.h>
#import "UIImageView+WebCache.h"
#import "fangkeyaqingViewController.h"
#import "jiatingzhangdanViewController.h"
#import "IBAlertView.h"
#import "LSXAlertInputView.h"
#import "MBProgressHUD+TVAssistant.h"
#import "fabutieziViewController.h"
@interface MyhomeViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UITableView *_TabelView;
    NSDictionary *_DicData;
    
    NSString *deletebind_type2;
    NSString *deletebind_type3;
}
//**/
@end

@implementation MyhomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"成员详情";
    
    deletebind_type2 = @"0";
    deletebind_type3 = @"0";
    [self getData];
    [self createUI];
    // Do any additional setup after loading the view.
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
    NSString *strurl = [API stringByAppendingString:@"property/room_info"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            NSLog(@"---%@--%@",responseObject,[responseObject objectForKey:@"msg"]);
            _DicData = [[NSDictionary alloc] init];
            _DicData = [responseObject objectForKey:@"data"];
        }
        [_TabelView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 2;
    }else if (section==1){
        NSArray *per_liarr = [[NSArray alloc] init];
        per_liarr = [_DicData objectForKey:@"per_li"];
        if ([per_liarr isKindOfClass:[NSArray class]]) {
            return 1+per_liarr.count;
        }else{
            return 0;
        }
    }else if (section==2){
        NSArray *per_li_arr = [[NSArray alloc] init];
        per_li_arr = [_DicData objectForKey:@"per_li_"];
        if ([per_li_arr isKindOfClass:[NSArray class]]) {
            return 1+per_li_arr.count;
        }else{
            return 2;
        }
    }else{
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            return 157.5;
        }else{
            return 55;
        }
    }else if (indexPath.section==3){
        return 75;
    }else if (indexPath.section==2){
        NSArray *per_li_arr = [[NSArray alloc] init];
        per_li_arr = [_DicData objectForKey:@"per_li_"];
        if ([per_li_arr isKindOfClass:[NSArray class]]) {
            if (indexPath.row==0) {
                return 65;
            }else{
                return 90.25;
            }
        }else{
            if (indexPath.row==0) {
                return 65;
            }else{
                return 242.5;
            }
        }
    }else {
        if (indexPath.row==0) {
            return 65;
        }else{
            return 90.25;
        }
    }
}
// 分组的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    NSArray *per_liarr = [[NSArray alloc] init];
    per_liarr = [_DicData objectForKey:@"per_li"];
    
    NSArray *per_li_arr = [[NSArray alloc] init];
    per_li_arr = [_DicData objectForKey:@"per_li_"];
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
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
            room_info = [_DicData objectForKey:@"room_info"];
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
        }else{
            NSArray *arr1 = @[@"fangke",@"jiatingjiaofei"];
            NSArray *arr2 = @[@" 访客邀请",@" 家庭账单"];
            for (int i=0; i<2; i++) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(Main_width/2*i, 0, Main_width/2, 55)];
                NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[arr2 objectAtIndex:i]];
                NSTextAttachment *attch = [[NSTextAttachment alloc] init];
                attch.image = [UIImage imageNamed:[arr1 objectAtIndex:i]];
                attch.bounds = CGRectMake(0, -5, 25, 25);
                NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
                [attri insertAttributedString:string atIndex:0];
                label.backgroundColor = [UIColor whiteColor];
                label.attributedText = attri;
                label.textAlignment = NSTextAlignmentCenter;
                [cell.contentView addSubview:label];
                
                UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(Main_width/2, 15, 2, 25)];
                lineview.backgroundColor = [UIColor blackColor];
                lineview.alpha = 0.6;
                [cell.contentView addSubview:lineview];
                
                UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
                but.backgroundColor = [UIColor clearColor];
                but.frame = CGRectMake(Main_width/2*i, 0, Main_width/2, 55);
                but.tag = i;
                [but addTarget:self action:@selector(butclick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:but];
            }
        }
    }else if (indexPath.section==1){
        if (indexPath.row==0) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, 25, Main_width/2, 25)];
            label.text = @"家庭成员";
            [label setFont:nomalfont];
            cell.backgroundColor = BackColor;
            [cell.contentView addSubview:label];
            
            NSArray *butimgarr = @[@"quanxian",@"Myhometianjia",@"shanchu"];
            for (int i=0; i<3; i++) {
                UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
                [but setImage:[UIImage imageNamed:[butimgarr objectAtIndex:i]] forState:UIControlStateNormal];
                [but addTarget:self action:@selector(jiatingchengyuan:) forControlEvents:UIControlEventTouchUpInside];
                but.frame = CGRectMake(Main_width-6*25+i*50, 25, 25, 25);
                but.tag = i;
                [cell.contentView addSubview:but];
            }
        }else{
            UIImageView *touxiangimageview = [[UIImageView alloc] initWithFrame:CGRectMake(20, 25, 42.5, 42.5)];
            NSString *touxiangurl = [API_img stringByAppendingString:[[per_liarr objectAtIndex:indexPath.row-1] objectForKey:@"avatars"]];
            [touxiangimageview sd_setImageWithURL:[NSURL URLWithString:touxiangurl] placeholderImage:[UIImage imageNamed:@"facehead1"]];
            touxiangimageview.layer.masksToBounds = YES;
            touxiangimageview.layer.cornerRadius = 21.25;
            [cell.contentView addSubview:touxiangimageview];
            
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
            
            UILabel *namelabel = [[UILabel alloc] initWithFrame:CGRectMake(20+42.5+15, 30, Main_width-77.5-10, 20)];
            [namelabel setFont:font18];
            NSString *bind_type = [[per_liarr objectAtIndex:indexPath.row-1] objectForKey:@"bind_type"];
            if ([bind_type isEqualToString:@"1"]) {
                namelabel.text = [NSString stringWithFormat:@"%@ | 业主",[[per_liarr objectAtIndex:indexPath.row-1] objectForKey:@"nickname"]];
            }else{
                namelabel.text = [[per_liarr objectAtIndex:indexPath.row-1] objectForKey:@"nickname"];
                
//                [cell.contentView addSubview:lineview];
//                [cell.contentView addSubview:circle];
            }
            [cell.contentView addSubview:namelabel];
            
            if (indexPath.row>1) {
                [cell.contentView addSubview:lineview];
                [cell.contentView addSubview:circle];
            }else{
                
            }
            
            UILabel *username = [[UILabel alloc] initWithFrame:CGRectMake(20+42.5+15, 55, Main_width-87.5, 20)];
            [username setFont:nomalfont];
            username.text = [[per_liarr objectAtIndex:indexPath.row-1] objectForKey:@"username"];
            [cell.contentView addSubview:username];
            
            UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
            but.frame = CGRectMake(Main_width-50, 31, 30, 30);
            but.tag = [[[per_liarr objectAtIndex:indexPath.row-1] objectForKey:@"id"] integerValue];
            [but setImage:[UIImage imageNamed:@"shanchuhong"] forState:UIControlStateNormal];
            [but addTarget:self action:@selector(deletechengyuan:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:but];
            if ([deletebind_type2 isEqualToString:@"0"]) {
                but.hidden = YES;
            }else{
                but.hidden = NO;
            }
        }
    }else if (indexPath.section==2){
        if (indexPath.row==0) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, 25, Main_width/2, 25)];
            label.text = @"租客成员";
            [label setFont:nomalfont];
            cell.backgroundColor = BackColor;
            [cell.contentView addSubview:label];
            
            NSArray *butimgarr = @[@"quanxian",@"Myhometianjia",@"shanchu"];
            for (int i=0; i<3; i++) {
                UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
                [but setImage:[UIImage imageNamed:[butimgarr objectAtIndex:i]] forState:UIControlStateNormal];
                but.frame = CGRectMake(Main_width-6*25+i*50, 25, 25, 25);
                but.tag = i;
                [but addTarget:self action:@selector(zukechengyuan:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:but];
            }
        }else{
            NSArray *per_li_arr = [[NSArray alloc] init];
            per_li_arr = [_DicData objectForKey:@"per_li_"];
            if ([per_li_arr isKindOfClass:[NSArray class]]) {
                UIImageView *touxiangimageview = [[UIImageView alloc] initWithFrame:CGRectMake(20, 25, 42.5, 42.5)];
                NSString *touxiangurl = [API_img stringByAppendingString:[[per_li_arr objectAtIndex:indexPath.row-1] objectForKey:@"avatars"]];
                [touxiangimageview sd_setImageWithURL:[NSURL URLWithString:touxiangurl] placeholderImage:[UIImage imageNamed:@"facehead1"]];
                touxiangimageview.layer.masksToBounds = YES;
                touxiangimageview.layer.cornerRadius = 21.25;
                [cell.contentView addSubview:touxiangimageview];
                
                UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(77.5, 3, 6, 6)];
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
                
                if (indexPath.row>1) {
                    [cell.contentView addSubview:lineview];
                    [cell.contentView addSubview:circle];
                }else{
                    
                }
                
                UILabel *namelabel = [[UILabel alloc] initWithFrame:CGRectMake(20+42.5+15, 30, Main_width-77.5-10, 20)];
                [namelabel setFont:font18];
                namelabel.text = [[per_li_arr objectAtIndex:indexPath.row-1] objectForKey:@"nickname"];
                [cell.contentView addSubview:namelabel];
                
                UILabel *username = [[UILabel alloc] initWithFrame:CGRectMake(20+42.5+15, 55, Main_width-87.5, 20)];
                [username setFont:nomalfont];
                username.text = [[per_li_arr objectAtIndex:indexPath.row-1] objectForKey:@"username"];
                [cell.contentView addSubview:username];
                
                UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
                but.frame = CGRectMake(Main_width-50, 31, 30, 30);
                but.tag = [[[per_li_arr objectAtIndex:indexPath.row-1] objectForKey:@"id"] integerValue];
                [but setImage:[UIImage imageNamed:@"shanchuhong"] forState:UIControlStateNormal];
                [but addTarget:self action:@selector(deletechengyuan:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:but];
                
                if ([deletebind_type3 isEqualToString:@"0"]) {
                    but.hidden = YES;
                }else{
                    but.hidden = NO;
                }
            }else{
                UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(Main_width/2-60, 25, 120, 120)];
                imageview.image = [UIImage imageNamed:@"pinglunweikong"];
                [cell.contentView addSubview:imageview];
                
                UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
                but.frame = CGRectMake(Main_width/2-60, imageview.frame.size.height+imageview.frame.origin.y+10, 120, 35);
                //[but setTitle:@"" forState:UIControlStateNormal];
                
                NSMutableAttributedString *attri =     [[NSMutableAttributedString alloc] initWithString:@"寻找租客"];
                
                NSTextAttachment *attch = [[NSTextAttachment alloc] init];
                attch.image = [UIImage imageNamed:@"youjiantou2x_03"];
                attch.bounds = CGRectMake(0, 0, 15, 15);
                NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
                [attri insertAttributedString:string atIndex:4];
                [but setAttributedTitle:attri forState:UIControlStateNormal];
                
                [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [but.titleLabel setFont:font15];
                [but addTarget:self action:@selector(fabutiezi) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:but];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, but.frame.size.height+but.frame.origin.y+12.5, Main_width, 20)];
                label.font = font15;
                label.text = @"你可以编辑一条租房消息,我们帮你找租客";
                label.alpha = 0.4;
                label.textAlignment = NSTextAlignmentCenter;
                [cell.contentView addSubview:label];
            }
        }
    }else{
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Main_width, 75)];
        label.text = @"若房屋信息有误，请联系：400-6535-355";
        label.alpha = 0.3;
        label.textAlignment = NSTextAlignmentCenter;
        [label setFont:nomalfont];
        cell.backgroundColor = BackColor;
        [cell.contentView addSubview:label];
    }
    
    return cell;
}
- (void)fabutiezi
{
    fabutieziViewController *fabutiezi = [[fabutieziViewController alloc] init];
    [self.navigationController pushViewController:fabutiezi animated:YES];
}
#pragma mark - 访客邀请--家庭账单
- (void)butclick:(UIButton *)sender
{
    if (sender.tag==0) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[defaults objectForKey:@"uid"],[defaults objectForKey:@"username"]]];
        NSDictionary *dict = @{@"apk_token":uid_username,@"room_id":_room_id,@"token":[defaults objectForKey:@"token"],@"tokenSecret":[defaults objectForKey:@"tokenSecret"]};
        NSString *strurl = [API stringByAppendingString:@"property/checkIsAjb"];
        [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@-11111-%@",[responseObject objectForKey:@"msg"],responseObject);
            NSDictionary *dicccc = [[NSDictionary alloc] init];
            if ([[responseObject objectForKey:@"status"] integerValue]==1) {
                dicccc = [responseObject objectForKey:@"data"];
                if ([dicccc isKindOfClass:[NSDictionary class]]) {
                    fangkeyaqingViewController *fangke = [[fangkeyaqingViewController alloc] init];
                    fangke.Dic = dicccc;
                    [self.navigationController pushViewController:fangke animated:YES];
                }else{
                    [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
                }
            }else{
                [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"failure--%@",error);
        }];
        
    }else{
        jiatingzhangdanViewController *jiating = [[jiatingzhangdanViewController alloc] init];
        jiating.Dic = [_DicData objectForKey:@"room_info"];
        jiating.room_id = _room_id;
        [self.navigationController pushViewController:jiating animated:YES];
    }
}

- (void)jiatingchengyuan:(UIButton *)sender
{
    if (sender.tag==0) {
        IBConfigration *configration = [[IBConfigration alloc] init];
        configration.title = @"权限说明";
        configration.message = @"1,所有家人都拥有权限邀请其他人加入\n2,租客智能邀请租客加入\n3,租客智能由户主和家人邀请加入\n\n4,所有人不能删除户主权限\n5,户主能删除所有人权限\n6,非户主家人只能删除非户主家人和租客\n\n7,租客只显示被邀请入住的房间";
        configration.cancelTitle = @"取消";
        configration.confirmTitle = @"确定";
        configration.tintColor = QIColor;
        configration.messageAlignment = NSTextAlignmentLeft;
        
        IBAlertView *alerView = [IBAlertView alertWithConfigration:configration block:^(NSUInteger index) {
            
        }];
        [alerView show];
    }else if(sender.tag==1) {
        LSXAlertInputView * alert=[[LSXAlertInputView alloc]initWithTitle:@"邀请成员" PlaceholderText:@"请输入被邀请人手机号" WithKeybordType:LSXKeyboardTypeDefault CompleteBlock:^(NSString *contents) {
            if ([contents isEqualToString:@""]) {
                [MBProgressHUD showToastToView:self.view withText:@"手机号不能为空"];
            }else{
                if ([self isValidateMobile:contents]) {
                    [self addchengyuan:contents :@"2"];
                }else{
                    [MBProgressHUD showToastToView:self.view withText:@"手机号格式不对"];
                }
            }
        }];
        [alert show];
    }else{
        if ([deletebind_type2 isEqualToString:@"0"]) {
            deletebind_type2 = @"1";
            deletebind_type3 = @"1";
        }else{
            deletebind_type2 = @"0";
            deletebind_type3 = @"0";
        }
        [_TabelView reloadData];
    }
}
- (void)zukechengyuan:(UIButton *)sender
{
    if (sender.tag==0) {
        IBConfigration *configration = [[IBConfigration alloc] init];
        configration.title = @"权限说明";
        configration.message = @"1,所有家人都拥有权限邀请其他人加入\n2,租客智能邀请租客加入\n3,租客智能由户主和家人邀请加入\n\n4,所有人不能删除户主权限\n5,户主能删除所有人权限\n6,非户主家人只能删除非户主家人和租客\n\n7,租客只显示被邀请入住的房间";
        configration.cancelTitle = @"取消";
        configration.confirmTitle = @"确定";
        configration.tintColor = QIColor;
        configration.messageAlignment = NSTextAlignmentLeft;
        
        IBAlertView *alerView = [IBAlertView alertWithConfigration:configration block:^(NSUInteger index) {
            
        }];
        [alerView show];
    }else if(sender.tag==1) {
        LSXAlertInputView * alert=[[LSXAlertInputView alloc]initWithTitle:@"邀请成员" PlaceholderText:@"请输入被邀请人手机号" WithKeybordType:LSXKeyboardTypeDefault CompleteBlock:^(NSString *contents) {
            if ([contents isEqualToString:@""]) {
                [MBProgressHUD showToastToView:self.view withText:@"手机号不能为空"];
            }else{
                if ([self isValidateMobile:contents]) {
                    [self addchengyuan:contents :@"3"];
                }else{
                    [MBProgressHUD showToastToView:self.view withText:@"手机号格式不对"];
                }
            }
        }];
        [alert show];
    }else{
        if ([deletebind_type3 isEqualToString:@"0"]) {
            deletebind_type3 = @"1";
        }else{
            deletebind_type3 = @"0";
        }
        [_TabelView reloadData];
    }
}
- (void)addchengyuan:(NSString *)mobilestring :(NSString *)bind_type
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[userinfo objectForKey:@"uid"],[userinfo objectForKey:@"username"]]];
    dict = @{@"room_id":_room_id,@"mobile":mobilestring,@"bind_type":bind_type,@"apk_token":uid_username,@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"]};
    NSString *strurl = [API stringByAppendingString:@"property/house_member_save"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"---%@--%@",responseObject,[responseObject objectForKey:@"msg"]);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            [self getData];
        }
        [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        //[_TabelView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
- (void)deletechengyuan:(UIButton *)sender
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[userinfo objectForKey:@"uid"],[userinfo objectForKey:@"username"]]];
    dict = @{@"id":[NSString stringWithFormat:@"%ld",sender.tag],@"apk_token":uid_username,@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"]};
    NSString *strurl = [API stringByAppendingString:@"property/set_bind_status"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"---%@--%@",responseObject,[responseObject objectForKey:@"msg"]);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            [self getData];
        }
        [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        //[_TabelView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
/*手机号码验证 MODIFIED BY LYH*/
-(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex =@"^1[3,8]\\d{9}|14[5,7,9]\\d{8}|15[^4]\\d{8}|17[^2,4,9]\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
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
