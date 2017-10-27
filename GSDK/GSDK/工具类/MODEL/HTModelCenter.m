//
//  HTModelCenter.m
//  GSDK
//
//  Created by 王璟鑫 on 16/8/19.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTModelCenter.h"

@implementation HTModelCenter
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.uid=value;
    }
}
@end
