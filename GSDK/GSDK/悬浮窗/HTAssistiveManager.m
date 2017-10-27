//
//  HTAssistiveManager.m
//  GSDK
//
//  Created by 王璟鑫 on 2017/3/14.
//  Copyright © 2017年 王璟鑫. All rights reserved.
//

#import "HTAssistiveManager.h"

@implementation HTAssistiveManager


+ (instancetype)shareAssistiveManager
{
    static HTAssistiveManager *manager;
    
    static dispatch_once_t *onceToken;
    dispatch_once(onceToken, ^{
        manager = [[HTAssistiveManager alloc]init];
    });
    return manager;
    
}

@end
