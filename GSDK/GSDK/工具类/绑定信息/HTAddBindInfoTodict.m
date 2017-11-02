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
    NSMutableDictionary*dict=[NSMutableDictionary dictionaryWithDictionary:[USER_DEFAULT objectForKey:@"usernewinfo"]];
    NSMutableDictionary*addDcit;
    if ([type isEqualToString:@"email"]) {
        addDcit=[NSMutableDictionary dictionaryWithObject:auth_name forKey:@"open_name"];

    }else
    {
    
    addDcit=[NSMutableDictionary dictionaryWithObject:auth_name forKey:@"open_name"];
    }
    
//    NSDictionary *newdic = dict[@"more"];
//    newdic setValue:auth_name forKey:<#(nonnull NSString *)#>
//    NSMutableDictionary*mudic=[NSMutableDictionary dictionaryWithDictionary:addDcit];
    NSMutableDictionary *mudic = [NSMutableDictionary dictionary];
    [mudic setObject:addDcit forKey:type];
    
    
    
//    NSMutableDictionary*dataDict=[NSMutableDictionary dictionaryWithDictionary:dict[@"data"]];
//    [dataDict setObject:mudic forKey:@"bind"];
    
    [dict setObject:mudic forKey:@"more"];
//真你妈比费劲握草!!!!!!!!
//    [USER_DEFAULT setObject:auth_name forKey:@"newbindname"];
    [USER_DEFAULT setObject:dict forKey:@"usernewinfo"];
    [USER_DEFAULT synchronize];
    NSLog(@"%@",[USER_DEFAULT objectForKey:@"usernewinfo"]);
    
}
@end
