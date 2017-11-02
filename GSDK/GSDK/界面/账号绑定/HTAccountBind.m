//
//  HTAccountBind.m
//  GSDK
//
//  Created by 王璟鑫 on 16/8/16.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTAccountBind.h"
#import "HTTextField.h"
#define MAINVIEW_HEIGHT MAINVIEW_WIDTH*(400/550.0)
#import "HTAddBindInfoTodict.h"
@interface HTAccountBind ()

@property (nonatomic,strong)HTTextField*top;
@property (nonatomic,strong)HTTextField*center;
@property (nonatomic,strong)HTTextField*bottom;

@end

@implementation HTAccountBind

- (void)viewDidLoad {
    [super viewDidLoad];
}


-(instancetype)init
{
    if (self=[super init]) {
        
        self.mainView.frame=CGRectMake(SCREEN_WIDTH*BEGIN_MAINVIEW, (SCREEN_HEIGHT-MAINVIEW_HEIGHT)/2, MAINVIEW_WIDTH, MAINVIEW_HEIGHT);
        self.backImageView.image=imageNamed(@"底板_2");
        self.backImageView.frame=self.mainView.bounds;
        self.titleLabel.text=bendihua(@"帳號綁定");
        [self configUI];
    }
    return self;
}
-(void)configUI
{
    self.top=[[HTTextField alloc]init];
    self.top.frame = CGRectMake(0.09*MAINVIEW_WIDTH, 103/400.0*MAINVIEW_HEIGHT, 0.82*MAINVIEW_WIDTH, 50/400.0*MAINVIEW_HEIGHT);
    self.top.placeholder=bendihua(@"请输入有效邮箱账号");
    [self.mainView addSubview:self.top];
    
    self.center=[[HTTextField alloc]init];
    self.center.frame = CGRectMake(self.top.left,self. top.bottom+18/400.0*MAINVIEW_HEIGHT, 0.82*MAINVIEW_WIDTH, 50/400.0*MAINVIEW_HEIGHT);
    self.center.placeholder=bendihua(@"请输入密码");
    self.center.clearButtonMode=YES;
    self.center.secureTextEntry=YES;
    [self.mainView addSubview:self.center];

   self.bottom=[[HTTextField alloc]init];
    self.bottom.frame = CGRectMake(self.center.left, self.center.bottom+18/400.0*MAINVIEW_HEIGHT, 0.82*MAINVIEW_WIDTH, 50/400.0*MAINVIEW_HEIGHT);
    self.bottom.placeholder=bendihua(@"請再次輸入密碼");
    self.bottom.clearButtonMode=YES;
    self.bottom.secureTextEntry=YES;
    [self.mainView addSubview:self.bottom];

    
    HTBaseButton*makesureBind=[HTBaseButton buttonWithType:(UIButtonTypeCustom)];
    [makesureBind setTitle:bendihua(@"确认绑定") font:MXSetSysFont(11) backColor:CRedColor corner:4];

    makesureBind.frame=CGRectMake(0,self.bottom.bottom+32/400.0*MAINVIEW_HEIGHT, 0.45*MAINVIEW_WIDTH, 46/400.0*MAINVIEW_HEIGHT);
    makesureBind.centerX=self.mainView.width/2;
    [makesureBind addTarget:self action:@selector(makeSureBind:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.mainView addSubview:makesureBind];

}

-(void)makeSureBind:(HTBaseButton*)sender
{
    if ([self.top.text isEqualToString:@""]||[self.center.text isEqualToString:@""])
    {
        
        [HTAlertView showAlertViewWithText:bendihua(@"用户名或密码不能为空") com:nil];
    }
    //是不是邮箱
    else if(![regex isValidateEmail:self.top.text])
    {
        [HTAlertView showAlertViewWithText:bendihua(@"请输入正确的邮箱账号") com:nil];

          }
    else if (!(self.center.text.length>=6&&self.center.text.length<=16))
    {
        [HTAlertView showAlertViewWithText:bendihua(@"密码长度在6位至16位之间") com:nil];

    }else if (!(self.top.text.length>=6&&self.top.text.length<=32)){
        [HTAlertView showAlertViewWithText:bendihua(@"请输入正确的邮箱账号") com:nil];
    }
    //    不能含有空格
    else if([regex haveKongGe:self.center.text])
    {
        [HTAlertView showAlertViewWithText:bendihua(@"密码不能含有空格") com:nil];
    }
    //两次密码输入不一致
    else if(![self.center.text isEqualToString:self.bottom .text])
    {
        [HTAlertView showAlertViewWithText:bendihua(@"两次输入不一致") com:nil];
    }else
    {
//改改改aaa官方账号绑定
        [HTprogressHUD showjuhuaText:@"正在绑定"];
       NSDictionary*userDict= [USER_DEFAULT objectForKey:@"userInfo"];
        
        NSString *newUrlStr = [NSString stringWithFormat:@"%@%@",SERVER_URL,BIND_URL];
        NSString *pram_access_token = [USER_DEFAULT objectForKey:@"access_token"];
        NSString *pram_username = self.top.text;
        NSString *pram_password = self.center.text;
        NSString *pram_lang = [USER_DEFAULT objectForKey:@"lang"];
        NSString *pramStr = [NSString stringWithFormat:@"access_token=%@&username=%@&password=%@&lang=%@",pram_access_token, pram_username, pram_password, pram_lang];
        NSString *newStr = [NSString stringWithFormat:@"%@?%@",newUrlStr,pramStr];
        NSLog(@"bindurl=%@",newStr);
        NSURL *URL = [NSURL URLWithString:newStr];
        
//        account/bind
//        参数 access_token, username, password
        
//        NSString*str=[NSString stringWithFormat:@"type=email&auth=%@&password=%@&token=%@",self.top.text,self.center.text,[userDict valueForKeyPath:@"data.token"]];
//        NSString*dataStr=[RSA encryptString:str];
//        NSURL*URL=[NSURL URLWithString:[NSString stringWithFormat:@"http://c.gamehetu.com//passport/bind?app=%@&format=json&version=2.0&data=%@",[USER_DEFAULT objectForKey:@"appID"],dataStr]];
        //access_token, username, password
        
        
        NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:URL];
        [HTNetWorking sendRequest:request ifSuccess:^(id response) {
            [HTprogressHUD hiddenHUD];
            if ([response[@"code"] isEqualToNumber:@0]) {
//                [HTprogressHUD hiddenHUD];
      
                   [HTAddBindInfoTodict addInfoToDictType:@"email" auth_name:self.top.text];
                [USER_DEFAULT setObject:pram_password forKey:@"password"];
                [USER_DEFAULT synchronize];
                
                [HTAlertView showAlertViewWithText:bendihua(@"绑定成功") com:^{
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }];

            }else if([response[@"code"]isEqualToNumber:@1])
            {
                [HTAlertView showAlertViewWithText:response[@"msg"] com:nil];
//                if ([response[@"msg"]isEqualToString:@"failed, the user is exist"]) {
//                    [HTAlertView showAlertViewWithText:bendihua(@"绑定失败,邮箱已被绑定") com:nil];
//                }else
//                {
//                    [HTAlertView showAlertViewWithText:bendihua(@"绑定失败,设备或账号已被绑定过") com:nil];
//                }
            
        }else
        {
//            [HTAlertView showAlertViewWithText:bendihua(@"绑定失败") com:nil];
            [HTAlertView showAlertViewWithText:response[@"msg"] com:nil];

            }
        }
        failure:^(NSError *error) {
       
            
        }];
    }

    
}




@end
