//
//  HTHistoryDetailCell.m
//  GSDK
//
//  Created by 王璟鑫 on 16/8/22.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTHistoryDetailCell.h"

@interface HTHistoryDetailCell ()

@property (nonatomic,strong)UIView*backView;

@end

@implementation HTHistoryDetailCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}
-(void)configUIWithModel:(HTModelCenter*)model
{
    
    self.backView=[[UIView alloc]init];
    
    self.backView.frame=CGRectMake(50/550.0*MAINVIEW_WIDTH, 4/550.0*MAINVIEW_WIDTH, 450/550.0*MAINVIEW_WIDTH, self.height-8/550.0*MAINVIEW_WIDTH);
    self.backView.backgroundColor=MXRGBColor(230, 230, 230);
    [self.contentView addSubview:self.backView];
    
    self.titleLabel=[[HTBaseLabel alloc]init];
    self.titleLabel.font=MXSetSysFont(10);
    if ([model.isManagerAnswer isEqualToString:@"false"])
    {
        self.titleLabel.text=bendihua(@"问:");
        [self.titleLabel setTextColor:CRedColor];
    }else{
        self.titleLabel.text=bendihua(@"答:");
        [self.titleLabel setTextColor:CGreenColor];
    }
    self.titleLabel.frame=CGRectMake(10/550.0*MAINVIEW_WIDTH, 10/550.0*MAINVIEW_WIDTH, 40/550.0*MAINVIEW_WIDTH, 0);
    [self.titleLabel sizeToFit];
    [self.backView addSubview:self.titleLabel];
    
    self.detailLabel=[[HTBaseLabel alloc]init];
    self.detailLabel.font=MXSetSysFont(8);
    self.detailLabel.textColor=CTextGrayColor;
    self.detailLabel.numberOfLines=0;
    self.detailLabel.text=model.content;
    self.detailLabel.frame=CGRectMake(50/550.0*MAINVIEW_WIDTH,13/550.0*MAINVIEW_WIDTH,self.backView.width-self.titleLabel.right,[self p_heightWithString:self.detailLabel.text]);
    [self.backView addSubview:self.detailLabel];
    
    
    self.dateLabel=[[HTBaseLabel alloc]init];
    self.dateLabel.text=model.createdTime;
    self.dateLabel.textColor=CTextGrayColor;
    self.dateLabel.font=MXSetSysFont(8);
    [self.dateLabel sizeToFit];
    [self.backView addSubview:self.dateLabel];
}

-(void)layoutSubviews
{
    self.backView.frame=CGRectMake(50/550.0*MAINVIEW_WIDTH, 4/550.0*MAINVIEW_WIDTH, 450/550.0*MAINVIEW_WIDTH, self.height-8/550.0*MAINVIEW_WIDTH);
    self.titleLabel.frame=CGRectMake(10/550.0*MAINVIEW_WIDTH, 10/550.0*MAINVIEW_WIDTH, 40/550.0*MAINVIEW_WIDTH, 0);
    [self.titleLabel sizeToFit];
    self.detailLabel.frame=CGRectMake(self.titleLabel.right+3,13/550.0*MAINVIEW_WIDTH,self.backView.width-self.titleLabel.right-10/550.0*MAINVIEW_WIDTH,[self p_heightWithString:self.detailLabel.text]);
    self.dateLabel.centerX=self.backView.width-(self.dateLabel.width/2)-10/550.0*MAINVIEW_WIDTH;
    self.dateLabel.top=self.detailLabel.bottom+13/550.0*MAINVIEW_WIDTH;
}

-(CGFloat)p_heightWithString:(NSString*)aString
{
    CGRect r= [aString boundingRectWithSize:CGSizeMake(400/550.0*MAINVIEW_WIDTH, 2000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:MXSetSysFont(8)} context:nil];
    return r.size.height;
}




@end
