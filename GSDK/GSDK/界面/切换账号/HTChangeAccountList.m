//
//  HTChangeAccountList.m
//  GSDK
//
//  Created by 王璟鑫 on 16/8/16.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTChangeAccountList.h"
#import "HTNameAndRequestModel.h"
#import "HTChangeAccountController.h"
#import "FacebookLogin.h"
#import <GoogleSignIn/GoogleSignIn.h>
#import <GameKit/GameKit.h>
#import "FacebookLogin.h"
#import "HTPhoneLogin.h"



#define MAINVIEW_HEIGHT MAINVIEW_WIDTH*(470/550.0)

@interface HTChangeAccountList ()<GIDSignInUIDelegate,GIDSignInDelegate>
@property (nonatomic,strong)HTPhoneLogin*login;

@end

@implementation HTChangeAccountList

- (void)viewDidLoad {
    [super viewDidLoad];
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

//改改改aaa切换账号的谷歌登录

        [HTprogressHUD showjuhuaText:bendihua(@"正在登录")];
        
        //platform code app_id uuid adid device version channel ip
        
        NSString *pram_platform = @"google";
        NSString *pram_code = user.authentication.idToken;
        //        NSString *pram_app_id = [USER_DEFAULT objectForKey:@"appID"];
        NSString *pram_app_id = [USER_DEFAULT objectForKey:@"appID"];
        NSString *pram_uuid = GETUUID;
        NSString *pram_adid = [USER_DEFAULT objectForKey:@"adid"];
        //        NSString *pram_device = [HTgetDeviceName deviceString];
        NSString *pram_device = @"ios";
        NSString *pram_version = [USER_DEFAULT objectForKey:@"version"];
        NSString *pram_channel = [USER_DEFAULT objectForKey:@"channel"];
        NSString *pram_ip = GETIP;
//        NSString *pram_open_id = [GIDSignIn sharedInstance].currentUser.profile.email;
        //        NSString *pram_
        
        NSString *pram_open_id = user.userID;
        NSString *open_name = user.profile.name;
        NSString *pram_open_name = [open_name stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *pram_lang = [USER_DEFAULT objectForKey:@"lang"];
        
        NSString *newPramStr = [NSString stringWithFormat:@"platform=%@&access_token=%@&open_id=%@&app_id=%@&uuid=%@&adid=%@&device=%@&version=%@&channel=%@&ip=%@&open_name=%@&lang=%@",pram_platform, pram_code,pram_open_id, pram_app_id, pram_uuid, pram_adid, pram_device, pram_version, pram_channel, pram_ip, pram_open_name,pram_lang];
        
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",SERVER_URL, LOGIN_URL];
        
        NSString *newUrlStr = [NSString stringWithFormat:@"%@?%@",urlStr,newPramStr];
        NSLog(@"url=%@",newUrlStr);
        
//        NSString*str=[NSString stringWithFormat:@"username=%@#google&name=%@&uuid=%@&token=%@",[GIDSignIn sharedInstance].currentUser.userID,[GIDSignIn sharedInstance].currentUser.profile.name,[UUID getUUID],user.authentication.idToken];
//        NSString*rsaStr=[RSA encryptString:str];
//        NSString*urlStr=[NSString stringWithFormat:@"http://c.gamehetu.com/passport/login?app=%@&data=%@&format=json&version=2.0",[[NSUserDefaults standardUserDefaults]objectForKey:@"appID"],rsaStr];
        
        NSURL*url=[NSURL URLWithString:newUrlStr];
        NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:url];
        
        [HTNetWorking sendRequest:request ifSuccess:^(id response) {
            
            if ([response[@"code"] isEqualToNumber:@0]) {
                [HTConnect showAssistiveTouch];
                [HTNameAndRequestModel setFastRequest:request AndNameFormdict:response];
                NSDictionary*googleDic=[NSDictionary dictionaryWithObjectsAndKeys:[GIDSignIn sharedInstance].currentUser.profile.email, @"googleID",[GIDSignIn sharedInstance].currentUser.profile.name,@"googleName",user.authentication.idToken,@"googleToken",nil];
                
                //切换google账号登录成功返回
                
                NSString *str = response[@"open_id"];
                NSLog(@"uid=%@",str);
                [USER_DEFAULT setObject:str forKey:@"uid"];
                //保存access_token
                [USER_DEFAULT setObject:@"31" forKey:@"loginway"];
                NSString *access_token = response[@"access_token"];
                [USER_DEFAULT setObject:[regex deleUrlBugChar:[GIDSignIn sharedInstance].currentUser.profile.name] forKey:@"showname"];
                [USER_DEFAULT setObject:access_token forKey:@"access_token"];
                [USER_DEFAULT synchronize];
                
                [HTLoginSuccess loginSuccessWithtoken:access_token];
                
                NSDictionary *changDic = @{@"code":@2,@"msg":@"success"};
                [HTConnect shareConnect].changePassword(changDic);

                [HTConnect shareConnect].changeAccount(response,googleDic);

                [HTHUD showHUD:bendihua(@"登入成功")];
                [HTpresentWindow dismissPresentWindow];
                
            }else
            {
                [HTAlertView showAlertViewWithText:bendihua(@"登录失败") com:nil];
            }
        } failure:^(NSError *error) {
            
        }];
    }
    [[GIDSignIn sharedInstance] signOut];
}

-(instancetype)init
{
    if (self=[super init]) {
        self.mainView.frame=CGRectMake(SCREEN_WIDTH*BEGIN_MAINVIEW, (SCREEN_HEIGHT-MAINVIEW_HEIGHT)/2, MAINVIEW_WIDTH, MAINVIEW_HEIGHT);
        self.backImageView.image=imageNamed(@"底板_3");
        self.backImageView.frame=self.mainView.bounds;
        self.titleLabel.text=bendihua(@"账号切换");
        [self configUI];
    }
    return self;
}
-(void)configUI
{
    HTBaseLabel*titleLabel=[[HTBaseLabel alloc]init];
    titleLabel.frame=CGRectMake(0, 83/470.0*MAINVIEW_HEIGHT, 0, 0);
    [titleLabel setText:bendihua(@"请选择登录方式") font:MXSetSysFont(16) color:CRedColor sizeToFit:YES];
    titleLabel.centerX=MAINVIEW_WIDTH/2;
    [self.mainView addSubview:titleLabel];
    
    HTBaseButton*offical=[HTBaseButton buttonWithType:(UIButtonTypeCustom)];
    offical.frame=CGRectMake(0.09*MAINVIEW_WIDTH,135/470.0*MAINVIEW_HEIGHT, 0.82*MAINVIEW_WIDTH, 50/470.0*MAINVIEW_HEIGHT);
    [offical setTitle:bendihua(@"官方账号") font:MXSetSysFont(13) backColor:CGreenColor corner:4];
    [offical addTarget:self action:@selector(accountAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.mainView addSubview:offical];
    
    HTBaseButton*phoneNumber=[HTBaseButton buttonWithType:(UIButtonTypeCustom)];
    phoneNumber.frame=CGRectMake(0.09*MAINVIEW_WIDTH,offical.bottom+ 15/470.0*MAINVIEW_HEIGHT, 0.82*MAINVIEW_WIDTH, 50/470.0*MAINVIEW_HEIGHT);
    [phoneNumber setTitle:bendihua(@"手机账号") font:MXSetSysFont(13) backColor:CRedColor corner:4];
    [phoneNumber addTarget:self action:@selector(phoneNumberAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.mainView addSubview:phoneNumber];

    
    HTBaseButton*facebook=[HTBaseButton buttonWithType:(UIButtonTypeCustom)];
    facebook.frame=CGRectMake(0.09*MAINVIEW_WIDTH,phoneNumber.bottom+ 15/470.0*MAINVIEW_HEIGHT, 0.82*MAINVIEW_WIDTH, 50/470.0*MAINVIEW_HEIGHT);
    [facebook setTitle:bendihua(@"Facebook") font:MXSetSysFont(13) backColor:CRedColor corner:4];
    [facebook addTarget:self action:@selector(facebookAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.mainView addSubview:facebook];

    HTBaseButton*Google=[HTBaseButton buttonWithType:(UIButtonTypeCustom)];
    Google.frame=CGRectMake(0.09*MAINVIEW_WIDTH,facebook.bottom+15/470.0*MAINVIEW_HEIGHT, 0.82*MAINVIEW_WIDTH, 50/470.0*MAINVIEW_HEIGHT);
    [Google setTitle:bendihua(@"Google+") font:MXSetSysFont(13) backColor:CRedColor corner:4];
    [Google addTarget:self action:@selector(googleAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.mainView addSubview:Google];

    HTBaseButton*Gamecenter=[HTBaseButton buttonWithType:(UIButtonTypeCustom)];
    Gamecenter.frame=CGRectMake(0.09*MAINVIEW_WIDTH,Google.bottom+15/470.0*MAINVIEW_HEIGHT, 0.82*MAINVIEW_WIDTH, 50/470.0*MAINVIEW_HEIGHT);
    [Gamecenter setTitle:bendihua(@"Gamecenter") font:MXSetSysFont(13) backColor:CRedColor corner:4];
    [Gamecenter addTarget:self action:@selector(gamecenterAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.mainView addSubview:Gamecenter];
}
-(void)accountAction:(HTBaseButton*)sender
{
    HTChangeAccountController*account=[[HTChangeAccountController alloc]init];
    //记录切换账号界面是从哪里跳出
    account.changeType=@1;
    [self.navigationController pushViewController:account animated:YES];
    
}
-(void)facebookAction:(HTBaseButton*)sender
{
    [FacebookLogin logInIfSuccess:^(id response, NSDictionary *FacebookDict) {
        
        NSDictionary *changDic = @{@"code":@2,@"msg":@"success"};
        [HTConnect shareConnect].changePassword(changDic);

        
        [HTConnect shareConnect].changeAccount(response,FacebookDict);

[HTpresentWindow dismissPresentWindow];
    } failure:^(NSError *error) {
        
    }];

}
-(void)googleAction:(HTBaseButton*)sender
{
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].delegate=self;
    [[GIDSignIn sharedInstance] signIn];
[HTConnect shareConnect].mywindow.windowLevel=UIWindowLevelNormal;
}
-(void)gamecenterAction:(HTBaseButton*)sender
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
            //iOS10以前的系统内跳转
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"gamecenter:"]];
        }
        //gamecenter身份验证状态
    }else if (localPlayer.authenticated) {
        
        [self gameCenterLoginConnection];
    }else{
        
        [HTprogressHUD showjuhuaText:bendihua(@"正在登录")];
        
        
        [localPlayer setAuthenticateHandler:                                                                                                 (^(UIViewController* viewcontroller, NSError *error) {
            
            [HTprogressHUD hiddenHUD];
            
            
            if (!error && viewcontroller)
            {
                
                con=viewcontroller;
                [self presentViewController:viewcontroller animated:YES completion:nil];
            }
            else if (error == nil&&viewcontroller==nil) {
                
                
                    [self gameCenterLoginConnection];
                
                
            }else if(error) {
                NSLog(@"error=%@",error);
                [HTConnect shareConnect].gameCenterLoginType=@"error";
                
            }else
            {
                
            }
        })];
    }}
-(void)gameCenterLoginConnection
{
    
//改改改aaa 切换账号的gamecenter登录
//    NSString*str=[NSString stringWithFormat:@"username=%@#apple&name=%@&uuid=%@",
//                  [GKLocalPlayer localPlayer].playerID,
//                  [GKLocalPlayer localPlayer].alias,
//                  [UUID getUUID]];
//    
//    NSString*urlStr=[NSString stringWithFormat:@"app=%@&data=%@&format=json&version=2.0",
//                     [USER_DEFAULT objectForKey:@"appID"],
//                     [RSA encryptString:str]];
//    
//    NSString*mainStr=@"http://c.gamehetu.com/passport/login";
    
    
    NSString *pram_platform = @"gameCenter";
    NSString *pram_code = @"";
    //        NSString *pram_app_id = [USER_DEFAULT objectForKey:@"appID"];
    NSString *pram_app_id = [USER_DEFAULT objectForKey:@"appID"];
    NSString *pram_uuid = GETUUID;
    NSString *pram_adid = [USER_DEFAULT objectForKey:@"adid"];
    //        NSString *pram_device = [HTgetDeviceName deviceString];
    NSString *pram_device = @"ios";
    NSString *pram_version = [USER_DEFAULT objectForKey:@"version"];
    NSString *pram_channel = [USER_DEFAULT objectForKey:@"channel"];
    NSString *pram_ip = GETIP;
    NSString *pram_open_id = [GKLocalPlayer localPlayer].playerID;
    //        NSString *pram_
    NSString *open_name = [regex deleUrlBugChar:[GKLocalPlayer localPlayer].alias];
    NSString *pram_open_name = [open_name stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *pram_lang = [USER_DEFAULT objectForKey:@"lang"];
    
    NSString *newPramStr = [NSString stringWithFormat:@"platform=%@&access_token=%@&open_id=%@&app_id=%@&uuid=%@&adid=%@&device=%@&version=%@&channel=%@&ip=%@&open_name=%@&lang=%@",pram_platform, pram_code,pram_open_id, pram_app_id, pram_uuid, pram_adid, pram_device, pram_version, pram_channel, pram_ip, pram_open_name, pram_lang];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SERVER_URL, LOGIN_URL];

    
    //這是為了保存request準備的
    NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:(NSURLRequestUseProtocolCachePolicy) timeoutInterval:15];
    [request setHTTPMethod:@"POST"];
    
    NSData*paraData=[newPramStr dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:paraData];
    [HTNetWorking sendRequest:request ifSuccess:^(id response) {
    
        [HTprogressHUD hiddenHUD];
        
        if ([response[@"code"] isEqualToNumber:@0]) {
            [HTNameAndRequestModel setFastRequest:request AndNameFormdict:response];
            
            NSDictionary *changDic = @{@"code":@2,@"msg":@"success"};
            [HTConnect shareConnect].changePassword(changDic);
            
            NSString *str = response[@"open_id"];
            NSLog(@"uid=%@",str);
            [USER_DEFAULT setObject:str forKey:@"uid"];
            //保存access_token
            [USER_DEFAULT setObject:@"32" forKey:@"loginway"];
            NSString *access_token = response[@"access_token"];
             [USER_DEFAULT setObject:[regex deleUrlBugChar:[GKLocalPlayer localPlayer].alias] forKey:@"showname"];
            [USER_DEFAULT setObject:access_token forKey:@"access_token"];
//            [USER_DEFAULT setObject:@"apple" forKey:@"loginway"];
            //保存密码
//            NSLog(@"password=%@",password);
//            [USER_DEFAULT setObject:password forKey:@"password"];
            [USER_DEFAULT synchronize];
            [HTLoginSuccess loginSuccessWithtoken:access_token];
            
            
            [HTConnect shareConnect].changeAccount(response,nil);
            [HTConnect showAssistiveTouch];
            [HTHUD showHUD:bendihua(@"登入成功")];
          [HTpresentWindow dismissPresentWindow];
            
        }else{
            [HTAlertView showAlertViewWithText:bendihua(@"登录失败") com:nil];
        }
    } failure:^(NSError *error) {
    }];
}
-(void)phoneNumberAction:(HTBaseButton*)sender
{
    self.login=[[HTPhoneLogin alloc]init];
    [self.login loginWithPhoneNumber:self ifSuccess:^(id data) {
        NSDictionary *changDic = @{@"code":@2,@"msg":@"success"};
        [HTConnect shareConnect].changePassword(changDic);
       
[HTpresentWindow dismissPresentWindow];
    
    } orFailure:^{
        
    }typeIs:@""];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
