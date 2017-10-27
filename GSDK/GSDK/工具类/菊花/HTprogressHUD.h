//
//  HTprogressHUD.h
//  ChangedSDK
//
//  Created by 王璟鑫 on 16/4/13.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTprogressHUD : UIView
+(instancetype)defaultJuhua;
+(void)showjuhuaText:(NSString*)text;
+ (void)hiddenHUD;
@end
