
//
//  HTHUD.m
//  GSDK
//
//  Created by 王璟鑫 on 2017/1/4.
//  Copyright © 2017年 王璟鑫. All rights reserved.
//

#import "HTHUD.h"

@interface HTHUD ()

@property (nonatomic,strong)UIView* backview;

@property (nonatomic,strong)UILabel*label;
@end

@implementation HTHUD
+(instancetype)shareHUD
{
    static HTHUD*hud=nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hud=[[HTHUD alloc]init];
        hud.windowLevel=UIWindowLevelAlert;
        hud.backview=[[UIView alloc]init];
        hud.label=[[UILabel alloc]init];
        [hud addSubview:hud.backview];
        [hud.backview addSubview:hud.label];
    });
    return  hud;
}

+(void)showHUD:(NSString*)string
{
    HTHUD*hud=[HTHUD shareHUD];
    hud.backview.frame=CGRectMake(0, 0, [HTHUD p_heightWithString:string]+30, 50);
    hud.label.text=string;
    [hud.label sizeToFit];
    hud.label.center=CGPointMake(hud.backview.width/2,hud.backview.height/2);
    hud.label.font=MXSetSysFont(13);
    hud.label.textColor=[UIColor whiteColor];
    hud.backview.backgroundColor=MXRGBColor(100, 100, 100);
    hud.frame=hud.backview.bounds;
    if (hud.width<80) {
        hud.width=80;
    }
    hud.rootViewController=[UIViewController new];
    hud.windowLevel=UIWindowLevelAlert;
    hud.center=CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/1.5);
    hud.layer.cornerRadius=hud.height/2;
    hud.layer.masksToBounds=YES;
    [hud makeKeyAndVisible];
    hud.alpha=0;
    [UIView animateWithDuration:0.4 animations:^{
        hud.alpha=1;
    } completion:^(BOOL finished) {
       
        [UIView animateWithDuration:1 animations:^{
            hud.alpha=0;
        } completion:^(BOOL finished) {
            [hud resignKeyWindow];
        }];
        
        
    }];
    
    
}
+(CGFloat)p_heightWithString:(NSString*)aString
{
    CGRect r= [aString boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 2000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0f]} context:nil];
    return r.size.width;
}
@end
