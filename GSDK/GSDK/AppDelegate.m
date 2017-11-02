//
//  AppDelegate.m
//  GSDK
//
//  Created by 王璟鑫 on 16/8/4.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "AppDelegate.h"
#import "HTAssistiveTouch.h"
#import <GoogleSignIn/GoogleSignIn.h>
#import <GameKit/GameKit.h>
#import "HTConnect.h"

#import "HTOrientation.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBNotifications/FBNotifications.h>
@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //facebook
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];

    //保存到userdefault
    NSString *fansUrl = @"https://www.facebook.com/lord.of.dark.tw/";
    [HTConnect initSDKwithAppID:@"1021016" andPhoneCountryNumber:@"86" andAudit:YES andFansUel:fansUrl andVersion:@"1.0" andChannel:@"default"];
    //google
    [GIDSignIn sharedInstance].clientID = @"1047879244101-ab7hk0r62dq3oqjk6jpmp6knimk4p2un.apps.googleusercontent.com";
    //统计接口
    [HTConnect StatisticsInterfacelogOrRegType:@"log"  coo_server:@"200" coo_uid:@"11" success:^(id response) {
        
//        NSLog(@"tongjijiekou=%@",response);
    } failure:^(id error) {
        
    }];

    return YES;
}
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options {
    
    if ([[url absoluteString] containsString:@"facebook"]) {
        return [[FBSDKApplicationDelegate sharedInstance] application:app
                                                              openURL:url
                                                    sourceApplication:@"com.apple.SafariViewService"
                                                           annotation:nil];
    }
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                      annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler {
    FBNotificationsManager *notificationsManager = [FBNotificationsManager sharedManager];
    [notificationsManager presentPushCardForRemoteNotificationPayload:userInfo
                                                   fromViewController:nil
                                                           completion:^(FBNCardViewController * _Nullable viewController, NSError * _Nullable error) {
                                                               if (error) {
                                                                   completionHandler(UIBackgroundFetchResultFailed);
                                                               } else {
                                                                   completionHandler(UIBackgroundFetchResultNewData);
                                                               }
                                                           }];
}



- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {

    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}


#pragma mark-FB
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    NSLog(@"DeviceToken: {%@}",deviceToken);
    [FBSDKAppEvents setPushNotificationsDeviceToken:deviceToken];

}
#pragma mark-FB
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [FBSDKAppEvents logPushNotificationOpen:userInfo];
}
#pragma mark-FB
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
    [FBSDKAppEvents logPushNotificationOpen:userInfo action:identifier];
}
#pragma mark-FB
-(void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBSDKAppEvents activateApp];
    
}
- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Register Remote Notifications error:{%@}",error);
    //    NSLog(@"Register Remote Notifications error:{%@}",error.localizedDescription);
}


#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] \
compare:v options:NSNumericSearch] == NSOrderedAscending)


- (void)applicationWillResignActive:(UIApplication *)application
{
    [HTConnect shareConnect].gameCenterLoginType=@"new";

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [HTConnect shareConnect].gameCenterLoginType=@"new";

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
   
}



- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
