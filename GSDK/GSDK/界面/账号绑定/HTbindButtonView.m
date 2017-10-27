//
//  HTbindButtonView.m
//  GSDK
//
//  Created by 王璟鑫 on 16/8/15.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTbindButtonView.h"

@implementation HTbindButtonView
-(instancetype)init
{
    if (self=[super init]) {
        self.backgroundColor=MXRGBColor(229, 229, 229);
        [self setCorner:4];
    }
    return self;
}
-(void)createView
{
    if (!self.leftLabel) {
    self.leftLabel=[[HTBaseLabel alloc]init];
    }
    self.leftLabel.frame=CGRectMake(8,0,150/550.0*MAINVIEW_WIDTH , self.height);
    self.leftLabel.font=MXSetSysFont(10);
    self.leftLabel.textAlignment=NSTextAlignmentLeft;
    self.leftLabel.textColor=MXRGBColor(136, 136, 136);
    [self addSubview:self.leftLabel];
    
    if (!self.centerLabel) {
    self.centerLabel=[[HTBaseLabel alloc]init];
    }
    self.centerLabel.frame=CGRectMake(self.leftLabel.right, 0, self.width-150/550.0*MAINVIEW_WIDTH*2, self.height);
    self.centerLabel.textAlignment=NSTextAlignmentCenter;
    self.centerLabel.font=MXSetSysFont(10);
    self.centerLabel.textColor=MXRGBColor(136, 136, 136);
    [self addSubview:self.centerLabel];
    
    if (!self.rightButton) {
        self.rightButton=[HTBaseButton buttonWithType:(UIButtonTypeCustom)];
        self.rightButton.frame=CGRectMake(self.centerLabel.right, 0, 150/550.0*MAINVIEW_WIDTH, self.height);
        self.rightButton.titleLabel.font=MXSetSysFont(10);
        [self addSubview:self.rightButton];
    
    }
    
}

@end
