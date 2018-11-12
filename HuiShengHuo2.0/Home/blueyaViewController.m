//
//  blueyaViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/4/8.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "blueyaViewController.h"
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
@interface blueyaViewController ()<AJBBlueOpenDoorDataDelegate,CBCentralManagerDelegate,CBPeripheralDelegate,AJBCustomCodeDataDelegate,AJBPassRecodeDataDelegate,AJBOwnerQRDataDelegate>
{
    UILabel *passwordlabel;
    NSDictionary *_dic;
}

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

@property (nonatomic,strong)UIView *testView;
@property (nonatomic,strong)UIView *testView1;
@property (nonatomic,strong)UIBezierPath *path;
@end

@implementation blueyaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"蓝牙开门";
    self.view.backgroundColor = BackColor;
    
    [self setup];
    
    [self jiazaishuju];
    // Do any additional setup after loading the view.
}

- (void)opnedoor
{
    [self.navigationController pushViewController:[openDoorViewController new] animated:YES];
}
- (void)setup
{
//    UIButton *buttt = [UIButton buttonWithType:UIButtonTypeCustom];
//    buttt.frame = CGRectMake(100, 100, 100, 40);
//    buttt.backgroundColor = QIColor;
//    [buttt addTarget:self action:@selector(opnedoor) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:buttt];
    
    _testView=[[UIView alloc] initWithFrame:CGRectMake(Main_width/2-125, Main_Height/2-125, 250, 250)];
    [self.view addSubview:_testView];
    
    UIImageView *img = [[UIImageView alloc] init];
    img.frame = CGRectMake(90+Main_width/2-125, 90+Main_Height/2-125, 70, 70);
    //img.backgroundColor = [UIColor redColor];
    img.image = [UIImage imageNamed:@"btn_ble"];
    [self.view addSubview:img];
    
    _testView.layer.backgroundColor = [UIColor clearColor].CGColor;
    //CAShapeLayer和CAReplicatorLayer都是CALayer的子类
    //CAShapeLayer的实现必须有一个path，可以配合贝塞尔曲线
    CAShapeLayer *pulseLayer = [CAShapeLayer layer];
    pulseLayer.frame = _testView.layer.bounds;
    pulseLayer.path = [UIBezierPath bezierPathWithOvalInRect:pulseLayer.bounds].CGPath;
    pulseLayer.fillColor = HColor(168, 206, 253).CGColor;//填充色
    pulseLayer.opacity = 0.0;
    
    //可以复制layer
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.frame = _testView.bounds;
    replicatorLayer.instanceCount = 6;//创建副本的数量,包括源对象。
    replicatorLayer.instanceDelay = 1;//复制副本之间的延迟
    [replicatorLayer addSublayer:pulseLayer];
    [_testView.layer addSublayer:replicatorLayer];
    
    CABasicAnimation *opacityAnima = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnima.fromValue = @(0.3);
    opacityAnima.toValue = @(0.0);
    
    CABasicAnimation *scaleAnima = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnima.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.0, 0.0, 0.0)];
    scaleAnima.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1.0, 1.0, 0.0)];
    
    CAAnimationGroup *groupAnima = [CAAnimationGroup animation];
    groupAnima.animations = @[opacityAnima, scaleAnima];
    groupAnima.duration = 4.0;
    groupAnima.autoreverses = NO;
    groupAnima.repeatCount = HUGE;
    [pulseLayer addAnimation:groupAnima forKey:@"groupAnimation"];
    
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, _testView.frame.size.height+_testView.frame.origin.y+25, Main_width-100, 0)];
    label.numberOfLines = 0;
    
    NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    // 行间距设置为30
    [paragraphStyle  setLineSpacing:15];
    
    NSString  *testString = @"手机开门只对有此功能的安居宝门口机有效请在设备2米范围内使用";
    NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:testString];
    [setString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [testString length])];
    
    // 设置Label要显示的text
    [label  setAttributedText:setString];
    
    label.textAlignment = NSTextAlignmentCenter;
    [label setFont:font15];
    label.alpha = 0.7;
    CGSize size = [label sizeThatFits:CGSizeMake(label.frame.size.width, MAXFLOAT)];
    label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, size.width,  size.height);
    label.font = font15;
    [self.view addSubview:label];
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake(Main_width/2-50, label.frame.size.height+label.frame.origin.y+30, 100, 35);
    but.layer.masksToBounds = YES;
    but.layer.cornerRadius = 20;
    but.layer.borderWidth = 2;
    but.layer.borderColor = [QIColor CGColor];
    [but setTitle:@"退出" forState:UIControlStateNormal];
    [but setTitleColor:QIColor forState:UIControlStateNormal];
    [but addTarget:self action:@selector(tuichu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];
}

#pragma mark - 蓝牙开门
- (void)jiazaishuju
{
    // 1.实例化
    //self.BlueData = [[AJBBlueOpenDoorData alloc] initWithHost:@"http://10.30.30.11" Port:8080];
    self.BlueData = [[AJBBlueOpenDoorData alloc] initWithHost:@"http://47.104.92.9" Port:8080];
    
    /// 2.设置代理
    self.BlueData.delegate = self;
    NSString *room = [NSString stringWithFormat:@"%@%@%@",[_Dic objectForKey:@"community"],[_Dic objectForKey:@"building"],[_Dic objectForKey:@"room_code"]];
    NSString *roomcode = [NSString stringWithFormat:@"%@00",room];
    /// 3.请求数据
    [self.BlueData RequestData:@[roomcode]];
}
#pragma mark - AJBBlueOpenDoorDataDelegate

/// 加载蓝牙开门数据成功 keys 是数据数组
- (void)AJBBlueOpenDoorDidLoadData:(NSArray *)keys{
    NSLog(@"keys:%@",keys);
    //[MBProgressHUD showToastToView:self.view withText:[NSString stringWithFormat:@"%@",keys]];
    self.keys = keys;
    [self connect];
}

/// 加载蓝牙开门数据失败 Msg  是错误信息
- (void)AJBBlueOpenDoorDidFailLoadData:(NSString *)Msg{
    NSLog(@"Msg:%@",Msg);
    [self.navigationController popViewControllerAnimated:YES];
    //[MBProgressHUD showToastToView:self.view withText:[NSString stringWithFormat:@"%@",Msg]];
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
        //[MBProgressHUD showToastToView:self.view withText:@"处于正在连接或者断开连接状态"];
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
        //[MBProgressHUD showToastToView:self.view withText:@"主动断开"];
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
            //[MBProgressHUD showToastToView:self.view withText:@"您的设备不支持蓝牙或蓝牙4.0"];
            break;
        case CBCentralManagerStatePoweredOff://蓝牙未打开，系统会自动提示打开，所以不用自行提示
            NSLog(@"蓝牙未打开,请打开蓝牙");
            //[MBProgressHUD showToastToView:self.view withText:@"蓝牙未打开,请打开蓝牙"];
            break;
        case CBCentralManagerStatePoweredOn:
            NSLog(@"蓝牙已打开,可扫描外设");
            //[MBProgressHUD showToastToView:self.view withText:@"蓝牙已打开,可扫描外设"];
            [self scan];//扫描
            break;
            
        case CBCentralManagerStateUnauthorized:
            NSLog(@"未授权");
            //[MBProgressHUD showToastToView:self.view withText:@"未授权"];
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
    //[MBProgressHUD showToastToView:self.view withText:@"开始扫描外设。。"];
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
        //[MBProgressHUD showToastToView:self.view withText:@"发现目标设备"];
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
    //[MBProgressHUD showToastToView:self.view withText:@"连接成功"];
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
    //[MBProgressHUD showToastToView:self.view withText:@"连接外围设备失败!"];
}

/**
 *  成功查找到服务
 *
 *  @param peripheral peripheral
 *  @param error      error
 */
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    NSLog(@"已发现可用服务...");
    //[MBProgressHUD showToastToView:self.view withText:@"已发现可用服务..."];
    if(error){
        NSLog(@"外围设备寻找服务过程中发生错误，错误信息：%@",error.localizedDescription);
        //[MBProgressHUD showToastToView:self.view withText:@"外围设备寻找服务过程中发生错误"];
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
        //[MBProgressHUD showToastToView:self.view withText:@"订阅的标志位不正确"];
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
        [self.navigationController popViewControllerAnimated:YES];
        //[MBProgressHUD showToastToView:self.view withText:[NSString stringWithFormat:@"开锁状态：%hhu",testByte[2]]];
    }
    else{
        //开门失败
        NSLog(@"开门失败");
        //[MBProgressHUD showToastToView:self.view withText:[NSString stringWithFormat:@"开锁状态：%hhu",testByte[2]]];
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

- (void)tuichu
{
    [self.navigationController popViewControllerAnimated:YES];
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
