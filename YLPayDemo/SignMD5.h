//
//  SignMD5.h
//  YLPayDemo
//
//  Created by 杭州移领 on 16/12/28.
//  Copyright © 2016年 DFL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignMD5 : NSObject

/**
 Description

 @param appid  应用ID
 @param noce_str  随机字符串
 @param  body 商品描述
 @param out_trade_no  商户订单号
 @param total_fee  总金额
 @param spbill_create_ip  终端IP ,获取本机IP地址，请再wifi环境下测试，否则获取的ip地址为error，正确格式应该是8.8.8.8,可以写成固定格式如spbill_create_ip = @"196.168.1.1"
 @param notify_url   通知回调
 @param trade_type  交易类型
 @return <#return value description#>
 */
-(instancetype)initWithAppid:(NSString *)appid
                      mch_id:(NSString *)mch_id
                   nonce_str:(NSString *)noce_str
                        body:(NSString *)body
                out_trade_no:(NSString *)out_trade_no
                   total_fee:(NSString *)total_fee
            spbill_create_ip:(NSString *)spbill_create_ip                   notify_url:(NSString *)notify_url
                  trade_type:(NSString *)trade_type;



/**
 获取带有 sign的xml字符串
 */
- (NSString *)getXMLString;

/**
 获取MD5签名
 */
- (NSString *)getMD5Sign;

/**
 生成随机字符串
 */
+ (NSString *)generateTradeNO;

/**
 产生随机数
 */
+ (NSString *)getOrderNumber;

/**
  创建发起支付时的MD5签名

 @param appid_key 应用appID
 @param partnerid_key 商户号返回的mch_id
 @param prepayid_key 预支付订单
 @param package_key  商家根据财付通文档填写的数据和签名
 @param noncestr_key 随机串，防重发
 @param timestamp_key 时间戳，防重发
 @return <#return value description#>
 */
-(NSString *)createMD5SingForPay:(NSString *)appid_key
                       partnerid:(NSString *)partnerid_key
                        prepayid:(NSString *)prepayid_key
                         package:(NSString *)package_key
                        noncestr:(NSString *)noncestr_key
                       timestamp:(UInt32)timestamp_key;
@end
