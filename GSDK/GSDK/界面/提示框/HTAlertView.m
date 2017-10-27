
//
//  HTAlertView.m
//  GSDK
//
//  Created by 王璟鑫 on 16/8/17.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTAlertView.h"
#import "MXCommonKit.h"
#import "HTBaseLabel.h"
#import "HTBaseButton.h"
#import "UIView+UIViewAdditional.h"

@interface HTAlertView()
@property (nonatomic,strong)UIView*backView;

@property (nonatomic,strong)HTBaseLabel*infoLabel;

@property (nonatomic,strong)HTBaseButton*OKButton;

@end

@implementation HTAlertView

+(instancetype)shareAlertView{
    static HTAlertView*alertview;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        alertview=[[HTAlertView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    });
    return alertview;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        self.windowLevel=UIWindowLevelAlert;
        self.rootViewController=[UIViewController new];
    }
    return self;
}

+(void)showAlertViewWithText:(NSString*)text com:(void(^)())com{
    HTAlertView*alert=[HTAlertView shareAlertView];
    alert.hidden=NO;
    if (!alert.backView) {
        alert.backView=[[UIView alloc]init];
    }
    alert.backView.frame=CGRectMake(SCREEN_WIDTH*BEGIN_MAINVIEW, 0, MAINVIEW_WIDTH, 150/550.0*MAINVIEW_WIDTH);
    alert.backView.center=alert.center;
    alert.backView.backgroundColor=CWhiteColor;
    alert.backView.layer.borderColor=CRedColor.CGColor;
    alert.backView.layer.borderWidth=1;
    [alert addSubview:alert.backView];
    
    if (!alert.infoLabel) {
    alert.infoLabel=[[HTBaseLabel alloc]init];
    }
    alert.infoLabel.frame=CGRectMake(20, 0, alert.backView.width-40, 0);
    
    [alert.infoLabel setText:text font:MXSetSysFont(13) color:CRedColor sizeToFit:NO];
    
    alert.infoLabel.numberOfLines=0;
    alert.infoLabel.textAlignment = NSTextAlignmentCenter;
    
    [alert.backView addSubview:alert.infoLabel];
    
    CGSize labelSize=[alert.infoLabel.text boundingRectWithSize:CGSizeMake(alert.backView.width-40, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: alert.infoLabel.font} context:nil].size;
    alert.infoLabel.height=labelSize.height;
    
    if (alert.infoLabel.height>25) {
        alert.backView.height+=20;
    }
    alert.backView.center=alert.center;
    alert.infoLabel.centerY=alert.backView.height/2;
    [HTAlertView shareAlertView].block=com;
    if (!alert.OKButton) {
    alert.OKButton=[[HTBaseButton alloc]init];
    }
    [alert.OKButton setTitle:bendihua(@"确认") font:MXSetSysFont(16) backColor:CRedColor corner:4];
    alert.OKButton.bounds=CGRectMake(0,0, 130/550.0*alert.backView.width, 50/550.0*alert.backView.width);
    alert.OKButton.left=alert.backView.right-alert.OKButton.width;
    alert.OKButton.top=alert.backView.bottom-alert.OKButton.height;
    [alert addSubview:alert.OKButton];
    
    [alert.OKButton addTarget:self action:@selector(hiddenAlertView:) forControlEvents:(UIControlEventTouchUpInside)];
    [alert makeKeyAndVisible];
    alert.alpha=0;
    [UIView animateWithDuration:0.3 animations:^{
        alert.alpha=1;
    }];
}
+(void)hiddenAlertView:(HTBaseButton*)sender
{
    HTAlertView*alert=[HTAlertView shareAlertView];
    alert.alpha=1;
    [UIView animateWithDuration:0.3 animations:^{
        alert.alpha=0;
    } completion:^(BOOL finished) {
        [alert resignKeyWindow];
        [alert setHidden:YES];
        
        if ([HTAlertView shareAlertView].block) {
            [HTAlertView shareAlertView].block();
        }
        
    }];
    
}
@end
