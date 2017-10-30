//
//  HTLoginSuccess.m
//  GSDK
//
//  Created by 王璟鑫 on 2017/10/30.
//  Copyright © 2017年 王璟鑫. All rights reserved.
//

#import "HTLoginSuccess.h"

@implementation HTLoginSuccess

+(void)loginSuccessWithtoken:(NSString *)token
{
    NSMutableURLRequest *request;
    NSLog(@"登录成功后的操作");
    NSString *newPramStr = [NSString stringWithFormat:@"access_token=%@",token];
    NSLog(@"token=%@",token);
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SERVER_URL, INFO_URL];
    NSString *newUrlStr = [NSString stringWithFormat:@"%@?%@",urlStr,newPramStr];
    NSURL *url = [NSURL URLWithString:[newUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"request=%@",newUrlStr);
    //简历网络请求体
    request=[NSMutableURLRequest requestWithURL:url];
    [HTNetWorking sendRequest:request ifSuccess:^(id response) {
        NSLog(@"success=");
        if ([response[@"code"]isEqualToNumber:@0]){
            NSLog(@"success=%@",response);
        }else
        {
            NSLog(@"what=%@",response);
        }
    } failure:^(NSError *error) {
        NSLog(@"error");
    }];
    
    
}

@end
