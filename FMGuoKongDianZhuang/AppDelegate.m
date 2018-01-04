//
//  AppDelegate.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/10.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "AppDelegate.h"
#import "GKTabBarController.h"
#import "GKLoginController.h"
#import <UMSocialCore/UMSocialCore.h>
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

#define UMENG_APPKEY @"5a4c3a07b27b0a5ccd000268"

#define WeChat_APPKEY @"wx7d9de31773130327"
#define WeChat_APPSECRET @"3f0d77281f87a0bc63608a9f9509ad5c"
#define QQ_APPKEY @"1106578087"
#define QQ_APPSECRET @"ujvi57d8kuMU76Yp"
#define Sina_APPKEY @""
#define Sina_APPSECRET @""

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMENG_APPKEY];
    
    [self configUSharePlatforms];
    
    //微信支付注册
    [WXApi registerApp:WeChat_APPKEY];
    
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [AMapServices sharedServices].enableHTTPS = YES;
    [AMapServices sharedServices].apiKey = MAMapKey;
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].shouldShowToolbarPlaceholder = NO;
    
    WEAKSELf
    if([FMUserDefault objectForKey:@"user_id"]){
        GKTabBarController *tabbarVC = [[GKTabBarController alloc]init];
        self.window.rootViewController = tabbarVC;
    }else{
        GKLoginController *vc = [[GKLoginController alloc]init];
        vc.loginFinishBlock = ^{
            GKTabBarController *tabbarVC = [[GKTabBarController alloc]init];
            weakSelf.window.rootViewController = tabbarVC;
        };
        self.window.rootViewController = vc;
    }
    
    
    return YES;
}

-(void)configUSharePlatforms{
    //微信
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WeChat_APPKEY appSecret:WeChat_APPSECRET redirectURL:nil];
    //qq
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQ_APPKEY  appSecret:QQ_APPSECRET redirectURL:@"http://mobile.umeng.com/social"];
    //sina
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:Sina_APPKEY  appSecret:Sina_APPSECRET redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
}

// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        
        if ([url.host isEqualToString:@"safepay"]) {
            //跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                [[NSNotificationCenter defaultCenter]postNotificationName:Alipay_notification object:resultDic];
            }];
        }else if([url.host isEqualToString:@"pay"]){
            return [WXApi handleOpenURL:url delegate:self];
        }
    }
    return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            [[NSNotificationCenter defaultCenter]postNotificationName:Alipay_notification object:resultDic];
        }];
    }else if([url.host isEqualToString:@"pay"]){
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

-(void)onResp:(BaseResp*)resp{
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp *response=(PayResp*)resp;
        
        [[NSNotificationCenter defaultCenter]postNotificationName:Wxpay_notification object:response];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
