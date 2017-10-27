//
//  HTModelCenter.h
//  GSDK
//
//  Created by 王璟鑫 on 16/8/19.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HTModelCenter : NSObject

@property (nonatomic,strong) NSString *type;

@property (nonatomic,strong) NSString* title;

@property (nonatomic,strong) NSString*content;

@property (nonatomic,strong) NSString*createdTime;

@property (nonatomic,strong) UIImage*thImage;

@property (nonatomic,strong) NSURL*imageURL;

@property (nonatomic,strong) NSString*uid;

@property (nonatomic,strong) NSString*isManagerAnswer;

@end
