//
//  YLHttpManager.h
//  YLPayDemo
//
//  Created by 杭州移领 on 16/12/28.
//  Copyright © 2016年 DFL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@interface YLHttpManager : NSObject

/**
 调用同意支付

 @param url 同意支付的域名 https://api.mch.weixin.qq.com/pay/unifiedorder
 @param xml xml格式字符串
 @param success <#success description#>
 @param failure <#failure description#>
 */
+ (void)YLWetChatPay:(NSString *)url
                 xml:(id)xml
             success:(void (^) (id responseObject))success
             failure:(void (^) (NSError *error))failure;
@end
