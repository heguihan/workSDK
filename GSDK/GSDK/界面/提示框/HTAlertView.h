//
//  HTAlertView.h
//  GSDK
//
//  Created by 王璟鑫 on 16/8/17.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTAlertView : UIWindow
@property (nonatomic, copy) void(^block)();

+(void)showAlertViewWithText:(NSString*)text com:(void(^)())com;
@end
