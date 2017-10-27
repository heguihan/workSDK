//
//  HTHistoryDetailController.m
//  GSDK
//
//  Created by 王璟鑫 on 16/8/22.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//
#import "HTHistoryDetailCell.h"
#import "HTHistoryDetailController.h"
#import "HTModelCenter.h"
#import "HTAlbumController.h"
#import "HTPhotosController.h"
#import "HTPOSTImageArray.h"
#import "HTOLUpload.h"
#define MAINVIEW_HEIGHT MAINVIEW_WIDTH*(560/550.0)

@interface HTHistoryDetailController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView*tableView;

@property (nonatomic,strong) NSMutableArray*dataArray;

@property (nonatomic,strong) UIView*headerView;

@property (nonatomic,strong) UIView*footerView;

@property (nonatomic,strong) UITextView*textView;

@property (nonatomic,strong) HTBaseLabel*placeHolderLabel;

@property (nonatomic,strong) uploadButton*addImageButton;

@property (nonatomic,strong) NSMutableArray*imageArray;

@property (nonatomic,strong) HTBaseButton*uploadButton;

@end

@implementation HTHistoryDetailController


-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}
-(NSMutableArray *)imageArray
{
    if (!_imageArray) {
        _imageArray=[NSMutableArray array];
    }
    return _imageArray;
}
-(instancetype)init
{
    if (self=[super init]) {
    
        self.mainView.frame=CGRectMake(SCREEN_WIDTH*BEGIN_MAINVIEW, (SCREEN_HEIGHT-MAINVIEW_HEIGHT)/2, MAINVIEW_WIDTH, MAINVIEW_HEIGHT);
        self.backImageView.image=imageNamed(@"底板_4");
        self.backImageView.frame=self.mainView.bounds;
        self.titleLabel.text=bendihua(@"联系客服");
        self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 70/550.0*MAINVIEW_WIDTH, MAINVIEW_WIDTH, MAINVIEW_HEIGHT-70/550.0*MAINVIEW_WIDTH)];
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        [self.mainView addSubview:self.tableView];
        self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[HTHistoryDetailCell class] forCellReuseIdentifier:@"historyDCll"];
        [self configNetUI];
    }

    return self;
}
-(void)configNetUI
{
    NSString*paraStr=[NSString stringWithFormat:@"token=%@&id=%@&zone=%@",USERTOKEN,[HTPassValueSingle sharePassValue].idStr,[USER_DEFAULT objectForKey:@"coo_server"]];
    
    NSString*url=[NSString stringWithFormat:@"http://aq.gamehetu.com/%@/topic/detail",[USER_DEFAULT objectForKey:@"appID"]];
    [HTNetWorking POST:url paramString:paraStr ifSuccess:^(id response) {
        
        if ([response[@"code"] isEqual:@0]) {
            
            NSArray*arr = [response valueForKeyPath:@"data.reply"];
    
            [self.dataArray removeAllObjects];
            
            for (NSDictionary*dict in arr) {
                
                HTModelCenter*model=[[HTModelCenter alloc]init];
                
                [model setValuesForKeysWithDictionary:dict];
                
                [self.dataArray addObject:model];
            }
            [self.tableView reloadData];
            
            [self createHeaderAndFooterView:[response valueForKeyPath:@"data.d0.title"]];
        }else
        {
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    

}
-(void)createHeaderAndFooterView:(NSString*)title
{
    self.headerView=[[UIView alloc]init];
    self.headerView.frame=CGRectMake(0, 0, 450/550*MAINVIEW_WIDTH, 38/550.0*MAINVIEW_WIDTH);
    HTBaseLabel*titleLable=[[HTBaseLabel alloc]init];
    [titleLable setText:title font:MXSetSysFont(10) color:CRedColor sizeToFit:YES];
    titleLable.frame=CGRectMake(50/550.0*MAINVIEW_WIDTH, 3, 450/550.0*MAINVIEW_WIDTH, self.headerView.height-3);
    [self.headerView addSubview:titleLable];
    self.tableView.tableHeaderView=self.headerView;
    self.footerView=[[UIView alloc]init];
    self.footerView.frame=CGRectMake(self.headerView.left, 0, self.headerView.width, 300/550.0*MAINVIEW_WIDTH);
    self.tableView.tableFooterView=self.footerView;
    
    self.textView=[[UITextView alloc]initWithFrame:CGRectMake(50/550.0*MAINVIEW_WIDTH, 15/550.0*MAINVIEW_WIDTH, 450/550.0*MAINVIEW_WIDTH, 120/550.0*MAINVIEW_WIDTH)];
    self.textView.layer.borderColor=CRedColor.CGColor;
    self.textView.layer.borderWidth=1;
    [self.footerView addSubview:self.textView];
    self.placeHolderLabel=[[HTBaseLabel alloc]initWithFrame:CGRectMake(10/550.0*MAINVIEW_WIDTH,8 , self.textView.width, 0)];
    [self.placeHolderLabel setText:bendihua(@"请详细描述您的问题,我们会尽快回复您!") font:MXSetSysFont(8) color:CTextGrayColor sizeToFit:YES];
    self.placeHolderLabel.numberOfLines=YES;
    [self.textView addSubview:self.placeHolderLabel];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification  object:nil];
    
    
    self.addImageButton=[[uploadButton alloc]initWithFrame:CGRectMake(self.textView.left, self.textView.bottom+15/550.0*MAINVIEW_WIDTH, 50/550.0*MAINVIEW_WIDTH, 50/550.0*MAINVIEW_WIDTH)];
    
    [self.addImageButton.button setImage:imageNamed(@"上传照片") forState:(UIControlStateNormal)];
    [self.addImageButton.button addTarget:self action:@selector(addImageButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.footerView addSubview:self.addImageButton];
    
    
    self.uploadButton=[HTBaseButton buttonWithType:(UIButtonTypeCustom)];
    self.uploadButton.frame=CGRectMake(self.textView.left, self.addImageButton.bottom+25/550.0*MAINVIEW_WIDTH, self.textView.width, 50/550.0*MAINVIEW_WIDTH);
    [self.uploadButton setTitle:bendihua(@"提交") font:MXSetSysFont(11) backColor:CRedColor corner:4];
    [self.uploadButton addTarget:self action:@selector(uploadButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.footerView addSubview:self.uploadButton];

}
#pragma mark -- 添加图片按钮
-(void)addImageButtonAction:(HTBaseButton*)sender
{
    [self removeAllImage];
    HTAlbumController*con=[[HTAlbumController alloc]init];
    UINavigationController*navi=[[UINavigationController alloc]initWithRootViewController:con];
    [HTPhotosController sharePhotoController].backPhoyosBlock=^(NSMutableArray*photoArray){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageArray=photoArray;
            [self configPhotos];
        });
    };
    [HTConnect shareConnect].mywindow.windowLevel=UIWindowLevelNormal;
    [self presentViewController:navi animated:YES completion:nil];
    
}
#pragma mark -- 提交按钮
-(void)uploadButtonAction:(HTBaseButton*)sender
{
    
    if ([self.textView.text isEqualToString:@""]||self.textView.text==nil) {

        [HTAlertView showAlertViewWithText:@"请描述您的问题" com:nil];
    }else if([regex stringContainsEmoji:self.textView.text])
    {
        [HTAlertView showAlertViewWithText:@"不能包含表情和特殊字符" com:nil];
    }else
    {
        [HTprogressHUD showjuhuaText:@"正在提交"];
        NSDictionary*para=@{@"token":USERTOKEN,@"id":[HTPassValueSingle sharePassValue].idStr,@"zone":[USER_DEFAULT objectForKey:@"coo_server"],@"message":self.textView.text};
        
        [HTPOSTImageArray postRequestWithURL:[NSString stringWithFormat:@"http://aq.gamehetu.com/%@/topic/commit",[USER_DEFAULT objectForKey:@"appID"]] postParems:para picArray:self.imageArray success:^(id data) {
            
            if ([data[@"code"]isEqual:@0]) {
                [HTHUD showHUD:bendihua(@"提交成功")];
                    self.textView.text=nil;
                    [self removeAllImage];
                [self.imageArray removeAllObjects];
                    [self textChange];
                    [self configNetUI];
            }else
            {
                [HTAlertView showAlertViewWithText:@"提交失败,请重试" com:nil];
            }
            [HTprogressHUD hiddenHUD];
        } failure:^(NSError *error) {
            [HTprogressHUD hiddenHUD];
        }];

    }
}



-(void)configPhotos
{
        for (int i=0; i<self.imageArray.count; i++) {
        UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.textView.left+65/550.0*MAINVIEW_WIDTH*i, self.addImageButton.top, self.addImageButton.width, self.addImageButton.height)];
        imageView.image=self.imageArray[i];
        imageView.tag=200+i;
        [self.footerView addSubview:imageView];
    }
    self.addImageButton.left=self.textView.left+65/550.0*MAINVIEW_WIDTH*self.imageArray.count;
}
-(void)removeAllImage
{    for (int i=0; i<self.imageArray.count; i++) {
    
    UIImageView*image=[self.footerView viewWithTag:200+i];
    [image removeFromSuperview];
}
    self.addImageButton.left=self.textView.left;
}

-(void)layoutImageView
{
    [self.footerView setNeedsLayout];
    for (int i=0; i<self.imageArray.count; i++) {
        UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.textView.left+65/550.0*MAINVIEW_WIDTH*i, self.addImageButton.top, self.addImageButton.width, self.addImageButton.height)];
        imageView.image=self.imageArray[i];
        [self.footerView addSubview:imageView];
    }
    self.addImageButton.left=self.textView.left+65/550.0*MAINVIEW_WIDTH*self.imageArray.count;
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HTHistoryDetailCell*cell=[[HTHistoryDetailCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"historyDCll"];
    
    [cell configUIWithModel:self.dataArray[indexPath.row]];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HTModelCenter*model=self.dataArray[indexPath.row];
    CGFloat heigh=[self p_heightWithString:model.content];
    return heigh+10/500.0*MAINVIEW_WIDTH+30;
}
-(void)textChange
{
    if (self.textView.hasText) {
        self.placeHolderLabel.text=nil;
    }else
    {
        self.placeHolderLabel.text=bendihua(@"请详细描述您的问题,我们会尽快回复您!");
    }
}
//输入一段文字返回文字高度
-(CGFloat)p_heightWithString:(NSString*)aString
{
    CGRect r= [aString boundingRectWithSize:CGSizeMake(400/550.0*MAINVIEW_WIDTH, 2000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:MXSetSysFont(8)} context:nil];
    return r.size.height;
}
@end
