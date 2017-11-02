//
//  HTOLUpload.m
//  GSDK
//
//  Created by 王璟鑫 on 16/8/17.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTOLUpload.h"
#import "HTTextField.h"
#import "HTOLUPLoadCell.h"
#import "HTAlbumController.h"
#import "HTPhotosController.h"


#import "HTPOSTImageArray.h"


@implementation uploadButton

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        
        self.button=[UIButton buttonWithType:(UIButtonTypeCustom)];
        self.button.frame=CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:self.button];
        self.label=[[UILabel alloc]initWithFrame:CGRectMake(0, self.button.bottom+2, frame.size.width, 15)];
        self.label.text=bendihua(@"上传图片");
        self.label.textColor=MXRGBColor(136, 136, 136);
        
        if (IS_IPAD&&SCALE==1) {
            self.label.font=[UIFont systemFontOfSize:9];
        }else
        {
        self.label.font=MXSetSysFont(5);
        }
        [self.label sizeToFit];
        self.label.centerX=self.button.width/2+1;
        [self addSubview:self.label];
        
    }
    return self;
}


@end


@interface HTOLUpload ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIView*topView;

@property (nonatomic,strong) HTBaseLabel*questionLabel;

@property (nonatomic,strong) UIImageView*xialaButton;

@property (nonatomic,strong) UITextView*textView;

@property (nonatomic,strong) HTBaseLabel*placeHolderLabel;

@property (nonatomic,strong) uploadButton*addImageButton;

@property (nonatomic,strong) NSMutableArray*imageArray;

@property (nonatomic,strong) HTTextField*emailTextField;

@property (nonatomic,strong) HTBaseButton*uploadButton;

@property (nonatomic,assign) BOOL showList;

@property (nonatomic,strong) UITableView*xialaTableView;

@property (nonatomic,strong) HTOLUPLoadCell*tempCell;

@property (nonatomic,strong) NSArray*questionArray;

@property (nonatomic,strong) NSString*seleceID;
@end
@implementation HTOLUpload
-(NSArray *)questionArray
{
    if (!_questionArray) {
        _questionArray=@[bendihua(@"游戏类问题"),bendihua(@"活动类问题"),bendihua(@"充值类问题"),bendihua(@"账号密码类问题"),bendihua(@"建议类问题"),bendihua(@"其他问题")];
    }
    return _questionArray;
}
-(NSMutableArray *)imageArray
{
    if (!_imageArray) {
        _imageArray=[NSMutableArray array];
    }
    return _imageArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showList=NO;
       
        [self configUI];
    }
    return self;
}

-(void)configUI
{
    
    self.topView=[[UIView alloc]initWithFrame:CGRectMake(50/550.0*MAINVIEW_WIDTH, 17/550.0*MAINVIEW_WIDTH, 450/550.0*MAINVIEW_WIDTH, 50/550.0*MAINVIEW_WIDTH)];
    self.topView.backgroundColor=CGrayColor;
    [self.topView setCorner:4];
    [self addSubview:self.topView];
    
    self.questionLabel=[[HTBaseLabel alloc]init];
    self.questionLabel.frame=CGRectMake(15/550.0*MAINVIEW_WIDTH, 0, 370/550.0*MAINVIEW_WIDTH, self.topView.height);
    [self.questionLabel setText:bendihua(@"请选择问题类型") font:MXSetSysFont(10) color:CTextGrayColor sizeToFit:NO];
    [self.topView addSubview:self.questionLabel];
    
    UIView*buttonView=[[UIView alloc]init];
    buttonView.backgroundColor=CGreenColor;
    buttonView.frame=CGRectMake(self.questionLabel.right, 0, self.topView.width-self.questionLabel.right, self.topView.height);
    [self.topView addSubview:buttonView];
    
    self.xialaButton=[[UIImageView alloc]init];
    self.xialaButton.image = imageNamed(@"箭头_2");
    self.xialaButton.bounds=CGRectMake(0, 0, 27/550.0*MAINVIEW_WIDTH, 17/550.0*MAINVIEW_WIDTH);
    self.xialaButton.center=CGPointMake(buttonView.width/2, buttonView.height/2);

    [buttonView addSubview:self.xialaButton];
    
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(xialaAction:)];
    [buttonView addGestureRecognizer:tap];
    
    self.textView=[[UITextView alloc]initWithFrame:CGRectMake(self.topView.left, self.topView.bottom+15/550.0*MAINVIEW_WIDTH, self.topView.width, 120/550.0*MAINVIEW_WIDTH)];
    self.textView.layer.borderColor=CRedColor.CGColor;
    self.textView.layer.borderWidth=1;
    [self addSubview:self.textView];
   
    self.placeHolderLabel=[[HTBaseLabel alloc]initWithFrame:CGRectMake(10/550.0*MAINVIEW_WIDTH,8 , self.textView.width, 0)];
    [self.placeHolderLabel setText:bendihua(@"请详细描述您的问题,我们会尽快回复您!") font:MXSetSysFont(8) color:CTextGrayColor sizeToFit:YES];
    self.placeHolderLabel.numberOfLines=YES;
    [self.textView addSubview:self.placeHolderLabel];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification  object:nil];
    
    
    self.addImageButton=[[uploadButton alloc]initWithFrame:CGRectMake(self.textView.left, self.textView.bottom+13/550.0*MAINVIEW_WIDTH, 50/550.0*MAINVIEW_WIDTH, 50/550.0*MAINVIEW_WIDTH)];
    [self.addImageButton.button setImage:imageNamed(@"上传照片") forState:(UIControlStateNormal)];
    [self.addImageButton.button addTarget:self action:@selector(addImageButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.addImageButton];
    
    self.emailTextField=[[HTTextField alloc]init];
    self.emailTextField.frame=CGRectMake(self.textView.left, self.addImageButton.bottom+20/550.0*MAINVIEW_WIDTH,self.topView.width, self.topView.height);
    self.emailTextField.placeholder=bendihua(@"请留下您的联系邮箱,方便我们与您取得联系!");
    [self addSubview:self.emailTextField];
    
    self.uploadButton=[HTBaseButton buttonWithType:(UIButtonTypeCustom)];
    self.uploadButton.frame=CGRectMake(self.emailTextField.left, self.emailTextField.bottom+16/550.0*MAINVIEW_WIDTH, self.emailTextField.width, self.emailTextField.height);
    [self.uploadButton setTitle:bendihua(@"提交") font:MXSetSysFont(11) backColor:CRedColor corner:4];
    [self.uploadButton addTarget:self action:@selector(uploadImageButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.uploadButton];
    
}


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
    [[self viewController]presentViewController:navi animated:YES completion:nil];
}

-(void)configPhotos
{
    
 
    for (int i=0; i<self.imageArray.count; i++) {
        UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.textView.left+65/550.0*MAINVIEW_WIDTH*i, self.addImageButton.top, self.addImageButton.width, self.addImageButton.height)];
        imageView.image=self.imageArray[i];
        imageView.tag=200+i;
        [self addSubview:imageView];
    }
    self.addImageButton.left=self.textView.left+65/550.0*MAINVIEW_WIDTH*self.imageArray.count;
}
-(void)uploadImageButton:(HTBaseButton*)sender
{
    if ([self.seleceID isEqualToString:@""]||self.seleceID==nil) {
        [HTAlertView showAlertViewWithText:@"请选择问题类型" com:nil];
    }else if([self.textView.text isEqualToString:@""])
    {
        [HTAlertView showAlertViewWithText:@"请描述您的问题" com:nil];
    }else if([regex stringContainsEmoji:self.textView.text])
    {
        [HTAlertView showAlertViewWithText:@"不能包含表情和特殊字符" com:nil];
    }
    else
    {
        [HTprogressHUD showjuhuaText:@"正在提交"];
//改改改aaa问题提交
        
    NSDictionary*para=@{@"token":[USER_DEFAULT objectForKey:@"access_token"],@"category":self.seleceID,@"zone":[USER_DEFAULT objectForKey:@"coo_server"],@"title":self.textView.text,@"email":self.emailTextField.text};

    [HTPOSTImageArray postRequestWithURL:[NSString stringWithFormat:@"http://aq.gamehetu.com/%@/topic/create",[USER_DEFAULT objectForKey:@"appID"]] postParems:para picArray:self.imageArray success:^(id data) {
        
        if ([data[@"code"]isEqual:@0]) {
            
            [HTHUD showHUD:bendihua(@"提交成功")];
                self.textView.text=nil;
                [self removeAllImage];
                [self.imageArray removeAllObjects];
                self.emailTextField.text=nil;
                [self textChange];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"SHUAXIN" object:nil];
            
            
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
-(void)removeAllImage
{
    for (int i=0; i<self.imageArray.count; i++) {

    UIImageView*image=[self viewWithTag:200+i];
    
    [image removeFromSuperview];
    
    }
    self.addImageButton.left=self.textView.left;
}

// 改变图像的尺寸，方便上传服务器
- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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

-(void)xialaAction:(UIGestureRecognizer*)sender
{
    
    if (self.showList==YES) {
        [self hiddenTableView];
        self.showList=NO;
    }else{
        [self showTableView];
        self.showList=YES;
    }
}
-(void)showTableView
{
    __weak typeof (self) weakSelf=self;
    [UIView animateWithDuration:0.3 animations:^{
        
        weakSelf.xialaTableView.height+=self.addImageButton.bottom-self.topView.bottom;
        
        weakSelf.xialaButton.transform=CGAffineTransformMakeRotation(M_PI);
        
    }];
    
}
-(void)hiddenTableView
{
    __weak typeof (self) weakSelf=self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.xialaTableView.height=0;
        weakSelf.xialaButton.transform=CGAffineTransformMakeRotation(0);

    }];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.questionArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HTOLUPLoadCell*cell=[[HTOLUPLoadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"upCell"];
    cell.leftLabel.text=self.questionArray[indexPath.row];
    

    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.topView.height;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.tempCell.rightButton.image=imageNamed(@"选择_1");
    HTOLUPLoadCell*cell=[tableView cellForRowAtIndexPath:indexPath];
    cell.rightButton.image=imageNamed(@"选择_2");
    self.tempCell=cell;
    [self hiddenTableView];
    self.showList=!self.showList;
    self.questionLabel.text=cell.leftLabel.text;
    self.seleceID=[NSString stringWithFormat:@"%ld",indexPath.row];
}
-(UITableView *)xialaTableView
{
    if (!_xialaTableView) {
        _xialaTableView=[[UITableView alloc]initWithFrame:CGRectMake(self.topView.left, self.topView.bottom, self.topView.width, 0)];
        _xialaTableView.delegate=self;
        _xialaTableView.dataSource=self;
    }
    _xialaTableView.backgroundColor=CGrayColor;
    [self addSubview:_xialaTableView];
    [_xialaTableView registerClass:[HTOLUPLoadCell class] forCellReuseIdentifier:@"upCell"];
    _xialaTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return _xialaTableView;
}
@end
