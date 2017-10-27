//
//  HTPhotosController.m
//  GSDK
//
//  Created by 王璟鑫 on 16/8/30.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTPhotosController.h"

@interface HTPhotosCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView*photoImageView;

@property (nonatomic,strong) UIButton*selectButton;

@end

@implementation HTPhotosCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=CWhiteColor;
        [self configUI];
    }
    return self;
}
-(void)configUI
{
    self.photoImageView=[[UIImageView alloc]init];
    self.photoImageView.frame=self.bounds;
    self.photoImageView.contentMode=UIViewContentModeScaleAspectFill;
    [self.photoImageView setClipsToBounds:YES];
    [self.contentView addSubview:self.photoImageView];
    
    self.selectButton=[UIButton buttonWithType:(UIButtonTypeCustom)];
    self.selectButton.frame=CGRectMake(0, 0, self.photoImageView.width/4, self.photoImageView.width/4);
    [self.selectButton setImage:imageNamed(@"未选中") forState:(UIControlStateNormal)];
    [self.selectButton setImage:imageNamed(@"选中") forState:(UIControlStateSelected)];
    [self.contentView addSubview:self.selectButton];
}


@end

#pragma 分界线
#define NAVIGATIONBAR self.navigationController.navigationBar
#import "HTModelCenter.h"
@interface HTPhotosController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView*collectionView;

@property (nonatomic,strong) NSMutableArray*selectImageArray;

@end

@implementation HTPhotosController

+(instancetype)sharePhotoController
{
    static HTPhotosController*con;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        con=[[HTPhotosController alloc]init];
    });
    return con;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithTitle:bendihua(@"取消") style:(UIBarButtonItemStylePlain) target:self action:@selector(itemAction:)];
    self.navigationItem.rightBarButtonItem=item;
    self.photoArr=[NSMutableArray array];
    UIView*toolBar=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.bottom-30, self.view.width, 30)];
    [self.view addSubview:toolBar];
    
    UIButton*button=[UIButton buttonWithType:(UIButtonTypeSystem)];
    [button setTitle:bendihua(@"完成") forState:(UIControlStateNormal)];
    button.titleLabel.font=MXSetSysFont(15);
    [button sizeToFit];
    button.frame=CGRectMake(toolBar.width-button.width-30, 0, button.width, toolBar.height);
    [button addTarget:self action:@selector(doneAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [toolBar addSubview:button];
    
    UIView*countView=[[UIView alloc]init];
    countView.frame=CGRectMake(0, 0, toolBar.height, toolBar.height);
    countView.right=button.left;
    [toolBar addSubview:countView];
    
    UIImageView*countBackImage=[[UIImageView alloc]initWithFrame:countView.bounds];
    countBackImage.image=imageNamed(@"beijing");
    countView.tag=199;
    [countView addSubview:countBackImage];
    
    UILabel*numberLabel=[[UILabel alloc]init];
    numberLabel.tag=200;
    numberLabel.frame=countView.bounds;
    numberLabel.font=MXSetSysFont(15);
    numberLabel.text=@"0";
    numberLabel.textAlignment=NSTextAlignmentCenter;
    numberLabel.textColor=CWhiteColor;
    [countView addSubview:numberLabel];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.selectXiangCe enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result) {
                HTModelCenter*model=[[HTModelCenter alloc]init];
                model.thImage=[UIImage imageWithCGImage:result.thumbnail];
                model.imageURL=result.defaultRepresentation.url;
                [self.photoArr addObject:model];
            } else {
                [self.collectionView reloadData];
            }
        }];
    });
    UICollectionViewFlowLayout*layout=[[UICollectionViewFlowLayout alloc]init];
    CGFloat margin = 5;
    CGFloat itemWH ;
    if (IS_IPAD) {
        
        itemWH = (self.view.frame.size.width-35)/6;
        
    }else
    {
        if ([HTOrientation hengPing]) {
            itemWH = (self.view.frame.size.width-35)/6;
        }else
        {
            itemWH = ((self.view.frame.size.width-20)/3);
        }
    }
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    layout.minimumInteritemSpacing = margin;
    layout.minimumLineSpacing = margin;
    layout.sectionInset=UIEdgeInsetsMake(5,5,0,5);
    self.collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, NAVIGATIONBAR.bottom, self.view.width, self.view.height-30-NAVIGATIONBAR.bottom) collectionViewLayout:layout];
    self.collectionView.backgroundColor=[UIColor whiteColor];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    [self.collectionView registerClass:[HTPhotosCell class] forCellWithReuseIdentifier:@"photo"];
    [self.view addSubview:self.collectionView];
    
   }
//设置多少分区
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//设置每个分区有多少个小方块
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HTPhotosCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"photo" forIndexPath:indexPath];
    HTModelCenter*model=self.photoArr[indexPath.row];
    cell.photoImageView.image=model.thImage;
    [cell.selectButton addTarget:self action:@selector(selectButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    cell.selectButton.tag=100+indexPath.row;
    return cell;
}
-(void)selectButtonAction:(UIButton*)sender
{
    HTModelCenter*model=self.photoArr[sender.tag-100];
    if (sender.selected) {
        sender.selected=NO;
        [self.selectImageArray removeObject:model.imageURL];
    }else
    {
        if (self.selectImageArray.count>=5) {
            UIAlertView*alert=[[UIAlertView alloc]initWithTitle:bendihua(@"提示") message:bendihua(@"图片最多可选择五张") delegate:self cancelButtonTitle:bendihua(@"確定") otherButtonTitles:nil, nil];
            [alert show];

        }else
        {
        sender.selected=YES;
        [self.selectImageArray addObject:model.imageURL];
        }
    }
    UILabel*numberLabel=[self.view viewWithTag:200];
    numberLabel.text=MXStrFormat(@"%ld",self.selectImageArray.count);
    //先缩放
    [UIView animateWithDuration:0.2 animations:^{
        [self.view viewWithTag:199].transform=CGAffineTransformMakeScale(1.2, 1.2);
        sender.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        //重新变回去
        [UIView animateWithDuration:0.2 animations:^{
            sender.transform = CGAffineTransformMakeScale(1, 1);
            [self.view viewWithTag:199].transform=CGAffineTransformMakeScale(1.0, 1.0);

        }];
    }];
    
}
-(void)doneAction:(UIButton*)sender
{
    
    if (self.selectImageArray.count!=0) {
        
        NSMutableArray*array=[NSMutableArray array];
        for (int i=0; i<self.selectImageArray.count; i++) {
            ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [lib assetForURL:self.selectImageArray[i] resultBlock:^(ALAsset *asset) {
                    ALAssetRepresentation *rep = asset.defaultRepresentation;
                    CGImageRef imageRef = rep.fullScreenImage;
                    
                    UIImage *image = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationUp];
                    if (image) {
                        [array addObject:image];
                        if (i==self.selectImageArray.count-1) {
                            [HTPhotosController sharePhotoController].backPhoyosBlock(array);
                            [HTConnect shareConnect].mywindow.windowLevel=UIWindowLevelAlert+1;

                        }
                    }
                } failureBlock:^(NSError *error) {
                }];
            });
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }else
    {
        return;
    }
}
-(void)itemAction:(UIBarButtonItem*)sender
{
    [HTConnect shareConnect].mywindow.windowLevel=UIWindowLevelAlert+1;

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(NSMutableArray *)selectImageArray
{
    if (!_selectImageArray) {
        _selectImageArray=[NSMutableArray array];
    }
    return _selectImageArray;
}
@end
