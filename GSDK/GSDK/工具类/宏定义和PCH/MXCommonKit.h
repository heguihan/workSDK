//
//  MXCommonKit.h
//  WJXTools
//
//  Created by 王璟鑫 on 16/8/1.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MXCommonKit : NSObject

//
////debug模式打印当前输出位置
//#ifdef DEBUG
//#define NSLog(...) NSLog(__VA_ARGS__)
////#define NSLog(format, ...) do {                                             \
////fprintf(stderr, "<%s : %d> %s\n",                                           \
////[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
////__LINE__, __func__);                                                        \
////(NSLog)((format), ##__VA_ARGS__);                                           \
////fprintf(stderr, "-------\n");                                               \
////} while (0)
//#else
//#define NSLog(...)
//#endif

//
//#ifdef DEBUG
//#define NSLog(...) NSLog(__VA_ARGS__)
//#define debugMethod() NSLog(@"%s", __func__)
//#else
//#define NSLog(...)
//#define debugMethod()
//#endif



#pragma ---------------*****(设备信息)*****---------------
//获取系统版本号
#define MXIOSVersion ([UIDevice currentDevice].systemVersion.floatValue)

//屏幕Bounds
#define MXScreenBounds ([UIScreen mainScreen].bounds)

//屏幕宽
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)

//屏幕高
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)

#pragma ---------------*****(颜色设置)*****---------------

//16进制颜色
#define MXHEXColor(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]

//RGB颜色
#define MXRGBColor(r, g, b) ([UIColor colorWithRed:(r) / 255.0  \
green:(g) / 255.0  \
blue:(b) / 255.0  \
alpha:1])

//RGBA颜色
#define MXRGBAColor(r, g, b, a) ([UIColor colorWithRed:(r) / 255.0  \
green:(g) / 255.0  \
blue:(b) / 255.0  \
alpha:(a)])

//重写各种颜色
#define CBlackColor       [UIColor blackColor]
#define CDarkGrayColor    [UIColor darkGrayColor]
#define CLightGrayColor   [UIColor lightGrayColor]
#define CGrayColor         MXRGBColor(229,229,229)
#define CWhiteColor       [UIColor whiteColor]
#define CRedColor          MXRGBColor(222,100,71)
#define CBlueColor        [UIColor blueColor]
#define CGreenColor        MXRGBColor(78,183,168)
#define CCyanColor        [UIColor cyanColor]
#define CYellowColor      [UIColor yellowColor]
#define CMagentaColor     [UIColor magentaColor]
#define COrangeColor      [UIColor orangeColor]
#define CPurpleColor      [UIColor purpleColor]
#define CBrownColor       [UIColor brownColor]
#define CClearColor       [UIColor clearColor]
#define CTextGrayColor    MXRGBColor(136, 136, 136)
#pragma ---------------*****(各种)*****---------------

//Application
#define MXApplication     [UIApplication sharedApplication]

//UserDefault
#define MXUserDefaults [NSUserDefaults standardUserDefaults]

//通知中心
#define MXNotificationCenter  [NSNotificationCenter defaultCenter]

//沙盒路径 Document
#define Document NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject

//设置图片
#define MXSetImage(Name) [UIImage imageNamed:Name]

//设置字体大小并对Plus做特殊处理
#define SCALE [[UIScreen mainScreen] scale]
#define MXSetSysFont(size) SCALE==3?[UIFont systemFontOfSize:size+4]:[UIFont systemFontOfSize:size+2]
//设置粗体字
#define MXSetBlodFont(size) SCALE==3?[UIFont boldSystemFontOfSize:size+4]:[UIFont boldSystemFontOfSize:size+2]

#define MXStrFormat(...) [NSString stringWithFormat:__VA_ARGS__]

#define MXRootViewController [UIApplication sharedApplication].keyWindow.rootViewController


@end
