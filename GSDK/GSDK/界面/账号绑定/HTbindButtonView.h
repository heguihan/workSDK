//
//  HTbindButtonView.h
//  GSDK
//
//  Created by 王璟鑫 on 16/8/15.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTbindButtonView : UIView

@property (nonatomic,strong) HTBaseLabel*leftLabel;

@property (nonatomic,strong) HTBaseLabel*centerLabel;

@property (nonatomic,strong) HTBaseButton*rightButton;
-(void)createView;

@end
