//
//  fuwusearchchildViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/12/7.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "fuwusearchchildViewController.h"
#import "fuwusearchresultViewController.h"
@interface fuwusearchchildViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_TableView;
    NSArray *dataarr;
}

@end

@implementation fuwusearchchildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createtableview];
    [self getdata];
    // Do any additional setup after loading the view.
}
- (void)createtableview
{
    _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_width, Main_Height-RECTSTATUS.size.height-44-50)];
    _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _TableView.delegate = self;
    _TableView.dataSource = self;
    _TableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    //_TableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(post1)];
    [self.view addSubview:_TableView];
}

// return按钮操作
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.view endEditing:YES];
    
    WBLog(@"----1111-----");
    
    return YES;
}


-(void)rightmengbutClick{
    WBLog(@"asd");
}
- (void)getdata
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = @{@"c_id":[user objectForKey:@"community_id"]};
    NSString *strurl = [API_NOAPK stringByAppendingString:@"/service/index/serviceKeys"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dataarr = [NSArray array];
        WBLog(@"---%@--%@",responseObject,[responseObject objectForKey:@"msg"]);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            if ([_shangjiaorfuwu isEqualToString:@"sj"]) {
                dataarr = [[responseObject objectForKey:@"data"] objectForKey:@"i_key"];
            }else{
                dataarr = [[responseObject objectForKey:@"data"] objectForKey:@"s_key"];
            }
        }else{
            
            
        }
        [_TableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

// 分组的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
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
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 147;
//}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIndetifier = @"myhousecell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        //cell.userInteractionEnabled = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
    }
    if (indexPath.section==0) {
        UIImageView *shuimg= [[UIImageView alloc]initWithFrame:CGRectMake(15, 17, 3, 20)];
        shuimg.backgroundColor = [UIColor blackColor];
        shuimg.alpha = 0.5;
        [cell.contentView addSubview:shuimg];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(shuimg.frame)+10, CGRectGetMinY(shuimg.frame), 200, 20)];
        lab.text = @"热门";
        lab.textColor = [UIColor grayColor];
        lab.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:lab];
        NSArray *tarr = dataarr;
        WBLog(@"%@--%@",tarr,dataarr);
        float butX = 15;
        float butY = CGRectGetMaxY(shuimg.frame)+10;
        for(int i = 0; i < tarr.count; i++){
            
            //宽度自适应
            NSDictionary *fontDict = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
            CGRect frame_W = [tarr[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:fontDict context:nil];
            
            if (butX+frame_W.size.width+20>Main_width-15) {
                
                butX = 15;
                
                butY += 55;
            }
            
            UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(butX, butY, frame_W.size.width+20, 40)];
            [but setTitle:tarr[i] forState:UIControlStateNormal];
            [but setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
            but.titleLabel.font = [UIFont systemFontOfSize:13];
            but.tag = i;
            [but addTarget:self action:@selector(pushrelust:) forControlEvents:UIControlEventTouchUpInside];
            but.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1];
            [cell.contentView addSubview:but];
            
            butX = CGRectGetMaxX(but.frame)+10;
            WBLog(@"%f",butY);
            tableView.rowHeight = butY+40;
        }
    }else{
        if (indexPath.row==0) {
            UIImageView *shuimg= [[UIImageView alloc]initWithFrame:CGRectMake(15, 17, 3, 20)];
            shuimg.backgroundColor = [UIColor blackColor];
            shuimg.alpha = 0.5;
            [cell.contentView addSubview:shuimg];
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(shuimg.frame)+10, CGRectGetMinY(shuimg.frame), 200, 20)];
            lab.text = @"历史";
            lab.textColor = [UIColor grayColor];
            lab.font = [UIFont systemFontOfSize:13];
            [cell.contentView addSubview:lab];
            tableView.rowHeight = 54;
        }else{
            tableView.rowHeight = 50;
        }
    }
    return cell;
}
-(void)pushrelust:(UIButton *)sender
{
    fuwusearchresultViewController *result = [[fuwusearchresultViewController alloc] init];
    result.key = [dataarr objectAtIndex:sender.tag];
    if ([_shangjiaorfuwu isEqualToString:@"sj"]) {
        result.canshu = @"i_key";
        result.url = @"/service/institution/merchantList";
    }else{
        result.canshu = @"s_key";
        result.url = @"/service/service/serviceList";
    }
    [self.navigationController pushViewController:result animated:YES];
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
