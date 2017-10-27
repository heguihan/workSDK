
//
//  HTTalkToServer.m
//  GSDK
//
//  Created by 王璟鑫 on 16/8/16.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTTalkToServer.h"
#define MAINVIEW_HEIGHT MAINVIEW_WIDTH*(560/550.0)
#import "HTSegmentTool.h"
@interface HTTalkToServer ()

@end

@implementation HTTalkToServer

- (void)viewDidLoad {
    [super viewDidLoad];
}
-(instancetype)init
{
    if (self=[super init]) {
        self.mainView.frame=CGRectMake(SCREEN_WIDTH*BEGIN_MAINVIEW, (SCREEN_HEIGHT-MAINVIEW_HEIGHT)/2, MAINVIEW_WIDTH, MAINVIEW_HEIGHT);
        self.backImageView.image=imageNamed(@"底板_4");
        self.backImageView.frame=self.mainView.bounds;
        self.titleLabel.text=bendihua(@"联系客服");
        [self configUI];
    }
    return self;
}
-(void)configUI
{
    HTSegmentTool*tool=[[HTSegmentTool alloc]initWithFrame:CGRectMake(0, 70/560.0*MAINVIEW_HEIGHT, MAINVIEW_WIDTH, MAINVIEW_HEIGHT-70/560.0*MAINVIEW_HEIGHT)];
    [self.mainView addSubview:tool];
}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
