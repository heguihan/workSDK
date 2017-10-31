//
//  HTPayViewController.m
//  GSDK
//
//  Created by 王璟鑫 on 2017/4/10.
//  Copyright © 2017年 王璟鑫. All rights reserved.
//

#import "HTPayViewController.h"


#define MAINVIEW_HEIGHT MAINVIEW_WIDTH*(400/550.0)

@interface HTPayViewController ()
@property (nonatomic,strong)UIWebView*webview;

@end

@implementation HTPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

-(void)configUI
{
//    self.navigationItem.rightBarButtonItem=anotherButton;
//改改改aaa第三方支付
    
    CGRect frame = CGRectMake(0, 70/550.0*MAINVIEW_WIDTH, self.mainView.bounds.size.width, self.mainView.bounds.size.height - 70/550.0*MAINVIEW_WIDTH);
    self.webview=[[UIWebView alloc]initWithFrame:frame];
    self.webview.backgroundColor=[UIColor whiteColor];
    [self.webview setScalesPageToFit:YES];//自动缩放以适应屏幕
    [self.webview setOpaque:NO];//opaque是不透明的意思
    [self.mainView addSubview:self.webview];
    NSString*urlStr;
  
        
        
        NSString *appid = [USER_DEFAULT objectForKey:@"appID"];
        NSString *uid = [USER_DEFAULT objectForKey:@"uid"];
        NSString *coo_server = [USER_DEFAULT objectForKey:@"coo_server"];
        NSString *coo_uid = [USER_DEFAULT objectForKey:@"coo_uid"];
        NSString *custom = [NSString stringWithFormat:@"%@-%@",coo_server,coo_uid];
//        https://hk.trade.gamehetu.com/trade?app_id=1001008&user_id=32434&custom=2001-3434444
//        urlStr = [NSString stringWithFormat:@"http://c.gamehetu.com/pay?app=%@&uid=%@&coo_server=%@&coo_uid=%@",appid,uid,coo_server,coo_uid];
        urlStr = [NSString stringWithFormat:@" https://hk.trade.gamehetu.com/trade?app——id=%@&user_id=%@&custom=%@",appid,uid,custom];
    
        NSLog(@"urlstr=%@",urlStr);
        NSLog(@"OK");
//                urlStr=@"http://c.gamehetu.com/pay?app=100008&uid=1363146&coo_server=9006&coo_uid=64";
        //        urlStr=@"http://c.gamehetu.com/pay?app=100008&uid=1363146&coo_server=9006&coo_uid=64";
    NSURL *url = [NSURL URLWithString:urlStr];
    [self.webview loadRequest:[NSURLRequest requestWithURL:url]];
}


-(instancetype)init
{
    if (self=[super init]) {
        
        self.mainView.frame=CGRectMake(SCREEN_WIDTH*BEGIN_MAINVIEW, (SCREEN_HEIGHT-MAINVIEW_HEIGHT)/2, MAINVIEW_WIDTH, MAINVIEW_HEIGHT);
        
        NSLog(@"width=%f",MAINVIEW_WIDTH);
        NSLog(@"height=%f",MAINVIEW_HEIGHT);
        self.backImageView.image=imageNamed(@"底板_3");
        self.backImageView.frame=self.mainView.bounds;
        self.titleLabel.text=@"Top Up";
        [self configUI];
    }
    return self;
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
