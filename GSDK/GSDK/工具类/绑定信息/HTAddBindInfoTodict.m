//
//  HTAddBindInfoTodict.m
//  GSDK
//
//  Created by 王璟鑫 on 16/8/25.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTAddBindInfoTodict.h"

@implementation HTAddBindInfoTodict
+(void)addInfoToDictType:(NSString*)type auth_name:(NSString*)auth_name
{
//改改改aaa绑定过后的信息存储
    NSMutableDictionary*dict=[NSMutableDictionary dictionaryWithDictionary:[USER_DEFAULT objectForKey:@"userInfo"]];
    NSMutableDictionary*addDcit;
    if ([type isEqualToString:@"email"]) {
        addDcit=[NSMutableDictionary dictionaryWithObject:auth_name forKey:@"auth_id"];

    }else
    {
    
    addDcit=[NSMutableDictionary dictionaryWithObject:auth_name forKey:@"auth_name"];
    }
    
    NSMutableDictionary*mudic=[NSMutableDictionary dictionaryWithDictionary:[dict valueForKeyPath:@"data.bind"]];
    [mudic setObject:addDcit forKey:type];

    
    NSMutableDictionary*dataDict=[NSMutableDictionary dictionaryWithDictionary:dict[@"data"]];
    [dataDict setObject:mudic forKey:@"bind"];
    
    [dict setObject:dataDict forKey:@"data"];
//真你妈比费劲握草!!!!!!!!
    
    [USER_DEFAULT setObject:dict forKey:@"userInfo"];
    [USER_DEFAULT synchronize];
    NSLog(@"%@",[USER_DEFAULT objectForKey:@"userInfo"]);
    
}
@end
