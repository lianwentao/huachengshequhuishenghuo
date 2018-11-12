//
//  openDoorViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/3/23.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "openDoorViewController.h"
#import <AFNetworking.h>
#import "AJBDoor.h"
#import "CoreBluetooth/CoreBluetooth.h"
#import "MBProgressHUD+TVAssistant.h"
#import "showerweimaViewController.h"
#import "fangkejiluViewController.h"

#import "AJBtalkServer.h"

#define SEUDID [CBUUID UUIDWithString:@"FFF0"] /// 服务的唯一标识符
#define ReUDID [CBUUID UUIDWithString:@"FFF1"] /// 读端的唯一标识符
#define WRUDID [CBUUID UUIDWithString:@"FFF2"] /// 写端的唯一标识符
@interface openDoorViewController ()<AJBBlueOpenDoorDataDelegate,CBCentralManagerDelegate,CBPeripheralDelegate,AJBCustomCodeDataDelegate,AJBPassRecodeDataDelegate,AJBOwnerQRDataDelegate>
{
    UILabel *passwordlabel;
    NSDictionary *_dic;
}

@property(nonatomic , strong) NSString * comNum;
@property(nonatomic , strong) NSString * BulNum;
@property(nonatomic , strong) NSString * romNum;


//
/* 蓝牙开门数据管理对象 **/
@property (nonatomic,strong) AJBBlueOpenDoorData *BlueData;
/* 开门数据 **/
@property (nonatomic,strong) NSArray *keys;
/* 蓝牙相关 **/
@property(nonatomic,strong) CBCentralManager *manager;
@property(nonatomic,strong) CBPeripheral *mPeripheral;
@property(nonatomic,strong) CBCharacteristic *readCh;
@property(nonatomic,strong) CBCharacteristic *writeCh;

///是否已经连接上了设备，标识程序的期望，与实际是否连接无关 用于判断突然断开时判断是否需要连接
@property(nonatomic,readwrite)BOOL isConnected;





/* 业主开门数据对象 **/
@property (nonatomic,strong) AJBCustomCodeData *customData;
/* 访客记录 **/
@property (nonatomic,strong) AJBPassRecodeData *passRecodeData;


/* 业主开门数据对象 **/
@property (nonatomic,strong) AJBOwnerQRData *ownerData;

@end

@implementation openDoorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"开门";
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self getData];
    
    NSArray *titlearr = @[@"蓝牙开门",@"业主二维码开门",@"访客二维码开门",@"通行证开门",@"记录"];
    for (int i=0; i<5; i++) {
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(100, 100+65*i, 150, 50);
        [but setTitle:[titlearr objectAtIndex:i] forState:UIControlStateNormal];
        but.tag = i;
        but.backgroundColor = [UIColor blueColor];
        [but addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
        //[self.view addSubview:but];
    }
    passwordlabel = [[UILabel alloc] initWithFrame:CGRectMake(100, Main_Height-250, Main_width-200, 250)];
    passwordlabel.textColor = [UIColor blackColor];
    passwordlabel.textAlignment = NSTextAlignmentCenter;
    
    //[self.view addSubview:passwordlabel];
    
//    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, RECTSTATUS.size.height+44, Main_width, Main_Height-(RECTSTATUS.size.height+44))];
//    [self.view addSubview:scrollview];
//
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Main_width, 0)];
//    label.numberOfLines = 0;
//    label.text = [NSString stringWithFormat:@"%@",_dict];
//    label.backgroundColor = BackColor;
//    CGSize size = [label sizeThatFits:CGSizeMake(label.frame.size.width, MAXFLOAT)];
//    label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, size.width,  size.height);
//    [label setFont:font15];
//
//    [scrollview addSubview:label];
//
//    scrollview.contentSize = CGSizeMake(Main_width, size.height);
    if ([_dict isKindOfClass:[NSDictionary class]]) {
        [self talk];
        
    }else{
        
    }
    if ([_jpushstring isEqualToString:@"jpush"]) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    }
    // Do any additional setup after loading the view.
}
- (void)back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void)talk{
    NSDictionary *dic = [_dict objectForKey:@"extras"];
    
    NSString *str1 = [dic objectForKey:@"address"];
    //NSString *str1 = @"47.104.92.9,6080,9090";
    NSArray *strarray = [str1 componentsSeparatedByString:@","];
    NSString *address = [strarray objectAtIndex:0];
    long videoport = [[strarray objectAtIndex:1] integerValue];
    long audioport = [[strarray objectAtIndex:2] integerValue];
    
    NSString *str2 = [NSString stringWithFormat:@"%@",[dic objectForKey:@"targetHouseNo"]];
    //NSString *str2 = @"99905901020101";
    NSString *comnum =  [str2 substringWithRange:NSMakeRange(0,6)];
    NSString *bulnum = [str2 substringWithRange:NSMakeRange(6, 4)];
    NSString *romnum = [str2 substringWithRange:NSMakeRange(10, 4)];
    
    passwordlabel.text = [NSString stringWithFormat:@"%@\n%@",str1,str2];
    /// 1.设置云对讲服务器的地址和端口 可以在云对讲服务器推送来的消息体获取
    [AJBtalkServer sharedTalkServer].videoAudioServerAddr = address;
    [AJBtalkServer sharedTalkServer].videoPort = videoport;
    [AJBtalkServer sharedTalkServer].audioPort = audioport;
    
    NSLog(@"%@--%@--%@--%@",strarray,comnum,bulnum,romnum);
    
    /// 2.设置房号
    self.comNum = comnum;    /// 6为小区号
    self.BulNum = bulnum;      /// 4位楼栋号
    self.romNum = romnum;      /// 4位房间号
    
    /// 3.启动云对讲
    [[AJBtalkServer sharedTalkServer]startClient:self.comNum anduserBuildNO:self.BulNum anduserRoomNO:self.romNum options:nil];
    
    
    
    
    /*
     对讲消息体如下
     
     {
     "_j_msgid" = 3419029301;
     address = "120.76.65.48,6081,9091";
     aps =     {
     alert = Calling;
     badge = 1;
     sound = "dingdong.caf";
     };
     targetHouseNo = 00001005014444;
     }
     
     其中address字段对应内容，120.76.65.48为音视频转发服务器，6081为视频端口，9091为音频端口。
     
     */
}
- (void)getData
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSDictionary *dict = @{@"room_id":@"19222"};//19222
    NSString *strurl = [API stringByAppendingString:@"property/checkIsAjb"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"---%@--%@",responseObject,[responseObject objectForKey:@"msg"]);
        _dic = [[NSDictionary alloc] init];
        
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            _dic = [responseObject objectForKey:@"data"];
        }else{
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
- (void)buttonclick:(UIButton *)sender
{
    NSString *mobile = [_dic objectForKey:@"mobile"];
    NSString *community = [_dic objectForKey:@"community"];
    NSString *room = [NSString stringWithFormat:@"%@%@",[_dic objectForKey:@"building"],[_dic objectForKey:@"room_code"]];
    NSLog(@"%@--%@--%@",mobile,community,room);
    if (sender.tag==0) {
        [self jiazaishuju];
    }else if (sender.tag==1){
        [self.ownerData RequestDataWithUserId:mobile estatecode:community housecode:room];
    }else if (sender.tag==2){
        [self.customData RequestQRDataWithUserId:mobile estatecode:community housecode:room guestName:@"黑河"];
    }else if (sender.tag==3){
        [self.customData RequestTemPassDataWithUserId:mobile estatecode:community housecode:room guestName:@"黑河"];
    }else{
        [self.passRecodeData RequestDataWithUserId:mobile estatecode:community housecode:room];
    }
}

#pragma mark - 业主二维码开门
#pragma mark -  AJBOwnerQRDataDelegate

/// 加载数据成功 keys 是数据数组
- (void)AJBOwnerQRDataDidLoadData:(NSDictionary *)key{
    NSLog(@"二维码信息 : %@  有效时间 : %@ 分钟",key[@"tempass"],key[@"valiateTime"]);
    [MBProgressHUD showToastToView:self.view withText:[NSString stringWithFormat:@"%@",key]];
    showerweimaViewController *erweima = [[showerweimaViewController alloc] init];
    erweima.erweimaxinxi = [key objectForKey:@"tempass"];
    [self.navigationController pushViewController:erweima animated:YES];
}

/// 加载数据失败 Msg  是错误信息
- (void)AJBOwnerQRDataDidFailLoadData:(NSString *)Msg{
    NSLog(@"Msg : %@",Msg);
    [MBProgressHUD showToastToView:self.view withText:[NSString stringWithFormat:@"%@",Msg]];
}

- (AJBOwnerQRData *)ownerData{
    if (!_ownerData) {
        _ownerData = [[AJBOwnerQRData alloc]initWithHost:@"http://47.104.92.9" Port:8080];
        _ownerData.delegate = self;
    }
    return _ownerData;
}
#pragma mark - 访客二维码和通行证和记录
#pragma mark - AJBCustomCodeDataDelegate
/// 加载数据成功 key 是数据
- (void)AJBCustomCodeDataDidLoadData:(NSDictionary *)dict{
    NSLog(@"--------key:%@",dict);
    NSString *str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"isQRorTP"]];
    if ([str isEqualToString:@"1"]) {
        [MBProgressHUD showToastToView:self.view withText:[dict objectForKey:@"tempPass"]];
        passwordlabel.text = [dict objectForKey:@"tempPass"];
    }else{
        showerweimaViewController *erweima = [[showerweimaViewController alloc] init];
        erweima.erweimaxinxi = [dict objectForKey:@"tempPass"];
        [self.navigationController pushViewController:erweima animated:YES];
    }
}
#pragma mark - AJBPassRecodeDataDelegate

/// 加载数据成功 keys 是数据数组
- (void)AJBPassRecodeDataDidLoadData:(NSArray *)keys{
    NSLog(@"keys:%@",keys);
    fangkejiluViewController *fangke = [[fangkejiluViewController alloc] init];
    fangke.KeysArr = keys;
    [self.navigationController pushViewController:fangke animated:YES];
}

/// 加载数据失败 Msg  是错误信息
- (void)AJBPassRecodeDataDidFailLoadData:(NSString *)Msg{
    NSLog(@"Msg:%@",Msg);
}
#pragma mark -  set && get

- (AJBCustomCodeData *)customData{
    if (!_customData) {
        _customData = [[AJBCustomCodeData alloc] initWithHost:@"http://47.104.92.9" Port:8080];
        _customData.delegate = self;
    }
    return _customData;
}

- (AJBPassRecodeData *)passRecodeData{
    if (!_passRecodeData) {
        _passRecodeData = [[AJBPassRecodeData alloc] initWithHost:@"http://47.104.92.9" Port:8080];
        _passRecodeData.delegate = self;
    }
    return _passRecodeData;
}
/// 加载数据失败 Msg  是错误信息
- (void)AJBCustomCodeDataDidFailLoadData:(NSString *)Msg{
    NSLog(@"Msg:%@",Msg);
}

#pragma mark - 蓝牙开门
- (void)jiazaishuju
{
    // 1.实例化
        //self.BlueData = [[AJBBlueOpenDoorData alloc] initWithHost:@"http://10.30.30.11" Port:8080];
    self.BlueData = [[AJBBlueOpenDoorData alloc] initWithHost:@"http://47.104.92.9" Port:8080];

    /// 2.设置代理
    self.BlueData.delegate = self;
    NSString *room = [NSString stringWithFormat:@"%@%@%@",[_dic objectForKey:@"community"],[_dic objectForKey:@"building"],[_dic objectForKey:@"room_code"]];
    NSString *roomcode = [NSString stringWithFormat:@"%@00",room];
    /// 3.请求数据
    [self.BlueData RequestData:@[roomcode]];
}
#pragma mark - AJBBlueOpenDoorDataDelegate

/// 加载蓝牙开门数据成功 keys 是数据数组
- (void)AJBBlueOpenDoorDidLoadData:(NSArray *)keys{
    NSLog(@"keys:%@",keys);
    [MBProgressHUD showToastToView:self.view withText:[NSString stringWithFormat:@"%@",keys]];
    self.keys = keys;
    [self connect];
}

/// 加载蓝牙开门数据失败 Msg  是错误信息
- (void)AJBBlueOpenDoorDidFailLoadData:(NSString *)Msg{
    NSLog(@"Msg:%@",Msg);
    [MBProgressHUD showToastToView:self.view withText:[NSString stringWithFormat:@"%@",Msg]];
}
/**
 *  2.连接设备
 */
-(void)connect{
    _manager = nil;
    _mPeripheral = nil;
    _manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

/**
 *  3.发送数据到设备
 *
 */
-(void)sendDate{
    
    /// 做发送前的判断
    if (_mPeripheral.state != CBPeripheralStateConnected) {
        //处于正在连接或者断开连接状态
        NSLog(@"处于正在连接或者断开连接状态");
        [MBProgressHUD showToastToView:self.view withText:@"处于正在连接或者断开连接状态"];
        _isConnected = NO;
        return ;
    }
    
    /// 订阅通知
    if (_mPeripheral) {
        [_mPeripheral setNotifyValue:YES forCharacteristic:_readCh];
    }
    
    /// 发送数据
    for (NSData *senddata in self.keys) {
        if (_writeCh && _mPeripheral) {
            [_mPeripheral writeValue:senddata forCharacteristic:_writeCh type:CBCharacteristicWriteWithResponse];
        }
    }
    
    return ;
}

/**
 *  4.断开连接
 */
-(void)disConnect{
    _isConnected = NO;
    if (_mPeripheral) {
        [_manager cancelPeripheralConnection:_mPeripheral];
        NSLog(@"主动断开");
        [MBProgressHUD showToastToView:self.view withText:@"主动断开"];
    }
    
}

#pragma mark - CBCentralManager 代理方法

/**
 *  中心设备的状态更新
 *
 *  @param central 中心设备的状态更新
 */
-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state){
        case CBCentralManagerStateUnsupported:
            NSLog(@"您的设备不支持蓝牙或蓝牙4.0");
            [MBProgressHUD showToastToView:self.view withText:@"您的设备不支持蓝牙或蓝牙4.0"];
            break;
        case CBCentralManagerStatePoweredOff://蓝牙未打开，系统会自动提示打开，所以不用自行提示
            NSLog(@"蓝牙未打开,请打开蓝牙");
            [MBProgressHUD showToastToView:self.view withText:@"蓝牙未打开,请打开蓝牙"];
            break;
        case CBCentralManagerStatePoweredOn:
            NSLog(@"蓝牙已打开,可扫描外设");
            [MBProgressHUD showToastToView:self.view withText:@"蓝牙已打开,可扫描外设"];
            [self scan];//扫描
            break;
            
        case CBCentralManagerStateUnauthorized:
            NSLog(@"未授权");
            [MBProgressHUD showToastToView:self.view withText:@"未授权"];
            break;
            
        default:
            break;
    }
}

/**
 *  扫描外设
 */
-(void)scan{
    NSLog(@"开始扫描外设。。");
    [MBProgressHUD showToastToView:self.view withText:@"开始扫描外设。。"];
    NSArray *serverlist = [[NSArray alloc]initWithObjects:SEUDID,nil];
    [_manager scanForPeripheralsWithServices:serverlist  options:nil];
}

/**
 *  发现到设备
 *
 *  @param central           central
 *  @param peripheral        已连接的peripheral
 *  @param advertisementData advertisementData
 *  @param RSSI              信号强度
 */
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    
    if ([peripheral.name isEqualToString:@"Keyfobdemo"] || [peripheral.name isEqualToString:@"AjbBle"]) {
        NSLog(@"发现目标设备");
        [MBProgressHUD showToastToView:self.view withText:@"发现目标设备"];
        [central stopScan];
        _mPeripheral = peripheral;
        _mPeripheral.delegate = self;
        [_manager connectPeripheral:_mPeripheral options:nil];
    }
    return ;
}

#pragma mark - CBPeripheral 代理方法

/**
 *  已经连接上设备
 *
 *  @param central    central
 *  @param peripheral peripheral
 */
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    
    NSLog(@"连接成功");
    [MBProgressHUD showToastToView:self.view withText:@"连接成功"];
    _mPeripheral = peripheral;
    _mPeripheral.delegate = self;
    
    
    
    
    //查找服务
    _readCh = nil;
    _writeCh = nil;
    [_mPeripheral discoverServices:@[SEUDID]];
    
    
    
}

/**
 *  连接外围设备失败
 *
 *  @return void
 */
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"连接外围设备失败!");
    [MBProgressHUD showToastToView:self.view withText:@"连接外围设备失败!"];
}

/**
 *  成功查找到服务
 *
 *  @param peripheral peripheral
 *  @param error      error
 */
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    NSLog(@"已发现可用服务...");
    [MBProgressHUD showToastToView:self.view withText:@"已发现可用服务..."];
    if(error){
        NSLog(@"外围设备寻找服务过程中发生错误，错误信息：%@",error.localizedDescription);
        [MBProgressHUD showToastToView:self.view withText:@"外围设备寻找服务过程中发生错误"];
    }
    //遍历查找到的服务
    for (CBService *service in peripheral.services) {
        if([service.UUID isEqual:SEUDID]){
            //外围设备查找指定服务中的特征
            [peripheral discoverCharacteristics:@[ReUDID,WRUDID] forService:service];
        }
    }
}


/**
 *  外围设备查找到特征
 *
 *  @param peripheral peripheral
 *  @param service    service
 *  @param error      error
 */
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    
    NSLog(@"已发现可用特征...");
    if (error) {
        NSLog(@"外围设备寻找特征过程中发生错误，错误信息：%@",error.localizedDescription);
        
    }
    if ([service.UUID isEqual:SEUDID]) {
        for (CBCharacteristic *characteristic in service.characteristics) {
            if ([characteristic.UUID isEqual:ReUDID]) {
                _readCh = characteristic;
            }
            if ([characteristic.UUID isEqual:WRUDID]) {
                _writeCh = characteristic;
            }
            if (_writeCh && _readCh) {
                //此处可以发送数据
                NSLog(@"可以发送数据");
                self.isConnected = YES;
                                [self sendDate];
            }
        }
    }
    
}


- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    NSLog(@"已经写入数据");
}


- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error{
    
    NSLog(@"接收设备信息");
    
    /// 过滤掉干扰的数据
    if (!characteristic.isNotifying) {
        NSLog(@"订阅的标志位不正确");
        [MBProgressHUD showToastToView:self.view withText:@"订阅的标志位不正确"];
        return;
    }
    
    Byte *testByte = (Byte *)[characteristic.value bytes];
    
    /// 过滤掉干扰的数据
    if (testByte == nil) {
        
        return ;
    }
    
    NSLog(@"开锁状态：%hhu",testByte[2]);
    if (testByte[2] == 0x01) {
        //开门成功
        NSLog(@"开门成功");
        [MBProgressHUD showToastToView:self.view withText:[NSString stringWithFormat:@"开锁状态：%hhu",testByte[2]]];
    }
    else{
        //开门失败
        NSLog(@"开门失败");
        [MBProgressHUD showToastToView:self.view withText:[NSString stringWithFormat:@"开锁状态：%hhu",testByte[2]]];
    }
    return ;
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    if (_isConnected) {
        //此处需要重新连接
        [self connect];
    }
    _manager = nil;
    _mPeripheral = nil;
    NSLog(@"已经断开与设备间的连接");
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
