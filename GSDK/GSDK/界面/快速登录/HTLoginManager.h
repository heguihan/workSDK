//
//  HTLoginManager.h
//  GSDK
//
//  Created by 王璟鑫 on 2017/4/10.
//  Copyright © 2017年 王璟鑫. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTLoginManager : NSObject

@property(nonatomic,assign)BOOL isGoingOnline;
@property(nonatomic,strong)NSString *fansUrlStr;


+(instancetype)sharedInstance;


+(void)loginRetuen;

@end
