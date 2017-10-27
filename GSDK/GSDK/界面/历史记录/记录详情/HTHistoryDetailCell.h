//
//  HTHistoryDetailCell.h
//  GSDK
//
//  Created by 王璟鑫 on 16/8/22.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTModelCenter.h"

@interface HTHistoryDetailCell : UITableViewCell

@property (nonatomic,strong) HTBaseLabel*titleLabel;

@property (nonatomic,strong) UILabel*detailLabel;

@property (nonatomic,strong) HTBaseLabel*dateLabel;

@property (nonatomic,assign) BOOL ASK;

-(void)configUIWithModel:(HTModelCenter*)model;

@end
