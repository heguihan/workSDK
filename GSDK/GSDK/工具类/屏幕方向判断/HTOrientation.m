//
//  HTOrientation.m
//  GSDK
//
//  Created by 王璟鑫 on 16/8/23.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTOrientation.h"

@implementation HTOrientation

+(CGFloat)getMainWidth
{
    
    CGFloat WIDTH;
    
    if (IS_IPAD) {
        
        if([self hengPing])
        {
            
            if (IsIOS7) {
                WIDTH=[UIScreen mainScreen].bounds.size.height;
                
                return (WIDTH*0.45);
                
            }else
            {
                WIDTH=[UIScreen mainScreen].bounds.size.width;
                return (WIDTH*0.45);
              
            }
    
        }else
        {
            WIDTH=[UIScreen mainScreen].bounds.size.width;
            return (WIDTH*0.5);
            
        }
        
    }else
    {
        if ([self hengPing]) {
            
            if (IsIOS7) {
                WIDTH=[UIScreen mainScreen].bounds.size.height;
                return (WIDTH*0.5);
                
            }else
            {
                WIDTH=[UIScreen mainScreen].bounds.size.width;
                return (WIDTH*0.5);
                
            }
            
        }else
        {
            WIDTH=[UIScreen mainScreen].bounds.size.width;
            return (WIDTH*0.86);
            
        }
       

    }

    return 0;
    
}
+(CGFloat)getBeginWidth
{
    if (IS_IPAD) {
        
        if([self hengPing])
        {
            return 0.275;
        }else
        {
            return 0.25;
        }
    }else
    {
        if ([self hengPing]) {
            return 0.25;
        }else
        {
            return 0.07;
        }
}
    
    return 0;
    
}


+(BOOL)hengPing
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication]statusBarOrientation];
    
    
    switch (orientation) {
        
        case UIDeviceOrientationPortrait:
            return  NO;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            return  NO;
            break;
        case UIDeviceOrientationLandscapeLeft:
            return  YES;
            break;
        case UIDeviceOrientationLandscapeRight:
            return YES;
            break;
        default:
            break;
    }
    
    return NO;
}

@end
