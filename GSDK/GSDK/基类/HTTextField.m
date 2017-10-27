//
//  HTTextField.m
//  GSDK
//
//  Created by 王璟鑫 on 16/8/15.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTTextField.h"

@implementation HTTextField

-(instancetype)init
{
    if (self=[super init]) {

        self.backgroundColor=MXRGBColor(229, 229, 229);
        
       
        self.font=MXSetSysFont(11);
        [self setCorner:4];
        self.textAlignment=NSTextAlignmentCenter;
        
    }
    
    return self;
}
-(void)setPlaceholder:(NSString *)placeholder
{
    [super setPlaceholder:placeholder];
    [self setValue:MXRGBColor(136, 136, 136)forKeyPath:@"_placeholderLabel.textColor"];

    
    
}

@end
