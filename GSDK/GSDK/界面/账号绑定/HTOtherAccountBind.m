//
//  HTOtherAccountBind.m
//  GSDK
//
//  Created by 王璟鑫 on 16/8/15.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//
#import "HTPhoneLogin.h"
#import "HTOtherAccountBind.h"
#import "HTbindButtonView.h"
#import "FacebookLogin.h"
#import "HTAddBindInfoTodict.h"
#import <GoogleSignIn/GoogleSignIn.h>
#import <GameKit/GameKit.h>

#define MAINVIEW_HEIGHT MAINVIEW_WIDTH*(400/550.0)


@interface HTOtherAccountBind ()<GIDSignInUIDelegate,GIDSignInDelegate>
@property (nonatomic,strong)HTPhoneLogin*phone;
@end

@implementation HTOtherAccountBind

- (void)viewDidLoad {
    [super viewDidLoad];
}
-(instancetype)init
{
    if (self=[super init]) {
        self.mainView.frame=CGRectMake(SCREEN_WIDTH*BEGIN_MAINVIEW, (SCREEN_HEIGHT-MAINVIEW_HEIGHT)/2, MAINVIEW_WIDTH, MAINVIEW_HEIGHT);
        self.backImageView.image=imageNamed(@"底板_2");
        self.backImageView.frame=self.mainView.bounds;
        self.titleLabel.text=bendihua(@"其他账号绑定");
        [GIDSignIn sharedInstance].uiDelegate = self;
        [GIDSignIn sharedInstance].delegate=self;
        [self configUI];
    }
    return self;
}
-(void)configUI
{
    HTBaseLabel*tipLabel=[[HTBaseLabel alloc]init];
    tipLabel.frame=CGRectMake(23/500.0*MAINVIEW_WIDTH, 93/400.0*MAINVIEW_HEIGHT, 0, 0);
    [tipLabel setText:bendihua(@"注：每个游客只能绑定一个其他账号") font:MXSetSysFont(8) color:CRedColor sizeToFit:YES];
    [self.mainView addSubview:tipLabel];
    
    HTbindButtonView*phoneNum=[[HTbindButtonView alloc]init];
    phoneNum.frame = CGRectMake(0.09*MAINVIEW_WIDTH, 120/400.0*MAINVIEW_HEIGHT, 0.82*MAINVIEW_WIDTH, 50/400.0*MAINVIEW_HEIGHT);
    [phoneNum createView];
    phoneNum.leftLabel.text=bendihua(@"手机号码");
    phoneNum.centerLabel.text=bendihua(@"未绑定");
    [phoneNum.rightButton setTitle:bendihua(@"点击绑定") forState:(UIControlStateNormal)];
    [phoneNum.rightButton setBackgroundColor:CRedColor];
    [phoneNum.rightButton addTarget:self action:@selector(accountKitAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.mainView addSubview:phoneNum];

    
    HTbindButtonView*top=[[HTbindButtonView alloc]init];
   top.frame = CGRectMake(0.09*MAINVIEW_WIDTH, phoneNum.bottom+20/400.0*MAINVIEW_HEIGHT, 0.82*MAINVIEW_WIDTH, 50/400.0*MAINVIEW_HEIGHT);
    [top createView];
    top.leftLabel.text=bendihua(@"Facebook");
    top.centerLabel.text=bendihua(@"未绑定");
    [top.rightButton setTitle:bendihua(@"点击绑定") forState:(UIControlStateNormal)];
    [top.rightButton setBackgroundColor:CRedColor];
    [top.rightButton addTarget:self action:@selector(FacebookBind:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.mainView addSubview:top];

    
    HTbindButtonView*center=[[HTbindButtonView alloc]init];
    center.frame = CGRectMake(0.09*MAINVIEW_WIDTH, top.bottom+20/400.0*MAINVIEW_HEIGHT, 0.82*MAINVIEW_WIDTH, 50/400.0*MAINVIEW_HEIGHT);
    [center createView];
    center.leftLabel.text=bendihua(@"Google+");
    center.centerLabel.text=bendihua(@"未绑定");
    [center.rightButton setTitle:bendihua(@"点击绑定") forState:(UIControlStateNormal)];
    [center.rightButton setBackgroundColor:CRedColor];
    [center.rightButton addTarget:self action:@selector(GoogleBind:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.mainView addSubview:center];
    
    HTbindButtonView*down=[[HTbindButtonView alloc]init];
    down.frame = CGRectMake(0.09*MAINVIEW_WIDTH, center.bottom+20/400.0*MAINVIEW_HEIGHT, 0.82*MAINVIEW_WIDTH, 50/400.0*MAINVIEW_HEIGHT);
    [down createView];
    down.leftLabel.text=bendihua(@"Gamecenter");
    down.centerLabel.text=bendihua(@"未绑定");
    [down.rightButton setTitle:bendihua(@"点击绑定") forState:(UIControlStateNormal)];
    [down.rightButton setBackgroundColor:CRedColor];
    [down.rightButton addTarget:self action:@selector(GamecenterBind:) forControlEvents:(UIControlEventTouchUpInside)];

    [self.mainView addSubview:down];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark -- facebook绑定
-(void)FacebookBind:(HTBaseButton*)sender
{
    
    [FacebookLogin getFacebookInfoIfSuccess:^{
        [HTHUD showHUD:bendihua(@"绑定成功")];
            [self.navigationController popViewControllerAnimated:YES];
    }];
}
#pragma mark --手机号绑定
-(void)accountKitAction:(HTBaseButton*)sender
{
//改改改aaa 手机号绑定
//    account/bind
//    待定
    self.phone=[[HTPhoneLogin alloc]init];
   [self.phone loginWithPhoneNumber:self ifSuccess:^(id data) {
       NSString*appID=[USER_DEFAULT objectForKey:@"appID"];
       NSDictionary*userDic = [USER_DEFAULT objectForKey:@"userInfo"];
       NSString*dataStr=[NSString stringWithFormat:@"type=accountkit&auth=%@&name=%@&token=%@",data[@"id"],data[@"phone"],[userDic valueForKeyPath:@"data.token"]];
       NSString*RSADataStr=[RSA encryptString:dataStr];
       NSString*urlStr=[NSString stringWithFormat:@"http://c.gamehetu.com/passport/bind?app=%@&data=%@&format=json&version=2.0",appID,RSADataStr];
       NSURL*url=[NSURL URLWithString:urlStr];
       NSMutableURLRequest*requestq=[NSMutableURLRequest requestWithURL:url];
       [HTNetWorking sendRequest:requestq ifSuccess:^(id response) {
           
           if ([response[@"code"] isEqualToNumber:@0]) {
               [HTAddBindInfoTodict addInfoToDictType:@"accountkit" auth_name:data[@"phone"]];
               [HTHUD showHUD:bendihua(@"绑定成功")];

                   [self.navigationController popViewControllerAnimated:NO];
               
           }else if([response[@"code"] isEqualToNumber:@1])
           {
               [HTAlertView showAlertViewWithText:bendihua(@"绑定失败,该账号已绑定过") com:nil];
               
           }else
           {
               [HTAlertView showAlertViewWithText:bendihua(@"綁定失败") com:nil];
           }
           
       } failure:^(NSError *error) {
           
       }];

   } orFailure:^{
       
   } typeIs:@"bind"];
}
- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error
{
    [HTConnect shareConnect].mywindow.windowLevel=UIWindowLevelAlert+1;

    if (error) {
        [[GIDSignIn sharedInstance] signOut];
        
    }else
    {
//改改改aaa谷歌绑定
        NSString*appID=[USER_DEFAULT objectForKey:@"appID"];
        NSDictionary*userDic = [USER_DEFAULT objectForKey:@"userInfo"];
        
        NSString *newUrlStr = [NSString stringWithFormat:@"%@%@",SERVER_URL,BIND_URL];
        NSString *pram_access_token =[userDic valueForKeyPath:@"data.token"];
        NSString *pram_platform = @"google";
        NSString *pram_code = @"待定";
        NSString *newPramStr = [NSString stringWithFormat:@"ccess_token=%@&platform=%@&code=%@",pram_access_token, pram_platform, pram_code];
        NSString *urlStr = [NSString stringWithFormat:@"%@?%@",newUrlStr, newPramStr];
        
        
//        NSString*dataStr=[NSString stringWithFormat:@"type=google&auth=%@&name=%@&token=%@",[GIDSignIn sharedInstance].currentUser.profile.email,[regex deleUrlBugChar:[GIDSignIn sharedInstance].currentUser.profile.name],[userDic valueForKeyPath:@"data.token"]];
//        NSString*RSADataStr=[RSA encryptString:dataStr];
//        NSString*urlStr=[NSString stringWithFormat:@"http://c.gamehetu.com/passport/bind?app=%@&data=%@&format=json&version=2.0",appID,RSADataStr];
        
        
        
        NSURL*url=[NSURL URLWithString:urlStr];
        NSMutableURLRequest*requestq=[NSMutableURLRequest requestWithURL:url];
        [HTNetWorking sendRequest:requestq ifSuccess:^(id response) {
            
            if ([response[@"code"] isEqualToNumber:@0]) {
                [HTAddBindInfoTodict addInfoToDictType:@"google" auth_name:[GIDSignIn sharedInstance].currentUser.profile.name];
                [HTHUD showHUD:bendihua(@"绑定成功")];
                
                    [self.navigationController popViewControllerAnimated:NO];
                    

            }else if([response[@"code"] isEqualToNumber:@1])
            {
                [HTAlertView showAlertViewWithText:bendihua(@"绑定失败,该账号已绑定过") com:nil];
                
            }else
            {
                [HTAlertView showAlertViewWithText:bendihua(@"綁定失败") com:nil];
            }
            
        } failure:^(NSError *error) {
            
        }];
    }
}
-(void)GoogleBind:(HTBaseButton*)sender
{
    [HTConnect shareConnect].mywindow.windowLevel=UIWindowLevelNormal;
    [[GIDSignIn sharedInstance] signIn];
    
}
-(void)GamecenterBind:(HTBaseButton*)sender
{
    [self authenticateLocalPlayer];

}
- (void) authenticateLocalPlayer
{
    
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    static  UIViewController*con;
    if([[HTConnect shareConnect].gameCenterLoginType isEqualToString:@"error"])
    {
        
        [HTprogressHUD hiddenHUD];
        if ([UIDevice currentDevice].systemVersion.floatValue>=10.0) {
            [HTAlertView showAlertViewWithText:bendihua(@"iOS 10使用者需要手动到设置里面登录游戏中心") com:nil];
        }else
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"gamecenter:"]];
        }
    }else if (localPlayer.authenticated) {
        
        [self appleBind];
    }else{
        
        [HTprogressHUD showjuhuaText:bendihua(@"正在绑定")];
        
        //    __weak typeof (self)weakSelf = self;
        [localPlayer setAuthenticateHandler:                                                                                                 (^(UIViewController* viewcontroller, NSError *error) {
            
            [HTprogressHUD hiddenHUD];
            
            if (!error && viewcontroller)
            {
                
                con=viewcontroller;
                [self presentViewController:viewcontroller animated:YES completion:nil];
            }
            else if (error == nil&&viewcontroller==nil) {
                
                    [self appleBind];
                
                
            }else if(error) {
                [HTConnect shareConnect].gameCenterLoginType=@"error";
                
            }else
            {
                NSLog(@"");
            }
        })];
    }}
-(void)appleBind
{
//改改改aaa apple绑定
    
        NSString*appID=[USER_DEFAULT objectForKey:@"appID"];
        NSDictionary*userDic = [USER_DEFAULT objectForKey:@"userInfo"];
    NSString*dataStr=[NSString stringWithFormat:@"type=apple&auth=%@&name=%@&token=%@",[GKLocalPlayer localPlayer].playerID,
                      [regex deleUrlBugChar:[GKLocalPlayer localPlayer].alias],[userDic valueForKeyPath:@"data.token"]];
        NSString*RSADataStr=[RSA encryptString:dataStr];
        NSString*urlStr=[NSString stringWithFormat:@"http://c.gamehetu.com/passport/bind?app=%@&data=%@&format=json&version=2.0",appID,RSADataStr];
        NSURL*url=[NSURL URLWithString:urlStr];
        NSMutableURLRequest*requestq=[NSMutableURLRequest requestWithURL:url];
        [HTNetWorking sendRequest:requestq ifSuccess:^(id response) {
            
            if ([response[@"code"] isEqualToNumber:@0]) {
                [HTAddBindInfoTodict addInfoToDictType:@"apple" auth_name:[GKLocalPlayer localPlayer].alias];
                [HTHUD showHUD:bendihua(@"绑定成功")];
                
                    [self.navigationController popViewControllerAnimated:NO];

            }else if([response[@"code"] isEqualToNumber:@1])
            {
                [HTAlertView showAlertViewWithText:bendihua(@"绑定失败,该账号已绑定过") com:nil];
                
            }else
            {
                [HTAlertView showAlertViewWithText:bendihua(@"綁定失败") com:nil];
            }
            
        } failure:^(NSError *error) {
        }];
}

@end
