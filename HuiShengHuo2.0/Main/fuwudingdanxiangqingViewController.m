//
//  fuwudingdanxiangqingViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/1/5.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "fuwudingdanxiangqingViewController.h"
#import <AFNetworking.h>
#import "MBProgressHUD+TVAssistant.h"
#import "UIImageView+WebCache.h"

#define screen_Width [UIScreen mainScreen].bounds.size.width
#define screen_Height [UIScreen mainScreen].bounds.size.height
@interface fuwudingdanxiangqingViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_TableView;
    NSMutableDictionary *_DataDic;
    NSMutableArray *_DataArr;
    NSMutableArray *_imgArr;
}

@end

@implementation fuwudingdanxiangqingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self post];
    [self createtableview];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gengxinmain" object:nil userInfo:nil];
    // Do any additional setup after loading the view.
}
- (void)createtableview
{
    _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_Width, screen_Height)];
    _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _TableView.delegate = self;
    _TableView.dataSource = self;
    [self.view addSubview:_TableView];
}
#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 4;
    }else{
        if ([_DataArr isKindOfClass:[NSArray class]]) {
            return _DataArr.count+1;
        }else{
            return 0;
        }
        
    }
}

// 分组的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
//headview的高度和内容
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }else{
        return 10;
    }
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
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (indexPath.section==0) {
        
        if (indexPath.row==0) {
            cell.textLabel.text = _nametitle;
            tableView.rowHeight = 45;
        }if (indexPath.row==1) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, screen_Width-20, 25)];
            label.text = [_DataDic objectForKey:@"address"];
            NSLog(@"%@",label.text);
            [cell.contentView addSubview:label];
            tableView.rowHeight = 45;
        }if (indexPath.row==2) {
            if (![_imgArr isKindOfClass:[NSArray class]]) {
                UILabel *labelcontent = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, screen_Width-30, 0)];
                labelcontent.text = [_DataDic objectForKey:@"description"];
                labelcontent.font = [UIFont systemFontOfSize:15];
                labelcontent.numberOfLines = 0;
                CGSize size = [labelcontent sizeThatFits:CGSizeMake(labelcontent.frame.size.width, MAXFLOAT)];
                labelcontent.frame = CGRectMake(labelcontent.frame.origin.x, labelcontent.frame.origin.y, labelcontent.frame.size.width,            size.height);
                [cell.contentView addSubview:labelcontent];
                tableView.rowHeight=size.height+10;
            }else{
                UILabel *labelcontent = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, screen_Width-30, 0)];
                labelcontent.text = [_DataDic objectForKey:@"description"];
                labelcontent.font = [UIFont systemFontOfSize:15];
                labelcontent.numberOfLines = 0;
                CGSize size = [labelcontent sizeThatFits:CGSizeMake(labelcontent.frame.size.width, MAXFLOAT)];
                labelcontent.frame = CGRectMake(labelcontent.frame.origin.x, labelcontent.frame.origin.y, labelcontent.frame.size.width,            size.height);
                [cell.contentView addSubview:labelcontent];
                for (int i=0; i<_imgArr.count; i++) {
                    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(10+screen_Width/5*i+10*i, size.height+20, screen_Width/5, screen_Width/5)];
                    NSString *strurl = [[_imgArr objectAtIndex:i] objectForKey:@"img"];
                    [image sd_setImageWithURL:[NSURL URLWithString:strurl]];
                    [cell.contentView addSubview:image];
                }
                _TableView.rowHeight = screen_Width/5+20+size.height+20;
            }
        }if (indexPath.row==3) {
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, screen_Width-20, 25)];
            NSString *isplay = [_DataDic objectForKey:@"is_replace"];
            [cell.contentView addSubview:label1];
            if ([isplay isEqualToString:@"1"]) {
                label1.text = @"需要更换配件";
            }else{
                label1.text = @"不需要更换配件";
            }
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, screen_Width-20, 25)];
            NSString *timestring = [_DataDic objectForKey:@"addtime"];
            NSTimeInterval interval   =[timestring doubleValue];
            NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSString *dateString = [formatter stringFromDate: date];
            label2.text = [NSString stringWithFormat:@"预约时间:%@",dateString];
            [cell.contentView addSubview:label2];
            tableView.rowHeight = 80;
        }
    }else{
        //[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (indexPath.row==0) {
            cell.textLabel.text = @"进度";
        }else{
            UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 45, 45)];
            NSString *strurl = [[_DataArr objectAtIndex:indexPath.row-1] objectForKey:@"avatars"];
            [imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_img,strurl]]];
            [cell.contentView addSubview:imageview];
            UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(65, 10,screen_Width-75, 20)];
            name.text = [NSString stringWithFormat:@"%@-%@",[[_DataArr objectAtIndex:indexPath.row-1] objectForKey:@"ins_name"],[[_DataArr objectAtIndex:indexPath.row-1] objectForKey:@"fullname"]];
            [cell.contentView addSubview:name];
            UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(65, 35, screen_Width-75, 20)];
            NSString *timestring = [[_DataArr objectAtIndex:indexPath.row-1] objectForKey:@"addtime"];
            NSTimeInterval interval   =[timestring doubleValue];
            NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSString *dateString = [formatter stringFromDate: date];
            time.text = dateString;
            [cell.contentView addSubview:time];
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(65, 56, screen_Width-75, 0.5)];
            view.alpha = 0.2;
            view.backgroundColor = [UIColor blackColor];
            [cell.contentView addSubview:view];
            UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(65, 60, screen_Width-75, 20)];
            content.text = [[_DataArr objectAtIndex:indexPath.row-1] objectForKey:@"repair"];
            [cell.contentView addSubview:content];
            tableView.rowHeight = 90;
        }
    }
    return cell;
}
#pragma mark ------联网请求---
-(void)post
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    NSDictionary *dict = @{@"id":_id,@"apk_token":uid_username,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *API = [defaults objectForKey:@"API"];
    NSString *urlstr = [API stringByAppendingString:@"property/my_property_repair_info"];
    [manager POST:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _DataArr = [[NSMutableArray alloc] init];
        _imgArr = [[NSMutableArray alloc] init];
        NSLog(@"success订单详情--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            _DataDic = [responseObject objectForKey:@"data"];
            _imgArr = [[responseObject objectForKey:@"data"] objectForKey:@"imgs"];
            
            _DataArr = [[responseObject objectForKey:@"data"] objectForKey:@"r_list"];
            
            
            
        }else{
            _DataDic = nil;
            _DataArr = nil;
            _imgArr = nil;
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
        [_TableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
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
