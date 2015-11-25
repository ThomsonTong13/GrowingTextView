//
//  CustomMethod.m
//  Keyboard
//
//  Created by Thomson on 15/11/25.
//  Copyright © 2015年 Kemi. All rights reserved.
//

#import "CustomMethod.h"

#import "MarkupParser.h"
#import "NSAttributedString+Attributes.h"
#import "EmojiUtility.h"
#import "RegexKitLite.h"

@implementation CustomMethod

+ (NSString *)escapedString:(NSString *)oldString
{
    NSString *escapedString_lt = [oldString stringByReplacingOccurrencesOfString:@"<" withString:@"&lt"];
    NSString *escapedString = [escapedString_lt stringByReplacingOccurrencesOfString:@">" withString:@"&gt"];

    return escapedString;
}

+ (NSMutableArray *)webpagesFromText:(NSString *)text
{
    // website
    NSString *regex = @"(https?|ftp|file)+://[^\\s]*";

    return [NSMutableArray arrayWithArray:[text componentsMatchedByRegex:regex]];
}

+ (NSMutableArray *)phonesFromText:(NSString *)text
{
    // telephone
    NSString *regex = @"\\d{3}-\\d{8}|\\d{3}-\\d{7}|\\d{4}-\\d{8}|\\d{4}-\\d{7}|1+[358]+\\d{9}|\\d{8}|\\d{7}";
    return [NSMutableArray arrayWithArray:[text componentsMatchedByRegex:regex]];
}

+ (NSMutableArray *)emailsFromText:(NSString *)text
{
    // email
    NSString *regex = @"\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*.\\w+([-.]\\w+)*";

    return [NSMutableArray arrayWithArray:[text componentsMatchedByRegex:regex]];
}

+ (NSString *)transformString:(NSString *)originalStr withEmojis:(NSDictionary *)dEmofis font:(UIFont *)font
{
    // emoji
    NSString *text = originalStr;
    NSString *regex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    NSArray *emojis = [text componentsMatchedByRegex:regex];

    for (NSString *emoji in emojis)
    {
        NSRange range = [text rangeOfString:emoji];
        NSString *fileName = [dEmofis objectForKey:emoji];
        if(fileName)
        {
            NSString *imageHtml = [NSString stringWithFormat:@"<img src='%@' width='%f' height='%f'>",fileName, font.pointSize+2, font.pointSize+2];
            text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, [emoji length]) withString:imageHtml];
        }
    }

    return text;
}

+ (NSMutableArray *)transformString:(NSString *)originalStr withEmojis:(NSArray *)dEmofis
{
    // emoji
    NSString *text = originalStr;
    NSString *regex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    NSArray *emojis = [text componentsMatchedByRegex:regex];

    NSMutableArray *emojies = [[NSMutableArray alloc] init];

    for (NSString *emoji in emojis)
    {
        int i = 0;
        for (NSString *str in [EmojiUtility EmojiNewNames])
        {
            if ([emoji isEqualToString:str])
            {
                [emojies addObject:[NSNumber numberWithInt:i]];

                break;
            }

            i ++;
        }
    }

    return emojies;
}

@end
