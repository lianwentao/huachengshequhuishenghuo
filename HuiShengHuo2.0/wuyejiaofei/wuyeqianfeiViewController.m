//
//  wuyeqianfeiViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/9/2.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "wuyeqianfeiViewController.h"
#import <AFNetworking.h>

@interface wuyeqianfeiViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_TableView;
    NSArray *wuyeArr;
    NSDictionary *dianfeiDic;
    NSDictionary *shuifeiDic;
    NSDictionary *roominfodic;
    
    NSString *is_available;
}

@end

@implementation wuyeqianfeiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    UIView *botomview = [[UIView alloc] initWithFrame:CGRectMake(0, Main_Height-55, Main_width, 55)];
    botomview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:botomview];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, Main_width/3*2, 30)];
    label1.text = @"总额:215.14元";
    label1.font = font15;
    label1.textColor = QIColor;
    [botomview addSubview:label1];
    
    UIButton *jiaofeibut = [UIButton buttonWithType:UIButtonTypeCustom];
    jiaofeibut.frame = CGRectMake(Main_width-50-12, 10, 50, 30);
    [jiaofeibut setTitle:@"缴费" forState:UIControlStateNormal];
    jiaofeibut.backgroundColor = [UIColor colorWithRed:255/255.0 green:92/255.0 blue:34/255.0 alpha:1];
    [jiaofeibut.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [botomview addSubview:jiaofeibut];
    
    [self getData];
    [self createtableview];
    
    self.title = @"缴费";
    // Do any additional setup after loading the view.
}
- (void)getData
{
    wuyeArr = [NSArray array];
    dianfeiDic = [[NSDictionary alloc] init];
    shuifeiDic = [[NSDictionary alloc] init];
    roominfodic = [[NSDictionary alloc] init];
    
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[userinfo objectForKey:@"uid"],[userinfo objectForKey:@"username"]]];
    dict = @{@"room_id":_room_id,@"apk_token":uid_username,@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"]};
    NSString *strurl = [API stringByAppendingString:@"property/getBillByRoom"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"---%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            wuyeArr = [[responseObject objectForKey:@"data"] objectForKey:@"wuye"];
            dianfeiDic = [[responseObject objectForKey:@"data"] objectForKey:@"dianfei"];
            shuifeiDic = [[responseObject objectForKey:@"data"] objectForKey:@"shuifei"];
            roominfodic = [[responseObject objectForKey:@"data"] objectForKey:@"room_info"];
            is_available = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"is_available"]];
            
//            [self createUI];
        }
        [_TableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}

- (void)createtableview
{
    _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_width, Main_Height)];
    _TableView.delegate = self;
    _TableView.dataSource = self;
    _TableView.backgroundColor = BackColor;
    _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_TableView];
}
#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==3) {
        if (![wuyeArr isKindOfClass:[NSArray class]]&&![shuifeiDic isKindOfClass:[NSDictionary class]]&&![dianfeiDic isKindOfClass:[NSDictionary class]]) {
            return 1;
        }else{
            return 3;
        }
    }else{
      return 1;
    }
}
// 分组的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
//headview的高度和内容
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section<3) {
        return 10;
    }else{
        return 0;
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @" ";
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
        
        cell.userInteractionEnabled = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
    }
    if (indexPath.section==0) {
        tableView.rowHeight = 50;
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, Main_width-20, 18)];
        label1.font = font15;
        label1.text = [roominfodic objectForKey:@"address"];
        [cell.contentView addSubview:label1];
    }else if (indexPath.section==1){
        tableView.rowHeight = 50;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, Main_width-20, 50)];
        label.font = font15;
        label.text = [roominfodic objectForKey:@"fullname"];
        [cell.contentView addSubview:label];
    }else if (indexPath.section==2){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, Main_width, 50)];
        label.text = @"生活缴费";
        label.font = font18;
        [cell.contentView addSubview:label];
    } else{
        if (![wuyeArr isKindOfClass:[NSArray class]]&&![shuifeiDic isKindOfClass:[NSDictionary class]]&&![dianfeiDic isKindOfClass:[NSDictionary class]]) {
            tableView.rowHeight = 50;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, Main_width-20, 50)];
            label.text = @"物业费已结清";
            label.font = font15;
            [cell.contentView addSubview:label];
        }else{
            
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
