//
//  HTUploadImage.h
//  GSDK
//
//  Created by 王璟鑫 on 16/10/18.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTUploadImage : NSObject
+ (void)postRequestWithParems:(NSMutableDictionary *)postParems images: (NSArray *)images;

@end
