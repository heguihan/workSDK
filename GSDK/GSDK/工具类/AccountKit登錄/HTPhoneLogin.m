//
//  HTPhoneLogin.m
//  NEWFacebookSDK
//
//  Created by 王璟鑫 on 16/10/17.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTPhoneLogin.h"
#import <AccountKit/AccountKit.h>
#import "IQKeyboardManager.h"
@interface HTPhoneLogin ()<AKFViewControllerDelegate>
@property (nonatomic,copy)void(^neiSuccess)(id data);
@property (nonatomic,copy)void(^neiFailure)();
@property (nonatomic,strong)NSString*type;
@end

@implementation HTPhoneLogin{
    AKFAccountKit *_accountKit;
    UIViewController<AKFViewController> *_pendingLoginViewController;
    
}
-(void)loginWithPhoneNumber:(UIViewController*)con ifSuccess:(success)Success orFailure:(failure)Failure typeIs:(NSString*)type
{
    [HTConnect shareConnect].mywindow.windowLevel=UIWindowLevelNormal;
    
    if (_accountKit == nil) {
        _accountKit = [[AKFAccountKit alloc] initWithResponseType:
                       AKFResponseTypeAccessToken];
    }
    AKFPhoneNumber *preFillPhoneNumber = [[AKFPhoneNumber alloc]initWithCountryCode:@"86" phoneNumber:@""];
    NSString *inputState = [[NSUUID UUID] UUIDString];
    UIViewController<AKFViewController> *viewController = [_accountKit viewControllerForPhoneLoginWithPhoneNumber:preFillPhoneNumber
                                                                                                            state:inputState];
    viewController.delegate=self;
//    [[IQKeyboardManager sharedManager] setEnable:NO];

    [con presentViewController:viewController animated:YES completion:NULL];
    self.type=type;
    self.neiFailure=Failure;
    self.neiSuccess=Success;

}
- (void)viewController:(UIViewController<AKFViewController> *)viewController didCompleteLoginWithAuthorizationCode:(NSString *)code state:(NSString *)state
{
    [HTConnect shareConnect].mywindow.windowLevel=UIWindowLevelAlert+1;
    [[IQKeyboardManager sharedManager] setEnable:YES];

}
- (void)viewController:(UIViewController<AKFViewController> *)viewController didCompleteLoginWithAccessToken:(id<AKFAccessToken>)accessToken state:(NSString *)state
{
    
    
//改改改aaa手机号登录
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [_accountKit requestAccount:^(id<AKFAccount>  _Nullable account, NSError * _Nullable error) {
        //获取手机号
        [HTConnect shareConnect].mywindow.windowLevel=UIWindowLevelAlert+1;

        NSString*phoneNum=[[account phoneNumber] stringRepresentation];
        [HTprogressHUD showjuhuaText:bendihua(@"正在绑定")];
        if ([self.type isEqualToString:@"bind"]) {
            NSDictionary*dict=@{@"phone":phoneNum,@"id":[accessToken accountID]};
            self.neiSuccess(dict);
        }else
        {
            [HTprogressHUD showjuhuaText:bendihua(@"正在登录")];
            NSString*dataStr=[NSString stringWithFormat:@"username=%@#accountkit&token=%@&uuid=%@&name=%@",[accessToken accountID],[accessToken tokenString],GETUUID,phoneNum];
            //加密
            NSString*rsaStr=[RSA encryptString:dataStr];
            //拼接加密后文件
            NSString*urlStr=[NSString stringWithFormat:@"http://c.gamehetu.com/passport/login?app=%@&data=%@&format=json&version=2.0",[USER_DEFAULT objectForKey:@"appID"],rsaStr];
            //创建url
            NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            //简历网络请求体
        NSMutableURLRequest * request=[NSMutableURLRequest requestWithURL:url];
        [HTNetWorking sendRequest:request ifSuccess:^(id response) {
           [HTprogressHUD hiddenHUD];
            if ([response[@"code"] isEqual:@0]) {
             [HTHUD showHUD:bendihua(@"登入成功")];
                 [HTConnect showAssistiveTouch];
                 [HTNameAndRequestModel setFastRequest:request AndNameFormdict:response];
                 self.neiSuccess(response);
             
            }else
            {
                    self.neiFailure();
            }
            
        } failure:^(NSError *error) {
            [HTprogressHUD hiddenHUD];
            
                self.neiFailure();
        }];
        }
    }];
    
}
- (void)viewController:(UIViewController<AKFViewController> *)viewController didFailWithError:(NSError *)error
{
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [HTConnect shareConnect].mywindow.windowLevel=UIWindowLevelAlert+1;
    self.neiFailure();
}
- (void)viewControllerDidCancel:(UIViewController<AKFViewController> *)viewController
{
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [HTConnect shareConnect].mywindow.windowLevel=UIWindowLevelAlert+1;
    self.neiFailure();
}

@end
