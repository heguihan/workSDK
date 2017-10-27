//
//  regex.m
//  NHTsdk
//
//  Created by 王璟鑫 on 16/1/8.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "regex.h"

@implementation regex
+(BOOL)validateUserName:(NSString*)string
{
    //判断长度
    if (string.length>6&&string.length<33) {
        //判断是否含有特殊符号 不含有为yes
        if ([self validateNickname:string]) {
            //判断是否含有@
            if ([self haveAiTe:string]) {
                //判断是否为邮箱
                if ([self isValidateEmail:string]) {
                    return YES;
                }else
                {
                    NSLog(@"含有特殊符号");
                    return NO;
                }
            }else
            {
                //判断没有@的情况下有没有点
                if ([self haveDote:string]) {
                    NSLog(@"含有特殊符号.");
                    return NO;
                }else
                {
                    return YES;
                    
                }
                
            }
            
        }else
        {
            NSLog(@"含有特殊字符");
            return NO;
        }
        
    }else
    {
        NSLog(@"长度不对");
        return NO;
    }
    
}

//判断是否为正确邮箱
+(BOOL)isValidateEmail:(NSString *)email

{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    return [emailTest evaluateWithObject:email];
}
+(BOOL)validateNickname:(NSString *)nickname {
    // 不包含特殊字符
    // 特殊字符包含`、-、=、\、[、]、;、'、,、.、/、~、!、@、#、$、%、^、&、*、(、)、_、+、|、?、>、<、"、:、{、}
    NSString *nicknameRegex = @".*[-`=\\\[\\];',/~!#$%^&*()_+|{}:\"<>?]+.* ";
    NSPredicate *nicknamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nicknameRegex];
    return ![nicknamePredicate evaluateWithObject:nickname];
}
+(BOOL)haveAiTe:(NSString*)aiteString
{
    NSRange rang=[aiteString rangeOfString:@"@"];
    if (rang.length>0) {
        return YES;
    }else
    {
        return NO;
    }
    
}
+(BOOL)haveDote:(NSString*)dote
{
    NSRange range=[dote rangeOfString:@"."];
    if (range.length>0) {
        return YES;
    }else
    {
        return NO;
    }
}
+(BOOL)haveKongGe:(NSString *)str
{
    NSRange range = [str rangeOfString:@" "];
    if (range.length>0) {
        return YES;
    }else
    {
        return NO;
    }
}

+(NSString*)deleUrlBugChar:(NSString*)tempString
{
    
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；。＂?、#%*=_\\|~＜＞$€^'#$%&()\""];
    
    tempString = [[tempString componentsSeparatedByCharactersInSet: set]componentsJoinedByString: @""];
    return tempString;

}
+(BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar high = [substring characterAtIndex: 0];
                                
                                // Surrogate pair (U+1D000-1F9FF)
                                if (0xD800 <= high && high <= 0xDBFF) {
                                    const unichar low = [substring characterAtIndex: 1];
                                    const int codepoint = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000;
                                    
                                    if (0x1D000 <= codepoint && codepoint <= 0x1F9FF){
                                        returnValue = YES;
                                    }
                                    
                                    // Not surrogate pair (U+2100-27BF)
                                } else {
                                    if (0x2100 <= high && high <= 0x27BF){
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

@end
