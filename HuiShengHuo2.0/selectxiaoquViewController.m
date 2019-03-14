//
//  selectxiaoquViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/8/21.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "selectxiaoquViewController.h"
#import "CoreLocation/CoreLocation.h"
#import <MapKit/MapKit.h>
#import <AFNetworking.h>
#import "Person.h"
#import "BMChineseSort.h"
#import "AddressPickerView.h"
@interface selectxiaoquViewController ()<CLLocationManagerDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,AddressPickerViewDelegate>
{
    UITableView *_Tableview;
    NSMutableArray *_Dataarr;
    NSMutableArray *arr;
    
    UILabel *locationlabel;
    
    NSString *_strurl;
    
    NSString *location_region_name;
    NSString *location_region_id;
    UIButton *locationbut;
}

@property (nonatomic ,strong) AddressPickerView * pickerView;
//排序后的出现过的拼音首字母数组
@property(nonatomic,strong)NSMutableArray *indexArray;
//排序好的结果数组
@property(nonatomic,strong)NSMutableArray *letterResultArr;
//定义location对象
@property (strong, nonatomic) CLLocationManager* locationManager;
@end

@implementation selectxiaoquViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //[self.navigationItem setHidesBackButton:YES];
    
    self.title = @"选择小区";
    
    
   
    [self createdaohangolan];
    [self startLocation];
    
    
    
    // Do any additional setup after loading the view.
}
- (BOOL)navigationShouldPopOnBackButton{
    UIViewController *viewc = self.navigationController.viewControllers[self.navigationController.viewControllers.count-1];
    [self.navigationController popToViewController:viewc animated:YES];
    return YES;
}
- (AddressPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[AddressPickerView alloc]init];
        _pickerView.delegate = self;
        [_pickerView setTitleHeight:40 pickerViewHeight:165];
        // 关闭默认支持打开上次的结果
                _pickerView.isAutoOpenLast = YES;
    }
    return _pickerView;
}
#pragma mark - 自定义导航栏
- (void)createdaohangolan
{
    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
//    [self.navigationItem setTitleView:view];
//
//    //NSArray *Imagearr = @[@"shop_icon_fenlei",@"icon_center_gouwu-1"];
//
//    UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-50, 5, 50, 30)];
//    [but setTitle:@"搜索" forState:UIControlStateNormal];
//    [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [but addTarget:self action:@selector(rightbut) forControlEvents:UIControlEventTouchUpInside];
//    but.backgroundColor = [UIColor clearColor];
//    //[view addSubview:but];
//
//
//    UISearchBar *customSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(30,5, (self.view.frame.size.width-70), 34)];
//    customSearchBar.delegate = self;
//    customSearchBar.showsCancelButton = NO;
//    customSearchBar.placeholder = @"搜索小区";
//    customSearchBar.searchBarStyle = UISearchBarStyleMinimal;
//    [view addSubview:customSearchBar];
//
//    UIButton *searchbut = [UIButton buttonWithType:UIButtonTypeCustom];
//    searchbut.frame = CGRectMake(0, 0, Main_width-70, 34);
//    [customSearchBar addSubview:searchbut];
//    [searchbut addTarget:self action:@selector(getsearchs) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *locationview = [[UIView alloc] initWithFrame:CGRectMake(0, RECTSTATUS.size.height+40, Main_width, 48)];
    //locationview.backgroundColor = QIColor;
    [self.view addSubview:locationview];
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 15, 15)];
    imageview.image = [UIImage imageNamed:@"ic_city_loaction"];
    [locationview addSubview:imageview];
    
    locationlabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 15, Main_width-90, 15)];
    [locationview addSubview:locationlabel];
    locationlabel.font = font15;
    
    locationbut = [UIButton buttonWithType:UIButtonTypeCustom];
    [locationbut setTitle:@"" forState:UIControlStateNormal];
    [locationbut setTitle:@"" forState:UIControlStateSelected];
    [locationbut addTarget:self action:@selector(selectlocation:) forControlEvents:UIControlEventTouchUpInside];
    
    locationbut.frame = CGRectMake(0, 0, Main_width, 48);
    [locationview addSubview:locationbut];
    
}
- (void)getsearchs
{
    
}
- (void)rightbut
{
    
}
- (void)selectlocation:(UIButton *)btn
{
    NSLog(@"111111");
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self.pickerView show];
    }else{
        [self.pickerView hide];
    }
}
#pragma mark - AddressPickerViewDelegate
- (void)cancelBtnClick{
    NSLog(@"点击了取消按钮");
    [self selectlocation:locationbut];
}
- (void)sureBtnClickReturnProvince:(NSString *)province City:(NSString *)city Area:(NSString *)area{
    locationlabel.text = [NSString stringWithFormat:@"您当前所选位置: %@ %@",city,area];
    [self selectlocation:locationbut];
    location_region_name = area;
    [self postaaaa];
    NSLog(@"location_name--%@",location_region_name);
}
-(void)startLocation{
    
    if ([CLLocationManager locationServicesEnabled]) {//判断定位操作是否被允许
        
        self.locationManager = [[CLLocationManager alloc] init];
        
        self.locationManager.delegate = self;//遵循代理
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        self.locationManager.distanceFilter = 10.0f;
        
        [_locationManager requestWhenInUseAuthorization];//使用程序其间允许访问位置数据（iOS8以上版本定位需要）
        
        [self.locationManager startUpdatingLocation];//开始定位
        
    }else{//不能定位用户的位置的情况再次进行判断，并给与用户提示
        
        //1.提醒用户检查当前的网络状况
        
        //2.提醒用户打开定位开关
        NSLog(@"提醒用户打开定位开关");
        
    }
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    
    //当前所在城市的坐标值
    CLLocation *currLocation = [locations lastObject];
    
    NSLog(@"经度=%f 纬度=%f 高度=%f", currLocation.coordinate.latitude, currLocation.coordinate.longitude, currLocation.altitude);
    
    [defaults setObject:[NSString stringWithFormat:@"%f",currLocation.coordinate.latitude] forKey:@"latitude"];
    [defaults setObject:[NSString stringWithFormat:@"%f",currLocation.coordinate.longitude] forKey:@"longitude"];
    [defaults synchronize];
    
    //根据经纬度反向地理编译出地址信息
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    
    [geoCoder reverseGeocodeLocation:currLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        for (CLPlacemark * placemark in placemarks) {
            
            NSDictionary *address = [placemark addressDictionary];
            
            //  Country(国家)  State(省)  City（市）
            NSLog(@"#####%@",address);
            
            NSLog(@"%@", [address objectForKey:@"Country"]);
            
            NSLog(@"%@", [address objectForKey:@"State"]);
            
            NSLog(@"%@", [address objectForKey:@"City"]);
            
            NSLog(@"%@",[address objectForKey:@"Name"]);
            NSLog(@"%@",[address objectForKey:@"State"]);
            NSLog(@"%@",[address objectForKey:@"SubLocality"]);
            
            locationlabel.text = [NSString stringWithFormat:@"您当前所选位置: %@ %@",[address objectForKey:@"City"],[address objectForKey:@"SubLocality"]];
            location_region_name = [address objectForKey:@"SubLocality"];
            [self postaaaa];
        }
        
    }];
    
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    if ([error code] == kCLErrorDenied){
        //访问被拒绝
    }
    if ([error code] == kCLErrorLocationUnknown) {
        //无法获取位置信息
    }
}
- (void)createtableview
{
    if (self.letterResultArr.count != 0) {
        _Tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, RECTSTATUS.size.height+40+48, Main_width, Main_Height-48-RECTSTATUS.size.height-40) ];
        _Tableview.estimatedRowHeight = 0;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
        _Tableview.tableHeaderView = view;
        UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
        _Tableview.tableFooterView = view1;
        _Tableview.delegate = self;
        _Tableview.dataSource = self;
        [self.view addSubview:_Tableview];
    }else{
        
        UIView *view = [[UIView alloc]init];
        view.frame = CGRectMake(0, RECTSTATUS.size.height+40+48, Main_width, Main_Height-48-RECTSTATUS.size.height-40);
        view.backgroundColor = [UIColor colorWithRed:243/255.0 green:249/255.0 blue:255/255.0 alpha:1];
        
        UIImageView *imgView = [[UIImageView alloc]init];
        imgView.frame = CGRectMake(Main_width/2-75, 65, 150, 150);
        imgView.image = [UIImage imageNamed:@"pinglunweikong"];
        [view addSubview:imgView];
        
        UILabel *textLab = [[UILabel alloc]init];
        textLab.text = @"该地区暂无服务小区如需合作请与我们联系";
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
        CGSize labelSize = [textLab.text boundingRectWithSize:CGSizeMake(160, 5000) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        textLab.numberOfLines = 0;//表示label可以多行显示
        textLab.textColor =[UIColor colorWithHexString:@"#555555"];
        textLab.font = [UIFont systemFontOfSize:15];
        textLab.frame = CGRectMake(Main_width/2-80, CGRectGetMaxY(imgView.frame)+20, 160, labelSize.height);
        [view addSubview:textLab];
        
        UIButton *zhBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        zhBtn.frame = CGRectMake(55, CGRectGetMaxY(textLab.frame)+50, 104, 40);
        zhBtn.backgroundColor = [UIColor colorWithHexString:@"#FF5722"];
        zhBtn.layer.cornerRadius = 5.0;
        zhBtn.titleLabel.textColor = [UIColor whiteColor];
        [zhBtn setTitle:@"智慧小区" forState:UIControlStateNormal];
        [zhBtn addTarget:self action:@selector(zhiHui:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:zhBtn];
        
        UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        callBtn.frame = CGRectMake(Main_width-55-104, CGRectGetMaxY(textLab.frame)+50, 104, 40);
        callBtn.backgroundColor = [UIColor colorWithHexString:@"#FFB638"];
        callBtn.layer.cornerRadius = 5.0;
        callBtn.titleLabel.textColor = [UIColor whiteColor];
        [callBtn setTitle:@"联系我们" forState:UIControlStateNormal];
        [callBtn addTarget:self action:@selector(call:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:callBtn];
   
       
        [self.view addSubview:view];
        
    }
    
    
    [self.view addSubview:self.pickerView];
}
- (void)zhiHui:(UIButton *)btn{
    
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    Person *p;
    NSString *str = @"智慧小区";
    // 存储数据
    [userinfo setObject:str forKey:@"community_name"];
//    [userinfo setObject:@"70" forKey:@"community_id"];//测试
    [userinfo setObject:@"66" forKey:@"community_id"];//线上
    [userinfo setObject:p.is_new forKey:@"is_new"];
    // 立刻同步
    [userinfo synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changetitle" object:nil userInfo:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
- (void)call:(UIButton *)btn{
    
    NSString *telStr = @"0354-535355";
    UIAlertController*alert = [UIAlertController
                               alertControllerWithTitle: @"客服电话"
                               message: telStr
                               preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction
                      actionWithTitle:@"取消"
                      style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                      {
                          
                      }]];
    [alert addAction:[UIAlertAction
                      actionWithTitle:@"拨打"
                      style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                      {
                          NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",telStr];
                          UIWebView *callWebview = [[UIWebView alloc] init];
                          [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                          [self.view addSubview:callWebview];
                      }]];
    //弹出提示框
    [self presentViewController:alert
                       animated:YES completion:nil];
}

#pragma mark - UITableView -
//section的titleHeader
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.indexArray objectAtIndex:section];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"  ";
}
//section行数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.indexArray count];
}
//每组section个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.letterResultArr objectAtIndex:section] count];
}
//section右侧index数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.indexArray;
}
//点击右侧索引表项时调用 索引与section的对应关系
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index;
}
//返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    
    Person *p = [[self.letterResultArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = p.name;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    Person *p = [[_letterResultArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString *str = p.name;
    
    if ([userinfo objectForKey:@"community_name"]==nil){
        //初始化警告框
        UIAlertController*alert = [UIAlertController
                                   alertControllerWithTitle: @"提示"
                                   message: @"选择小区后，仅显示本小区的商品和购物车信息，首页顶部可重新选择小区"
                                   preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction
                          actionWithTitle:@"取消"
                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                          {
                              
                          }]];
        [alert addAction:[UIAlertAction
                          actionWithTitle:@"确定"
                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                          {
                              AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                              manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
                              NSString *url = @"http://test.hui-shenghuo.cn/apk41/config/config";
                              
                              NSDictionary *dict = [[NSDictionary alloc] init];
                              int c_id = [p.id intValue];
                              NSLog(@"c_id = %d",c_id);
                              dict = @{@"community_id":p.id};
                              
                              NSLog(@"dict--%@",dict);
                              [manager POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                  
                                  int status = [responseObject[@"status"] intValue];
                                  if (status == 1) {
                                      
                                      NSLog(@"域名 == %@",responseObject);
                                      NSString *url1 = @"";
                                      NSString *url2 = @"/apk41/";
                                      NSString *url3 = responseObject[@"data"][@"hui_domain_name"];
                                      NSString *url4 = [url1 stringByAppendingString:url3];
                                      NSString *huiDomainName = [url4 stringByAppendingString:url2];
                                      NSLog(@"AppDelegate慧生活 == %@",huiDomainName);
                                      NSString *huiDomainName1 = [url1 stringByAppendingString:url3];
                                      NSLog(@"AppDelegatehuiDomainName1 == %@",huiDomainName1);
                                      // 存储数据
                                      [userinfo setObject:huiDomainName forKey:@"API"];
                                      [userinfo setObject:huiDomainName1 forKey:@"API_NOAPK"];
                                      [userinfo setObject:str forKey:@"community_name"];
                                      [userinfo setObject:p.id forKey:@"community_id"];
                                      [userinfo setObject:p.is_new forKey:@"is_new"];
                                      // 立刻同步
                                      [userinfo synchronize];
                                      
                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"change" object:nil userInfo:nil];
                                      [self.navigationController popToRootViewControllerAnimated:YES];
                                      
                                  }
                                  
                              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                  
                                  NSLog(@"failure--%@",error);
                              }];
                          }]];
        //弹出提示框
        [self presentViewController:alert
                           animated:YES completion:nil];
    }else{
        UIAlertController*alert = [UIAlertController
                                   alertControllerWithTitle: @"提示"
                                   message: @"选择小区后，仅显示本小区的商品和购物车信息，首页顶部可重新选择小区"
                                   preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction
                          actionWithTitle:@"取消"
                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                          {
                              
                          }]];
        [alert addAction:[UIAlertAction
                          actionWithTitle:@"确定"
                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                          {
                              
                              AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                              manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
                              NSString *url = @"http://test.hui-shenghuo.cn/apk41/config/config";
                              
                              NSDictionary *dict = [[NSDictionary alloc] init];
                              int c_id = [p.id intValue];
                              NSLog(@"c_id = %d",c_id);
                              dict = @{@"community_id":p.id};
                              
                              NSLog(@"dict--%@",dict);
                              [manager POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                  
                                  int status = [responseObject[@"status"] intValue];
                                  if (status == 1) {
                                      
                                      NSLog(@"域名 == %@",responseObject);
                                      NSString *url1 = @"";
                                      NSString *url2 = @"/apk41/";
                                      NSString *url3 = responseObject[@"data"][@"hui_domain_name"];
                                      NSString *url4 = [url1 stringByAppendingString:url3];
                                      NSString *huiDomainName = [url4 stringByAppendingString:url2];
                                      NSLog(@"AppDelegate慧生活 == %@",huiDomainName);
                                      NSString *huiDomainName1 = [url1 stringByAppendingString:url3];
                                      NSLog(@"AppDelegatehuiDomainName1 == %@",huiDomainName1);
                                      // 存储数据
                                      [userinfo setObject:huiDomainName forKey:@"API"];
                                      [userinfo setObject:huiDomainName1 forKey:@"API_NOAPK"];
                                      [userinfo setObject:str forKey:@"community_name"];
                                      [userinfo setObject:p.id forKey:@"community_id"];
                                      [userinfo setObject:p.is_new forKey:@"is_new"];
                                      // 立刻同步
                                      [userinfo synchronize];
                                      
                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"changetitle" object:nil userInfo:nil];
                                      [self.navigationController popToRootViewControllerAnimated:YES];
                                      
                                  }
                                  
                              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                  
                                  NSLog(@"failure--%@",error);
                              }];
                          }]];
        //弹出提示框
        [self presentViewController:alert
                           animated:YES completion:nil];
    }
    
}

-(void)postaaaa{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSString *dw = @"http://m.hui-shenghuo.cn/apk41/";
    NSString *url = [dw stringByAppendingString:@"site/getCommunityByCity"];
    NSDictionary *dict = [[NSDictionary alloc] init];
    dict = @{@"region_name":location_region_name};
    
    NSLog(@"dict--%@",dict);
    [manager POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
                _Dataarr = [[NSMutableArray alloc] initWithCapacity:0];
                arr = [[NSMutableArray alloc] init];
                arr = [[responseObject objectForKey:@"data"] objectForKey:@"community_list"];
                for (int i = 0; i<[arr count]; i++) {
                    Person *p = [[Person alloc] init];
                    p.name = [[arr objectAtIndex:i] objectForKey:@"name"];
                    p.city_id = [[arr objectAtIndex:i] objectForKey:@"city_id"];
                    p.region_id = [[arr objectAtIndex:i] objectForKey:@"region_id"];
                    p.id = [[arr objectAtIndex:i] objectForKey:@"id"];
                    p.is_new = [[arr objectAtIndex:i] objectForKey:@"is_new"];
                    [_Dataarr addObject:p];
                }
                //根据Person对象的 name 属性 按中文 对 Person数组 排序
                self.indexArray = [BMChineseSort IndexWithArray:_Dataarr Key:@"name"];
                self.letterResultArr = [BMChineseSort sortObjectArray:_Dataarr Key:@"name"];
                [_Tableview reloadData];
        NSLog(@"location--%@--%@",[responseObject class],responseObject);
         [self createtableview];
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
