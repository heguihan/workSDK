//
//  HTPOSTImageArray.m
//  GSDK
//
//  Created by 王璟鑫 on 16/10/18.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTPOSTImageArray.h"

@implementation HTPOSTImageArray
+ (void)postRequestWithURL: (NSString *)url
                postParems: (NSDictionary *)postParems
                  picArray: (NSMutableArray *)picArray
                   success:(void(^)(id data))success
                   failure:(void(^)(NSError*))failure{
    
    
    

    NSString *hyphens = @"--";
    NSString *boundary = @"*****";
    NSString *end = @"\r\n";
    
    NSMutableData *myRequestData1=[NSMutableData data];
    //遍历数组，添加多张图片
    for (int i = 0; i < picArray.count; i ++) {
        NSData* data;
        UIImage *image=picArray[i];
    
        // 将图片存到沙河,判断文件大小,测试文件上传是否成功
        NSString *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES).lastObject;
        NSLog(@"%@",paths);
        NSString *filePath = [NSString stringWithFormat:@"%@旧图.png", paths];
        //保存文件的名称
        [UIImageJPEGRepresentation(image, 1.0) writeToFile: filePath    atomically:YES];
        
        //判断图片是不是png格式的文件
        if (UIImagePNGRepresentation(image)) {
            //返回为png图像。
            data = UIImagePNGRepresentation(image);
        }else {
            //返回为JPEG图像。
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        UIImage*yasuoImage=[UIImage imageWithData:data];
            for (int i=0; i>=0;i++ ) {
                if (data.length/1024.0>200) {
                    CGSize size=CGSizeMake(yasuoImage.size.width*0.8, yasuoImage.size.height*0.8);
                    data = [self imageWithImage:yasuoImage scaledToSize:size];
                    yasuoImage=[UIImage imageWithData:data];
                }else
                {                    NSLog(@"%f",data.length/1024.0);

                    break;
                }
                [data writeToFile:filePath atomically:YES];
        }//307.548828//301.538086//266.374023//332.580078//365.232422
        //所有字段的拼接都不能缺少，要保证格式正确
        [myRequestData1 appendData:[hyphens dataUsingEncoding:NSUTF8StringEncoding]];
        [myRequestData1 appendData:[boundary dataUsingEncoding:NSUTF8StringEncoding]];
        [myRequestData1 appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
        NSMutableString *fileTitle=[[NSMutableString alloc]init];
        //要上传的文件名和key，服务器端用file接收
        [fileTitle appendFormat:@"Content-Disposition:form-data;name=\"%@\";filename=\"%@\"",[NSString stringWithFormat:@"file%d",i+1],[NSString stringWithFormat:@"image%d.png",i+1]];
        [fileTitle appendString:end];
        [fileTitle appendString:[NSString stringWithFormat:@"Content-Type:image/pjpeg%@",end]];
        [fileTitle appendString:end];
        [myRequestData1 appendData:[fileTitle dataUsingEncoding:NSUTF8StringEncoding]];
        
        [myRequestData1 appendData:data];
        
        [myRequestData1 appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
        
    }
    
    
    [myRequestData1 appendData:[hyphens dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData1 appendData:[boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData1 appendData:[hyphens dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData1 appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //参数的集合的所有key的集合
    NSArray *keys= [postParems allKeys];
    
    //添加其他参数
    for(int i=0;i<[keys count];i++)
    {
        
        NSMutableString *body=[[NSMutableString alloc]init];
        [body appendString:hyphens];
        [body appendString:boundary];
        [body appendString:end];
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //添加字段名称
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"",key];
        
        [body appendString:end];
        
        [body appendString:end];
        //添加字段的值
        [body appendFormat:@"%@",[postParems objectForKey:key]];
        
        [body appendString:end];
        
        [myRequestData1 appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"添加字段的值==%@",[postParems objectForKey:key]);
    }
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:20];
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data;boundary=%@",boundary];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%ld", [myRequestData1 length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData1];
    //http method
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (data) {
            NSDictionary*dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"%@",dict);
            NSLog(@"%@",response);
            success(dict);
        }else
        {
            failure(connectionError);
        }
    }];
}
+ (NSData *)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 0.8);
}

@end
