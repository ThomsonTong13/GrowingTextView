//
//  CustomMethod.h
//  Keyboard
//
//  Created by Thomson on 15/11/25.
//  Copyright © 2015年 Kemi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CustomMethod : NSObject

+ (NSString *)escapedString:(NSString *)oldString;
+ (NSMutableArray *)webpagesFromText:(NSString *)text;
+ (NSMutableArray *)phonesFromText:(NSString *)text;
+ (NSMutableArray *)emailsFromText:(NSString *)text;
+ (NSString *)transformString:(NSString *)originalStr withEmojis:(NSDictionary *)dEmofis font:(UIFont *)font;

+ (NSMutableArray *)transformString:(NSString *)originalStr withEmojis:(NSArray *)dEmofis;

@end
