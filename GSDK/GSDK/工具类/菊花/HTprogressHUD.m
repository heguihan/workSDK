
//
//  HTprogressHUD.m
//  ChangedSDK
//
//  Created by 王璟鑫 on 16/4/13.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTprogressHUD.h"

@implementation HTprogressHUD

-(instancetype)initWithFrame:(CGRect)frame
{
    //重写初始化
    if (self=[super initWithFrame:frame])
    {
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}
+(instancetype)defaultJuhua
{
    static HTprogressHUD*juhua=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        juhua=[[HTprogressHUD alloc]initWithFrame:MXApplication.windows[0].bounds];
    });
    return juhua;
}
+(void)showjuhuaText:(NSString*)text
{
    [[self defaultJuhua]showHUDText:text];
}
- (void)showHUDText:(NSString*)text{
    //加载背景(大方框)
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 5;
    
    //加载视图(旋转的图片)
    UIImageView * loadingImg = [[UIImageView alloc] initWithFrame:CGRectMake((bgView.frame.size.width-60)*0.5, 10, 60, 60)];
    loadingImg.image = imageNamed(@"等待条");
    loadingImg.layer.masksToBounds = YES;
    loadingImg.layer.cornerRadius = loadingImg.frame.size.width/2;
    
    //提示文字
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, loadingImg.bottom+5, bgView.width, bgView.height-loadingImg.height-10-5)];
    label.textAlignment=NSTextAlignmentCenter;
    label.text=text;
    
    [bgView addSubview:label];
    //旋转动画
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 0;
    rotationAnimation.speed = 0.2;
    rotationAnimation.cumulative = YES;
    //后台进前台动画重启
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.repeatCount = MAXFLOAT;
    [loadingImg.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];

    
    //设置视图属性
    [bgView addSubview:loadingImg];
    //    loadingImg.center = bgView.center;
    //    [bgView addSubview:centerImg];
    //    centerImg.center = bgView.center;
    //放在当前视图上 最后设置bgView的位置
    bgView.center = self.center;
    [self addSubview:bgView];
    //将当前视图放在需要的视图上
    [MXApplication.keyWindow addSubview:self];
}
+ (void)hiddenHUD{
    [[self defaultJuhua] removeFromSuperview];

}

@end
