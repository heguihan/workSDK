//
//  HTLoginManager.m
//  GSDK
//
//  Created by 王璟鑫 on 2017/4/10.
//  Copyright © 2017年 王璟鑫. All rights reserved.
//

#import "HTLoginManager.h"
#import "HTpresentWindow.h"
#import "HTAssistiveTouch.h"
#import "HTConnect.h"

@implementation HTLoginManager

+(instancetype)sharedInstance
{
    static HTLoginManager *manager=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[[HTLoginManager alloc]init];
    });


    return manager;
}

+(void)loginRetuen
{
    
    BOOL test = [HTLoginManager sharedInstance].isGoingOnline;
    
    if (!test) {
            [HTConnect shareConnect].mywindow.hidden = YES;
    }
    
    NSLog(@"ok sssaaa");
//    [HTpresentWindow dismissPresentWindow];
//    [HTAssistiveTouch hiddenWindow];
//    [HTConnect shareConnect].mywindow.hidden = YES;
}


@end
