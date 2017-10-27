//
//  HTNameAndRequestModel.h
//  GSDK
//
//  Created by 王璟鑫 on 16/8/17.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTNameAndRequestModel : NSObject

@property (nonatomic,strong) NSString*name;

@property (nonatomic,strong) NSMutableURLRequest*requset;

+(instancetype)sharedRequestModel;
+(void)setFastRequest:(NSMutableURLRequest*)request AndNameFormdict:(NSDictionary*)dict;
+(HTNameAndRequestModel*)getModelFormUserDefault;

@end
