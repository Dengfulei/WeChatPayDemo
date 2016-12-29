//
//  AppDelegate.m
//  YLPayDemo
//
//  Created by 杭州移领 on 16/12/28.
//  Copyright © 2016年 DFL. All rights reserved.
//

#import "AppDelegate.h"
#import "YLPayManager.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[YLPayManager sharedManager] registerApp:@"商户自己的APPID" withDescription:@"demo 2.0"];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    return [[YLPayManager sharedManager] application:application openURL:url sourceApplication:sourceApplication annotation:application];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    return [[YLPayManager sharedManager] application:app openURL:url options:options];
}


@end
