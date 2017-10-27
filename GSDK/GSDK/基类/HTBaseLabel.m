//
//  HTBaseLabel.m
//  GSDK
//
//  Created by 王璟鑫 on 16/8/4.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTBaseLabel.h"

@implementation HTBaseLabel

-(void)setText:(NSString*)text font:(UIFont*)font color:(UIColor*)color sizeToFit:(BOOL)sizeToFit
{
    self.text=text;
    self.font=font;
    self.textColor=color;
    if (sizeToFit) {
        [self sizeToFit];
    }
}

@end
