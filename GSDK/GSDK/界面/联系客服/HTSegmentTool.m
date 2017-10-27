//
//  HTSegmentTool.m
//  GSDK
//
//  Created by 王璟鑫 on 16/8/16.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTSegmentTool.h"
#import "HTCustomButtonView.h"
#import "HTFAQView.h"
#import "HTOLUpload.h"
#import "HTMyHistory.h"
@interface HTSegmentTool ()

@property (nonatomic,strong) HTCustomButtonView*tempView;

@property (nonatomic,strong) NSArray*picArray;

@property (nonatomic,strong) NSArray*selectArr;
@end



@implementation HTSegmentTool
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}
-(void)configUI
{
    UIView*buttonBackView=[[UIView alloc]init];
    buttonBackView.frame=CGRectMake(0, 0, self.width, 70/490.0*self.height);
    buttonBackView.backgroundColor=MXRGBColor(247, 245, 245);
    [self addSubview:buttonBackView];
    
    UIView*shuxian1=[[UIView alloc]init];
    shuxian1.frame=CGRectMake(self.width/3, 0, 1, 40/490.0*self.height);
    shuxian1.centerY=buttonBackView.centerY;
    shuxian1.backgroundColor=CRedColor;
    UIView*shuxian2=[[UIView alloc]init];
    shuxian2.frame=CGRectMake(self.width/3*2, 0, 1, 40/490.0*self.height);
    shuxian2.centerY=buttonBackView.centerY;
    shuxian2.backgroundColor=CRedColor;
    [buttonBackView addSubview:shuxian1];
    [buttonBackView addSubview:shuxian2];
    
    
    self.picArray=@[imageNamed(@"常见问题_1"),imageNamed(@"在线提交_1"),imageNamed(@"我的记录_1")];
    self.selectArr=@[imageNamed(@"常见问题_2"),imageNamed(@"在线提交_2"),imageNamed(@"我的记录_2")];

    NSArray*nameArray=@[bendihua(@"常见问题"),bendihua(@"在线提交"),bendihua(@"我的记录")];
    for (int i=0; i<3; i++) {
        HTCustomButtonView*smallView=[[HTCustomButtonView alloc]init];
        smallView.frame=CGRectMake(self.width/3*i, 0, self.width/3, buttonBackView.height);
        [buttonBackView addSubview:smallView];
        smallView.backgroundColor=CClearColor;
        smallView.tag=100+i;
        smallView.buttonImage=[[UIImageView alloc]init];
        smallView.buttonImage.bounds=CGRectMake(0, 0, 25/70.0*smallView.height, 25/70.0*smallView.height);
        smallView.buttonImage.center=CGPointMake(smallView.width/2, smallView.height/2.5);
        smallView.buttonLabel=[[UILabel alloc]init];
        smallView.buttonLabel.text=nameArray[i];
        smallView.buttonLabel.font=MXSetSysFont(8);
        [smallView.buttonLabel sizeToFit];
        if (i==0) {
            smallView.buttonImage.image=self.selectArr[i];
            [smallView.buttonLabel setTextColor:CRedColor];
            self.tempView=smallView;
        }else
        {
        smallView.buttonImage.image=self.picArray[i];
        [smallView.buttonLabel setTextColor:MXRGBColor(136, 136, 136)];
        }
        smallView.buttonLabel.centerX=smallView.width/2;
        smallView.buttonLabel.top=smallView.buttonImage.bottom+3;
        [smallView addSubview:smallView.buttonLabel];
        [smallView addSubview:smallView.buttonImage];
        
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectIndex:)];
        [smallView addGestureRecognizer:tap];
        
    }
    
    UIScrollView*bigScrollView=[[UIScrollView alloc]init];
    bigScrollView.frame=CGRectMake(0, buttonBackView.bottom, self.width, self.height-buttonBackView.height);
    bigScrollView.contentSize=CGSizeMake(self.width*3, self.height-buttonBackView.height);
    bigScrollView.tag=200;
    HTFAQView*FAQ=[[HTFAQView alloc]initWithFrame:CGRectMake(0, 0, bigScrollView.width, bigScrollView.height)];
    HTOLUpload*OLU=[[HTOLUpload alloc]initWithFrame:CGRectMake(bigScrollView.width, 0, bigScrollView.width, bigScrollView.height)];
    HTMyHistory*MHT=[[HTMyHistory alloc]initWithFrame:CGRectMake(bigScrollView.width*2, 0, bigScrollView.width, bigScrollView.height)];
    
    bigScrollView.pagingEnabled=YES;
    bigScrollView.bounces=NO;
    bigScrollView.scrollEnabled=NO;
    [bigScrollView addSubview:FAQ];
    [bigScrollView addSubview:OLU];
    [bigScrollView addSubview:MHT];
    [self addSubview:bigScrollView];
}
-(void)selectIndex:(UITapGestureRecognizer*)sender
{
    self.tempView.buttonImage.image=self.picArray[self.tempView.tag-100];
    
    self.tempView.buttonLabel.textColor=MXRGBColor(136, 136, 136);
    
    HTCustomButtonView*smallView=(HTCustomButtonView*)sender.view;
    
    smallView.buttonImage.image=self.selectArr[smallView.tag-100];
    
    [smallView.buttonLabel setTextColor:CRedColor];
    
    self.tempView=smallView;
    
    UIScrollView*big=[self viewWithTag:200];
    
    [UIView animateWithDuration:0.3 animations:^{
        big.contentOffset=CGPointMake((smallView.tag-100)*self.width, 0);
    }];
    
    
}

@end
