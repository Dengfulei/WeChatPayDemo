//
//  YLHttpManager.m
//  YLPayDemo
//
//  Created by 杭州移领 on 16/12/28.
//  Copyright © 2016年 DFL. All rights reserved.
//

#import "YLHttpManager.h"
#import "XMLDictionary.h"
@implementation YLHttpManager

+ (void)YLWetChatPay:(NSString *)url
                 xml:(id)xml
             success:(void (^)(id))success
             failure:(void (^)(NSError *))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];

    [manager.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    [manager.requestSerializer setValue:@"https://api.mch.weixin.qq.com/pay/unifiedorder" forHTTPHeaderField:@"SOAPAction"];
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return xml;
    }];
    [manager POST:url parameters:xml progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] ;
        NSLog(@"responseString is %@",responseString);
      NSDictionary *jsonDic = [NSDictionary dictionaryWithXMLString:responseString];
        success(jsonDic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}
@end
