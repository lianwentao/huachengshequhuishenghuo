//
//  FacepayjiluViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/3/23.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "FacepayjiluViewController.h"
#import <AFNetworking.h>
#import "facepaymodel.h"
#import "facepayjiluTableViewCell.h"
#import "UIViewController+BackButtonHandler.h"
#import "FacePayViewController.h"
#import "UITableView+PlaceHolderView.h"
#import "MJRefresh.h"
@interface FacepayjiluViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_DataArr;
    NSMutableArray *modelArr;
    
    UITableView *_TabelView;
    
    int _pagenum;
}

@end

@implementation FacepayjiluViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pagenum = 1;
    self.title = @"当面付历史记录";
    
    [self createUI];
    [self getData];
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    backBtn.frame = CGRectMake(0, 0, 60, 40);
//    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = item;
    // Do any additional setup after loading the view.
}
-(BOOL)navigationShouldPopOnBackButton {
    [self backBtnClicked];
    
    return NO;
}
- (void)backBtnClicked{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[FacePayViewController class]]) {
            FacePayViewController *revise =(FacePayViewController *)controller;
            [self.navigationController popToViewController:revise animated:YES];
        }
    }
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
    facepaymodel *model = [[facepaymodel alloc] init];
    model = [modelArr objectAtIndex:indexPath.row];
    NSString *biaoshi = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"community_name"];
    
    NSString *m_name = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"m_name"];
    NSString *community_name = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"community_name"];
    if (![m_name isEqualToString:@""]) {
        model.biaoshi = @"m_name";
    }
    if (![community_name isEqualToString:@""]) {
        model.biaoshi = @"community_name";
    }
    
    if ([model.biaoshi isEqualToString:@"m_name"]) {
        return 222.5+37.5+[model.labelheight floatValue]-45;
    }else if([model.biaoshi isEqualToString:@"community_name"]){
        return 222.5+37.5+[model.labelheight floatValue];
    }else{
        return 222.5+37.5+[model.labelheight floatValue]-75;
    }
    
    
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
    facepayjiluTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell == nil) {
        cell = [[facepayjiluTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        //cell.userInteractionEnabled = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
    }
    cell.model = [modelArr objectAtIndex:indexPath.row];
    return cell;
}

- (void)getData
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = @{@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
    
    NSString *strurl = [API stringByAppendingString:@"property/face_order_list"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"---%@--%@",responseObject,[responseObject objectForKey:@"msg"]);
        _DataArr = [NSMutableArray array];
        modelArr = [NSMutableArray arrayWithCapacity:0];
        
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            _DataArr = [responseObject objectForKey:@"data"];
            for (int i=0; i<_DataArr.count; i++) {
                facepaymodel *model = [[facepaymodel alloc] init];
                NSTimeInterval interval    =[[[_DataArr objectAtIndex:i] objectForKey:@"addtime"] doubleValue];
                NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *dateString       = [formatter stringFromDate: date];
                model.time = dateString;
                model.price = [NSString stringWithFormat:@"%@:%@元",[[_DataArr objectAtIndex:i] objectForKey:@"c_name"],[[_DataArr objectAtIndex:i] objectForKey:@"money"]];
                model.biahao = [[_DataArr objectAtIndex:i] objectForKey:@"order_number"];
                model.name = [NSString stringWithFormat:@"%@/%@",[[_DataArr objectAtIndex:i] objectForKey:@"fullname"],[[_DataArr objectAtIndex:i] objectForKey:@"mobile"]];
                model.house = [NSString stringWithFormat:@"%@%@%@单元",[[_DataArr objectAtIndex:i] objectForKey:@"community_name"],[[_DataArr objectAtIndex:i] objectForKey:@"building_name"],[[_DataArr objectAtIndex:i] objectForKey:@"unit"]];
                
                model.notice = [[_DataArr objectAtIndex:i] objectForKey:@"note"];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(17.5, 0, Main_width-35, 0)];
                label.text = [NSString stringWithFormat:@"备注:%@",model.notice];
                CGSize size = [label sizeThatFits:CGSizeMake(label.frame.size.width, MAXFLOAT)];
                model.labelheight = [NSString stringWithFormat:@"%f",size.height];
                
                NSString *m_name = [[_DataArr objectAtIndex:i] objectForKey:@"m_name"];
                model.m_name = m_name;
                NSString *community_name = [[_DataArr objectAtIndex:i] objectForKey:@"community_name"];
                if (![m_name isEqualToString:@""]) {
                    model.biaoshi = @"m_name";
                }
                if (![community_name isEqualToString:@""]) {
                    model.biaoshi = @"community_name";
                }
                [modelArr addObject:model];
            }
        }
        [_TabelView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
- (void)postup
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    _pagenum = _pagenum+1;
    NSString *string = [NSString stringWithFormat:@"%d",_pagenum];
    NSDictionary *dict = nil;
    dict = @{@"p":string};
    
    NSString *strurl = [API stringByAppendingString:@"property/face_order_list"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            _DataArr = [responseObject objectForKey:@"data"];
            NSArray *arr = [[NSArray alloc] init];
            arr = [responseObject objectForKey:@"data"];
            NSString *stringnumber = [[arr objectAtIndex:0] objectForKey:@"total_Pages"];
            NSInteger i = [stringnumber integerValue];
            if (_pagenum>i) {
                _TabelView.mj_footer.state = MJRefreshStateNoMoreData;
                [_TabelView.mj_footer resetNoMoreData];
            }else{
                for (int i=0; i<_DataArr.count; i++) {
                    facepaymodel *model = [[facepaymodel alloc] init];
                    NSTimeInterval interval    =[[[_DataArr objectAtIndex:i] objectForKey:@"addtime"] doubleValue];
                    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
                    
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSString *dateString       = [formatter stringFromDate: date];
                    model.time = dateString;
                    model.price = [NSString stringWithFormat:@"%@:%@元",[[_DataArr objectAtIndex:i] objectForKey:@"c_name"],[[_DataArr objectAtIndex:i] objectForKey:@"money"]];
                    model.biahao = [[_DataArr objectAtIndex:i] objectForKey:@"order_number"];
                    model.name = [NSString stringWithFormat:@"%@/%@",[[_DataArr objectAtIndex:i] objectForKey:@"fullname"],[[_DataArr objectAtIndex:i] objectForKey:@"mobile"]];
                    model.house = [NSString stringWithFormat:@"%@%@%@单元",[[_DataArr objectAtIndex:i] objectForKey:@"community_name"],[[_DataArr objectAtIndex:i] objectForKey:@"building_name"],[[_DataArr objectAtIndex:i] objectForKey:@"unit"]];
                    
                    model.notice = [[_DataArr objectAtIndex:i] objectForKey:@"note"];
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(17.5, 0, Main_width-35, 0)];
                    label.text = [NSString stringWithFormat:@"备注:%@",model.notice];
                    CGSize size = [label sizeThatFits:CGSizeMake(label.frame.size.width, MAXFLOAT)];
                    model.labelheight = [NSString stringWithFormat:@"%f",size.height];
                    
                    model.biaoshi = [[_DataArr objectAtIndex:i] objectForKey:@"community_name"];
                    [modelArr addObject:model];
                }
            }
            
            }
        [_TabelView.mj_footer endRefreshing];
        [_TabelView reloadData];
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
