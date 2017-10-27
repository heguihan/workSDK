//
//  HTAssistiveTouch.m
//  NSDK
//
//  Created by 王璟鑫 on 16/7/22.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//
#import "HTTalkToServer.h"
#import "HTAssistiveTouch.h"
#import "HTAccountController.h"
#import "HTBaseNavigationController.h"
#import "HTCustomButtonView.h"
#import "HTWebViewController.h"

#import "HTPayViewController.h"
//获取屏幕 宽度、高度

@interface HTAssistiveTouch ()

typedef enum {
    LEFT=0,
    RIGHT,
}VIEWPOPDIRECTION;

@property (nonatomic,strong) UIImageView *imageView;     //window上的图片

@property (nonatomic,strong) UIView *buttobnView;       //上面放4个Button

@property (nonatomic,strong) UIPanGestureRecognizer*pan;

@end

@implementation HTAssistiveTouch
{
    CGPoint centerPoint;//中心点
    BOOL isShow;        //按钮是否是展开状态
    BOOL isHidden;      //检测是否是
    VIEWPOPDIRECTION DIR;       //展开方向
    VIEWPOPDIRECTION HIDDEN_DIR;        //隐藏方向
}

+(instancetype)sharedInstance
{
    static HTAssistiveTouch *window=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        window=[[HTAssistiveTouch alloc]init];
    });

    return window;
}


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        
        isShow=NO;      //默认是关闭状态

        self.frame=frame;

        self.backgroundColor=[UIColor clearColor];
        
        self.windowLevel=UIWindowLevelAlert+1; //设置window等级
        
        self.pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(changeLoaction:)];//设置移动手势

        [self addGestureRecognizer:self.pan];
        
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];//设置轻拍手势
        [self addGestureRecognizer:tap];

        [self addSubview:self.imageView];
        //調用這個方法,啟動的時候有隱藏的動畫
        //边缘吸附
        [self moveToWind];
    }
    return  self;
    
}

-(void)changeLoaction:(UIPanGestureRecognizer*)pan
{
    self.alpha=1;
    CGPoint point=[pan translationInView:pan.view];
    
    
    if(pan.state == UIGestureRecognizerStateBegan)//平移开始
    {
        
        centerPoint=self.center;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(afterMoveAction:) object:nil];
        
    }else if(pan.state == UIGestureRecognizerStateChanged)
    {
        self.center=CGPointMake(point.x+centerPoint.x, point.y+centerPoint.y);  //移动位置 并且计算中心位置与所点击的地方的差值
        
    }else if(pan.state==UIGestureRecognizerStateEnded)//平移结束
    {
        [self moveToWind];
    }
}
-(void)moveToWind       //边缘吸附效果
{
    
    [UIView animateWithDuration:0.3 animations:^{
        if (self.center.x<(SCREEN_WIDTH/2)) {//左半边
            self.center = CGPointMake(0+self.height/2, self.center.y);
            HIDDEN_DIR=LEFT;
            
        }else
        {
            self.center = CGPointMake((SCREEN_WIDTH-self.height/2), self.center.y);
            HIDDEN_DIR=RIGHT;
            
        }
        if (self.center.y<self.height/2) {
            self.centerY=self.height/2;
        }else if(self.bottom>SCREEN_HEIGHT)
        {
            self.centerY=SCREEN_HEIGHT-self.height/2;
        }
        
        //将小球的位置保存起来
        NSDictionary*dict=@{@"X":[NSString stringWithFormat:@"%f",self.center.x],@"Y":[NSString stringWithFormat:@"%f",self.center.y]};
        [USER_DEFAULT setObject:dict forKey:@"weizhi"];
    }];
    
    [self performSelector:@selector(afterMoveAction:) withObject:nil afterDelay:5];
    
}

-(void)click:(UIButton*)sender          //点击
{
    self.alpha=1;
    if (isHidden) {         //判断是不是在隐藏状态,是的话第一次点击不弹出buttonView,将小白点从隐藏状态移到屏幕边缘
        [self moveToWind];
        isHidden=NO;
    }else
    {

        if (!isShow) {

            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(afterMoveAction:) object:nil];
            
            //只在展开之前获取方向,展开之后,window会变大,window.cebter会移位.
            DIR=(self.origin.x==0||self.center.x<SCREEN_WIDTH/2) ? LEFT:RIGHT;         //三木运算符判断弹出的方向
            
            if (DIR == LEFT) {
                
                self.buttobnView.frame=CGRectMake(self.height+3, 0, 0, self.height);

                [UIView animateWithDuration:0.3 animations:^{
                    
                    self.buttobnView.width=-self.height*5;                 //动画方式
                    self.buttobnView.left=self.height+3;
                }];
                
            }else
            {
                
                self.buttobnView.frame=CGRectMake(-3, 0, 0, self.height);

                [UIView animateWithDuration:0.3 animations:^{

                    self.buttobnView.width=self.height*5;
                    self.buttobnView.left=-3-self.height*5;
                    
                }completion:^(BOOL finished) {
                    
                    self.originX=self.originX-self.height*5-3;
                    self.imageView.frame=CGRectMake(self.width-self.height, 0, self.height, self.height
                                                    );
                    self.buttobnView.right=self.imageView.left-3;
                }];
            }
            self.width=self.height*6+3;

            [self addSubview:self.buttobnView];
            
            self.pan.enabled=NO;
            isShow=YES;
        }else
        {
            
            
            if (DIR==LEFT) {
                
                [UIView animateWithDuration:0.3 animations:^{
                    self.buttobnView.width=0;
                } completion:^(BOOL finished) {
                    
                    [self.buttobnView removeFromSuperview];
                }];
                
            }else
                
            {
                [UIView animateWithDuration:0.3 animations:^{
                self.originX=self.originX+self.height*5+3;
                self.imageView.frame=CGRectMake(0, 0, self.height, self.height);
                self.buttobnView.left=self.imageView.left-3;
                self.buttobnView.width=0;
                } completion:^(BOOL finished) {
                    [self.buttobnView removeFromSuperview];
                }];
            }
            self.width=self.height;
            isShow=NO;
            [self performSelector:@selector(afterMoveAction:) withObject:nil afterDelay:5];
            self.pan.enabled=YES;
        }
        
        
        
        
    }
}

-(void)afterMoveAction:(SEL)sender
{

    if (!isShow) {
        if (HIDDEN_DIR==LEFT) {
            [UIView animateWithDuration:0.2 animations:^{
                self.center=CGPointMake(0-self.height/4, self.center.y);
            }];
          
            
        }else{
            [UIView animateWithDuration:0.2 animations:^{
                self.center=CGPointMake(SCREEN_WIDTH+self.height/4, self.center.y);
                
            }];
            }
        isHidden=YES;
        self.alpha=0.5;
    }



}

#pragma 懒加载----------
-(UIImageView *)imageView
{
    if (!_imageView) {
        
        _imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.height, self.height)];
        [_imageView setCorner:self.height/2];
        _imageView.image=imageNamed(@"G");
    }
    return _imageView;
}
-(UIView *)buttobnView
{
    if (!_buttobnView) {
        
        _buttobnView=[[UIView alloc]init];
        _buttobnView.backgroundColor=[UIColor blackColor];
        [_buttobnView setCorner:self.height/2];
        for (int i=0; i<4; i++) {
            NSArray*imageArray=@[imageNamed(@"账号中心"),imageNamed(@"联系客服"),imageNamed(@"粉丝页"),imageNamed(@"第三方支付")];
            NSArray*nameArray=@[bendihua(@"账号中心"),bendihua(@"联系客服"),bendihua(@"粉丝页"),bendihua(@"优惠储值")];
            HTCustomButtonView*butt=[[HTCustomButtonView alloc]init];
            butt.frame=CGRectMake(self.height/2+self.height*i, 0, self.height, self.height);
            butt.buttonImage=[[UIImageView alloc]init];
            butt.buttonImage.image=imageArray[i];
            butt.buttonImage.bounds=CGRectMake(0, 0, butt.height/2.12, butt.height/2.12);
            butt.buttonImage.center=CGPointMake(butt.height/2, butt.height/2.6);
            
            butt.buttonLabel=[[UILabel alloc]init];
            butt.buttonLabel.text=nameArray[i];
            butt.buttonLabel.textColor=CWhiteColor;
            butt.buttonLabel.font=MXSetSysFont(8);
            [butt.buttonLabel sizeToFit];
            butt.buttonLabel.centerX=butt.height/2;
            butt.buttonLabel.top=butt.buttonImage.bottom+3;
            [butt addSubview:butt.buttonLabel];
            [butt addSubview:butt.buttonImage];
            butt.tag=100+i;
           
            UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonTapAction:)];
            [butt addGestureRecognizer:tap];
            [_buttobnView addSubview:butt];
        }
    }
    return _buttobnView;
}
-(void)buttonTapAction:(UITapGestureRecognizer*)sender
{
    [self click:nil];
    if (sender.view.tag==100) {
        HTAccountController*account=[[HTAccountController alloc]init];
        HTBaseNavigationController*navi=[[HTBaseNavigationController alloc]initWithRootViewController:account];
        [HTpresentWindow sharedInstance].rootViewController=navi;
        
    }else if (sender.view.tag==101)
    {
        HTTalkToServer*talk=[[HTTalkToServer alloc]init];
        HTBaseNavigationController*navi=[[HTBaseNavigationController alloc]initWithRootViewController:talk];
        [HTpresentWindow sharedInstance].rootViewController=navi;
    }else if (sender.view.tag==102)
    {
        [HTConnect shareConnect].mywindow.windowLevel=UIWindowLevelNormal;

        HTWebViewController*con=[[HTWebViewController alloc]init];
        con.type=@"2";
        UINavigationController*navi=[[UINavigationController alloc]initWithRootViewController:con];
        [HTpresentWindow sharedInstance].rootViewController=navi;
    }else
    {
        
        //第三方支付
        
        HTPayViewController *pay = [[HTPayViewController alloc]init];
        HTBaseNavigationController*navi=[[HTBaseNavigationController alloc]initWithRootViewController:pay];
        [HTpresentWindow sharedInstance].rootViewController=navi;
        
        
//        [HTConnect shareConnect].mywindow.windowLevel=UIWindowLevelNormal;
//        HTWebViewController*con=[[HTWebViewController alloc]init];
//        con.type=@"1";
//        UINavigationController*navi=[[UINavigationController alloc]initWithRootViewController:con];
//        [HTpresentWindow sharedInstance].rootViewController=navi;
    }
}

+(void)hiddenWindow
{
    [[HTAssistiveTouch alloc]init].hidden = YES;
}


@end
