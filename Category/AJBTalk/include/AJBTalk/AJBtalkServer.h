//
//  AJBtalkServer.h
//  statice
//
//  Created by anjubao on 15/12/16.
//  Copyright © 2015年 anjubao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"


//设置服务器
@interface AJBtalkServer : NSObject

//创建单例
singleton_h(TalkServer);


/* 音视频转发服务器地址 **/
@property (nonatomic,strong) NSString *videoAudioServerAddr;

/// 视频端口
@property (nonatomic,readwrite) NSInteger videoPort;

/* 音频端口 **/
@property (nonatomic,readwrite) NSInteger audioPort;


//先设置上面的地址参数 再开启
-(void)startClient:(NSString *)userCommunity anduserBuildNO:(NSString *)userBuildNO anduserRoomNO:(NSString *)userRoomNO options:(NSDictionary *)launchOptions;

@end

