//
//  HTFAQCell.m
//  GSDK
//
//  Created by 王璟鑫 on 16/8/19.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTFAQCell.h"

@interface HTFAQCell ()

@property (nonatomic,strong)HTBaseLabel*titleLabel;

@end


@implementation HTFAQCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView*backView=[[UIView alloc]initWithFrame:CGRectMake(40/550.0*MAINVIEW_WIDTH, 3, 470/550.0*MAINVIEW_WIDTH, self.height-6)];
        backView.backgroundColor=MXRGBColor(230, 230, 230);
        backView.tag=10;
        [self.contentView addSubview:backView];
        
        self.titleLabel=[[HTBaseLabel alloc]init];
        
        self.titleLabel.frame=CGRectMake(20/550.0*MAINVIEW_WIDTH, 0, 470/550.0*MAINVIEW_WIDTH-60/550.0*MAINVIEW_WIDTH, 60/550.0*MAINVIEW_WIDTH-6);
        self.titleLabel.font=MXSetSysFont(10);
        self.titleLabel.textColor=CRedColor;
        [backView addSubview:self.titleLabel];
        
        UIImageView*down=[[UIImageView alloc]init];
        down.frame=CGRectMake(self.titleLabel.right+3, 0, 28/550.0*MAINVIEW_WIDTH, 17/550.0*MAINVIEW_WIDTH);
        down.image=imageNamed(@"箭头_3");
        
        down.tag=11;
        down.centerY=self.titleLabel.centerY;
        [backView addSubview:down];
        self.detailLabel=[[UILabel alloc]init];
        self.detailLabel.frame=CGRectMake(self.titleLabel.left, self.titleLabel.bottom, backView.width-self.titleLabel.left*2, 30);
        self.detailLabel.font=MXSetSysFont(10);
        self.detailLabel.textColor=CTextGrayColor;
        self.detailLabel.numberOfLines = 0;
        
        [backView addSubview:self.detailLabel];
        
        
    }
    return self;
}
-(void)configUIWithModel:(HTModelCenter*)model
{
    self.titleLabel.text=model.title;
    self.detailLabel.text=model.content;
    if (self.isExpent) {
        self.detailLabel.hidden=NO;
    }else
    {
        self.detailLabel.hidden=YES;
    }
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self viewWithTag:10].frame=CGRectMake(40/550.0*MAINVIEW_WIDTH, 3, 470/550.0*MAINVIEW_WIDTH, self.height-6);
    if (self.isExpent) {
        
        [self viewWithTag:11].top=self.detailLabel.bottom;
        [self viewWithTag:11].transform = CGAffineTransformMakeRotation(M_PI);
        
    }
}

@end
