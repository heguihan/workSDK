//
//  HTBaseViewController.m
//  NSDK
//
//  Created by 王璟鑫 on 16/8/1.
//  Copyright © 2016年 王璟鑫. All rights reserved.
#import "HTBaseViewController.h"
#import "HTConnect.h"
@interface HTBaseViewController ()

@end

@implementation HTBaseViewController





- (void)viewDidLoad {
    
    [super viewDidLoad];
    
}
-(instancetype)init
{
    if (self=[super init]) {
        
        //隐藏系统返回键
        self.navigationItem.hidesBackButton = YES;

        self.view.backgroundColor=[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.1];
        
        self.mainView=[[UIView alloc]init];
        
        self.mainView.backgroundColor=CClearColor;
        
        self.backImageView=[[UIImageView alloc]init];
        [self.mainView addSubview:self.backImageView];
        
        
        [self.view addSubview: self.mainView];
        
        self.titleLabel=[[HTBaseLabel alloc]init];
        self.titleLabel.text=@"這是個佔位符8個";
        self.titleLabel.font=MXSetBlodFont(18);
        self.titleLabel.textColor=CWhiteColor;
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
        [self.titleLabel sizeToFit];
        self.titleLabel.centerX=self.view.centerX-SCREEN_WIDTH*BEGIN_MAINVIEW;
        self.titleLabel.centerY=70/550.0*MAINVIEW_WIDTH/2;
        [self.mainView addSubview:self.titleLabel];
        


        
        self.backButton=[[HTCustomButtonView alloc]init];
        self.backButton.frame=CGRectMake(0, 0, 100/550.0*MAINVIEW_WIDTH, 70/550.0*MAINVIEW_WIDTH);
        self.backButton.buttonImage=[[UIImageView alloc]initWithFrame:CGRectMake(8, 0,20/100.0*self.backButton.width , 30/70.0*self.backButton.height)];
        self.backButton.buttonImage.centerY=self.backButton.height/2;
        self.backButton.buttonImage.image=imageNamed(@"箭头_1");
        [self .backButton addSubview:self.backButton.buttonImage];
        self.backButton.buttonLabel=[[UILabel alloc]init];
        self.backButton.buttonLabel.frame=CGRectMake(self.backButton.buttonImage.right, 0, 0, self.backButton.height);
        self.backButton.buttonLabel.text=bendihua(@"返回");
        self.backButton.buttonLabel.font=MXSetSysFont(12);
        self.backButton.buttonLabel.textColor=CWhiteColor;
        [self.backButton.buttonLabel sizeToFit];
        self.backButton.buttonLabel.centerY=self.backButton.buttonImage.centerY;
        [self.backButton addSubview:self.backButton.buttonImage];
        [self.backButton addSubview:self.backButton.buttonLabel];
        [self.mainView addSubview:self.backButton];
        
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backButton:)];
        [self.backButton addGestureRecognizer:tap];
        
        
        self.rightButton=[HTBaseButton buttonWithType:(UIButtonTypeCustom)];
        self.rightButton.frame=CGRectMake(0, 0, 0, 70/550.0*MAINVIEW_WIDTH);
        [self.rightButton setTitle:bendihua(@"关闭") font:MXSetSysFont(12) backColor:nil corner:0];
        [self.rightButton setTitleColor:CWhiteColor forState:(UIControlStateNormal)];
        [self.rightButton sizeToFit];
        self.rightButton.centerY=self.backButton.height/2;
        self.rightButton.right=SCREEN_WIDTH-BEGIN_MAINVIEW*SCREEN_WIDTH*2-8;
        [self.mainView addSubview:self.rightButton];
        
        [self.rightButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return self;
}
-(void)backButton:(UITapGestureRecognizer*)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)closeButtonAction:(HTBaseButton*)sender
{
    [HTpresentWindow dismissPresentWindow];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewWillAppear:(BOOL)animated
{
    if (self.navigationController.childViewControllers.count==1) {
        self.backButton.hidden=YES;
    }
    if (![HTConnect shareConnect].mywindow) {
        self.rightButton.hidden=YES;
    }
}

@end
