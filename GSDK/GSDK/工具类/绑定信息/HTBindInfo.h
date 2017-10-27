//
//  HTBindInfo.h
//  GSDK
//
//  Created by 王璟鑫 on 16/8/23.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTBindInfo : NSObject


+(NSString*)returnHomeName:(NSDictionary*)dict;
+(BOOL)haveBindOfficalAccount;
+(BOOL)haveBindThridAccount;
+(NSDictionary*)showBindAccountName;


@end
