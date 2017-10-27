//
//  HTOLUPLoadCell.m
//  GSDK
//
//  Created by 王璟鑫 on 16/8/22.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTOLUPLoadCell.h"

@implementation HTOLUPLoadCell




-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor=MXRGBColor(247, 245, 245);
        
        [self configUI];
    }
    return self;
}
-(void)configUI
{
    self.leftLabel=[[HTBaseLabel alloc]initWithFrame:CGRectMake(15/550.0*MAINVIEW_WIDTH, 0, 370/550.0*MAINVIEW_WIDTH, 50/550.0*MAINVIEW_WIDTH)];
    self.leftLabel.font=MXSetSysFont(10);
    self.leftLabel.textColor=CTextGrayColor;
    [self addSubview:self.leftLabel];
    UIView*buttonView=[[UIView alloc]init];
    buttonView.backgroundColor=[UIColor clearColor];
    buttonView.frame=CGRectMake(self.leftLabel.right, 0, 450/550.0*MAINVIEW_WIDTH-self.leftLabel.right, 50/550.0*MAINVIEW_WIDTH);
    [self.contentView addSubview:buttonView];
    
    self.rightButton=[[UIImageView alloc]init];
    self.rightButton.bounds=CGRectMake(0, 0, 25/550.0*MAINVIEW_WIDTH, 25/550.0*MAINVIEW_WIDTH);
    self.rightButton.center=CGPointMake(buttonView.width/2, buttonView.height/2);
    self.rightButton.image=imageNamed(@"选择_1");
    [buttonView addSubview:self.rightButton];
    UIView*hengxanView=[[UIView alloc]initWithFrame:CGRectMake(self.leftLabel.left, 50/550.0*MAINVIEW_WIDTH-1, buttonView.left-self.leftLabel.left+3, 1)];
    hengxanView.backgroundColor=CGrayColor;
    [self addSubview:hengxanView];
    }

@end
