//
//  newselectroomViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/12/25.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "newselectroomViewController.h"

@interface newselectroomViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_DataArr;
    UITableView *_Tableview;
}

@end

@implementation newselectroomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self post];
    [self createtableview];
    // Do any additional setup after loading the view.
}
- (void)createtableview
{
    _Tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_width, Main_Height) ];
    _Tableview.delegate = self;
    _Tableview.dataSource = self;
    _Tableview.estimatedRowHeight = 0;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
    _Tableview.tableHeaderView = view;
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
    _Tableview.tableFooterView = view1;
    [self.view addSubview:_Tableview];
}
#pragma mark - UITableView -

//section行数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//每组section个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _DataArr.count;
}
//返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    
    cell.textLabel.text = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"code"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakself = self;
    
    if (weakself.returnValueBlock) {
        //将自己的值传出去，完成传值
        weakself.returnValueBlock([[_DataArr objectAtIndex:indexPath.row] objectForKey:@"id"],[[_DataArr objectAtIndex:indexPath.row] objectForKey:@"code"],[[_DataArr objectAtIndex:indexPath.row] objectForKey:@"id"]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)post{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [[NSDictionary alloc] init];
    if ([_housetype isEqualToString:@"2"]||[_housetype isEqualToString:@"4"]) {
        dict = @{@"community_id":_c_id,@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"],@"hui_community_id":[user objectForKey:@"community_id"]};
    }else{
        dict = @{@"community_id":_c_id,@"buildsing_id":_buildid,@"units":_danyuanid,@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"],@"hui_community_id":[user objectForKey:@"community_id"]};
        
    }
    
    NSString *url = [API stringByAppendingString:@"property/get_pro_room"];
    NSLog(@"dict--%@",dict);
    [manager POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        WBLog(@"location--%@--%@",[responseObject class],responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            _DataArr = [NSArray array];
            _DataArr = [responseObject objectForKey:@"data"];
        }else{
            
        }
        
        [_Tableview reloadData];
        
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
