//
//  SignMD5.m
//  YLPayDemo
//
//  Created by 杭州移领 on 16/12/28.
//  Copyright © 2016年 DFL. All rights reserved.
//

#import "SignMD5.h"
#import <CommonCrypto/CommonDigest.h>
/** 商户密匙*/
const NSString *Partner_Key = @"";

@interface SignMD5 ()
/** 应用ID*/
@property (nonatomic,strong) NSString *appid;
/** 商户号*/
@property (nonatomic,strong) NSString *mch_id;
/** 随机字符串*/
@property (nonatomic,strong) NSString *nonce_str;
/** 商品描述*/
@property (nonatomic,strong) NSString *body;
/** 商户订单号*/
@property (nonatomic,strong) NSString *out_trade_no;
/** 总金额*/
@property (nonatomic,strong) NSString *total_fee;
/** 终端IP*/
@property (nonatomic,strong) NSString *spbill_create_ip;
/** 通知回调*/
@property (nonatomic,strong) NSString *notify_url;
/** 交易类型*/
@property (nonatomic,strong) NSString *trade_type;

@end

@implementation SignMD5

- (instancetype)initWithAppid:(NSString *)appid
                       mch_id:(NSString *)mch_id
                    nonce_str:(NSString *)noce_str
                         body:(NSString *)body
                 out_trade_no:(NSString *)out_trade_no
                    total_fee:(NSString *)total_fee
             spbill_create_ip:(NSString *)spbill_create_ip                   notify_url:(NSString *)notify_url
                   trade_type:(NSString *)trade_type {
    
    if (self = [super init]) {
        _appid            = appid;
        _mch_id           = mch_id;
        _nonce_str        = noce_str;
        _body             = body;
        _out_trade_no     = out_trade_no;
        _total_fee        = total_fee;
//        _spbill_create_ip = spbill_create_ip;
        _notify_url       = notify_url;
        _trade_type       = trade_type;
        
    }
    return self;
}


/**
  md5 sign 是有 _appid _mch_id _nonce_str _body等参数组成
 
 @return MD5字符串
 */
- (NSString *)getMD5Sign {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:_appid forKey:@"appid"];
        [dic setValue:_mch_id forKey:@"mch_id"];
        [dic setValue:_nonce_str forKey:@"nonce_str"];
        [dic setValue:_body forKey:@"body"];
        [dic setValue:_out_trade_no forKey:@"out_trade_no"];
        [dic setValue:_total_fee forKey:@"total_fee"];
//        [dic setValue:_spbill_create_ip forKey:@"spbill_create_ip"];
        [dic setValue:_notify_url forKey:@"notify_url"];
        [dic setValue:_trade_type forKey:@"trade_type"];
        return [self createMd5Sign:dic];
}
/**
 enum{
 
 NSCaseInsensitiveSearch = 1,//不区分大小写比较
 
 NSLiteralSearch = 2,//区分大小写比较
 
 NSBackwardsSearch = 4,//从字符串末尾开始搜索
 
 NSAnchoredSearch = 8,//搜索限制范围的字符串
 
 NSNumbericSearch = 64//按照字符串里的数字为依据，算出顺序。例如 Foo2.txt < Foo7.txt < Foo25.txt
 
 //以下定义高于 mac os 10.5 或者高于 iphone 2.0 可用
 
 ,
 
 NSDiacriticInsensitiveSearch = 128,//忽略 "-" 符号的比较
 
 NSWidthInsensitiveSearch = 256,//忽略字符串的长度，比较出结果
 
 NSForcedOrderingSearch = 512//忽略不区分大小写比较的选项，并强制返回 NSOrderedAscending 或者 NSOrderedDescending
 
 //以下定义高于 iphone 3.2 可用
 
 ,
 
 NSRegularExpressionSearch = 1024//只能应用于 rangeOfString:..., stringByReplacingOccurrencesOfString:...和 replaceOccurrencesOfString:... 方法。使用通用兼容的比较方法，如果设置此项，可以去掉 NSCaseInsensitiveSearch 和 NSAnchoredSearch
 
 }
 */

//创建签名
-(NSString*) createMd5Sign:(NSMutableDictionary*)dict {
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return  [obj1 compare:obj2 options:NSNumericSearch];
    }];
    for (NSString *categoryId in sortedArray) {
        if (   ![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![[dict objectForKey:categoryId] isEqualToString:@"sign"]
            && ![[dict objectForKey:categoryId] isEqualToString:@"key"]
            ) {
            
            [contentString appendFormat:@"%@=%@&",categoryId,[dict objectForKey:categoryId]];
        }
    }
    //在最后拼接密匙_partnerkey
    [contentString appendFormat:@"key=%@",Partner_Key];
    NSString *md5Sign =[self md5:contentString];
    
    return md5Sign;
}

/**
 创建发起支付时的MD5签名
 PayReq *request.sign
 @param appid_key 应用appID
 @param partnerid_key 商户号返回的mch_id
 @param prepayid_key 预支付订单
 @param package_key  商家根据财付通文档填写的数据和签名
 @param noncestr_key 随机串，防重发
 @param timestamp_key 时间戳，防重发
 @return <#return value description#>
 */
- (NSString *)createMD5SingForPay:(NSString *)appid_key
                        partnerid:(NSString *)partnerid_key
                         prepayid:(NSString *)prepayid_key
                          package:(NSString *)package_key
                         noncestr:(NSString *)noncestr_key
                        timestamp:(UInt32)timestamp_key {
    NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
    [signParams setObject:appid_key forKey:@"appid"];
    [signParams setObject:noncestr_key forKey:@"noncestr"];
    [signParams setObject:package_key forKey:@"package"];
    [signParams setObject:partnerid_key forKey:@"partnerid"];
    [signParams setObject:prepayid_key forKey:@"prepayid"];
    [signParams setObject:[NSString stringWithFormat:@"%u",timestamp_key] forKey:@"timestamp"];
    return [self createMd5Sign:signParams];
}

-(NSString *) md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    //加密规则，因为逗比微信没有出微信支付demo，这里加密规则是参照安卓demo来得
    unsigned char result[16]= "0123456789abcdef";
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    //这里的x是小写则产生的md5也是小写，x是大写则md5是大写，这里只能用大写，逗比微信的大小写验证很逗
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


/**
 生成调用统一下单的请求参数的

 @return XML格式字符串
 */
- (NSString *)getXMLString {
    NSString *sign = [self getMD5Sign];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:_appid forKey:@"appid"];//公众账号ID
    [dic setValue:_mch_id forKey:@"mch_id"];//商户号
    [dic setValue:_nonce_str forKey:@"nonce_str"];//随机字符串
    [dic setValue:sign forKey:@"sign"];//签名
    [dic setValue:_body forKey:@"body"];//商品描述
    [dic setValue:_out_trade_no forKey:@"out_trade_no"];//订单号
    [dic setValue:_total_fee forKey:@"total_fee"];//金额
    //    [dic setValue:_spbill_create_ip forKey:@"spbill_create_ip"];//终端IP
    [dic setValue:_notify_url forKey:@"notify_url"];//通知地址
    [dic setValue:_trade_type forKey:@"trade_type"];//交易类型
    
    NSMutableString *reqPars = [NSMutableString string];
    NSArray *keys = [dic allKeys];
    [reqPars appendString:@"<xml>"];
    for (NSString *categoryId in keys) {
        [reqPars appendFormat:@"<%@>%@</%@>"
         , categoryId, [dic objectForKey:categoryId],categoryId];
    }
    [reqPars appendFormat:@"</xml>"];
    return [NSString stringWithString:reqPars];

}

///产生随机字符串
+ (NSString *)generateTradeNO {
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRST";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

//产生随机数
+ (NSString *)getOrderNumber {
    int random = arc4random()%10000;
    
    const char *cStr = [[NSString stringWithFormat:@"%d",random] UTF8String];
    //加密规则，因为逗比微信没有出微信支付demo，这里加密规则是参照安卓demo来得
    unsigned char result[16]= "0123456789abcdef";
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    //这里的x是小写则产生的md5也是小写，x是大写则md5是大写，这里只能用大写，逗比微信的大小写验证很逗
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];

   }

@end
