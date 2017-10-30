//
//  HTAccountController.m
//  GSDK
//
//  Created by 王璟鑫 on 16/8/5.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTAccountController.h"
#import "HTbindButtonView.h"
#import "HTOtherAccountBind.h"
#import "HTAccountBind.h"
#import "HTChangeAccountList.h"
#import "HTBindInfo.h"
#import "HTRevisePasswordController.h"
#define MAINVIEW_HEIGHT MAINVIEW_WIDTH*(400/550.0)
@interface HTAccountController ()

@property (nonatomic,strong) HTBaseLabel *logInNameAndImage;

@property (nonatomic,strong) UIView *topView;

@property (nonatomic,strong) UIView *bottomView;

@property (nonatomic,strong) HTBaseButton *changeAccountButton;

@property (nonatomic,strong) HTBaseLabel*label;

@property (nonatomic,strong) UIImageView*loginImage;

@property (nonatomic,strong) HTBaseLabel*leftLabel;

@property (nonatomic,strong) HTbindButtonView*topBackView;

@property (nonatomic,strong) HTBaseLabel*centerLabel;

@property (nonatomic,strong)HTbindButtonView*bottomBackView;



@end

@implementation HTAccountController

- (void)viewDidLoad {

    [super viewDidLoad
     
     ];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.view setNeedsLayout];
    [self configUI];

}
-(instancetype)init
{
    if (self=[super init]) {
        
        self.mainView.frame=CGRectMake(SCREEN_WIDTH*BEGIN_MAINVIEW, (SCREEN_HEIGHT-MAINVIEW_HEIGHT)/2, MAINVIEW_WIDTH, MAINVIEW_HEIGHT);
        self.backImageView.image=imageNamed(@"底板_2");
        self.backImageView.frame=self.mainView.bounds;
        self.titleLabel.text=bendihua(@"账号中心");
    }
    return self;
}
-(void)configUI
{
    [self makeLogInNameAndImageLabel];
    NSString *token = [USER_DEFAULT objectForKey:@"access_token"];
    NSLog(@"token=%@",token);
    [HTLoginSuccess loginSuccessWithtoken:token];
}
-(void)makeLogInNameAndImageLabel
{
    
    NSDictionary*showDict= [HTBindInfo showBindAccountName];
    NSLog(@"dict=%@",showDict);
    
    UIImage*qudaoImage;
    NSString*leftStr;
    if ([[showDict allKeys] containsObject:@"image"])
    {
        qudaoImage=showDict[@"image"];
        
    }else
    {

            leftStr=bendihua(@"游客账号:");

    }
//改改改aaa显示界面
    
    NSString* textStr=showDict[@"name"];
    NSLog(@"===============分割线===================");
    NSLog(@"name====%@",textStr);
    NSLog(@"===============分割线===================");
    if (!self.label) {
        self.label=[[HTBaseLabel alloc]init];
            }
    [self.label setText:textStr font:MXSetSysFont(9) color:CRedColor sizeToFit:YES];
    if (qudaoImage) {
        if (!self.loginImage) {
            self.loginImage=[[UIImageView alloc]init];
        }
        self.loginImage.image=qudaoImage;
        self.loginImage.frame=CGRectMake(23/500.0*MAINVIEW_WIDTH, 87/400.0*MAINVIEW_HEIGHT,15 , 15);
        [self.mainView addSubview:self.loginImage];
        self.label.centerY=self.loginImage.centerY;
        self.label.left=self.loginImage.right+5;
        self.label.width=self.mainView.width-self.loginImage.right-10;
        [self.mainView addSubview:self.label];

    }else
    {
        if (!self.leftLabel) {
            self.leftLabel=[[HTBaseLabel alloc]init];

        }
        [self.leftLabel setText:leftStr font:MXSetSysFont(9) color:CRedColor sizeToFit:YES];
        self.leftLabel.frame=CGRectMake(23/500.0*MAINVIEW_WIDTH, 87/400.0*MAINVIEW_HEIGHT, self.leftLabel.width, self.leftLabel.height);
        [self.mainView addSubview:self.leftLabel];
        self.label.centerY=self.leftLabel.centerY;
        self.label.left=self.leftLabel.right+3;
        self.label.width=self.mainView.width-self.leftLabel.right-8;
        [self.mainView addSubview:self.label];

    }
    
    
    
    
    if (!self.topBackView) {
        self.topBackView=[[HTbindButtonView alloc]init];
    }
    self.topBackView.frame=CGRectMake(0.09*MAINVIEW_WIDTH, 140/400.0*MAINVIEW_HEIGHT, 0.82*MAINVIEW_WIDTH, 50/400.0*MAINVIEW_HEIGHT);
            [self.topBackView createView];
    
    if ([HTBindInfo haveBindOfficalAccount]) {
        self.topBackView.centerLabel.text=bendihua(@"已绑定");
        [self.topBackView.rightButton setTitle:bendihua(@"修改密码") forState:(UIControlStateNormal)];
    }else
    {
        self.topBackView.centerLabel.text=bendihua(@"未绑定");
        [self.topBackView.rightButton setTitle:bendihua(@"点击绑定") forState:(UIControlStateNormal)];
    }
     [self.topBackView.rightButton addTarget:self action:@selector(accountBind:) forControlEvents:(UIControlEventTouchUpInside)];
    self.topBackView.leftLabel.text=bendihua(@"已绑定");
    [self.topBackView.rightButton setBackgroundColor:CRedColor];
    [self.mainView addSubview:self.topBackView];
    
    if (![HTBindInfo haveBindOfficalAccount]) {
        
        if (!self.centerLabel) {
            self.centerLabel=[[HTBaseLabel alloc]init];
        }
        [self.centerLabel setText:bendihua(@"绑定官方账号,获得价值10$大礼包") font:MXSetSysFont(9) color:CRedColor sizeToFit:YES];
        self.centerLabel.left=self.topBackView.left;
        self.centerLabel.centerY=self.topBackView.bottom+22/400.0*MAINVIEW_HEIGHT;
        [self.mainView addSubview:self.centerLabel];
    }
    
    
    if (!self.bottomBackView) {
        self.bottomBackView=[[HTbindButtonView alloc]init];
    }
    self.bottomBackView.frame=CGRectMake(self.topBackView.left, self.topBackView.bottom+44/400.0*MAINVIEW_HEIGHT, self.topBackView.width, self.topBackView.height);
    
        [self.bottomBackView createView];
    
    self.bottomBackView.leftLabel.text=bendihua(@"其他账号:");
    
    if([HTBindInfo haveBindThridAccount])
    {
        self.bottomBackView.centerLabel.text=bendihua(@"已绑定");
        [self.bottomBackView.rightButton setTitle:bendihua(@"已绑定") forState:(UIControlStateNormal)];
        [self.bottomBackView.rightButton setBackgroundColor:MXRGBColor(136, 136, 136)];
    }else
    {
        NSDictionary*dict=[USER_DEFAULT objectForKey:@"userInfo"];
        NSArray*arr=[[dict valueForKeyPath:@"data.bind"] allKeys];
        self.bottomBackView.centerLabel.text=bendihua(@"未绑定");

        if ([arr containsObject:@"email"]||arr.count==0) {
            [self.bottomBackView.rightButton setTitle:bendihua(@"未绑定") forState:(UIControlStateNormal)];
            [self.bottomBackView.rightButton setBackgroundColor:MXRGBColor(136, 136, 136)];

        }else
        {
        
    [self.bottomBackView.rightButton setTitle:bendihua(@"点击绑定") forState:(UIControlStateNormal)];
    [self.bottomBackView.rightButton addTarget:self action:@selector(otherAccountBind:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.bottomBackView.rightButton setBackgroundColor:CGreenColor];
        }
    }
    [self.mainView addSubview:self.bottomBackView];
    
    HTBaseButton*changeAccountButton;
    if (!changeAccountButton) {
        changeAccountButton=[HTBaseButton buttonWithType:(UIButtonTypeCustom)];
    }
    [changeAccountButton setTitle:bendihua(@"切换账号") font:MXSetSysFont(11) backColor:CRedColor corner:4];
    changeAccountButton.frame=CGRectMake(0,self.bottomBackView.bottom+0.1*MAINVIEW_HEIGHT, 0.45*MAINVIEW_WIDTH, 46/400.0*MAINVIEW_HEIGHT);
    changeAccountButton.centerX=self.mainView.width/2;
    [changeAccountButton addTarget:self action:@selector(changeAccount:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.mainView addSubview:changeAccountButton];
}
-(void)accountBind:(UIButton*)sender
{
    if ([self.topBackView.rightButton.currentTitle isEqualToString:bendihua(@"修改密码")]) {
        HTRevisePasswordController*con=[[HTRevisePasswordController alloc]init];
        [self.navigationController pushViewController:con animated:NO];
    }else
    {
    HTAccountBind*AccountBind=[[HTAccountBind alloc]init];
    [self.navigationController pushViewController:AccountBind animated:NO];
    }
}
-(void)otherAccountBind:(UIButton*)sender
{
    if ([self.bottomBackView.rightButton.currentTitle isEqualToString:bendihua(@"已绑定")]) {

        return;
        
    }
    HTOtherAccountBind*bindAccount=[[HTOtherAccountBind alloc]init];
    [self.navigationController pushViewController:bindAccount animated:NO];

}
-(void)changeAccount:(UIButton*)sender
{
    
    HTChangeAccountList*change=[[HTChangeAccountList alloc]init];
    [self.navigationController pushViewController:change animated:YES];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self.loginImage removeFromSuperview];
    [self.centerLabel removeFromSuperview];
    [self.leftLabel removeFromSuperview];
    [self.topBackView removeFromSuperview];
    [self.bottomBackView removeFromSuperview];
}
@end
