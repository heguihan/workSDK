//
//  HTUploadImage.m
//  GSDK
//
//  Created by 王璟鑫 on 16/10/18.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTUploadImage.h"

@implementation HTUploadImage
+ (void)postRequestWithParems:(NSMutableDictionary *)postParems images: (NSArray *)images
{
    NSURL*URL=[NSURL URLWithString:[NSString stringWithFormat:@"http://aq.gamehetu.com/%@/topic/commit",[USER_DEFAULT objectForKey:@"appID"]]];
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL
cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
timeoutInterval:10];
    //分割符
    NSString *TWITTERFON_FORM_BOUNDARY = @"0xKhTmLbOuNdArY";
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //http 参数body的字符串
    NSMutableString *paraBody=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [postParems allKeys];
    //遍历keys
    for(int i = 0; i < [keys count] ; i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //添加分界线，换行
        [paraBody appendFormat:@"%@\r\n",MPboundary];
        //添加字段名称，换2行
        [paraBody appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        //添加字段的值
        [paraBody appendFormat:@"%@\r\n",[postParems objectForKey:key]];
        
        NSLog(@"参数%@ == %@",key,[postParems objectForKey:key]);
    }
    
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData = [[NSMutableData alloc] init];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[paraBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    for (int i = 0; i < images.count; i++)
    {
        NSMutableString *imageBody = [[NSMutableString alloc] init];
        NSData *imageData = nil;
        //判断图片是不是png格式的文件
        if (UIImagePNGRepresentation(images[i]))
        {
            //返回为png图像。
            imageData = UIImagePNGRepresentation(images[i]);
        }else
        {
            //返回为JPEG图像。
            imageData = UIImageJPEGRepresentation(images[i], 1.0);
        }
        
        //添加分界线，换行
        [imageBody appendFormat:@"%@\r\n",MPboundary];
        //声明pic字段，文件名为boris.png
        [imageBody appendFormat:@"Content-Disposition:form-data;name=\"%@\";filename=\"%@\"",[NSString stringWithFormat:@"file%d",i+1],[NSString stringWithFormat:@"image%d.png",i+1]];
        //声明上传文件的格式
        [imageBody appendFormat:@"Content-Type: image/jpge,image/gif, image/jpeg, image/pjpeg, image/pjpeg\r\n\r\n"];
        //将image的data加入
        
        [myRequestData appendData:[imageBody dataUsingEncoding:NSUTF8StringEncoding]];
        [myRequestData appendData:[[NSData alloc] initWithData:imageData]];
        [myRequestData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (data) {
            NSLog(@"\n\n%@",response);
            NSDictionary*dic=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
            NSLog(@"%@",dic);
        }else
        {
            
        }
    }];
}
@end
