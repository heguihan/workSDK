//
//  HTNetWorking.h
//  GSDK
//
//  Created by 王璟鑫 on 16/8/9.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTNetWorking : NSObject
+(void)POST:(NSString*)URL paramString:(NSString*)paramString ifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure;
+(void)sendRequest:(NSMutableURLRequest*)request ifSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure;

+(void)NetworkRequestEmailCode:(NSDictionary *)signupEmailDic ifSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure;

@end
