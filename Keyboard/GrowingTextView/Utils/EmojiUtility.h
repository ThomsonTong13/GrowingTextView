//
//  EmojiUtility.h
//  Keyboard
//
//  Created by Thomson on 15/11/25.
//  Copyright © 2015年 Kemi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmojiUtility : NSObject

+ (NSArray *)getEmojiFiles;

+ (NSArray *)getEmojiNames;

+ (NSArray *)EmojiNewNames;

+ (NSArray *)EmojiNewIamges;

+ (NSArray *)alatoy_ZH_names;

+ (NSArray *)alatoy_EN_names;

+ (NSArray *)alatoy_emoji;

+ (NSDictionary *)alatoy_emojiForName;

+ (BOOL)isAlatoyEmoji:(NSString *)text;

@end
