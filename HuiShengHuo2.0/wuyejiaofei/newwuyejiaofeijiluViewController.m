//
//  newwuyejiaofeijiluViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/8/23.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "newwuyejiaofeijiluViewController.h"
#import <AFNetworking.h>
#import "newjiaofeimodel.h"
#import "newjiaofeiTableViewCell.h"
#import "MJRefresh.h"
@interface newwuyejiaofeijiluViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *modelArr;
    NSMutableArray *_DataArr;
    UITableView *_TabelView;
    
    int _pagenum;
}

@end

@implementation newwuyejiaofeijiluViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getData];
    [self createUI];
    
    self.title = @"缴费记录";
    // Do any additional setup after loading the view.
}
- (void)getData
{
    _DataArr = [NSMutableArray array];
    modelArr = [NSMutableArray arrayWithCapacity:0];
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[userinfo objectForKey:@"uid"],[userinfo objectForKey:@"username"]]];
    dict = @{@"apk_token":uid_username,@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"]};
    NSString *strurl = [API stringByAppendingString:@"property/getUserBill"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"---%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            _DataArr = [responseObject objectForKey:@"data"];
            for (int i=0; i<_DataArr.count; i++) {
                newjiaofeimodel *model = [[newjiaofeimodel alloc] init];
                NSTimeInterval interval    =[[[[_DataArr objectAtIndex:i] objectForKey:@"info"] objectForKey:@"pay_time"] doubleValue];
                NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *dateString       = [formatter stringFromDate: date];
                model.time = dateString;
                WBLog(@"dateString====%@",dateString);
//                model.price = [NSString stringWithFormat:@"%@:%@元",[[_DataArr objectAtIndex:i] objectForKey:@"c_name"],[[_DataArr objectAtIndex:i] objectForKey:@"money"]];
//                model.biahao = [[_DataArr objectAtIndex:i] objectForKey:@"order_number"];
                model.name = [NSString stringWithFormat:@"%@",[[[_DataArr objectAtIndex:i] objectForKey:@"info"] objectForKey:@"name"]];
                model.address = [[[_DataArr objectAtIndex:i] objectForKey:@"info"] objectForKey:@"address"];
                model.zhangdanhao = [NSString stringWithFormat:@"账单号:%@",[[[_DataArr objectAtIndex:i] objectForKey:@"info"] objectForKey:@"order_num"]];
                model.listarr = [[_DataArr objectAtIndex:i] objectForKey:@"list"];
                
                [modelArr addObject:model];
            }
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
    _TabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _TabelView.backgroundColor = BackColor;
    _TabelView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(postup)];
    [self.view addSubview:_TabelView];
}
#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return modelArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"list"];
    long j=arr.count+1;
//    for (int i = 0; i<arr.count; i++) {
//        NSArray *arrlist = [arr objectAtIndex:indexPath.row];
//        j = arrlist.count+j;
//    }
    return 180+35*j;
}
// 分组的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIndetifier = @"facepayjiluTableViewCell";
    NSLog(@"-----------111==%@",modelArr);
    newjiaofeiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell == nil) {
        cell = [[newjiaofeiTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        //cell.userInteractionEnabled = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
    }
    cell.model = [modelArr objectAtIndex:indexPath.row];
    return cell;
}
- (void)postup
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
