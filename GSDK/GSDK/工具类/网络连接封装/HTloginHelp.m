//  HTloginHelp.m
//  NewSDkBy
//
//  Created by 王璟鑫 on 16/1/15.
//  Copyright © 2016年 www.gamehetu.com. All rights reserved.
//
#import "HTgetDeviceName.h"
#import "HTloginHelp.h"
#import "RSA.h"
#import "UUID.h"

@implementation HTloginHelp

+(NSMutableURLRequest*)returnRequest:(NSString*)mainStr usernameTextField:(UITextField*)usernameTextField passwordTextField:(UITextField*)passwordTextField
{
//    NSString*nameAndWord;
    //主体
    NSURL*url=[NSURL URLWithString:mainStr];
//new = username, password, app_id, uuid, adid, device, version, channel, ip(否)
//    nameAndWord=[NSString stringWithFormat:@"username=%@&password=%@&uuid=%@",usernameTextField.text,passwordTextField.text,[UUID getUUID]];
    
    NSString *username = usernameTextField.text;
    NSString *password = passwordTextField.text;
    NSString *app_id = [USER_DEFAULT objectForKey:@"appID"];
    NSString *uuid = [UUID getUUID];
    NSString *adid = [USER_DEFAULT objectForKey:@"adid"];
    NSString *device =  [HTgetDeviceName deviceString];
    NSString *version = [USER_DEFAULT objectForKey:@"version"];
    NSString *channel = [USER_DEFAULT objectForKey:@"channel"];
    NSString *ip = GETIP;
    NSString *pram_lang = [USER_DEFAULT objectForKey:@"lang"];
    
    NSString *newStr = [NSString stringWithFormat:@"username=%@&password=%@&app_id=%@&uuid=%@&adid=%@&device=%@&version=%@&channel=%@&ip=%@&lang=%@",username, password,app_id, uuid, adid, device, version, channel, ip, pram_lang];
//    //将获取的信息加密
//    NSString*dataStr=[RSA encryptString:nameAndWord];
//    NSString*appId=[USER_DEFAULT objectForKey:@"appID"];
//    NSString*parmaStr=[NSString stringWithFormat:@"app=%@&data=%@&format=json&version=2.0",appId,dataStr];
//    NSLog(@"str=%@",parmaStr);
    NSLog(@"%@",newStr);
    NSLog(@"main=%@",mainStr);
    NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:url cachePolicy:(NSURLRequestUseProtocolCachePolicy) timeoutInterval:15];
    
    [request setHTTPMethod:@"POST"];
    NSData *paraData=[newStr dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:paraData];
    return request;
}
+(NSString*)returnLoginString
{
//    NSString*str=@"http://c.gamehetu.com/passport/login?";
//    NSString*newStr=@"http://c.gamehetu.com/public/access_token";
     NSString *newUrlStr = [NSString stringWithFormat:@"%@%@",SERVER_URL,LOGIN_URL];
    return newUrlStr;
}
+(NSString*)returnSignupString
{
//    NSString*str=@"http://c.gamehetu.com/passport/register?";
    NSString *newUrlStr = [NSString stringWithFormat:@"%@%@",SERVER_URL,REGISTER_URL];
    return newUrlStr;
}
+(NSDictionary*)jsonBecomeDict:(NSData*)data
{
    NSDictionary*dict=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
    return dict;
}


@end
