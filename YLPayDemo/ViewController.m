//
//  ViewController.m
//  YLPayDemo
//
//  Created by 杭州移领 on 16/12/28.
//  Copyright © 2016年 DFL. All rights reserved.
//

#import "ViewController.h"
#import "YLPayManager.h"
#import "SignMD5.h"
#import "YLHttpManager.h"
@interface ViewController ()<YLPayManagerDelegate>

@end

@implementation ViewController

/**
 1. 开发者需要在工程Build Phases ———>Link Binary Libraries中:
                        SystemConfiguration.framework,
                        libz.dylib, 
                        libsqlite3.0.dylib,
                        libc++.dylib, 
                        Security.framework,
                        CoreTelephony.framework, 
                        CFNetwork.framework。
 2.选择Build Setting，在"Other Linker Flags"中加入"-Objc"，
 3.具体配置https://open.weixin.qq.com/cgi-bin/index?t=home/index&lang=zh_CN ————>接入指南
 */
- (void)viewDidLoad {
    [super viewDidLoad];
   
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [YLPayManager sharedManager].delegate = self;
}

- (void)managerPayBaseReqErrCode:(NSInteger)errCode {
    switch (errCode) {
        case WXSuccess:
             NSLog(@"成功");
            break;
            
        default:
            NSLog(@"失败");
            break;
    }
}
- (void)pay {
    //应用APPID
    NSString *appid = @"";
    //微信支付商户号
    NSString * mch_id = @"";
    ///产生随机字符串，这里最好使用和安卓端一致的生成逻辑
    NSString * nonce_str =[SignMD5 generateTradeNO];
    NSString * body = @"海蚂蚁跨境海购";
    //随机产生订单号用于测试，正式使用请换成你从自己服务器获取的订单号
    NSString * out_trade_no = [SignMD5 getOrderNumber];
    //交易价格1表示0.01元，10表示0.1元
    NSString * total_fee = [NSString stringWithFormat:@"%.f",1.0f] ;
    //获取本机IP地址，请再wifi环境下测试，否则获取的ip地址为error，正确格式应该是8.8.8.8
    NSString *spbill_create_ip = @"196.168.1.1";//[getIPhoneIP getIPAddress];
    //交易结果通知网站此处用于测试，随意填写，正式使用时填写正确网站
    NSString *notify_url = @"www.baidu.com";
    NSString * trade_type = @"APP";
    SignMD5 *data = [[SignMD5 alloc] initWithAppid:appid
                                            mch_id:mch_id
                                         nonce_str:nonce_str
                                              body:body
                                      out_trade_no:out_trade_no
                                         total_fee:total_fee
                                  spbill_create_ip:spbill_create_ip
                                        notify_url:notify_url
                                        trade_type:trade_type];
    NSString *xmlString = [data getXMLString];
    
    [YLHttpManager YLWetChatPay:@"https://api.mch.weixin.qq.com/pay/unifiedorder" xml:xmlString success:^(id responseObject) {
        NSLog(@"responseObject ===%@",responseObject);
        PayReq *request = [[PayReq alloc] init];
        request.partnerId = responseObject[@"mch_id"];        
        request.prepayId=  responseObject[@"prepay_id"];
        request.package = @"Sign=WXPay";
        request.nonceStr= responseObject[@"nonce_str"] ;
        //将当前事件转化成时间戳
        NSDate *datenow = [NSDate date];
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
        UInt32 timeStamp =[timeSp intValue];
        request.timeStamp= timeStamp;
        
        request.sign=[data createMD5SingForPay:responseObject[@"appid"]
                                    partnerid:request.partnerId
                                     prepayid:request.prepayId
                                      package:request.package
                                     noncestr:request.nonceStr
                                    timestamp:request.timeStamp];
         [WXApi sendReq:request];
    } failure:^(NSError *error) {
        NSLog(@"error ===%@",error);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
