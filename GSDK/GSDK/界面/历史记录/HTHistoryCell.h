//
//  HTHistoryCell.h
//  GSDK
//
//  Created by 王璟鑫 on 16/8/19.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTModelCenter.h"

@interface HTHistoryCell : UITableViewCell

@property (nonatomic,strong) HTBaseLabel*leftLabel;

@property (nonatomic,strong) HTBaseLabel*centerLabel;

@property (nonatomic,strong) HTBaseButton*rightButton;

@property (nonatomic,assign) BOOL type;
-(void)configUIwithModel:(HTModelCenter*)model;

@end
