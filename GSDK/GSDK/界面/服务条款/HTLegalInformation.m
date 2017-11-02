//
//  HTLegalInformation.m
//  GSDK
//
//  Created by 王璟鑫 on 16/10/14.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTLegalInformation.h"

@interface HTLegalInformation ()
#define MAINVIEW_HEIGHT MAINVIEW_WIDTH*(560/550.0)

@end

@implementation HTLegalInformation

- (void)viewDidLoad {
    [super viewDidLoad];
}
-(instancetype)init
{
    if (self=[super init]) {
        self.mainView.frame=CGRectMake(SCREEN_WIDTH*BEGIN_MAINVIEW, (SCREEN_HEIGHT-MAINVIEW_HEIGHT)/2, MAINVIEW_WIDTH, MAINVIEW_HEIGHT);
        self.backImageView.image=imageNamed(@"底板_4");
        self.backImageView.frame=self.mainView.bounds;
        self.titleLabel.text=bendihua(@"隐私条款");
        [self configUI];
    }
    return self;
}
-(void)configUI
{
    UITextView*textView=[[UITextView alloc]initWithFrame:CGRectMake(0, 70/560.0*MAINVIEW_HEIGHT , self.mainView.width, self.mainView.height-70/560.0*MAINVIEW_HEIGHT)];
    [self.mainView addSubview:textView];
    textView.selectable=NO;
    textView.editable=NO;
    textView.text=bendihua(@"隐私条款正文");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
