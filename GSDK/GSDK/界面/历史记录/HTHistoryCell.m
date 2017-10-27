//
//  HTHistoryCell.m
//  GSDK
//
//  Created by 王璟鑫 on 16/8/19.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTHistoryCell.h"

@interface HTHistoryCell ()

@property (nonatomic,strong)UIView*backView;
@end
@implementation HTHistoryCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backView=[[UIView alloc]init];
        self.backView.frame=CGRectMake(6, 12/550.0*MAINVIEW_WIDTH, MAINVIEW_WIDTH-30/550.0*MAINVIEW_WIDTH, self.height-24/550.0*MAINVIEW_WIDTH);
        self.backView.backgroundColor=MXRGBColor(247, 245, 245);
        [self.contentView addSubview:self.backView];
        
        self.leftLabel=[[HTBaseLabel alloc]init];
        self.leftLabel.frame=CGRectMake(20/520.0*self.backView.width, 0, 100/520.0*self.backView.width, self.backView.height);
        [self.backView addSubview:self.leftLabel];

        self.rightButton=[HTBaseButton buttonWithType:(UIButtonTypeCustom)];
        self.rightButton.frame=CGRectMake(self.backView.width-100/520.0*self.backView.width-5, 0, 100/520.0*self.backView.width+8,self. backView.height);
        self.rightButton.titleLabel.font=MXSetSysFont(10);
        [self.rightButton setTitle:bendihua(@"详情查看") forState:(UIControlStateNormal)];
        [self.backView addSubview:self.rightButton];
        
        
        self.centerLabel=[[HTBaseLabel alloc]init];
        self.centerLabel.frame=CGRectMake(self.leftLabel.right+10, 0, self.backView.width-self.leftLabel.width-self.rightButton.width, self.backView.height);
        self.centerLabel.font=MXSetSysFont(10);
        self.centerLabel.textAlignment=NSTextAlignmentLeft;
        [self.backView addSubview:self.centerLabel];
               self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)configUIwithModel:(HTModelCenter*)model
{
    if ([model.type isEqualToString:@"已回复"]) {
        self.leftLabel.text=bendihua(@"[已回复]");
        self.leftLabel.textColor=CGreenColor;
    }else
    { self.leftLabel.text=bendihua(@"[未回复]");
        self.leftLabel.textColor=CTextGrayColor;
    }
    self.leftLabel.font=MXSetSysFont(9);
    self.leftLabel.textAlignment=NSTextAlignmentLeft;
    self.leftLabel.centerY=self.backView.height/2;

  
    self.centerLabel.text=model.title;
    if ([model.type isEqualToString:@"已回复"]) {
        self.rightButton.backgroundColor=CRedColor;
        self.centerLabel.textColor=CRedColor;
    }else{
        self.rightButton.backgroundColor=CTextGrayColor;
        self.centerLabel.textColor=CTextGrayColor;
    }

   

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
