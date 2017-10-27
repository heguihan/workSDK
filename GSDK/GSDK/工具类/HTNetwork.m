//
//  HTNetwork.m
//  GSDK
//
//  Created by 何圭韩 on 2017/10/20.
//  Copyright © 2017年 王璟鑫. All rights reserved.
//

#import "HTNetwork.h"

@implementation HTNetwork

+(void)NetworkStatistics:(NSString *)paramestr success:(HTTPRequestSuccessBlock)success failed:(HTTPRequestFailBlock)failed
{
    NSString *urlStr = @"https://c.gamehetu.com/stats/login";
    [HTNetWorking POST:urlStr paramString:paramestr ifSuccess:^(id response) {
        success(response);
        NSLog(@"yes,that is OK!");
        
    } failure:^(NSError *error) {
        failed(error);
        NSLog(@"error!!!");
    }];

}
@end
