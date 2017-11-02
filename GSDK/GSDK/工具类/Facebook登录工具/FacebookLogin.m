//
//  FacebookLogin.m
//  GSDK
//
//  Created by 王璟鑫 on 16/8/5.
//  Copyright © 2016年 王璟鑫. All rights reserved

#import "HTNameAndRequestModel.h"
#import "FacebookLogin.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "HTAddBindInfoTodict.h"
@implementation FacebookLogin

+(void)logInIfSuccess:(void(^)(id response, NSDictionary*FacebookDict))success failure:(void(^)(NSError*error))failure
{

//改改改aaafacebook登录
    [HTConnect shareConnect].mywindow.windowLevel=UIWindowLevelNormal;
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    if ([FBSDKAccessToken currentAccessToken]!=nil) {
        [login logOut];
    }
    login.loginBehavior = FBSDKLoginBehaviorNative;
    
    [login
     logInWithReadPermissions: @[@"public_profile",@"read_custom_friendlists",@"user_friends",@"email"]
     fromViewController:[UIApplication sharedApplication].keyWindow.rootViewController     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         [HTConnect shareConnect].mywindow.windowLevel=UIWindowLevelAlert+1;
         if (error) {
   
             [HTConnect shareConnect].mywindow.windowLevel=UIWindowLevelAlert+1;
             failure(error);
         } else if (result.isCancelled) {
   
            [HTConnect shareConnect].mywindow.windowLevel=UIWindowLevelAlert+1;
         } else {
             NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                            @"name,id",@"fields",
                                            nil];
             FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                           initWithGraphPath:@"me"
                                           parameters:params
                                           HTTPMethod:@"GET"];
             [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                   id result,
                                                   NSError *error) {
                 NSLog(@"----------%@",result);
    if (result) {
        [HTConnect shareConnect].mywindow.windowLevel=UIWindowLevelAlert+1;
        [HTprogressHUD  showjuhuaText:bendihua(@"正在登录")];
        
        //platform code app_id uuid adid device version channel ip
        
        NSString *pram_platform = @"facebook";
        NSString *pram_code = [FBSDKAccessToken currentAccessToken].tokenString;
        NSString *pram_app_id = [USER_DEFAULT objectForKey:@"appID"];
        NSString *pram_uuid = GETUUID;
        NSString *pram_adid = [USER_DEFAULT objectForKey:@"adid"];
//        NSString *pram_device = [HTgetDeviceName deviceString];
        NSString *pram_device = @"ios";
        NSString *pram_version = [USER_DEFAULT objectForKey:@"version"];
        NSString *pram_channel = [USER_DEFAULT objectForKey:@"channel"];
        NSString *pram_ip = GETIP;
        NSString *pram_open_id = result[@"id"];
        NSString *open_name = result[@"name"];
        NSString *pram_open_name = [open_name stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *pram_lang = [USER_DEFAULT objectForKey:@"lang"];
        
        
        NSString *newPramStr = [NSString stringWithFormat:@"platform=%@&access_token=%@&open_id=%@&app_id=%@&uuid=%@&adid=%@&device=%@&version=%@&channel=%@&ip=%@&open_name=%@&lang=%@",pram_platform, pram_code,pram_open_id, pram_app_id, pram_uuid, pram_adid, pram_device, pram_version, pram_channel, pram_ip,pram_open_name, pram_lang];
        
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",SERVER_URL, LOGIN_URL];
        
        NSString *newUrlStr = [NSString stringWithFormat:@"%@?%@",urlStr,newPramStr];
//        
//        NSString*str=[NSString stringWithFormat:@"username=%@#facebook&name=%@&uuid=%@&token=%@",result[@"id"],result[@"name"],[UUID getUUID],[FBSDKAccessToken currentAccessToken].tokenString];
//                     
//        NSString*rsaStr=[RSA encryptString:str];
//        NSString*urlStr=[NSString stringWithFormat:@"http://c.gamehetu.com/passport/login?app=%@&data=%@&format=json&version=2.0",[[NSUserDefaults standardUserDefaults]objectForKey:@"appID"],rsaStr];
//        
//
        NSLog(@"打印api = %@",newUrlStr);
        NSURL*url=[NSURL URLWithString:newUrlStr];
        NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:url];
        
        
        [HTNetWorking sendRequest:request ifSuccess:^(id response) {
             NSDictionary*facebookDict=[NSDictionary dictionaryWithObjectsAndKeys:result[@"id"], @"facebookID",result[@"name"],@"facebookName",[FBSDKAccessToken currentAccessToken].tokenString,@"facebookToken",nil];
            if ([response[@"code"]isEqualToNumber:@0]) {
                [HTConnect showAssistiveTouch];
                [HTHUD showHUD:bendihua(@"登入成功")];
                
                NSString *str = response[@"open_id"];
                NSLog(@"uid=%@",str);
                [USER_DEFAULT setObject:str forKey:@"uid"];
                //保存access_token
                NSString *access_token = response[@"access_token"];
                [USER_DEFAULT setObject:[FBSDKAccessToken currentAccessToken].tokenString forKey:@"facebookToken"];
                [USER_DEFAULT setObject:result[@"name"] forKey:@"showname"];
                [USER_DEFAULT setObject:@"30" forKey:@"loginway"];
                [USER_DEFAULT setObject:access_token forKey:@"access_token"];
                [USER_DEFAULT synchronize];
                
                [HTLoginSuccess loginSuccessWithtoken:access_token];
                [HTNameAndRequestModel setFastRequest:request AndNameFormdict:response];
                success(response,facebookDict);
            }else
            {
                [HTprogressHUD hiddenHUD];
            }

        } failure:^(NSError *error) {
            [HTConnect shareConnect].mywindow.windowLevel=UIWindowLevelAlert+1;
            [HTprogressHUD hiddenHUD];
        }];
                 }
            else
                 {
                     failure(error);
                     NSLog(@"%@Facebook登录出错",error);
                     [HTAlertView showAlertViewWithText:bendihua(@"网络连接失败") com:nil];
                     [HTConnect shareConnect].mywindow.windowLevel=UIWindowLevelAlert+1;
                 }
             }];
         }
     }];
}
+(void)getFacebookInfoIfSuccess:(void(^)())success{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [HTConnect shareConnect].mywindow.windowLevel=UIWindowLevelNormal;
    if ([FBSDKAccessToken currentAccessToken]!=nil) {
    }
    login.loginBehavior = FBSDKLoginBehaviorNative;
    [login
     logInWithReadPermissions: @[@"public_profile",@"read_custom_friendlists",@"user_friends",@"email"]
     fromViewController:MXRootViewController
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         [HTConnect shareConnect].mywindow.windowLevel=UIWindowLevelAlert+1;

//改改改aaa Facebook绑定
         if (error) {
             NSLog(@"Process error");
             [HTConnect shareConnect].mywindow.windowLevel=UIWindowLevelAlert+1;
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
             [HTConnect shareConnect].mywindow.windowLevel=UIWindowLevelAlert+1;
         } else {
             NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"name,id",@"fields",nil];
             FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                        initWithGraphPath:@"me"                                           parameters:params
                                           HTTPMethod:@"GET"];
             [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,id result,NSError *error) {
                 
                 NSLog(@"----------%@",result);
                if (result) {
                    [HTConnect shareConnect].mywindow.windowLevel=UIWindowLevelAlert+1;
                     NSString*appID=[USER_DEFAULT objectForKey:@"appID"];
                     NSDictionary*userDic = [USER_DEFAULT objectForKey:@"userInfo"];
                    
                    //新的接口
                    NSString *newUrlStr = [NSString stringWithFormat:@"%@%@",SERVER_URL,BIND_URL];
                    NSString *pram_access_token =[USER_DEFAULT objectForKey:@"access_token"];
                    NSString *pram_platform = @"facebook";
                    NSString *pram_code = [USER_DEFAULT objectForKey:@"facebookToken"];
                    NSString *pram_lang = [USER_DEFAULT objectForKey:@"lang"];
                    NSString *newPramStr = [NSString stringWithFormat:@"ccess_token=%@&platform=%@&code=%@&lang=%@",pram_access_token, pram_platform, pram_code, pram_lang];
                    NSString *urlStr = [NSString stringWithFormat:@"%@?%@",newUrlStr, newPramStr];
                    
//                     NSString*dataStr=[NSString stringWithFormat:@"type=facebook&auth=%@&name=%@&token=%@",result[@"id"],result[@"name"],[userDic valueForKeyPath:@"data.token"]];
//                     NSString*RSADataStr=[RSA encryptString:dataStr];
//                     NSString*urlStr=[NSString stringWithFormat:@"http://c.gamehetu.com/passport/bind?app=%@&data=%@&format=json&version=2.0",appID,RSADataStr];
                    
                    
                    
                     NSURL*url=[NSURL URLWithString:urlStr];
                     NSMutableURLRequest*requestq=[NSMutableURLRequest requestWithURL:url];
                     [HTNetWorking sendRequest:requestq ifSuccess:^(id response) {
                         
                         if ([response[@"code"] isEqualToNumber:@0]) {
                             [HTAddBindInfoTodict addInfoToDictType:@"facebook" auth_name:result[@"name"]];
                             success();
                         
                         }else if([response[@"code"] isEqualToNumber:@1])
                         {
                             [HTAlertView showAlertViewWithText:response[@"msg"] com:nil];
                             [HTAlertView showAlertViewWithText:bendihua(@"绑定失败,该账号已绑定过") com:nil];
                             
                         }else
                         {
                             [HTAlertView showAlertViewWithText:bendihua(@"綁定失败") com:nil];
                         }
                         
                     } failure:^(NSError *error) {
                         [HTAlertView showAlertViewWithText:bendihua(@"綁定失败") com:nil];

                     }];

                 }

                 else
                 {
                     [HTAlertView showAlertViewWithText:bendihua(@"网络连接失败") com:nil];
                     [HTConnect shareConnect].mywindow.windowLevel=UIWindowLevelAlert+1;
                 }
                 
             }];
             [HTConnect shareConnect].mywindow.windowLevel=UIWindowLevelAlert+1;
         }
     }];
    
}


@end
