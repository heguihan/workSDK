//
//  HTBaseViewController.h
//  NSDK
//
//  Created by 王璟鑫 on 16/8/1.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTBaseLabel.h"
#import "HTBaseButton.h"
#import "HTCustomButtonView.h"
@interface HTBaseViewController : UIViewController

//所有controller都继承这个
@property (nonatomic,strong) UIView*mainView;



@property (nonatomic,strong) HTBaseButton*rightButton;

@property (nonatomic,strong) HTBaseLabel*titleLabel;

@property (nonatomic,strong) UIImageView*backImageView;

@property (nonatomic,strong) HTCustomButtonView*backButton;
@end
