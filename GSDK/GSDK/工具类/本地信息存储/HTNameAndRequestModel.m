//
//  HTNameAndRequestModel.m
//  GSDK
//
//  Created by 王璟鑫 on 16/8/17.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTNameAndRequestModel.h"

@implementation HTNameAndRequestModel
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.requset forKey:@"request"];
    [aCoder encodeObject:self.name forKey:@"name"];
   
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        self.name=[aDecoder decodeObjectForKey:@"name"];
        self.requset=[aDecoder decodeObjectForKey:@"request"];
    }
    return self;
}
+(instancetype)sharedRequestModel
{
    static HTNameAndRequestModel*request;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        request=[[HTNameAndRequestModel alloc]init];
    });
    
    return  request;
}
+(void)setFastRequest:(NSMutableURLRequest*)request AndNameFormdict:(NSDictionary*)dict
{
   
    HTNameAndRequestModel*model= [HTNameAndRequestModel sharedRequestModel];
    model.requset=request;
    model.name=    [HTBindInfo returnHomeName:dict];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];

    [USER_DEFAULT setObject:dict forKey:@"userInfo"];
    [USER_DEFAULT setObject:data forKey:@"fastLogin"];
    [USER_DEFAULT synchronize];
}
+(HTNameAndRequestModel*)getModelFormUserDefault
{
    NSData*data = [USER_DEFAULT objectForKey:@"fastLogin"];
    
    HTNameAndRequestModel*model= [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return model;
}
@end
