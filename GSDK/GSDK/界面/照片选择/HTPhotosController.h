//
//  HTPhotosController.h
//  GSDK
//
//  Created by 王璟鑫 on 16/8/30.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface HTPhotosController : UIViewController

@property (nonatomic,strong) NSMutableArray*photoArr;

@property (nonatomic,strong)ALAssetsGroup*selectXiangCe;

+(instancetype)sharePhotoController;

@property (nonatomic,copy) void(^backPhoyosBlock)(NSMutableArray*array);


@end
