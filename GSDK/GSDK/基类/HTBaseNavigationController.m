//
//  HTBaseNavigationController.m
//  NSDK
//
//  Created by 王璟鑫 on 16/8/1.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTBaseNavigationController.h"

@interface HTBaseNavigationController ()

@end

@implementation HTBaseNavigationController


- (void)viewDidLoad {
    
    [super viewDidLoad];
}

-(instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    if (self=[super initWithRootViewController:rootViewController]) {
        
        //设置模态后不变黑
            //判断系统版本
        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
            
            self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
            self.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        }else{
            
            [UIApplication sharedApplication].keyWindow.rootViewController.modalPresentationStyle=UIModalPresentationCurrentContext;
            
        }
        
        //导航栏背景透明
        [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        [self.navigationBar setShadowImage:[[UIImage alloc] init]];
        

    }

    [HTConnect shareConnect].mywindow.userInteractionEnabled=NO;
    return self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    [super presentViewController:viewControllerToPresent animated:flag completion:^{
    
    }];
    
    
}
-(void)pushViewController:(HTBaseViewController *)viewController animated:(BOOL)animated
{
    self.navigationItem.hidesBackButton = YES;
    
    [super pushViewController:viewController animated:NO];
    
    CATransition *transition = [CATransition animation];
    
    transition.duration = 0.35;
    
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    transition.type = kCATransitionFade;
    
    transition.subtype = kCATransitionFromRight;
    
    [self.view.layer addAnimation:transition forKey:nil];
}
-(UIViewController*)popViewControllerAnimated:(BOOL)animated
{
    CATransition *transition = [CATransition animation];
    
    transition.duration = 0.35;
    
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    transition.type = kCATransitionFade;
    
    transition.subtype = kCATransitionFromLeft;
    
    [self.view.layer addAnimation:transition forKey:nil];
    
    return  [super popViewControllerAnimated:NO];
}

-(void)dealloc
{
    
    [HTConnect shareConnect].mywindow.userInteractionEnabled=YES;
    
}

@end
