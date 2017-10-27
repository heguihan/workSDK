//
//  HTBaseButton.m
//  GSDK
//
//  Created by 王璟鑫 on 16/8/4.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTBaseButton.h"

@implementation HTBaseButton

-(instancetype)init
{
    if (self=[super init]) {
        
    }
    return self;
}

-(void)setTitle:(NSString*)title font:(UIFont*)font backColor:(UIColor*)backColor corner:(NSInteger)corner
{
    [self setTitle:title forState:(UIControlStateNormal)];
    self.titleLabel.font=font;
    if (backColor) {
        self.backgroundColor=backColor;
    }
    [self setCorner:corner];
}

@end
