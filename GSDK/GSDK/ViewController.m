//
//  ViewController.m
//  GSDK
#import "HTTalkToServer.h"
//  Created by 王璟鑫 on 16/8/4.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//
#import "HTBaseNavigationController.h"
#import "ViewController.h"
#import "HTFaseLoginViewController.h"
#import "HTConnect.h"
#import "HTAccountController.h"
#import "HTAddBindInfoTodict.h"
#import "HTAlbumController.h"
#import "HTPOSTImageArray.h"
#import "HTUploadImage.h"
#import "HTIAPManager.h"

#import "AppDelegate.h"

#import "HTIAPManager.h"
#import "HTpresentWindow.h"
#import "HTAssistiveTouch.h"



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor greenColor];
    UIButton*butt=[UIButton buttonWithType:(UIButtonTypeCustom)];
    butt.frame=CGRectMake(50, 100, 100, 100);
    [butt addTarget:self action:@selector(fuck) forControlEvents:(UIControlEventTouchUpInside)];
    butt.backgroundColor=[UIColor cyanColor];
    [self.view addSubview:butt];

    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
    self.view.backgroundColor=CGrayColor;
    UIButton*postImage=[UIButton buttonWithType:UIButtonTypeCustom];
    postImage.frame=CGRectMake(200, 200, 100, 100);
    postImage.backgroundColor=[UIColor blackColor];
    [self.view addSubview:postImage];
    [postImage addTarget:self action:@selector(postImage) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self testchange];
    
    
}

- (void)testchange
{
    
    
//    [HTConnect showHTSDKwithLoginInfo:^(NSDictionary *loginInfo, NSDictionary *FaceBookInfo) {
//        
//        NSLog(@"这里有什么");
//        NSLog(@"%@,\n%@",loginInfo,FaceBookInfo);
//        NSLog(@"数值");
//    }];
    
    [HTConnect changeAccount:^(NSDictionary *accountInfo, NSDictionary *facebookInfo) {
        
        NSLog(@"接入方在这里写退出登录的代码%@\n,%@",accountInfo,facebookInfo);
        
    }];
    
    
    [HTConnect gameRestart:^(NSDictionary *dic) {
        NSLog(@"restart=%@",dic);
    }];
    
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    }
-(void)fuck
{
    
//    [self testchange];
//        [HTConnect gameRestart:^(NSDictionary *dic) {
//            NSLog(@"restart=%@",dic);
//        }];
    
    

    NSString *ip = GETIP;
    NSLog(@"ttip=%@",ip);
    [HTConnect showHTSDKwithLoginInfo:^(NSDictionary *loginInfo, NSDictionary *FaceBookInfo) {
        
        NSLog(@"这里有什么");
        NSLog(@"%@,\n%@",loginInfo,FaceBookInfo);
        NSLog(@"数值");
//        [HTpresentWindow dismissPresentWindow];
//        [HTAssistiveTouch hiddenWindow];
//        [HTConnect shareConnect].mywindow.hidden = YES;
    }];
    
//    [HTConnect changeAccount:^(NSDictionary *accountInfo, NSDictionary *facebookInfo) {
//        
//        NSLog(@"接入方在这里写退出登录的代码%@",accountInfo);
//        
//    }];
    
//    [HTConnect gameRestart:^(NSDictionary *dic) {
//        NSLog(@"restart=%@",dic);
//    }];
//    
    
    
    
    
   }
-(void)tap{
    
    
//    [HTpresentWindow sharedInstance].backgroundColor=[UIColor clearColor];
    
    
//    [HTConnect showHTSDKwithLoginInfo:^(NSDictionary *loginInfo, NSDictionary *FaceBookInfo) {
//        NSLog(@"%@,\n%@",loginInfo,FaceBookInfo);
//    }];
//
//    [HTConnect changeAccount:^(NSDictionary *accountInfo, NSDictionary *facebookInfo) {
//     
//        NSLog(@"接入方在这里写退出登录的代码%@",accountInfo);
//        
//    }];

//   NSString*str= [regex deleUrlBugChar:@"爱上!?@#$%^&*?()/。就肯定会"];
//    NSLog(@"%@",str);
    
//    NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://aq.gamehetu.com/10001/topic/commit?token=mIdSzYy1E9alXqVxFYziDWvcxbZv2lnX1nahFUdiLxetKX5hm1mIpvfHVmWKyKIK&zone=2001&id=341&message=呼叫"]];
//
//    
//    [HTNetWorking sendRequest:request ifSuccess:^(id response) {
//        
//    } failure:^(NSError *error) {
//        
//    }];


    
    
//    [HTNetWorking POST:@"http://aq.gamehetu.com/10001/topic/commit?token=mIdSzYy1E9alXqVxFYziDWvcxbZv2lnX1nahFUdiLxetKX5hm1mIpvfHVmWKyKIK&zone=2001&id=341&message=呼叫" paramString:nil ifSuccess:^(id response) {
//        
//    } failure:^(NSError *error) {
//        
//    }];
//    
}
-(void)postImage
{
//[[HTIAPManager defaultManager] requestProductWithId:@"com.zc.ios.6"];
//[HTConnect shareToFacebookWithURL:@"https://www.baidu.com" imageURL:@"http://www.baidu.com" contentTitle:@"asd" contentDescription:@"asd" shareInfoBlock:^(NSDictionary *shareInfoDic) {
//    
//}];
//    [HTNetWorking POST:@"http://aq.gamehetu.com/10001/topic/detail?token=mIdSzYy1E9alXqVxFYziDWvcxbZv2lnX1nahFUdiLxetKX5hm1mIpvfHVmWKyKIK&zone=2001&id=341" paramString:nil ifSuccess:^(id response) {
//        
//    } failure:^(NSError *error) {
//        
//    }];
//    
    
//    [self test1];
    [self test222];
    
}

- (void)test222
{
    [SKStoreReviewController requestReview];
    
}


-(void)goToAppStore
{
    int appID = 12345;
    NSString *str = [NSString stringWithFormat:
                     @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",appID]; //appID 解释如下
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}



- (void)testss
{
    NSString*urlStr=[NSString stringWithFormat:@"http://c.gamehetu.com/passport/login?app=%@&data=%@&format=json&version=2.0",@"12345678",@""];
    NSLog(@"pingjie =%@",urlStr);
    //创建url
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //简历网络请求体
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    
    [HTNetWorking sendRequest:request ifSuccess:^(id response) {
        NSLog(@"success");
    } failure:^(NSError *error) {
        NSLog(@"error");
    }];
    
}



- (void)test1
{
    [HTConnect getProductsIDwithServer:@"1" ifSuccess:^(NSArray *response) {
        NSLog(@"success=%@",response);
    } orError:^(NSError *error) {
        NSLog(@"error=%@",error);
    }];
    
}

- (void)test{
    
    
    [HTIAPManager defaultManager].IAPBlock=^(NSString*string)
    {
        NSLog(@"string");//string返回的成功或者失败
    };
    NSString *str = [USER_DEFAULT objectForKey:@"uid"];
    NSLog(@"uuuuuuuid=%@",str);

    [HTIAPManager defaultManager].extra = @"";
    NSString *proid = @"com.zc.ios.1";
    [[HTIAPManager defaultManager] requestProductWithId:proid];
    
    
//    [[HTIAPManager defaultManager] requestProductWithId:proid withblock:^(NSString *str) {
//        NSLog(@"fanhui = %@",str);
//        NSLog(@"end");
//    }];
    

}


@end
