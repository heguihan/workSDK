//
//  HTAlbumController.m
//  GSDK
//
//  Created by 王璟鑫 on 16/8/30.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTAlbumController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface HTAlbunCell :UITableViewCell

@property (nonatomic,strong) UIImageView*albumImage;

@property (nonatomic,strong) UILabel*nameLabel;

@end

@implementation HTAlbunCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self configUI];
    }
    return self;
}
-(void)configUI
{
    self.albumImage=[[UIImageView alloc]init];
    self.albumImage.frame=CGRectMake(10, 10, 80, 80);
    [self.contentView addSubview:self.albumImage];
    self.nameLabel=[[UILabel alloc]init];
    self.nameLabel.frame=CGRectMake(self.albumImage.right+20, self.albumImage.centerY-20, 200, 40);
    [self.contentView addSubview:self.nameLabel];
}
@end

#import "HTPhotosController.h"
#import "HTModelCenter.h"

@interface HTAlbumController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView*tableView;

@property (nonatomic,strong)ALAssetsLibrary*assetsLibrary;

@property (nonatomic,strong)NSMutableArray*albumARR;//相册数组
@end

@implementation HTAlbumController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView=[[UITableView alloc]init];
    self.tableView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:self.tableView];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView registerClass:[HTAlbunCell class] forCellReuseIdentifier:@"album"];
    self.assetsLibrary = [[ALAssetsLibrary alloc] init];
    self.albumARR=[NSMutableArray array];
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithTitle:bendihua(@"取消") style:(UIBarButtonItemStylePlain) target:self action:@selector(itemAction:)];
    self.navigationItem.rightBarButtonItem=item;

    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            if (group.numberOfAssets > 0) {
                // 把相册储存到数组中，方便后面展示相册时使用
                [self.albumARR addObject:group];
                //设置过滤全部图片
                [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            }
        } else {
            if ([self.albumARR count] > 0) {
                // 把所有的相册储存完毕，可以展示相册列表
                [self.tableView reloadData];
            } else {
                // 没有任何有资源的相册，输出提示
                NSLog(@"相册为空,这个有点牛逼");
            }
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"Asset group not found!\n");
    }];
}
-(void)itemAction:(UIBarButtonItem*)sender
{
    [HTConnect shareConnect].mywindow.windowLevel=UIWindowLevelAlert+1;

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.albumARR.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HTAlbunCell*cell=[[HTAlbunCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"album"];
    ALAssetsGroup*danyixiangce = (ALAssetsGroup *)[self.albumARR objectAtIndex:indexPath.row];
    
    //获取相册图标
    NSInteger gCount = [danyixiangce numberOfAssets];
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@  (%ld)",[danyixiangce valueForProperty:ALAssetsGroupPropertyName],(long)gCount];
    [cell.albumImage setImage:[UIImage imageWithCGImage:[(ALAssetsGroup *)[self.albumARR objectAtIndex:indexPath.row] posterImage]]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        //选出相册
        ALAssetsGroup*selectXiangCe = (ALAssetsGroup *)[self.albumARR objectAtIndex:indexPath.row];
        //将相册传递下去
        HTPhotosController*photo=[[HTPhotosController alloc]init];
        photo.selectXiangCe=selectXiangCe;
        [self.navigationController pushViewController:photo animated:YES];

}
@end
