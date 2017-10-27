//
//  HTFAQCell.h
//  GSDK
//
//  Created by 王璟鑫 on 16/8/19.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTModelCenter.h"

@interface HTFAQCell : UITableViewCell
@property (nonatomic,strong)UILabel*detailLabel;

@property (nonatomic,assign)BOOL isExpent;

-(void)configUIWithModel:(HTModelCenter*)model;
@end
