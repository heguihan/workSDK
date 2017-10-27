//
//  HTpresentWindow.m
//  GSDK
//
//  Created by 王璟鑫 on 2016/11/28.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTpresentWindow.h"

@implementation HTpresentWindow
+(instancetype)sharedInstance
{
    static HTpresentWindow*window=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        window=[[HTpresentWindow alloc]init];
    });
    window.windowLevel = UIWindowLevelAlert;
    window.hidden=NO;
    [window makeKeyAndVisible];
    //移除所有的subview
    [window.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    return window;
}
-(instancetype)init
{
    self=[super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.windowLevel = UIWindowLevelAlert;
        [self makeKeyAndVisible];
    }
    return self;
}
+(void)dismissPresentWindow
{
    [HTpresentWindow sharedInstance].hidden=YES;
}
@end
