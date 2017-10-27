//
//  HTPassValueSingle.m
//  GSDK
//
//  Created by 王璟鑫 on 16/10/18.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTPassValueSingle.h"

@implementation HTPassValueSingle
+(instancetype)sharePassValue
{
    static HTPassValueSingle*single=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        single=[[HTPassValueSingle alloc]init];
    });
    return single;
}
@end
