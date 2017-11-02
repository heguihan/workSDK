//
//  HTRegisterController.m
//  GSDK
//
//  Created by 王璟鑫 on 16/8/18.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//
#import "HTTextField.h"
#import "HTRegisterController.h"
#import "HTAlertView.h"
#import "HTNameAndRequestModel.h"
#import "HTloginHelp.h"
#import "HTLegalInformation.h"
#import "HTServerInformation.h"
#import "HTLoginManager.h"
#define MAINVIEW_HEIGHT MAINVIEW_WIDTH*(400/550.0)

@interface HTRegisterController ()

@end

@implementation HTRegisterController{
    HTTextField*top;
    HTTextField*bottom;
    HTTextField*center;
    HTBaseButton*fangkuangButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(instancetype)init
{
    if (self=[super init]) {
        self.mainView.frame=CGRectMake(SCREEN_WIDTH*BEGIN_MAINVIEW, (SCREEN_HEIGHT-MAINVIEW_HEIGHT)/2, MAINVIEW_WIDTH, MAINVIEW_HEIGHT);
        self.backImageView.image=imageNamed(@"底板_2");
        self.backImageView.frame=self.mainView.bounds;
        self.titleLabel.text=bendihua(@"帳號注册");
        [self configUI];
    }
    return self;
}
-(void)configUI
{
    top=[[HTTextField alloc]init];
    top.frame = CGRectMake(0.09*MAINVIEW_WIDTH, 89/400.0*MAINVIEW_HEIGHT,0.82*MAINVIEW_WIDTH, 50/400.0*MAINVIEW_HEIGHT);
    top.placeholder=bendihua(@"请输入正确的邮箱XXXX@XX.XXX");
    [self.mainView addSubview:top];
    
    center=[[HTTextField alloc]init];
    center.frame = CGRectMake(0.09*MAINVIEW_WIDTH, top.bottom+11/400.0*MAINVIEW_HEIGHT, 0.82*MAINVIEW_WIDTH, 50/400.0*MAINVIEW_HEIGHT);
    center.clearButtonMode=YES;
    center.secureTextEntry=YES;
    center.placeholder=bendihua(@"请输入新密码");
    [self.mainView addSubview:center];
    
    bottom=[[HTTextField alloc]init];
    bottom.frame = CGRectMake(0.09*MAINVIEW_WIDTH, center.bottom+11/400.0*MAINVIEW_HEIGHT, 0.82*MAINVIEW_WIDTH, 50/400.0*MAINVIEW_HEIGHT);
    bottom.clearButtonMode=YES;
    bottom.secureTextEntry=YES;
    bottom.placeholder=bendihua(@"請再次輸入密碼");
    [self.mainView addSubview:bottom];
    

    fangkuangButton=[HTBaseButton buttonWithType:(UIButtonTypeCustom)];
    fangkuangButton.frame=CGRectMake(bottom.left, bottom.bottom+19/400.0*MAINVIEW_HEIGHT, 33/550.0*MAINVIEW_WIDTH, 27/550.0*MAINVIEW_WIDTH);
    [fangkuangButton setImage:imageNamed(@"方形选择_2") forState:(UIControlStateNormal)];
    [fangkuangButton setImage:imageNamed(@"方形选择_1") forState:(UIControlStateSelected)];
    [fangkuangButton addTarget:self action:@selector(fangkuangAcction:) forControlEvents:(UIControlEventTouchUpInside)];
    [fangkuangButton setSelected:YES];
    [self.mainView addSubview:fangkuangButton];
    
    
    HTBaseLabel*woTongYi=[[HTBaseLabel alloc]init];
    woTongYi.frame=CGRectMake(fangkuangButton.right+2, fangkuangButton.top, 0, 0);
    [woTongYi setText:bendihua(@"我同意") font:MXSetSysFont(10) color:CTextGrayColor sizeToFit:YES];
    woTongYi.centerY=fangkuangButton.centerY+1;
    [self.mainView addSubview:woTongYi];
    
    
    HTBaseButton*fuWuTiaoKuan=[HTBaseButton buttonWithType:(UIButtonTypeCustom)];
    fuWuTiaoKuan.frame=CGRectMake(woTongYi.right+2, woTongYi.top, 0, 0);
    NSMutableAttributedString *fuwuStr = [[NSMutableAttributedString alloc] initWithString:bendihua(@"服务条款")];
    NSRange strRange = {0,[fuwuStr length]};
    [fuwuStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [fuwuStr addAttribute:NSForegroundColorAttributeName value:CTextGrayColor range:strRange];
    [fuwuStr addAttribute:NSUnderlineColorAttributeName
                value:CTextGrayColor
                range:strRange];
    [fuWuTiaoKuan setAttributedTitle:fuwuStr forState:UIControlStateNormal];
    fuWuTiaoKuan.titleLabel.font=MXSetSysFont(10);
    [fuWuTiaoKuan sizeToFit];
    fuWuTiaoKuan.centerY=woTongYi.centerY;
    [self.mainView addSubview:fuWuTiaoKuan];
    [fuWuTiaoKuan addTarget:self action:@selector(fuWuTiaoKuan:) forControlEvents:UIControlEventTouchUpInside];
    
    
    HTBaseLabel*he=[[HTBaseLabel alloc]init];
    he.frame=CGRectMake(fuWuTiaoKuan.right+2, 0, 0, 0);
    [he setText:bendihua(@"和") font:woTongYi.font color:CTextGrayColor sizeToFit:YES];
    he.centerY=fuWuTiaoKuan.centerY;
    [self.mainView addSubview:he];
    
    
    
    HTBaseButton*yinSiTiaoKuan=[HTBaseButton buttonWithType:(UIButtonTypeCustom)];
    yinSiTiaoKuan.frame=CGRectMake(he.right+2, he.top, 0, 0);
    NSMutableAttributedString *yinSiStr = [[NSMutableAttributedString alloc] initWithString:bendihua(@"隐私条款")];
    NSRange yiStrRange = {0,[yinSiStr length]};
    [yinSiStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:yiStrRange];
    [yinSiStr addAttribute:NSForegroundColorAttributeName value:CTextGrayColor range:yiStrRange];
    [yinSiStr addAttribute:NSUnderlineColorAttributeName
                value:CTextGrayColor
                range:yiStrRange];

    [yinSiTiaoKuan setAttributedTitle:yinSiStr forState:UIControlStateNormal];
    yinSiTiaoKuan.titleLabel.font=MXSetSysFont(10);
    [yinSiTiaoKuan sizeToFit];
    yinSiTiaoKuan.centerY=he.centerY;
    [self.mainView addSubview:yinSiTiaoKuan];
    [yinSiTiaoKuan addTarget:self action:@selector(yinSiTiaoKuan:) forControlEvents:UIControlEventTouchUpInside];
    
    HTBaseButton*regisAndLogin=[HTBaseButton buttonWithType:(UIButtonTypeCustom)];
    [regisAndLogin setTitle:bendihua(@"注册并登录") font:MXSetSysFont(11) backColor:CRedColor corner:4];
    regisAndLogin.frame=CGRectMake(0,fangkuangButton.bottom+20/400.0*MAINVIEW_HEIGHT, 0.45*MAINVIEW_WIDTH, 46/400.0*MAINVIEW_HEIGHT);
    regisAndLogin.centerX=self.mainView.width/2;
    [regisAndLogin addTarget:self action:@selector(regisAndLoginAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.mainView addSubview:regisAndLogin];
}
-(void)fangkuangAcction:(HTBaseButton*)sender
{
    if (!sender.selected) {
        
        sender.selected=YES;
        
    }else
    {
        sender.selected=NO;
    }
}
-(void)regisAndLoginAction:(HTBaseButton*)sender
{
    //判断用户名或密码不能为空
    if ([top.text isEqualToString:@""]||[center.text isEqualToString:@""])
    {

        [HTAlertView showAlertViewWithText:bendihua(@"用户名或密码不能为空") com:nil];
    }
    //判断用户
    else if (![regex isValidateEmail:top.text])
    {
     
        [HTAlertView showAlertViewWithText:bendihua(@"请输入常用邮箱,方便密码找回") com:nil];
    }
    else if (!(center.text.length>=6&&center.text.length<=16))
    {
      
        [HTAlertView showAlertViewWithText:bendihua(@"密码长度在6位至16位之间") com:nil];

    }else if (!(top.text.length>=6&&top.text.length<=32)){
        
        [HTAlertView showAlertViewWithText:bendihua(@"用戶名長度應在6位元至32位之間") com:nil];
    }
    //不能含有空格
    else if([regex haveKongGe:center.text])
    {
        [HTAlertView showAlertViewWithText:bendihua(@"密码不能含有空格") com:nil];
    }
    //两次密码输入不一致
    else if(![center.text isEqualToString:bottom .text])
    {
     [HTAlertView showAlertViewWithText:bendihua(@"密码输入不一致请重新输入") com:nil];
    }
    //请先同意用户协议
    else if(fangkuangButton.selected==NO)
    {
        [HTAlertView showAlertViewWithText:bendihua(@"请同意使用者协议") com:nil];
    }else
    {
//改改改aaa注册。。。。注册成功之后信息有没有保存？
        [HTprogressHUD showjuhuaText:@"正在注册"];
        NSMutableURLRequest*request=[HTloginHelp returnRequest:[HTloginHelp returnSignupString] usernameTextField:top passwordTextField:center];
        NSString *password = center.text;
        [HTNetWorking sendRequest:request ifSuccess:^(id response) {
        
            if ([response[@"code"] isEqualToNumber:@0]) {

                NSMutableURLRequest*murequest=[HTloginHelp returnRequest:[HTloginHelp returnLoginString] usernameTextField:top passwordTextField:center];
                [HTNameAndRequestModel setFastRequest:murequest AndNameFormdict:response];

                [HTHUD showHUD:bendihua(@"注册并登录成功")];
                
                
                NSString *str = response[@"open_id"];
                NSLog(@"uid=%@",str);
                [USER_DEFAULT setObject:str forKey:@"uid"];
                //保存access_token
                
                NSString *access_token = response[@"access_token"];
                [USER_DEFAULT setObject:access_token forKey:@"access_token"];
                //保存密码
                NSLog(@"password=%@",password);
                [USER_DEFAULT setObject:@"10" forKey:@"loginway"];
                [USER_DEFAULT setObject:password forKey:@"password"];
                [USER_DEFAULT synchronize];
                [HTLoginSuccess loginSuccessWithtoken:access_token];
                
                
                [HTConnect showAssistiveTouch];
                
                
                [HTConnect shareConnect].loginBackBlock(response,nil);
                NSDictionary *changDic = @{@"code":@2,@"msg":@"success"};
                [HTConnect shareConnect].changePassword(changDic);
                
                [HTpresentWindow dismissPresentWindow];
                [HTLoginManager loginRetuen];
                
            }
//            else if ([response[@"code"]isEqualToNumber:@40106])
//            {
//                [HTAlertView showAlertViewWithText:bendihua(@"用户名已存在") com:nil];
//                [HTprogressHUD hiddenHUD];
//                
//            }
            else{
                
//                [HTAlertView showAlertViewWithText:bendihua(@"登录失败") com:nil];
                [HTAlertView showAlertViewWithText:response[@"msg"] com:nil];
                [HTprogressHUD hiddenHUD];
            }
                    } failure:^(NSError *error) {
                        [HTprogressHUD hiddenHUD];
            
        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)yinSiTiaoKuan:(HTBaseButton*)sender
{
    HTLegalInformation*legal=[[HTLegalInformation alloc]init];
    [self.navigationController pushViewController:legal animated:YES];
}

-(void)fuWuTiaoKuan:(HTBaseButton*)sender
{
    HTServerInformation*infor=[[HTServerInformation alloc]init];
    [self.navigationController pushViewController:infor animated:YES];

}
@end
