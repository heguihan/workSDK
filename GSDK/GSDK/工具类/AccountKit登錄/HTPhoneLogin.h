//
//  HTPhoneLogin.h
//  NEWFacebookSDK
//
//  Created by 王璟鑫 on 16/10/17.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef void(^success)(id data);
typedef void(^failure)();

@interface HTPhoneLogin : NSObject

-(void)loginWithPhoneNumber:(UIViewController*)con ifSuccess:(success)Success orFailure:(failure)Failure typeIs:(NSString*)type;


@end
