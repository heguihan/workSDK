//
//  HTNetWorking.m
//  GSDK
//
//  Created by 王璟鑫 on 16/8/9.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTNetWorking.h"




@implementation HTNetWorking
+(void)POST:(NSString*)URL paramString:(NSString*)paramString ifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure
{
    
    NSLog(@"url=%@",URL);
    NSLog(@"param=%@",paramString);
    
    NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL] cachePolicy:(NSURLRequestUseProtocolCachePolicy) timeoutInterval:15];
    [request setHTTPMethod:@"POST"];
    
    NSData*paraData=[paramString dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:paraData];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        [HTprogressHUD hiddenHUD];

        if (data) {
    
            NSDictionary*dict=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
            NSLog(@"%@",dict);
            success(dict);
            
        }else
        {
            NSLog(@"%@",connectionError);
            [HTAlertView showAlertViewWithText:bendihua(@"网络连接失败") com:nil];
            failure(connectionError);
        }
    }];
}
+(void)sendRequest:(NSMutableURLRequest*)request ifSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure
{
    

//    
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
//        [HTprogressHUD hiddenHUD];
//
//        if (data) {
//            
//            NSDictionary*dict=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
//            NSLog(@"%@",dict);
//            success(dict);
//            
//        }else
//        {
//            NSLog(@"%@",connectionError);
//            failure(connectionError);
//            [HTAlertView showAlertViewWithText:bendihua(@"网络连接失败") com:nil];
//        }
//    }];
//
    
    
    //******************************//
    
//    [request setTimeoutInterval:10.0];
//    
//    //设置缓存策略
//    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
//    
//    
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    // 构造NSURLSession，网络会话；
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
//    
//    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//
//                if (data) {
//        
//                    NSDictionary*dict=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
//                    NSLog(@"%@",dict);
//                    success(dict);
//        
//                }else
//                {
//                    NSLog(@"%@",error);
//                    failure(error);
//                    [HTAlertView showAlertViewWithText:bendihua(@"网络连接失败") com:nil];
//                }
//        
//        
//    }];
//    
//    [task resume];
    
    
    
//    // 1.创建一个网络路径
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://172.16.2.254/php/phonelogin?yourname=%@&yourpas=%@&btn=login",yourname,yourpass]];
//    // 2.创建一个网络请求
//    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    // 3.获得会话对象
    
    
//    [request setHTTPMethod:@"GET"];
    NSLog(@"请求方式=%@",request.HTTPMethod);
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务：
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"从服务器获取到数据");
        /*
         对从服务器获取到的数据data进行相应的处理：
        */
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
        
        
                        if (data) {
        
                            NSDictionary*dict=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
                            NSLog(@"%@",dict);
                            
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                // 刷新界面....
                                success(dict);
                                
                            });
//                            success(dict);
        
                        }else
                        {
                            NSLog(@"%@",error);
                            failure(error);
//                            [HTAlertView showAlertViewWithText:bendihua(error.description) com:nil];
                        }
    }];
    // 5.最后一步，执行任务（resume也是继续执行）:
    [sessionDataTask resume];
    
    
    
    
}

- (void)useSessionWithRequest:(NSMutableURLRequest *)request
{
//    [request setHTTPMethod:@"POST"];
    // 设置请求超时 默认超时时间60s
    [request setTimeoutInterval:10.0];

    //设置缓存策略
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    // 构造NSURLSession，网络会话；
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 请求失败，打印错误信息
        if (error) {
            NSLog(@"get error :%@",error.localizedDescription);
        }
        //请求成功，解析数据
        else {
            // JSON数据格式解析
            
            NSLog(@"response=%@",response);
            
            id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            // 判断是否解析成功
            if (error) {
                NSLog(@"get error :%@",error.localizedDescription);
            }else {
                NSLog(@"get success :%@",object);
                // 解析成功，处理数据，通过GCD获取主队列，在主线程中刷新界面。
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 刷新界面....
                });
            }
        }
    }];
    
    [task resume];

}


//+(void)NetworkRequestEmailCode:(NSDictionary *)signupEmailDic ifSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure
//{
//    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
////    manager.securityPolicy = [[self alloc] getCustomHttpsPolicy:manager];
//#ifdef DES_SERVER
//    [manager setSecurityPolicy:[self customSecurityPolicy]];
//#endif
//    //设置请求格式
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    //设置返回格式
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    
//    //URL
//    
//    
//    //获取标识符
//    NSString *identifier = GETUUID;
//    //拼接字符串
//    NSString*str=[NSString stringWithFormat:@"username=%@#device&name=%@&uuid=%@",identifier,[HTgetDeviceName deviceString],GETUUID];
//    //加密
//    NSString*rsaStr=[RSA encryptString:str];
//    //拼接加密后文件
//    NSString*urlTotal=[NSString stringWithFormat:@"http://c.gamehetu.com/passport/login?app=%@&data=%@&format=json&version=2.0",[USER_DEFAULT objectForKey:@"appID"],rsaStr];
////    NSLog(@"pingjie =%@",urlStr);
//
//    
//    
//    
////    NSString *urlTotal = [NSString stringWithFormat:@"%@%@",SERVER_URL,USER_IPHONESIGNUPCODE_URL];
//    
//    NSLog(@"urlTotal=%@",urlTotal);
//    
//    [manager POST:urlTotal parameters:signupEmailDic progress:^(NSProgress * _Nonnull uploadProgress) {
//        NSLog(@"what");
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        //        NSLog(@"responseObject: %@", responseObject);
//        
//        NSLog(@"%@",responseObject);
//        success(responseObject);
//        NSLog(@"success");
//
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//    }];
//    
//}















@end

