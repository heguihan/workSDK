//
//  HTChangeAccountController.m
//  GSDK
//  Created by 王璟鑫 on 16/8/16.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTChangeAccountController.h"
#import "HTTextField.h"
#import "HTNameAndRequestModel.h"
#import "HTAlertView.h"
#import "HTRegisterController.h"
#import "HTloginHelp.h"
#import "HTforgetPasswordController.h"
#import "HTLoginManager.h"

#define MAINVIEW_HEIGHT MAINVIEW_WIDTH*(400/550.0)

@interface HTChangeAccountController ()
{
    HTTextField*top;
    HTTextField*bottom;
}
@end

@implementation HTChangeAccountController

- (void)viewDidLoad {
    [super viewDidLoad];
}
-(instancetype)init
{
    if (self=[super init]) {
        self.mainView.frame=CGRectMake(SCREEN_WIDTH*BEGIN_MAINVIEW, (SCREEN_HEIGHT-MAINVIEW_HEIGHT)/2, MAINVIEW_WIDTH, MAINVIEW_HEIGHT);
        self.backImageView.image=imageNamed(@"底板_2");
        self.backImageView.frame=self.mainView.bounds;
        self.titleLabel.text=bendihua(@"账号登录");
        [self configUI];
    }
    return self;
}
-(void)configUI
{
    top=[[HTTextField alloc]init];
    top.frame = CGRectMake(0.09*MAINVIEW_WIDTH, 103/400.0*MAINVIEW_HEIGHT,0.82*MAINVIEW_WIDTH, 50/400.0*MAINVIEW_HEIGHT);
    top.placeholder=bendihua(@"请输入账号");
    [self.mainView addSubview:top];

    
    bottom=[[HTTextField alloc]init];
    bottom.frame = CGRectMake(0.09*MAINVIEW_WIDTH, top.bottom+32/400.0*MAINVIEW_HEIGHT, 0.82*MAINVIEW_WIDTH, 50/400.0*MAINVIEW_HEIGHT);
    bottom.clearButtonMode=YES;
    bottom.secureTextEntry=YES;
    bottom.placeholder=bendihua(@"请输入密码");

    [self.mainView addSubview:bottom];
    
    HTBaseButton*leftbutton=[HTBaseButton buttonWithType:(UIButtonTypeCustom)];
    leftbutton.frame=CGRectMake(bottom.left,bottom.bottom+56/400.0*MAINVIEW_HEIGHT, 110/400.0*MAINVIEW_WIDTH,50/400.0*MAINVIEW_HEIGHT);
    [leftbutton setTitle:bendihua(@"账号注册") font:MXSetSysFont(11) backColor:CRedColor corner:4];
    [leftbutton addTarget:self action:@selector(registerBUtton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.mainView addSubview:leftbutton];
    
    HTBaseButton*rightButton=[HTBaseButton buttonWithType:(UIButtonTypeCustom)];
    rightButton.frame=CGRectMake(bottom.right-110/400.0*MAINVIEW_WIDTH,bottom.bottom+56/400.0*MAINVIEW_HEIGHT, 110/400.0*MAINVIEW_WIDTH,50/400.0*MAINVIEW_HEIGHT);
    [rightButton setTitle:bendihua(@"登录") font:MXSetSysFont(11) backColor:CGreenColor corner:4];

    [rightButton addTarget:self action:@selector(loginButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.mainView addSubview:rightButton];

    
    HTBaseButton*forgetPassword=[HTBaseButton buttonWithType:(UIButtonTypeCustom)];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:bendihua(@"忘记密码")];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [str addAttribute:NSForegroundColorAttributeName value:CTextGrayColor range:strRange];
    [str addAttribute:NSUnderlineColorAttributeName
                    value:CTextGrayColor
                    range:strRange];
    
    [forgetPassword setAttributedTitle:str forState:UIControlStateNormal];
    forgetPassword.titleLabel.font=MXSetSysFont(10);
    [forgetPassword sizeToFit];
    forgetPassword.frame=CGRectMake(rightButton.right-forgetPassword.width,rightButton.bottom+ 8/400.0*MAINVIEW_HEIGHT , forgetPassword.width, forgetPassword.height);
    [forgetPassword addTarget:self action:@selector(forgetPasswordButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.mainView addSubview:forgetPassword];
    
}
-(void)forgetPasswordButtonAction:(HTBaseButton*)sender
{
    HTforgetPasswordController*con=[[HTforgetPasswordController alloc]init];
    [self.navigationController pushViewController:con animated:YES];

}
-(void)registerBUtton:(HTBaseButton*)sender
{
    HTRegisterController*registe=[[HTRegisterController alloc]init];
    [self.navigationController pushViewController:registe animated:NO];
    
}
-(void)loginButton:(HTBaseButton*)sender
{
//    
//    top.text = @"905966567@qq.com";
//    bottom.text = @"12345s6";
    
    if([top.text isEqualToString:@""]||[bottom.text isEqualToString:@""])
    {
        [HTAlertView showAlertViewWithText:bendihua(@"用户名或密码不能为空") com:nil];
        
    }else if (!(bottom.text.length>=6&&bottom.text.length<=16))
    {
        [HTAlertView showAlertViewWithText:bendihua(@"密码长度在6位至16位之间") com:nil];

    }else if (!(top.text.length>=6&&bottom.text.length<=32)){
        
        [HTAlertView showAlertViewWithText:bendihua(@"用户名长度在6位至32位之间") com:nil];
    }
    //用户名或密码是否为空
    else if (![regex validateUserName:top.text])
    {
     
        [HTAlertView showAlertViewWithText:bendihua(@"您輸入的用戶名包含非法字元，用戶名只能由字母、數位、底線組成") com:nil];
    }else
    {
//改改改aaa账号登录
         [HTprogressHUD showjuhuaText:bendihua(@"正在登录")];
        NSMutableURLRequest *request=[HTloginHelp returnRequest:[HTloginHelp returnLoginString] usernameTextField:top passwordTextField:bottom];
        [HTNetWorking sendRequest:request ifSuccess:^(id response) {
           
            if ([response[@"code"] isEqualToNumber:@0]) {
                [HTNameAndRequestModel setFastRequest:request AndNameFormdict:response];
                
                //账号登陆成功返回
                if ([self.changeType isEqualToNumber:@0]) {
                    
//                    NSString *str = response[@"data"][@"uid"];
                    NSString *str = response[@"open_id"];
                    NSLog(@"uid=%@",str);
                    [USER_DEFAULT setObject:str forKey:@"uid"];
                    //保存access_token
                    NSString *access_token = response[@"access_token"];
                    [USER_DEFAULT setObject:access_token forKey:@"access_token"];
                    [USER_DEFAULT synchronize];
                    
                 [HTConnect shareConnect].loginBackBlock(response,nil);
                    
                    [HTLoginManager loginRetuen];
                }else
                {
                   //切换账号
                    if ([HTConnect shareConnect].changeAccount) {
                        
                        
                        
                        NSDictionary *changDic = @{@"code":@2,@"msg":@"success"};
                        [HTConnect shareConnect].changePassword(changDic);

                        [HTConnect shareConnect].changeAccount(response,nil);
                    }
                    
                }
                
                [HTHUD showHUD:bendihua(@"登入成功")];
                    [HTpresentWindow dismissPresentWindow];
                    [HTConnect showAssistiveTouch];
                
        }else if ([response[@"code"]isEqualToNumber:@40101]){
            
            [HTAlertView showAlertViewWithText:bendihua(@"用户名或密码为空") com:nil];
            [HTprogressHUD hiddenHUD];
            
        }else if ([response[@"code"]isEqualToNumber:@40105])
         {
             [HTAlertView showAlertViewWithText:bendihua(@"用户名或密码错误") com:nil];
             [HTprogressHUD hiddenHUD];

         }else
         {
             [HTAlertView showAlertViewWithText:bendihua(@"登录失败") com:nil];
             [HTprogressHUD hiddenHUD];
         }
            
        } failure:^(NSError *error) {
            [HTprogressHUD hiddenHUD];
            
        }];
        
    }
}


-(void)dealloc
{
    
}
@end
