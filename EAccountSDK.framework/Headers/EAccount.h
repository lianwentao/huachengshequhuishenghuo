//
//  EAccount.h

/*
 修订历史：2017、04、26
 删除旧的网关认证接口:gatewayLoginOnly
 修改打开免密登录页面接口的参数。
 */

/*
 SDK说明：
 SDk_Version: 3.1.0
 一些特别说明：凡是涉及到页面操作的接口，请保证在主线程中调用，SDK也保证在主线程中返回
 不涉及到页面操作的接口，SDK会开子线程去处理，不保证在主线程中返回。
 适配系统版本：最低iOS7，最高iOS10.3
 */

/*
 SDK_Version: 3.1.6
 wap页面加载超时设置为30秒.
 添加对使用-force_load接入方式的兼容
 */

/*
 SDK_Version: 3.1.9
 优化网关认证逻辑，提供认证成功率。
 解决一些内部逻辑错误。
 */

/*
 SDK_Version: 3.2.0
 更新日期：2017、12、14
 优化免密登录逻辑。
 添加预判断接口：canGetMobile。
 删除获取用户信息接口，
 删除通用请求接口
 添加获取我的页面的cookie的接口
 */

/*
 SDK_Version: 3.2.1
 更新日期：2018、01、31
 优化免密登录页面显示，突出免密登录。
 添加预判断接口的主动调用预判断机制，如果接入方没调用，SDK打开页面前会主动调用。
 解决一些已知的bug.
 */


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN


typedef   void (^successHandler) ( NSDictionary * _Nullable  resultDic);

typedef   void (^failureHandler) ( NSError * _Nullable  error);

typedef NS_OPTIONS (NSInteger, ThirdLoginType) {
    ThirdLoginDefaultLogin = 0,       //
    ThirdLoginQQLogin = 1 << 1,      //QQ登录
    ThirdLoginWeiXinLogin = 1 << 2, //微信登录
    ThirdLoginWeiboLogin = 1 << 3   //微博登录
};


@interface EAccount : NSObject

/*
 @description 获取当前设备的设备id
 
 @return deviceId(）
 */
@property (NS_NONATOMIC_IOSONLY, getter=getCurrentDeviceId, readonly, copy) NSString * _Nonnull currentDeviceId;

/**
 初始化SDK

 @param appKey 接入方在账号平台领取的appKey
 @param appSecrect 接入方在账号平台领取的appSecrect
 @param appName 接入方在账号平台领取的appName
 */
+ (void)initWithSelfKey:(NSString *)appKey
                      appSecret:(NSString *)appSecrect
                        appName:(NSString *)appName;


#pragma mark - 登录相关接口

/**
 打开登录页面
 @param thirdLogin 第三方登录的配置，有qq，微博，微信三个，要哪个登录方式，就传对应的拼音，如@"qq" 或者@"qq|weixin" 或者@"qq|weixin|weibo"，
 @param loginWay 登录方式，zm、dm、zm|dm、dm|zm等4种方式，zm代表账号密码登录，dm，代表短信验证码登录，zm|dm代表两种都有，并且优先账号密码登录, dm|zm代表两种都有，优先短信登录
 @param accountType 账号类型，有mobile,email两种，两种都要的话，传@"mobile|email"，否则传@"mobile" 或者@"email"
 @param loginList 已经登录上的账号的accessToken组成的数组，不需要多账号功能的，可以传一个空的数组
 @param hasat 登录页面的登录账号是否默认加上@189.cn，yes表示有后缀，no表示没有后缀
 @param hideTop 是否隐藏头部导航栏
 @param baseApp 自定义账号入口方式
 @param basicLoginTxt 自定义账号入口方式的自定义文本 （6到8个字符）
 @param controller 可以为nil，如果是nil，SDK会新建一/Users/thy/TY/EAccountSDK_WIFI/EAccountSDK/EAccountSDK/EAccount.h个window来加载登录页面，如果不是空，SDK会使用controller来preszent登录页面。
 @param success 登录成功的回调
 @param failure 登录失败的回调
 */
+ (void)login:(ThirdLoginType)thirdLogin
     loginWay:(NSString *)loginWay
  accountType:(NSString *)accountType  //
    loginList:(NSArray *)loginList
         hasat:(BOOL)hasat
      hideTop:(BOOL)hideTop
      baseApp:(BOOL)baseApp
basicLoginTxt:(NSString *)basicLoginTxt
   controller:(nullable UIViewController *)controller
      success:(successHandler)success
      failure:(failureHandler)failure;

/**
 打开登录页面
 @param thirdLogin 第三方登录的配置，有qq，微博，微信三个，要哪个登录方式，就传对应的拼音，如@"qq" 或者@"qq|weixin" 或者@"qq|weixin|weibo"
 @param loginWay 登录方式，zm、dm、zm|dm、dm|zm等4种方式，zm代表账号密码登录，dm，代表短信验证码登录，zm|dm代表两种都有，并且优先账号密码登录, dm|zm代表两种都有，优先短信登录
 @param accountType 账号类型，有mobile,email两种，两种都要的话，传@"mobile|email"，否则传@"mobile" 或者@"email"
 @param loginList 已经登录上的账号的accessToken组成的数组，不需要多账号功能的，可以传一个空的数组
 @param hasat 登录页面的登录账号是否默认加上@189.cn，yes表示有后缀，no表示没有后缀
 @param hideTop 是否隐藏头部导航栏
 @param baseApp 自定义账号入口方式
 @param basicLoginTxt 自定义账号入口方式的自定义文本 （6到8个字符）
 @param controller 可以为nil，如果是nil，SDK会新建一/Users/thy/TY/EAccountSDK_WIFI/EAccountSDK/EAccountSDK/EAccount.h个window来加载登录页面，如果不是空，SDK会使用controller来preszent登录页面。
 @param loginMode Token过期登录账号原来的登陆类型 0 免密,1 短密，2 账密
 @param modifyAccount 账号可否被修改，true/false， 必填
 @param tokenAccount Token过期登录账号，例如：18988886666或者别名账号，必填
 @param tokenOpenId token过期账号对应的openId，必填。
 @param success 登录成功的回调
 @param failure 登录失败的回调
 */

+ (void)login:(ThirdLoginType)thirdLogin
     loginWay:(NSString *)loginWay
  accountType:(NSString *)accountType  //
    loginList:(NSArray *)loginList
        hasat:(BOOL)hasat
      hideTop:(BOOL)hideTop
      baseApp:(BOOL)baseApp
basicLoginTxt:(NSString *)basicLoginTxt
   controller:(nullable UIViewController *)controller
   loginMode:(NSString *)loginMode
modifyAccount:(BOOL)modifyAccount
 tokenAccount:(NSString *)tokenAccount
  tokenOpenId:(NSString *)tokenOpenId
      success:(successHandler)success
      failure:(failureHandler)failure;





+ (void)authWithCustomWebAddress:(NSString *)getMobileURLStr webView:(UIWebView *)webview success:(successHandler)completion failure:(failureHandler)fail;

/**
 获取取号/号码验证的code

 @param bussinessType 业务类型，取号（传@"qh"）或者号码校验(传@"jy")，
 @param completion 成功的返回
 @param fail 失败的返回
 */
+ (void)getMobileAccessCode:(NSString *)bussinessType  success:(successHandler)completion failure:(failureHandler)fail;



/**
扫码 在webview中加载url
 
 @param urlStr url
 @param controller 用来push的controller
 //7008 返回
 //7009 取消
 
 */
+ (void)loadUuid:(nonnull NSString *)urlStr withToken:(NSString *)token controller:(nonnull UIViewController *)controller success:(nonnull successHandler)success failure:(nonnull failureHandler)failure;

#pragma mark -

/*
 *@description 获取SDK当前的版本号
 */
+ (NSString *)getSDKVersion;

#pragma mark -二次验证相关接口
/*
 @description 设置决定是否检查设备一致性的开关的状态
 @param status 新的状态
 @param accessToken 登录返回的accessToken
 @return 无
 */
+ (void)setDeviceSwitch:(BOOL)status token:(NSString *)accessToken success:(successHandler)success failure:(failureHandler)failure;

/*
 @description 查询决定是否检查设备一致性的开关的状态
 @param accessToken 登录返回的accessToken
 @return 无
 */
+ (void)getDeviceSwitchStatus:(NSString *)accessToken success:(successHandler)success failure:(failureHandler)failure;

/*
 @description 删除用户某一台设备信息
 @param deviceId 要删除设备的deviceId；
 @param accessToken 登录返回的accessToken
 @return 无
 */
+ (void)removeDeviceInfo:(NSString *)deviceId token:(NSString *)accessToken success:(successHandler)success failure:(failureHandler)failure;

/*
 @description 删除用户所有设备信息
 @param accessToken 登录返回的accessToken
 @retun 无；
 */
+ (void)removeDevicesInfo:(NSString *)accessToken success:(successHandler)success failure:(failureHandler)failure;

/*
 @description 查询用户的所有设备信息
 @param accessToken 登录返回的accessToken
 @retun 无；
 */
+ (void)getUserDevicesInfo:(NSString *)accessToken success:(successHandler)success failure:(failureHandler)failure;




#pragma mark - “我的”页面模块功能。
/**
 *@description 打开“我的”页面
  **/
+(void)openMyPage:(NSString *)accessToken controller:(nonnull UIViewController *)controller success:(successHandler)success failure:(failureHandler)failure;

/**
 获取cookie
 
 @param accessToken 用户token
 @param success 成功的回调
 @param failure 失败的回调
 */
+ (void)getMyPageCookie:(NSString*)accessToken
                success:(successHandler)success
                failure:(failureHandler)failure;



#pragma mark - 微信，微博，QQ登录


/**
 *@description 微信登录天翼账号
 *@param weChatToken 微信token
 *@param weChatOpenId 微信openId
 *@param weChatAppId 微信应用的AppId
 **/
+(void)weChatTokenVerify:(NSString *)weChatToken
              withOpenId:(NSString*)weChatOpenId
               withAppId:(NSString*)weChatAppId
              completion:(successHandler)completion
                    fail:(failureHandler)fail;

/**
 *@description 微信登录天翼账号
 *@param weChatCode 微信code
 *@param weChatAppId 微信应用的AppId
 **/
+(void)weChatCodeVerify:(NSString *)weChatCode
              withAppId:(NSString*)weChatAppId
             completion:(successHandler)completion
                   fail:(failureHandler)fail;


/**
 *@description QQ登录天翼账号
 *@param qqToken  token
 **/
+(void)qqTokenVerify:(NSString *)qqToken
          completion:(successHandler)completion
                fail:(failureHandler)fail;


/**
 *@description 微博登录天翼账号
 *@param weiboToken 微博token
 **/
+(void)weiboTokenVerify:(NSString *)weiboToken
             completion:(successHandler)completion
                   fail:(failureHandler)fail;



/**
 接入方调用该接口对用户当前网络环境进行检测，判断该用户是否可以取到免密登录。
 
 @param success 成功的返回
 @param failure 错误的返回
 */
+ (void)canGetMobile:(successHandler)success
               failure:(failureHandler)failure;



@end

NS_ASSUME_NONNULL_END
