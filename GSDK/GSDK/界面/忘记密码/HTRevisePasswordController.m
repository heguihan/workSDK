//
//  HTRevisePasswordController.m
//  GSDK
//
//  Created by 王璟鑫 on 16/8/16.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//
#import "HTBaseNavigationController.h"
#import "HTChangeAccountController.h"
#import "HTRevisePasswordController.h"
#import "HTTextField.h"
#define MAINVIEW_HEIGHT MAINVIEW_WIDTH*(470/550.0)

@interface HTRevisePasswordController ()
@property (nonatomic,strong)HTTextField *username;
@property (nonatomic,strong)HTTextField *password;
@end

@implementation HTRevisePasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
}
-(instancetype)init
{
    if (self=[super init]) {
        self.mainView.frame=CGRectMake(SCREEN_WIDTH*BEGIN_MAINVIEW, (SCREEN_HEIGHT-MAINVIEW_HEIGHT)/2, MAINVIEW_WIDTH, MAINVIEW_HEIGHT);
        self.backImageView.image=imageNamed(@"底板_3");
        self.backImageView.frame=self.mainView.bounds;
        self.titleLabel.text=bendihua(@"修改密码");
        [self configUI];
    }
    return self;
}
-(void)configUI
{
    self.username=[[HTTextField alloc]init];
    self.username.frame = CGRectMake(0.09*MAINVIEW_WIDTH, 120/470.0*MAINVIEW_HEIGHT, 0.82*MAINVIEW_WIDTH, 60/470.0*MAINVIEW_HEIGHT);
    self.username.placeholder=bendihua(@"请输入新密码");
    [self.mainView addSubview:self.username];
    self.password=[[HTTextField alloc]init];
    self.password.frame = CGRectMake(0.09*MAINVIEW_WIDTH, 200/470.0*MAINVIEW_HEIGHT, 0.82*MAINVIEW_WIDTH, 60/470.0*MAINVIEW_HEIGHT);
    self.password.placeholder=bendihua(@"请再次输入新密码");
    [self.mainView addSubview:self.password];

   
    
    HTBaseButton*makesureRevise=[HTBaseButton buttonWithType:(UIButtonTypeCustom)];
    [makesureRevise setTitle:bendihua(@"确认修改") font:MXSetSysFont(11) backColor:CRedColor corner:4];
    
    makesureRevise.frame=CGRectMake(0,self.password.bottom+44/470.0*MAINVIEW_HEIGHT, self.username.width*2/3, 60/470.0*MAINVIEW_HEIGHT);
    makesureRevise.centerX=self.mainView.width/2;
    [makesureRevise addTarget:self action:@selector(makeSureRevise:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.mainView addSubview:makesureRevise];
    
}

-(void)makeSureRevise:(HTBaseButton*)sender
{
    if (!self.password.text) {
        [HTAlertView showAlertViewWithText:bendihua(@"密码不能为空") com:nil];
    }else if(self.password.text.length<6||self.password.text.length>16)
    {
        [HTAlertView showAlertViewWithText:bendihua(@"密码长度在6位至16位之间") com:nil];
    }
    else if(![self.username.text isEqualToString:self.password.text])
    {
        [HTAlertView showAlertViewWithText:bendihua(@"密码输入不一致请重新输入") com:nil];
    }else if ([regex haveKongGe:self.username.text])
    {
        [HTAlertView showAlertViewWithText:bendihua(@"密码不能含有空格") com:nil];

    }
    else
    {
    NSString*dataStr=[NSString stringWithFormat:@"token=%@&password=%@",USERTOKEN,self.username.text];
        NSString*rsaStr=[RSA encryptString:dataStr];
        NSString*urlStr=[NSString stringWithFormat:@"http://c.gamehetu.com/passport/update?app=%@&format=json&data=%@&version=2.0",[[NSUserDefaults standardUserDefaults]objectForKey:@"appID"],rsaStr];
        NSURL*url=[NSURL URLWithString:urlStr];
        NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:url];
        [HTprogressHUD showjuhuaText:bendihua(@"正在加載")];
        [HTNetWorking sendRequest:request ifSuccess:^(id response) {
            [HTprogressHUD hiddenHUD];
            if ([response[@"code"] isEqual:@0]) {
                [HTHUD showHUD:bendihua(@"密码修改成功,请重新登录游戏")];
                
                NSDictionary *changDic = @{@"code":@2,@"msg":@"success"};
                
                [HTConnect shareConnect].changePassword(changDic);
                
//                [HTConnect shareConnect].changeAccount(response,nil);
                [USER_DEFAULT setObject:nil forKey:@"first"];
                [USER_DEFAULT setObject:nil forKey:@"userInfo"];
                [HTConnect hideAssistiveTouch];
                HTChangeAccountController*account=[[HTChangeAccountController alloc]init];
                HTBaseNavigationController*navi=[[HTBaseNavigationController alloc]initWithRootViewController:account];
                account.rightButton.hidden=YES;
                account.backButton.hidden=YES;
                [HTpresentWindow sharedInstance].rootViewController=navi;
            }else if ([response[@"msg"]isEqualToString:@"new password error"])
            {
                [HTAlertView showAlertViewWithText:bendihua(@"新密码不能和旧密码相同") com:nil];

            }
            else
            {
                [HTAlertView showAlertViewWithText:response[@"msg"] com:nil];
            }
        } failure:^(NSError *error) {
            
        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
