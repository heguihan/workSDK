//
//  HTWebViewController.m
//  GSDK
//
//  Created by 王璟鑫 on 2017/1/4.
//  Copyright © 2017年 王璟鑫. All rights reserved.
//

#import "HTWebViewController.h"
#import "HTLoginManager.h"

@interface HTWebViewController ()
@property (nonatomic,strong)UIWebView*webview;
@end

@implementation HTWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(methodtocall) ];
    
    self.navigationItem.rightBarButtonItem=anotherButton;
    self.webview=[[UIWebView alloc]initWithFrame:self.view.frame];
    self.webview.backgroundColor=[UIColor whiteColor];
//    [self.webview setScalesPageToFit:YES];//自动缩放以适应屏幕
    [self.webview setOpaque:NO];//opaque是不透明的意思
    [self.view addSubview:self.webview];
    NSString*urlStr;
    if ([self.type isEqualToString:@"1"]) {
        
        
        NSString *appid = [USER_DEFAULT objectForKey:@"appID"];
        NSString *uid = [USER_DEFAULT objectForKey:@"uid"];
        NSString *coo_server = [USER_DEFAULT objectForKey:@"coo_server"];
        NSString *coo_uid = [USER_DEFAULT objectForKey:@"coo_uid"];
        
//        urlStr = [NSString stringWithFormat:@"http://c.gamehetu.com/pay?app=%@&uid=%@&coo_server=%@&coo_uid=%@",appid,uid,coo_server,coo_uid];
        
        NSLog(@"urlstr=%@",urlStr);
        NSLog(@"OK");
        urlStr=@"http://c.gamehetu.com/pay?app=100008&uid=1363146&coo_server=9006&coo_uid=64";
//        urlStr=@"http://c.gamehetu.com/pay?app=100008&uid=1363146&coo_server=9006&coo_uid=64";
    }else
    {
//        urlStr=@"https://www.facebook.com/lord.of.dark.tw/";
        urlStr =  [HTLoginManager sharedInstance].fansUrlStr;
        NSLog(@"fans=%@",urlStr);
        NSLog(@"OK");
    }
    NSURL *url = [NSURL URLWithString:urlStr];
    [self.webview loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)methodtocall
{
    [HTConnect shareConnect].mywindow.windowLevel=UIWindowLevelAlert+1;
    [HTpresentWindow dismissPresentWindow];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
