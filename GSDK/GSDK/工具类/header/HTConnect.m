//
//  HTConnect.m
//  GSDK
//
//  Created by 王璟鑫 on 16/8/9.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTConnect.h"
#import <AdSupport/AdSupport.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "HTAssistiveTouch.h"
#import "HTFaseLoginViewController.h"
#import "HTBaseNavigationController.h"
#import "HTAssistiveTouch.h"
#import "IQKeyboardManager.h"
#import "HTPhoneLogin.h"
#import <AccountKit/AccountKit.h>
#import "HTLoginManager.h"



@interface HTConnect ()<FBSDKSharingDelegate,FBSDKGameRequestDialogDelegate>

@property (nonatomic,strong)UIWindow*presentwindow;

@end

@implementation HTConnect
//单利
+(instancetype)shareConnect
{
    static HTConnect*help = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        help=[[HTConnect alloc]init];
    });
    return help;
}

/**
 *  展示SDK ui
 *
 *  @param infoBlack 登录信息回调
 */
+(void)showHTSDKwithLoginInfo:(void(^)(NSDictionary*loginInfo,NSDictionary*thridLoginInfo))infoBlack
{
    HTFaseLoginViewController*fast=[[HTFaseLoginViewController alloc]init];
    HTBaseNavigationController*navi=[[HTBaseNavigationController alloc]initWithRootViewController:fast];

    
    [HTpresentWindow sharedInstance].rootViewController=navi;

    [HTConnect shareConnect].loginBackBlock=^(NSDictionary*loginDic,NSDictionary*facebookDic)
    {
        infoBlack(loginDic,facebookDic);
    };
}
/**
 *  初始化appID
 *
 *  @param AppID
 */

+(void)initSDKwithAppID:(NSString*)AppID andPhoneCountryNumber:(NSString*)countryNumber andAudit:(BOOL)isgoingOnline andFansUel:(NSString *)urlstr andVersion:(NSString *)version andChannel:(NSString *)channel
{
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    
//    [self showHTSDKwithLoginInfo:^(NSDictionary *loginInfo, NSDictionary *thridLoginInfo) {
//        
//        NSString *str = loginInfo[@"data"][@"uid"];
//        NSLog(@"uid=%@",str);
//        
//        
//    }];
    [HTLoginManager sharedInstance].fansUrlStr = urlstr;
    [HTLoginManager sharedInstance].isGoingOnline = isgoingOnline;
    NSString *lang = bendihua(@"lang");
    [USER_DEFAULT setObject:lang forKey:@"lang"];
    

    [FBSDKAppEvents activateApp];
    //使内存中的缓存与用户默认系统进行同步
    [USER_DEFAULT setObject:countryNumber forKey:@"countryNumber"];
    [USER_DEFAULT setObject:AppID forKey:@"appID"];
    [USER_DEFAULT setObject:version forKey:@"version"];
    [USER_DEFAULT setObject:channel forKey:@"channel"];
    [USER_DEFAULT synchronize];
}

/**
 *  显示悬浮窗
 */
+(void)showAssistiveTouch
{
    if (![HTConnect shareConnect].mywindow) {
        CGFloat kuan;
        if (IS_IPAD) {
            
            if (SCREEN_WIDTH > SCREEN_HEIGHT) {
                
                kuan=50/768.0*SCREEN_HEIGHT;
            }else
            {
                kuan=50/768.0*SCREEN_WIDTH;

            }
            
        }else
        {
            if (SCREEN_WIDTH>SCREEN_HEIGHT) {
                kuan = 38/320.0*SCREEN_HEIGHT;
            }else
            {
                kuan=38/320.0*SCREEN_WIDTH;
            }
        }
        if ([USER_DEFAULT objectForKey:@"weizhi"]) {
            
            NSDictionary*dic=[USER_DEFAULT objectForKey:@"weizhi"];
            NSString*X=dic[@"X"];
            NSString*Y=dic[@"Y"];
            
            [HTConnect shareConnect].mywindow=[[HTAssistiveTouch alloc]initWithFrame:CGRectMake(([X floatValue]-kuan/2), ([Y floatValue]-kuan/2), kuan, kuan)];
        }else
        {
        
        [HTConnect shareConnect].mywindow=[[HTAssistiveTouch alloc]initWithFrame:CGRectMake(0, 100, kuan, kuan)];
        }
        UIViewController*viewCon=[[UIViewController alloc]init];
        [[HTConnect shareConnect].mywindow setRootViewController:viewCon];
        [[HTConnect shareConnect].mywindow makeKeyAndVisible];
      
    }else
    {
        [HTConnect shareConnect].mywindow.hidden=NO;

    }
    [USER_DEFAULT setObject:@"second" forKey:@"first"];
    [USER_DEFAULT synchronize];
}
/**
 *  关闭悬浮窗相应
 */
+(void)disableAssistiveUserTap
{
    [HTConnect shareConnect].mywindow.userInteractionEnabled=NO;
}
/**
 *  打开悬浮窗相应
 */
+(void)enableAssistiveUserTap
{
    [HTConnect shareConnect].mywindow.userInteractionEnabled=YES;

}
/**
 *  隐藏悬浮窗
 */
+(void)hideAssistiveTouch
{
    [HTConnect shareConnect].mywindow.hidden=YES;
}
/**
 *  统计接口
 */
+(void)StatisticsInterfacelogOrRegType:(NSString*)type coo_server:(NSString*)coo_server coo_uid:(NSString*)coo_uid success:(void(^)(id response))success failure:(void(^)(id error))failure
{
//改改改aaa统计
//    coo_server  == zone
//    coo_uid == user_id
    // uid登录的时候返回的账号id
    //type
    
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
//    NSString*urlStr=@"http://c.gamehetu.com/stat/login";
    NSString *newUrlStr = @"http://c.gamehetu.com/stat/logi";
    
    
    NSString *pram_app_id = [USER_DEFAULT objectForKey:@"appID"];
    NSString *pram_zone = coo_server;
    NSString *pram_user_id = coo_uid;
    NSString *pram_uuid = [UUID getUUID];
    NSString *pram_adid = adId;
    NSString *pram_device = [HTgetDeviceName deviceString];
    NSString *pram_version = [USER_DEFAULT objectForKey:@"version"];
    NSString *pram_channel = [USER_DEFAULT objectForKey:@"channel"];
    NSString *pram_type = type;
    NSString *newPramString = [NSString stringWithFormat:@"app_id=%@&zone=%@&user_id=%@&uuid=%@&adid=%@&device=%@&version=%@&channel=%@&type=%@",pram_app_id, pram_zone, pram_user_id, pram_uuid, pram_adid, pram_device, pram_version, pram_channel, pram_type];
//    NSString*paramString=[NSString stringWithFormat:@"app=%@&type=%@&version=%@&os=ios&channel=%@&uid=%@&coo_server=%@&coo_uid=%@&uuid=%@&idfa=%@&device_type=%@",
//                     [USER_DEFAULT objectForKey:@"appID"],
//                     type,
//                     version,
//                     channel,
//                     [USER_DEFAULT objectForKey:@"uid"],
//                     coo_server,
//                     coo_uid,
//                     [UUID getUUID],
//                     adId,
//                     [HTgetDeviceName deviceString]
//                     ];
    [USER_DEFAULT setObject:type forKey:@"type"];

    [USER_DEFAULT setObject:adId forKey:@"adid"];
    [USER_DEFAULT setObject:type forKey:@"type"];
    [USER_DEFAULT synchronize];
    
    [HTNetWorking POST:newUrlStr paramString:newPramString ifSuccess:^(id response) {
        success(response);
        
    } failure:^(NSError *error) {
        failure(error);
    }];
    [USER_DEFAULT setObject:coo_server forKey:@"coo_server"];
    [USER_DEFAULT setObject:coo_uid forKey:@"coo_uid"];
    [USER_DEFAULT synchronize];
}

/**
 *  获取商品列表
 */
+(void)getProductsIDwithServer:(NSString*)server ifSuccess:(void(^)(NSArray* response))success orError:(void(^)(NSError*error))error
{
    
//改改改aaa获取商品列表
    NSString*string=[NSString stringWithFormat:@"http://c.gamehetu.com/%@/product?package=%@&os=ios&channel=%@&server=%@",[USER_DEFAULT objectForKey:@"appID"],[NSBundle mainBundle].bundleIdentifier,[USER_DEFAULT objectForKey:@"channel"],server];
    NSURL *url=[NSURL URLWithString:string];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (success) {
            
            if (data) {
                
                NSArray*dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                success(dict);
            }
        }else if(error)
        {
            if (connectionError) {
                error(connectionError);
            }
        }
        
    } ];
    
    
}

/**
 *  facebook分享
 */
+(void)shareToFacebookWithURL:(NSString*)url imageURL:(NSString*)imageURL contentTitle:(NSString*)contentTitle contentDescription:(NSString*)contentDescription shareInfoBlock:(void(^)(NSDictionary *shareInfoDic))shareInfoBlock
{
    
    FBSDKShareLinkContent*content=[[FBSDKShareLinkContent alloc]init];
    content.contentURL=[NSURL URLWithString:url];
    content.imageURL=[NSURL URLWithString:imageURL];
    content.contentTitle=contentTitle;
    content.contentDescription=contentDescription;
    FBSDKShareDialog *shareDialog = [FBSDKShareDialog new];
    [shareDialog setMode:FBSDKShareDialogModeWeb];
    [shareDialog setShareContent:content];
    [shareDialog setFromViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
    [shareDialog setDelegate:(id<FBSDKSharingDelegate>)self];
    [shareDialog show];
    [HTConnect shareConnect].sharFB=^(NSDictionary*shareDic)
    {
        shareInfoBlock(shareDic);
    };
    
}

//faceBook分享代理
+ (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
{
    NSLog(@"分享成功");
    NSDictionary*dic=[NSDictionary dictionaryWithObject:@"success" forKey:@"share"];
    [HTConnect shareConnect].sharFB(dic);
    
    
}
+ (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error
{
    NSLog(@"分享失败");
    NSDictionary*dic=[NSDictionary dictionaryWithObject:@"erroe" forKey:@"share"];
    [HTConnect shareConnect].sharFB(dic);
}
+ (void)sharerDidCancel:(id<FBSDKSharing>)sharer
{
    NSLog(@"取消分享");
    NSDictionary*dic=[NSDictionary dictionaryWithObject:@"cancle" forKey:@"share"];
    [HTConnect shareConnect].sharFB(dic);
}

//Facebook邀请
+ (void)inviteFB:(NSString *)title message:(NSString *)msg inviteInfoBlock:(void(^)(NSDictionary*inviteInfoDic))inviteInfoBlock
{
    FBSDKGameRequestContent *gameRequestContent = [[FBSDKGameRequestContent alloc] init];
    gameRequestContent.message = msg;
    gameRequestContent.title = title;
    FBSDKGameRequestDialog*game=[[FBSDKGameRequestDialog alloc]init];
    gameRequestContent.actionType = FBSDKGameRequestActionTypeNone;
    game.content=gameRequestContent;
    game.delegate=(id<FBSDKGameRequestDialogDelegate>)self;
    [game show];
    [HTConnect shareConnect].inviteFB=^(NSDictionary*inviteDic)
    {
        inviteInfoBlock(inviteDic);
    };
}
//邀请代理
+ (void)gameRequestDialog:(FBSDKGameRequestDialog *)gameRequestDialog didCompleteWithResults:(NSDictionary *)results
{
    NSDictionary*dic=[NSDictionary dictionaryWithObject:@"success" forKey:@"invite"];

    [HTConnect shareConnect].inviteFB(dic);
    NSLog(@"%@完成",results);
}
+ (void)gameRequestDialog:(FBSDKGameRequestDialog *)gameRequestDialog didFailWithError:(NSError *)error
{
    NSDictionary*dic=[NSDictionary dictionaryWithObject:@"error" forKey:@"invite"];
    [HTConnect shareConnect].inviteFB(dic);
}
+ (void)gameRequestDialogDidCancel:(FBSDKGameRequestDialog *)gameRequestDialog
{
    NSDictionary*dic=[NSDictionary dictionaryWithObject:@"cancle" forKey:@"invite"];
    [HTConnect shareConnect].inviteFB(dic);
    NSLog(@"取消");
}

//切换账号
+(void)changeAccount:(void(^)(NSDictionary*accountInfo,NSDictionary*facebookInfo))changeAccountBlock
{
    [HTConnect shareConnect].changeAccount=^(NSDictionary*dict,NSDictionary*facebook)
    {
        changeAccountBlock(dict,facebook);
    };
}

//
+ (void)gameRestart:(void (^)(NSDictionary *dic))restarBlock

{
    [HTConnect shareConnect].changePassword = ^(NSDictionary *dic)
    {
        restarBlock(dic);
    };
}


//test
//切换账号






@end
