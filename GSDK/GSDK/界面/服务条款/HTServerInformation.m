//
//  HTServerInformation.m
//  GSDK
//
//  Created by 王璟鑫 on 2016/11/24.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTServerInformation.h"

@interface HTServerInformation ()
#define MAINVIEW_HEIGHT MAINVIEW_WIDTH*(560/550.0)

@end

@implementation HTServerInformation

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(instancetype)init
{
    if (self=[super init]) {
        self.mainView.frame=CGRectMake(SCREEN_WIDTH*BEGIN_MAINVIEW, (SCREEN_HEIGHT-MAINVIEW_HEIGHT)/2, MAINVIEW_WIDTH, MAINVIEW_HEIGHT);
        self.backImageView.image=imageNamed(@"底板_4");
        self.backImageView.frame=self.mainView.bounds;
        self.titleLabel.text=bendihua(@"服務條款");
        [self configUI];
    }
    return self;
}
-(void)configUI
{
    UITextView*textView=[[UITextView alloc]initWithFrame:CGRectMake(0, 70/560.0*MAINVIEW_HEIGHT , self.mainView.width, self.mainView.height-70/560.0*MAINVIEW_HEIGHT)];
    [self.mainView addSubview:textView];
    textView.selectable=NO;
    textView.editable=NO;
    textView.text=bendihua(@"服务条款正文");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
