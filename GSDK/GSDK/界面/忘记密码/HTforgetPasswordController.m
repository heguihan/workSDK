//
//  HTforgetPasswordController.m
//  GSDK
//
//  Created by 王璟鑫 on 16/8/31.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//
#define MAINVIEW_HEIGHT MAINVIEW_WIDTH*(400/550.0)

#import "HTforgetPasswordController.h"
#import "HTTextField.h"

@interface HTforgetPasswordController ()

@property (nonatomic,strong) HTTextField*emailTextfield;

@end

@implementation HTforgetPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(instancetype)init
{
    if (self=[super init]) {
        
        self.mainView.frame=CGRectMake(SCREEN_WIDTH*BEGIN_MAINVIEW, (SCREEN_HEIGHT-MAINVIEW_HEIGHT)/2, MAINVIEW_WIDTH, MAINVIEW_HEIGHT);
        self.backImageView.image=imageNamed(@"底板_2");
        self.backImageView.frame=self.mainView.bounds;
        self.titleLabel.text=bendihua(@"忘记密码");
        [self configUI];
    }
    return self;
}
-(void)configUI
{
    
    self.emailTextfield=[[HTTextField alloc]init];
    self.emailTextfield.frame = CGRectMake(0.09*MAINVIEW_WIDTH, 100/400.0*MAINVIEW_HEIGHT,0.82*MAINVIEW_WIDTH, 80/400.0*MAINVIEW_HEIGHT);
    self.emailTextfield.placeholder=bendihua(@"请输入官方账号注册邮箱");
    [self.mainView addSubview:self.emailTextfield];

    HTBaseButton*reset=[HTBaseButton buttonWithType:(UIButtonTypeCustom)];
    reset.frame=CGRectMake(0.09*MAINVIEW_WIDTH,200/400.0*MAINVIEW_HEIGHT, 0.82*MAINVIEW_WIDTH, 80/470.0*MAINVIEW_HEIGHT);
    [reset setTitle:bendihua(@"重置") font:MXSetSysFont(13) backColor:CGreenColor corner:4];
    [reset addTarget:self action:@selector(resetAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.mainView addSubview:reset];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)resetAction:(HTBaseButton*)sender
{
    
//改改改aaa忘记密码
    if (![regex isValidateEmail:self.emailTextfield.text]) {
        
        [HTAlertView showAlertViewWithText:bendihua(@"请输入正确的邮箱") com:^{}];
    }
    else
    {
        [HTprogressHUD showjuhuaText:bendihua(@"正在发送")];
        
        NSString*strURL=[NSString stringWithFormat:@"http://c.gamehetu.com/passport/find?app=%@&username=%@",[USER_DEFAULT objectForKey:@"appID"],self.emailTextfield.text];
        NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:strURL]];
        [HTNetWorking sendRequest:request ifSuccess:^(id response) {
            
            if ([response[@"code"] isEqualToNumber:@0]) {
                
                [HTAlertView showAlertViewWithText:bendihua(@"密码已发送,请注意查收") com:nil];
            }else
            {
                [HTAlertView showAlertViewWithText:bendihua(@"邮箱不正确") com:nil];
            }
            
        } failure:^(NSError *error) {
            
        }];
        
            
    
    }

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
