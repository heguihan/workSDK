//
//  HTNetwork.h
//  GSDK
//
//  Created by 何圭韩 on 2017/10/20.
//  Copyright © 2017年 王璟鑫. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HTNetWorking.h"
#import "HTloginHelp.h"
#import "url.h"
typedef void(^HTTPRequestSuccessBlock)(id responserData);
typedef void(^HTTPRequestFailBlock)(NSError *failedError);

@interface HTNetwork : NSObject

//统计接口

+(void)NetworkStatistics:(NSString*)paramestr success:(HTTPRequestSuccessBlock)success failed:(HTTPRequestFailBlock)failed;


@end
