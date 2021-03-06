//
//  HTFaseLoginViewController.m
//  GSDK
//
//  Created by 王璟鑫 on 16/8/4.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTFaseLoginViewController.h"
#import "HTNameAndRequestModel.h"
#import "HTChangeAccountController.h"
#import "FacebookLogin.h"
#import <GoogleSignIn/GoogleSignIn.h>
#import <GameKit/GameKit.h>
#import "HTPhoneLogin.h"

#import "HTLoginManager.h"

@interface HTFaseLoginViewController ()<GIDSignInUIDelegate,GIDSignInDelegate>

@property (nonatomic,strong) HTBaseButton*fastLoginButton;

@property (nonatomic,strong) HTBaseLabel*otherLoginWayLabel;

@property (nonatomic,strong) UIImageView*imageView;

@property (nonatomic,strong) HTPhoneLogin*login;

@property (nonatomic,strong) NSString*gameBug;//游戏中心自动调用bug解决

@end



@implementation HTFaseLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}
-(instancetype)init
{
    if (self=[super init]) {
    
        self.mainView.frame=CGRectMake(SCREEN_WIDTH*BEGIN_MAINVIEW,((SCREEN_HEIGHT-MAINVIEW_WIDTH*0.67)/2),MAINVIEW_WIDTH,MAINVIEW_WIDTH*0.67);
        
        self.backImageView.image=imageNamed(@"底板_1");
        self.backImageView.frame=self.mainView.bounds;
        self.titleLabel.text=@"登录";
        self.view.backgroundColor = [UIColor orangeColor];
        [self configUI];
}
    return self;
}
-(BOOL)isFirstLogin
{
    if ([USER_DEFAULT objectForKey:@"first"]) {
        return NO;
    }else
    {
        return YES;
    }
}

-(void)configUI
{
    [self setFastLoginButton];
    [self setOtherLoginWayLabel];
    [self setOtherLoginButton];
}
-(void)setFastLoginButton
{
    self.fastLoginButton=[HTBaseButton buttonWithType:(UIButtonTypeCustom)];
    
    self.fastLoginButton.frame=CGRectMake(25,self.mainView.height*(130/370.0), self.mainView.width-50, self.mainView.height*(80/370.0));
    
    HTBaseLabel*inforLabel=[[HTBaseLabel alloc]init];
    inforLabel.frame=CGRectMake(23/550.0*MAINVIEW_WIDTH,93/550.0*MAINVIEW_WIDTH, 0, 0);
    [self.mainView addSubview:inforLabel];
    
    [self.fastLoginButton setTitle:bendihua(@"进入游戏") font:MXSetSysFont(16) backColor:CRedColor corner:4];
    if ([self isFirstLogin]) {
        
        [self.fastLoginButton setTitle:bendihua(@"快速登录") forState:(UIControlStateNormal)];
    }else
    {
        [inforLabel setText:bendihua(@"当前账号:") font:MXSetSysFont(9) color:CRedColor sizeToFit:YES];
    }
    HTBaseLabel*nameLabel=[[HTBaseLabel alloc]init];
    nameLabel.frame=CGRectMake(inforLabel.right, 0, 0, 0);
    [nameLabel setText:[HTBindInfo returnHomeName:[USER_DEFAULT objectForKey:@"usernewinfo"]] font:MXSetSysFont(9) color:CRedColor sizeToFit:YES];
//    [nameLabel setText:[USER_DEFAULT objectForKey:@"name"] font:MXSetSysFont(9) color:CRedColor sizeToFit:YES];
    nameLabel.centerY=inforLabel.centerY;
    nameLabel.width=self.mainView.width-nameLabel.left-5;
    [self.mainView addSubview:nameLabel];
    
    
    [self.mainView addSubview:self.fastLoginButton];
    
    [self.fastLoginButton addTarget:self action:@selector(fastLoginAction:) forControlEvents:(UIControlEventTouchUpInside)];
}

#pragma mark --快速登录
-(void)fastLoginAction:(UIButton*)sender
{
//改改改aaa游客登录
    
    NSString *lang = bendihua(@"lang");
    NSLog(@"lang=%@",lang);
    
    
    NSMutableURLRequest *request;
    if ([self isFirstLogin]) {
    //获取标识符
//    NSString *identifier = GETUUID;
    //拼接字符串
        
    // app_id, uuid, adid, device, version, channel, ip
        NSString *pram_app_id = [USER_DEFAULT objectForKey:@"appID"];
//        NSString *pram_uuid = GETUUID;
        NSString *pram_uuid = @"sskasfjdfakfahhdsadjksajlajsdljaskljal";
        NSString *pram_adid = [USER_DEFAULT objectForKey:@"adid"];
        NSString *pram_device = [HTgetDeviceName deviceString];
        NSString *pram_version = [USER_DEFAULT objectForKey:@"version"];
        NSString *pram_channel = [USER_DEFAULT objectForKey:@"channel"];
        NSString *pram_ip = GETIP;
        NSString *pram_lang = [USER_DEFAULT objectForKey:@"lang"];
        NSString *newStr = [NSString stringWithFormat:@"app_id=%@&uuid=%@&adid=%@&device=%@&version=%@&channel=%@&ip=%@&lang=%@",pram_app_id, pram_uuid, pram_adid, pram_device, pram_version, pram_channel, pram_ip, pram_lang];
        
//    NSString*str=[NSString stringWithFormat:@"username=%@#device&name=%@&uuid=%@",identifier,[HTgetDeviceName deviceString],GETUUID];
//    //加密
//    NSString*rsaStr=[RSA encryptString:str];
    //拼接加密后文件
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",SERVER_URL, LOGIN_URL];
        NSString *newUrlStr = [NSString stringWithFormat:@"%@?%@",urlStr,newStr];
        
        NSLog(@"tttttttt=%@",newUrlStr);
        
//    NSString*urlStr=[NSString stringWithFormat:@"http://c.gamehetu.com/passport/login?app=%@&data=%@&format=json&version=2.0",[USER_DEFAULT objectForKey:@"appID"],rsaStr];
        
//            NSString*urlStr=[NSString stringWithFormat:@"http://c.gamehetu.com/passport/login?app=&data=&format=json&version=2.0"];
//        NSLog(@"pingjie =%@",urlStr);
//            NSString*urlStr=[NSString stringWithFormat:@"http://c.gamehetu.com/passport/login?app=%@&data=%@&format=json&version=2.0",@"1111",@"rsaStr"];
        
    //创建url
    NSURL *url = [NSURL URLWithString:[newUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //简历网络请求体
        request=[NSMutableURLRequest requestWithURL:url];
//        [request setHTTPMethod:@"POST"];
        
        
    }else
    {
        request=[HTNameAndRequestModel getModelFormUserDefault].requset;
    }
    [HTprogressHUD showjuhuaText:bendihua(@"正在载入")];

    NSLog(@"kuaisu请求方式=%@",request.HTTPMethod);
    [HTNetWorking sendRequest:request ifSuccess:^(id response) {
//改改改aaa测试数据
        if ([response[@"code"]isEqualToNumber:@0]) {
            
            NSString *str = response[@"open_id"];
            NSLog(@"uid=%@",str);
            [USER_DEFAULT setObject:str forKey:@"uid"];
            //保存access_token
            [USER_DEFAULT setObject:@"50" forKey:@"loginway"];
            NSString *access_token = response[@"access_token"];
            
            [USER_DEFAULT setObject:access_token forKey:@"access_token"];
            [USER_DEFAULT setObject:response[@"name"] forKey:@"name"];
            [USER_DEFAULT synchronize];
            
            NSLog(@"===============分割线==================");
            NSLog(@"open_id=%@",str);
            NSLog(@"name=%@",response[@"name"]);
            NSLog(@"===============分割线==================");
            NSLog(@"token=%@",access_token);
            [HTLoginSuccess loginSuccessWithtoken:access_token];
            [HTConnect showAssistiveTouch];
            [HTNameAndRequestModel setFastRequest:request AndNameFormdict:response];
            [HTConnect shareConnect].loginBackBlock(response,nil);
            [USER_DEFAULT setObject:@"aa" forKey:@"changePassword"];
            [HTHUD showHUD:bendihua(@"登入成功")];
            [HTpresentWindow dismissPresentWindow];
            [HTLoginManager loginRetuen];

            }else
            {
                [HTprogressHUD hiddenHUD];
                [HTAlertView showAlertViewWithText:@"登录失败" com:nil];
                }
    } failure:^(NSError *error) {
        
    }];
    
    
//    [HTNetWorking NetworkRequestEmailCode:nil ifSuccess:^(id response) {
//        NSLog(@"response=%@",response);
//        NSLog(@"返回成功");
//        
//                if ([response[@"code"]isEqualToNumber:@0]) {
//        
//                    [HTConnect showAssistiveTouch];
//                    [HTNameAndRequestModel setFastRequest:request AndNameFormdict:response];
//                    [HTConnect shareConnect].loginBackBlock(response,nil);
//                    [USER_DEFAULT setObject:@"aa" forKey:@"changePassword"];
//                    [HTHUD showHUD:bendihua(@"登入成功")];
//                    [HTpresentWindow dismissPresentWindow];
//        //            }];
//                    }else
//                    {
//                        [HTAlertView showAlertViewWithText:@"登录失败" com:nil];
//                        }
//        
//    } failure:^(NSError *error) {
//        NSLog(@"error=%@",error);
//        NSLog(@"返回失败");
//    }];
//    
    
}
-(void)setOtherLoginWayLabel
{
    self.otherLoginWayLabel=[[HTBaseLabel alloc]init];
    
    self.otherLoginWayLabel.frame=CGRectMake(self.fastLoginButton.left, self.fastLoginButton.bottom+self.mainView.height*(57/370.0), self.fastLoginButton.width, 1);
    self.otherLoginWayLabel.backgroundColor=MXRGBColor(231, 87, 53);
    [self.mainView addSubview:self.otherLoginWayLabel];
    
    HTBaseLabel*textLabel=[[HTBaseLabel alloc]init];
    [textLabel setText:bendihua(@"其他登录方式") font:MXSetSysFont(10) color:MXRGBColor(231, 87, 53) sizeToFit:YES];
    UIView*labelBackView=[[UIView alloc]init];
    labelBackView.backgroundColor=CWhiteColor;
    labelBackView.bounds=CGRectMake(-5, 0, textLabel.width+10, textLabel.height);
    [labelBackView addSubview:textLabel];
    labelBackView.centerX=self.otherLoginWayLabel.centerX;
    labelBackView.centerY=self.otherLoginWayLabel.centerY;
    [self.mainView addSubview:labelBackView];
    
}
-(void)setOtherLoginButton
{
    NSArray*imagearray=@[imageNamed(@"渠道图标_1"),imageNamed(@"手机登录"),imageNamed(@"渠道图标_4"),imageNamed(@"渠道图标_2"),imageNamed(@"渠道图标_3")];
    for (int i=0; i<5; i++) {
        
        HTBaseButton*button=[[HTBaseButton alloc]init];
        
        button.tag=99+i;
        
        button.frame=CGRectMake(self.otherLoginWayLabel.left+(((self.otherLoginWayLabel.width-250/550.0*MAINVIEW_WIDTH)/4.0+50/550.0*MAINVIEW_WIDTH)*i), self.otherLoginWayLabel.bottom+15, 50/550.0*MAINVIEW_WIDTH, 50/550.0*MAINVIEW_WIDTH);
        
//        button.backgroundColor=COrangeColor
        
        [self.mainView addSubview:button];
        
        [button setImage:imagearray[i] forState:(UIControlStateNormal)];
        switch (button.tag) {
                case 99:
                [button addTarget:self action:@selector(FaceBookLogin:) forControlEvents:(UIControlEventTouchUpInside)];
                break;
            case 100:
            [button addTarget:self action:@selector(PhoneLogin:) forControlEvents:(UIControlEventTouchUpInside)];
                break;
            case 101:
            [button addTarget:self action:@selector(AccountLogin:) forControlEvents:(UIControlEventTouchUpInside)];
                break;
            case 102:
            [button addTarget:self action:@selector(GameCenterLogin:) forControlEvents:(UIControlEventTouchUpInside)];
                break;
            case 103:
            [button addTarget:self action:@selector(GoogleLogin:) forControlEvents:(UIControlEventTouchUpInside)];
                break;
            default:
                break;
        }
    }
}

-(void)FaceBookLogin:(HTBaseButton*)sender
{
    [FacebookLogin logInIfSuccess:^(id response, NSDictionary *FacebookDict) {
        
        
        NSString *str = response[@"data"][@"uid"];
        NSLog(@"uid=%@",str);
        

            
            [USER_DEFAULT setObject:str forKey:@"uid"];
            [USER_DEFAULT synchronize];
        
        
//        [HTLoginManager loginRetuen];
        [HTConnect showAssistiveTouch];
        [HTConnect shareConnect].loginBackBlock(response,FacebookDict);
        [HTpresentWindow dismissPresentWindow];
        [HTLoginManager loginRetuen];
    } failure:^(NSError *error) {
    
    }];
}

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error
{
    
    
    NSString *open = user.userID;
    NSLog(@"open=%@",open);
    
    [HTConnect shareConnect].mywindow.windowLevel=UIWindowLevelAlert+1;

    if (error) {

        [[GIDSignIn sharedInstance] signOut];
        
    }else
    {
//改改改aaa谷歌登录
//         NSString *transString = [NSString stringWithString:[string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        
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
        NSString *pram_open_id = user.userID;
        NSString *open_name = user.profile.name;
        NSString *pram_open_name = [open_name stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *pram_lang = [USER_DEFAULT objectForKey:@"lang"];
        
        NSString *newPramStr = [NSString stringWithFormat:@"platform=%@&access_token=%@&open_id=%@&app_id=%@&uuid=%@&adid=%@&device=%@&version=%@&channel=%@&ip=%@&open_name=%@&lang=%@",pram_platform, pram_code,pram_open_id, pram_app_id, pram_uuid, pram_adid, pram_device, pram_version, pram_channel, pram_ip,pram_open_name, pram_lang];
        
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",SERVER_URL, LOGIN_URL];
        
        NSString *newUrlStr = [NSString stringWithFormat:@"%@?%@",urlStr,newPramStr];

//        
//        
//        NSString*str=[NSString stringWithFormat:@"username=%@#google&name=%@&uuid=%@&token=%@",[GIDSignIn sharedInstance].currentUser.profile.email,[regex deleUrlBugChar:[GIDSignIn sharedInstance].currentUser.profile.name],[UUID getUUID],user.authentication.idToken];
//        
//        //platform(第三方平台) code(授权码)，app_id, uuid, adid, device, version, channel, ip
//        
//        NSLog(@"google=%@",str);
//        NSString*rsaStr=[RSA encryptString:str];
//        NSString*urlStr=[NSString stringWithFormat:@"http://c.gamehetu.com/passport/login?app=%@&data=%@&format=json&version=2.0",[[NSUserDefaults standardUserDefaults]objectForKey:@"appID"],rsaStr];
        
        NSLog(@"request=%@",newUrlStr);
        NSURL*url=[NSURL URLWithString:newUrlStr];
        NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:url];
        
        [HTNetWorking sendRequest:request ifSuccess:^(id response) {
            
            if ([response[@"code"] isEqualToNumber:@0]) {
                
                [HTConnect showAssistiveTouch];
                [HTNameAndRequestModel setFastRequest:request AndNameFormdict:response];
                NSDictionary*googleDic=[NSDictionary dictionaryWithObjectsAndKeys:[GIDSignIn sharedInstance].currentUser.userID, @"googleID",[GIDSignIn sharedInstance].currentUser.profile.name,@"googleName",user.authentication.idToken,@"googleToken",nil];
                
                //google登录成功返回
//                NSString *str = response[@"data"][@"uid"];
//                NSLog(@"uid=%@",str);
//                
//                [USER_DEFAULT setObject:str forKey:@"uid"];
//                [USER_DEFAULT synchronize];
                NSString *str = response[@"open_id"];
                NSLog(@"uid=%@",str);
                [USER_DEFAULT setObject:str forKey:@"uid"];
                [USER_DEFAULT setObject:[regex deleUrlBugChar:[GIDSignIn sharedInstance].currentUser.profile.name] forKey:@"showname"];
                //保存access_token
                [USER_DEFAULT setObject:@"31" forKey:@"loginway"];
                NSString *access_token = response[@"access_token"];
                [USER_DEFAULT setObject:access_token forKey:@"access_token"];
                [USER_DEFAULT synchronize];
                
                [HTLoginSuccess loginSuccessWithtoken:access_token];
                [HTConnect shareConnect].loginBackBlock(response,googleDic);
                [HTHUD showHUD:bendihua(@"登录成功")];
                [HTpresentWindow dismissPresentWindow];
                [HTLoginManager loginRetuen];
                
            }else
            {
                [HTAlertView showAlertViewWithText:bendihua(@"登录失败") com:nil];
                [HTprogressHUD hiddenHUD];
            }
        } failure:^(NSError *error) {
            [HTprogressHUD hiddenHUD];
            [HTAlertView showAlertViewWithText:bendihua(@"登录失败") com:nil];
            
        }];
        

        
        
    }
    [[GIDSignIn sharedInstance] signOut];
}
-(void)PhoneLogin:(UIButton*)sender
{
    self.login=[[HTPhoneLogin alloc]init];
    [self.login loginWithPhoneNumber:self ifSuccess:^(id data) {
        
//        NSString *str = data[@"data"][@"uid"];
//        NSLog(@"uid=%@",str);
//        
//        [USER_DEFAULT setObject:str forKey:@"uid"];
//        [USER_DEFAULT synchronize];
        
        
         [HTConnect shareConnect].loginBackBlock(data,nil);
        
        [HTpresentWindow dismissPresentWindow];
        [HTLoginManager loginRetuen];
    } orFailure:^{
        [HTAlertView showAlertViewWithText:@"登录失败" com:nil];
    }typeIs:@""];
}
-(void)GameCenterLogin:(UIButton*)sender
{
    [self authenticateLocalPlayer];
}
-(void)GoogleLogin:(UIButton*)sender
{
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].delegate=self;
    [[GIDSignIn sharedInstance] signIn];
    [HTConnect shareConnect].mywindow.windowLevel=UIWindowLevelNormal;
}
-(void)AccountLogin:(UIButton*)sender
{
    HTChangeAccountController*account=[[HTChangeAccountController alloc]init];
    account.changeType=@0;
    [self.navigationController pushViewController:account animated:NO];
}

- (void) authenticateLocalPlayer
{

    self.gameBug=@"bug";//为了解决进入游戏进入后台在返回前台就会重新调用gamecenter的错误
    
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    static  UIViewController*con;
    if([[HTConnect shareConnect].gameCenterLoginType isEqualToString:@"error"])
    {
//        a=NO;
        [HTprogressHUD hiddenHUD];
        if ([UIDevice currentDevice].systemVersion.floatValue>=10.0) {
            [HTAlertView showAlertViewWithText:bendihua(@"iOS 10使用者需要手动到设置里面登录游戏中心") com:nil];
        }else
        {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"gamecenter:"]];
        }
    }else if (localPlayer.authenticated) {
        
        [self gameCenterLoginConnection];
    }else{
        
        [HTprogressHUD showjuhuaText:bendihua(@"正在登录")];

    __weak typeof (self)weakSelf = self;
    [localPlayer setAuthenticateHandler:                                                                                                 (^(UIViewController* viewcontroller, NSError *error) {
        
        [HTprogressHUD hiddenHUD];

        if (!error && viewcontroller)
        {
            
            con=viewcontroller;
            [weakSelf presentViewController:viewcontroller animated:YES completion:nil];
        }
        else if (error == nil&&viewcontroller==nil) {

            if (weakSelf.gameBug) {
            [weakSelf gameCenterLoginConnection];
            }

        }else if(error) {
            [HTAlertView showAlertViewWithText:bendihua(@"iOS 10使用者需要手动到设置里面登录游戏中心") com:nil];
            [HTConnect shareConnect].gameCenterLoginType=@"error";
            
            
        }else
        {
             [HTAlertView showAlertViewWithText:bendihua(@"iOS 10使用者需要手动到设置里面登录游戏中心") com:nil];
            NSLog(@"");

        }
    })];
    }
}
-(void)gameCenterLoginConnection
{
    [HTprogressHUD showjuhuaText:bendihua(@"正在登录")];
//改改改aaa game center
//    NSString*str=[NSString stringWithFormat:@"username=%@#apple&name=%@&uuid=%@",
//                  [GKLocalPlayer localPlayer].playerID,
//                  [regex deleUrlBugChar:[GKLocalPlayer localPlayer].alias],
//                  [UUID getUUID]];
//    
//    NSString*urlStr=[NSString stringWithFormat:@"app=%@&data=%@&format=json&version=2.0",
//                     [USER_DEFAULT objectForKey:@"appID"],
//                     [RSA encryptString:str]];
//    
//    NSString*mainStr=@"http://c.gamehetu.com/passport/login";
    
    //platform code app_id uuid adid device version channel ip
    
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
    
    NSString *newPramStr = [NSString stringWithFormat:@"platform=%@&access_token=%@&open_id=%@&app_id=%@&uuid=%@&adid=%@&device=%@&version=%@&channel=%@&ip=%@&open_name=%@&lang=%@",pram_platform, pram_code,pram_open_id, pram_app_id, pram_uuid, pram_adid, pram_device, pram_version, pram_channel, pram_ip,pram_open_name, pram_lang];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SERVER_URL, LOGIN_URL];
    
//    NSString *newUrlStr = [NSString stringWithFormat:@"%@?%@",urlStr,newPramStr];
    
    
    
    
    
    //這是為了保存request準備的
    NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:(NSURLRequestUseProtocolCachePolicy) timeoutInterval:15];
    [request setHTTPMethod:@"POST"];
    
    NSData*paraData=[newPramStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:paraData];
    
    [HTNetWorking sendRequest:request ifSuccess:^(id response) {
        
        [HTprogressHUD hiddenHUD];
        
    if ([response[@"code"] isEqualToNumber:@0]) {
                  [HTNameAndRequestModel setFastRequest:request AndNameFormdict:response];
        
        NSString *str = response[@"open_id"];
        NSLog(@"===============分割线==================");
        NSLog(@"open_id=%@",str);
        NSLog(@"name=%@",response[@"name"]);
        NSLog(@"===============分割线==================");
        [USER_DEFAULT setObject:str forKey:@"uid"];
        //保存access_token
        [USER_DEFAULT setObject:@"32" forKey:@"loginway"];
        [USER_DEFAULT setObject:[regex deleUrlBugChar:[GKLocalPlayer localPlayer].alias] forKey:@"showname"];
        NSString *access_token = response[@"access_token"];
        [USER_DEFAULT setObject:access_token forKey:@"access_token"];
        [USER_DEFAULT synchronize];
        
        [HTLoginSuccess loginSuccessWithtoken:access_token];
        [HTConnect shareConnect].loginBackBlock(response,nil);
        [HTConnect showAssistiveTouch];

        self.gameBug=nil;
        [HTHUD showHUD:bendihua(@"登入成功")];
          [HTpresentWindow dismissPresentWindow];
        [HTLoginManager loginRetuen];
        
    }
        else{
            [HTAlertView showAlertViewWithText:bendihua(@"登录失败") com:nil];
            [HTprogressHUD hiddenHUD];
        }
    }
     failure:^(NSError *error) {
         [HTprogressHUD hiddenHUD];

    }];
}
@end
