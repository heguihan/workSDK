//
//  HTpresentWindow.h
//  GSDK
//
//  Created by 王璟鑫 on 2016/11/28.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTpresentWindow : UIWindow
+(instancetype)sharedInstance;
+(void)dismissPresentWindow;
@end
