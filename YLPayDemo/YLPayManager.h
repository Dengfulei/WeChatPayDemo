//
//  YLPayManager.h
//  YLPayDemo
//
//  Created by 杭州移领 on 16/12/28.
//  Copyright © 2016年 DFL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "WechatAuthSDK.h"

@protocol YLPayManagerDelegate <NSObject>

@optional

- (void)managerPayBaseReqErrCode:(NSInteger)errCode;

- (void)managerDidRecvGetMessageReq:(GetMessageFromWXReq *)request;

- (void)managerDidRecvShowMessageReq:(ShowMessageFromWXReq *)request;

- (void)managerDidRecvLaunchFromWXReq:(LaunchFromWXReq *)request;

- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response;

- (void)managerDidRecvAuthResponse:(SendAuthResp *)response;

- (void)managerDidRecvAddCardResponse:(AddCardToWXCardPackageResp *)response;

@end

@interface YLPayManager : NSObject <WXApiDelegate>

@property (nonatomic, assign) id<YLPayManagerDelegate> delegate;

+ (instancetype)sharedManager;
/**
   注册appid

 @param appid appID
 @param appdesc 描述
 */
- (void)registerApp:(NSString *)appid withDescription:(NSString *)appdesc;

#warning 微信支付需要实现下面两个方法
// api 适配ios 9.0+
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options;

@end
