//
//  HTBindInfo.m
//  GSDK
//
//  Created by 王璟鑫 on 16/8/23.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTBindInfo.h"

@implementation HTBindInfo


+(instancetype)shareBindInfo
{
    static HTBindInfo*bindInfo;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        bindInfo=[[HTBindInfo alloc]init];
        
    });
    
    return bindInfo;
}

+(NSString*)returnHomeName:(NSDictionary*)dict
{
    
//改改改aaa用于快速登录时显示的账号名字

    NSArray*arr=[[dict valueForKeyPath:@"more"] allKeys];
    if (arr.count==0) {
        
        return [dict valueForKeyPath:@"name"];
        
    }else if ([arr containsObject:@"email"]) {
    
        return [dict valueForKeyPath:@"more.email.open_name"];
    
    }else if ([arr containsObject:@"accountkit"])
    {

        return [dict valueForKeyPath:@"more.accountkit.open_name"];
    }
    else if([arr containsObject:@"phone"])
    {
        return [dict valueForKeyPath:@"phone"];

    }
    else if([arr containsObject:@"facebook"])
    {
        return [dict valueForKeyPath:@"more.facebook.open_name"];
    
    }else if([arr containsObject:@"google"])
    {
        
        return [dict valueForKeyPath:@"more.google.open_name"];
        
    }else if([arr containsObject:@"apple"])
    {
        
        return [dict valueForKeyPath:@"more.apple.open_name"];
        
    }else
    {
        return [dict valueForKeyPath:@"name"];

    }
}

+(BOOL)haveBindOfficalAccount
{
    
//yes是已绑定官方账号
    
    NSDictionary*dict=[USER_DEFAULT objectForKey:@"usernewinfo"];
////    NSArray*arr=[[dict valueForKeyPath:@"data.bind"] allKeys];
    NSDictionary *arr = dict[@"more"];
//    if ([[arr allKeys] containsObject:@"email"]) {
//        NSLog(@"有官方账号");
//    }
    if (arr.count==0) {
        return NO;
    }
//    return [arr containsObject:@"email"];
    return [[arr allKeys] containsObject:@"email"];
}
+(BOOL)haveBindThridAccount
{
    NSDictionary*dict=[USER_DEFAULT objectForKey:@"usernewinfo"];
//    NSArray*arr=[[dict valueForKeyPath:@"data.bind"] allKeys];
    NSDictionary *diccc = dict[@"more"];
    if (diccc.count == 0) {
        return NO;
    }
    NSArray *arr = [diccc allKeys];
//    if ([arr containsObject:@"email"]||arr.count==0) {
//        return YES;
//    }else
        if ([arr containsObject:@"accountkit"]) {
        return YES;
    }
    else if ([arr containsObject:@"facebook"]){
     return YES;
    }else if([arr containsObject:@"google"]){
        return YES;
    }else if([arr containsObject:@"apple"])
    {
        return YES;
    }else
    {
        return NO;
    }
}

+(NSDictionary*)showBindAccountName
{
    NSDictionary*dict=[USER_DEFAULT objectForKey:@"usernewinfo"];
    NSLog(@"dic = %@",dict);
    NSString *name = dict[@"name"];
    NSArray *arr = dict[@"more"];
    NSLog(@"name=%@",name);

    NSDictionary*userInfo;
    
//    NSArray*arr=[[dict valueForKeyPath:@"more"] allKeys];
    NSLog(@"%lu",(unsigned long)arr.count);
    
    
    if ([self haveBindOfficalAccount]) {
        
        if(arr.count==0)
        {
            userInfo=[NSDictionary dictionaryWithObjectsAndKeys:imageNamed(@"渠道图标_4"),@"image",@"email",@"type",[dict valueForKeyPath:@"name"],@"name", nil];
            
            return userInfo;
        }
        
        userInfo=[NSDictionary dictionaryWithObjectsAndKeys:imageNamed(@"渠道图标_4"),@"image",@"email",@"type",[dict valueForKeyPath:@"more.email.open_name"],@"name", nil];
        
        return userInfo;
    }
    else
    {
        if ([self haveBindThridAccount]) {
            
            if ([arr containsObject:@"accountkit"]) {
                userInfo=[NSDictionary dictionaryWithObjectsAndKeys:imageNamed(@"手机登录"),@"image",@"accountkit",@"type",[dict valueForKeyPath:@"more.accountkit.open_name"],@"name", nil];
                return userInfo;
            }
           else if ([arr containsObject:@"facebook"]) {
            userInfo=[NSDictionary dictionaryWithObjectsAndKeys:imageNamed(@"渠道图标_1"),@"image",@"facebook",@"type",[dict valueForKeyPath:@"more.facebook.open_name"],@"name", nil];
                return userInfo;
                
            }else if([arr containsObject:@"google"])
            {
                userInfo=[NSDictionary dictionaryWithObjectsAndKeys:imageNamed(@"渠道图标_3"),@"image",@"google",@"type",[dict valueForKeyPath:@"more.google.open_name"],@"name", nil];
                return userInfo;
                
            }else
            {
                userInfo=[NSDictionary dictionaryWithObjectsAndKeys:imageNamed(@"渠道图标_2"),@"image",@"gamecenter",@"type",[dict valueForKeyPath:@"more.apple.open_name"],@"name", nil];
                return userInfo;
            }
           
        }else//设备登录,没有绑定
        {
            userInfo=[NSDictionary dictionaryWithObjectsAndKeys:@"device",@"type",[dict valueForKeyPath:@"name"],@"name", nil];
            NSLog(@"userinfo=%@",userInfo);
            return userInfo;
        }
    }
    return nil;
}

@end
