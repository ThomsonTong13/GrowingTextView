//
//  EmojiUtility.m
//  Keyboard
//
//  Created by Thomson on 15/11/25.
//  Copyright © 2015年 Kemi. All rights reserved.
//

#import "EmojiUtility.h"

@implementation EmojiUtility

+ (NSArray *)getEmojiFiles1
{
    NSArray *emojiFiles = [[NSArray alloc]initWithObjects:@"wb1.png",@"wb2.png",@"wb3.png",@"wb4.png",@"wb5.png",@"wb6.png",@"wb7.png",@"wb8.png",@"wb9.png",@"wb10.png",@"wb11.png",@"wb12.png",@"wb13.png",@"wb14.png",@"wb15.png",@"wb16.png",@"wb17.png",@"wb18.png",@"wb19.png",@"wb20.png",@"wbdelete.png",
                           @"wb21.png",@"wb22.png",@"wb23.png",@"wb24.png",@"wb25.png",@"wb26.png",@"wb27.png",@"wb28.png",@"wb29.png",@"wb30.png",@"wb31.png",@"wb32.png",@"wb33.png",@"wb34.png",@"wb35.png",@"wb36.png",@"wb37.png",@"wb38.png",@"wb39.png",@"wb40.png",@"wbdelete.png",
                           @"wb41.png",@"wb42.png",@"wb43.png",@"wb44.png",@"wb45.png",@"wb46.png",@"wb47.png",@"wb48.png",@"wb49.png",@"wb50.png",@"wb51.png",@"wb52.png",@"wb53.png",@"wb54.png",@"wb55.png",@"wb56.png",@"wb57.png",@"wb58.png",@"wb59.png",@"wb60.png",@"wbdelete.png",
                           @"wb61.png",@"wb62.png",@"wb63.png",@"wb64.png",@"wb65.png",@"wb66.png",@"wb67.png",@"wb68.png",@"wb69.png",@"wb70.png",@"wb71.png",@"wb72.png",@"wb73.png",@"wb74.png",@"wb75.png",@"wb76.png",@"wb77.png",@"wb78.png",@"wb79.png",@"wb80.png",@"wbdelete.png",
                           nil];

    return emojiFiles;
}

+ (NSArray *)getEmojiNames1
{
    NSArray *emojiNames= [[NSArray alloc]initWithObjects:@"[大笑]", @"[微笑]", @"[亲亲]", @"[抱抱]", @"[好羡慕哦]", @"[龇牙]", @"[好害羞]", @"[窃笑]", @"[见钱眼开]", @"[眨眼]", @"[做鬼脸]", @"[可爱]", @"[热吻]", @"[好好爱你哟]", @"[嘴馋]", @"[困惑]", @"[好困呀]", @"[睡觉去了]", @"[好失望]", @"[吃惊]",  ///1--20
                          @"[wbdelete]",@"[小声点]", @"[吐你一身]", @"[闭嘴]", @"[打你]", @"[我真生气了]", @"[怒骂]", @"[抓狂]",  @"[你好讨厌]", @"[愤怒]", @"[生病]", @"[伤心死了]", @"[饭]", @"[流汗]", @"[非典]", @"[?]", @"[思考]", @"[转向]", @"[晕倒了]", @"[翻白眼]", @"[再见了]",    ///21--40
                          @"[wbdelete]",@"[警察]", @"[整蛊]", @"[我酷吧]", @"[书呆子]", @"[小丑]", @"[男孩]", @"[女孩]", @"[真棒]", @"[不怎么样]", @"[猪头]",@"[猫猫]", @"[狗狗]", @"[小精灵]", @"[骷髅]", @"[玫瑰凋谢了]", @"[玫瑰开放了]", @"[我心碎了]", @"[我心永恒]", @"[活力四射]", @"[小星星]", //41--60
                          @"[wbdelete]",@"[太阳]", @"[月亮]", @"[下雨了]", @"[雨伞]", @"[吃饭]", @"[生日快乐]", @"[送你礼物]", @"[吃个西瓜]", @"[干杯]", @"[来杯咖啡]", @"[吃个苹果]", @"[便便]", @"[时钟]", @"[电话]", @"[电视]", @"[电影]", @"[邮件]", @"[音乐]", @"[踢球去]", @"[灯泡]",@"[wbdelete]",
                          nil];

    return emojiNames;
}

+ (NSArray *)getEmojiFiles
{
    return @[@"emoji_1.png",
             @"emoji_2.png",
             @"emoji_3.png",
             @"emoji_4.png",
             @"emoji_5.png",
             @"emoji_6.png",
             @"emoji_7.png",
             @"emoji_8.png",
             @"emoji_9.png",
             @"emoji_10.png",
             @"emoji_11.png",
             @"emoji_12.png",
             @"emoji_13.png",
             @"emoji_14.png",
             @"emoji_15.png",
             @"emoji_16.png",
             @"emoji_17.png",
             @"emoji_18.png",
             @"emoji_19.png",
             @"emoji_20.png",
             @"wbdelete.png",

             @"emoji_21.png",
             @"emoji_22.png",
             @"emoji_23.png",
             @"emoji_24.png",
             @"emoji_25.png",
             @"emoji_26.png",
             @"emoji_27.png",
             @"emoji_28.png",
             @"emoji_29.png",
             @"emoji_30.png",
             @"emoji_31.png",
             @"emoji_32.png",
             @"emoji_33.png",
             @"emoji_34.png",
             @"emoji_35.png",
             @"emoji_36.png",
             @"emoji_37.png",
             @"emoji_38.png",
             @"emoji_39.png",
             @"emoji_40.png",
             @"wbdelete.png",
             
             @"emoji_41.png",
             @"emoji_42.png",
             @"emoji_43.png",
             @"emoji_44.png",
             @"emoji_45.png",
             @"emoji_46.png",
             @"emoji_47.png",
             @"emoji_48.png",
             @"emoji_49.png",
             @"emoji_50.png",
             @"emoji_51.png",
             @"emoji_52.png",
             @"emoji_53.png",
             @"emoji_54.png",
             @"emoji_55.png",
             @"emoji_56.png",
             @"emoji_57.png",
             @"emoji_58.png",
             @"emoji_59.png",
             @"emoji_60.png",
             @"wbdelete.png",
             
             @"emoji_61.png",
             @"emoji_62.png",
             @"emoji_63.png",
             @"emoji_64.png",
             @"emoji_65.png",
             @"emoji_66.png",
             @"emoji_67.png",
             @"emoji_68.png",
             @"emoji_69.png",
             @"emoji_70.png",
             @"emoji_71.png",
             @"emoji_179.png",
             @"emoji_180.png",
             @"emoji_181.png",
             @"emoji_182.png",
             @"emoji_183.png",
             @"emoji_184.png",
             @"emoji_185.png",
             @"emoji_186.png",
             @"emoji_187.png",
             @"wbdelete.png",
             
             @"emoji_188.png",
             @"emoji_189.png",
             @"emoji_190.png",
             @"emoji_191.png",
             @"emoji_192.png",
             @"emoji_193.png",
             @"emoji_194.png",
             @"emoji_195.png",
             @"emoji_196.png",
             @"emoji_197.png",
             @"emoji_198.png",
             @"emoji_199.png",
             @"emoji_200.png",
             @"emoji_201.png",
             @"emoji_202.png",
             @"emoji_203.png",
             @"emoji_204.png",
             @"emoji_205.png",
             @"emoji_206.png",
             @"emoji_207.png",
             @"wbdelete.png",
             
             @"emoji_208.png",
             @"emoji_209.png",
             @"emoji_210.png",
             @"emoji_211.png",
             @"emoji_212.png",
             @"emoji_213.png",
             @"emoji_214.png",
             @"emoji_215.png",
             @"emoji_216.png",
             @"emoji_217.png",
             @"emoji_218.png",
             @"emoji_219.png",
             @"emoji_220.png",
             @"emoji_221.png",
             @"emoji_222.png",
             @"emoji_223.png",
             @"emoji_224.png",
             @"wbdelete.png"];
}

+ (NSArray *)getEmojiNames
{
    return @[@"[可爱]",
             @"[笑脸]",
             @"[囧]",
             @"[生气]",
             @"[鬼脸]",
             @"[花心]",
             @"[害怕]",
             @"[我汗]",
             @"[尴尬]",
             @"[哼哼]",
             @"[忧郁]",
             @"[呲牙]",
             @"[媚眼]",
             @"[累]",
             @"[苦逼]",
             @"[瞌睡]",
             @"[哎呀]",
             @"[刺瞎]",
             @"[哭]",
             @"[激动]",
             @"[wbdelete]",
             
             @"[难过]",
             @"[害羞]",
             @"[高兴]",
             @"[愤怒]",
             @"[亲]",
             @"[飞吻]",
             @"[得意]",
             @"[惊恐]",
             @"[口罩]",
             @"[惊讶]",
             @"[委屈]",
             @"[生病]",
             @"[红心]",
             @"[心碎]",
             @"[玫瑰]",
             @"[花]",
             @"[外星人]",
             @"[金牛座]",
             @"[双子座]",
             @"[巨蟹座]",
             @"[wbdelete]",
             
             @"[狮子座]",
             @"[处女座]",
             @"[天平座]",
             @"[天蝎座]",
             @"[射手座]",
             @"[摩羯座]",
             @"[水瓶座]",
             @"[白羊座]",
             @"[双鱼座]",
             @"[星座]",
             @"[男孩]",
             @"[女孩]",
             @"[嘴唇]",
             @"[爸爸]",
             @"[妈妈]",
             @"[衣服]",
             @"[皮鞋]",
             @"[照相]",
             @"[电话]",
             @"[石头]",
             @"[wbdelete]",
             
             @"[胜利]",
             @"[禁止]",
             @"[滑雪]",
             @"[高尔夫]",
             @"[网球]",
             @"[棒球]",
             @"[冲浪]",
             @"[足球]",
             @"[小鱼]",
             @"[问号]",
             @"[叹号]",
             @"[顶]",
             @"[写字]",
             @"[衬衫]",
             @"[小花]",
             @"[郁金香]",
             @"[向日葵]",
             @"[鲜花]",
             @"[椰树]",
             @"[仙人掌]",
             @"[wbdelete]",
             
             @"[气球]",
             @"[炸弹]",
             @"[喝彩]",
             @"[剪子]",
             @"[蝴蝶结]",
             @"[机密]",
             @"[铃声]",
             @"[女帽]",
             @"[裙子]",
             @"[理发店]",
             @"[和服]",
             @"[比基尼]",
             @"[拎包]",
             @"[拍摄]",
             @"[铃铛]",
             @"[音乐]",
             @"[心星]",
             @"[粉心]",
             @"[丘比特]",
             @"[吹气]",
             @"[wbdelete]",
             
             @"[口水]",
             @"[对]",
             @"[错]",
             @"[绿茶]",
             @"[面包]",
             @"[面条]",
             @"[咖喱饭]",
             @"[饭团]",
             @"[麻辣烫]",
             @"[寿司]",
             @"[苹果]",
             @"[橙子]",
             @"[草莓]",
             @"[西瓜]",
             @"[柿子]",
             @"[眼睛]",
             @"[好的]",
             @"[wbdelete]"
             ];
}

/*表情更换地方*/
+(NSArray*)EmojiNewIamges
{
    return @[
             @"smiley_0.png",
             @"smiley_1.png",
             @"smiley_2.png",
             @"smiley_3.png",
             @"smiley_4.png",
             @"smiley_5.png",
             @"smiley_6.png",
             @"smiley_7.png",
             @"smiley_8.png",
             @"smiley_9.png",
             @"smiley_10.png",
             @"smiley_11.png",
             @"smiley_12.png",
             @"smiley_13.png",
             @"smiley_14.png",
             @"smiley_15.png",
             @"smiley_16.png",
             @"smiley_17.png",
             @"smiley_18.png",
             @"smiley_19.png",
             @"wbdelete.png",
             
             @"smiley_20.png",
             @"smiley_21.png",
             @"smiley_22.png",
             @"smiley_23.png",
             @"smiley_24.png",
             @"smiley_25.png",
             @"smiley_26.png",
             @"smiley_27.png",
             @"smiley_28.png",
             @"smiley_29.png",
             @"smiley_30.png",
             @"smiley_31.png",
             @"smiley_32.png",
             @"smiley_33.png",
             @"smiley_34.png",
             @"smiley_35.png",
             @"smiley_36.png",
             @"smiley_37.png",
             @"smiley_38.png",
             @"smiley_39.png",
             @"wbdelete.png",
             
             @"smiley_40.png",
             @"smiley_41.png",
             @"smiley_42.png",
             @"smiley_43.png",
             @"smiley_44.png",
             @"smiley_45.png",
             @"smiley_46.png",
             @"smiley_47.png",
             @"smiley_48.png",
             @"smiley_49.png",
             @"smiley_50.png",
             @"smiley_51.png",
             @"smiley_52.png",
             @"smiley_53.png",
             @"smiley_54.png",
             @"smiley_55.png",
             @"smiley_56.png",
             @"smiley_57.png",
             @"smiley_58.png",
             @"smiley_59.png",
             @"wbdelete.png",
             
             @"smiley_60.png",
             @"smiley_61.png",
             @"smiley_62.png",
             @"smiley_63.png",
             @"smiley_64.png",
             @"smiley_65.png",
             @"smiley_66.png",
             @"smiley_67.png",
             @"smiley_68.png",
             @"smiley_69.png",
             @"smiley_70.png",
             @"smiley_71.png",
             @"smiley_72.png",
             @"smiley_73.png",
             @"smiley_74.png",
             @"smiley_75.png",
             @"smiley_76.png",
             @"smiley_77.png",
             @"smiley_78.png",
             @"smiley_79.png",
             @"wbdelete.png",
             
             @"smiley_80.png",
             @"smiley_81.png",
             @"smiley_82.png",
             @"smiley_83.png",
             @"smiley_84.png",
             @"smiley_85.png",
             @"smiley_86.png",
             @"smiley_87.png",
             @"smiley_88.png",
             @"smiley_89.png",
             @"smiley_90.png",
             @"smiley_91.png",
             @"smiley_92.png",
             @"smiley_93.png",
             @"smiley_94.png",
             @"smiley_95.png",
             @"smiley_96.png",
             @"smiley_97.png",
             @"smiley_98.png",
             @"smiley_99.png",
             @"wbdelete.png",
             
             @"smiley_100.png",
             @"smiley_101.png",
             @"smiley_102.png",
             @"smiley_103.png",
             @"smiley_104.png",
             @"wbdelete.png"
             
             ];
}


+(NSArray*)EmojiNewNames
{
    return @[
             @"[微笑]",
             @"[撇嘴]",
             @"[喜爱]",
             @"[发呆]",
             @"[得意]",
             @"[流泪]",
             @"[害羞]",
             @"[闭嘴]",
             @"[呼呼]",
             @"[大哭]",
             @"[尴尬]",
             @"[发怒]",
             @"[调皮]",
             @"[呲牙]",
             @"[惊讶]",
             @"[难过]",
             @"[酷]",
             @"[冷汗]",
             @"[抓狂]",
             @"[吐]",
             @"[wbdelete]",
             
             @"[偷笑]",
             @"[可爱]",
             @"[白眼]",
             @"[傲慢]",
             @"[饥饿]",
             @"[困]",
             @"[惊恐]",
             @"[流汗]",
             @"[大笑]",
             @"[大兵]",
             @"[奋斗]",
             @"[咒骂]",
             @"[疑问]",
             @"[嘘]",
             @"[晕]",
             @"[折磨]",
             @"[衰]",
             @"[骷髅]",
             @"[敲打]",
             @"[再见]",
             @"[wbdelete]",
             
             @"[擦汗]",
             @"[挖鼻孔]",
             @"[鼓掌]",
             @"[糗]",
             @"[坏笑]",
             @"[左哼]",
             @"[右哼]",
             @"[哈欠]",
             @"[鄙视]",
             @"[委屈]",
             @"[难过]",
             @"[奸笑]",
             @"[亲亲]",
             @"[吓]",
             @"[可怜]",
             @"[刀]",
             @"[西瓜]",
             @"[啤酒]",
             @"[篮球]",
             @"[乒乓球]",
             @"[wbdelete]",
             
             @"[咖啡]",
             @"[饭]",
             @"[猪头]",
             @"[玫瑰]",
             @"[凋谢]",
             @"[吻]",
             @"[爱心]",
             @"[心碎]",
             @"[蛋糕]",
             @"[闪电]",
             @"[炸弹]",
             @"[小刀]",
             @"[足球]",
             @"[虫子]",
             @"[大便]",
             @"[月亮]",
             @"[太阳]",
             @"[礼物]",
             @"[拥抱]",
             @"[强]",
             @"[wbdelete]",
             
             @"[弱]",
             @"[握手]",
             @"[胜利]",
             @"[久仰]",
             @"[勾引]",
             @"[拳头]",
             @"[拉勾]",
             @"[示爱]",
             @"[No]",
             @"[OK]",
             @"[爱情]",
             @"[飞吻]",
             @"[跳]",
             @"[发抖]",
             @"[怄火]",
             @"[转圈]",
             @"[磕头]",
             @"[回头]",
             @"[跳绳]",
             @"[挥手]",
             @"[wbdelete]",
             
             @"[激动]",
             @"[街舞]",
             @"[献吻]",
             @"[左太极]",
             @"[右太极]",
             @"[wbdelete]"
             
             ];
}

+(NSArray *)alatoy_emoji
{
    return @[
             
             @"alatoy_1.gif",
             @"alatoy_2.gif",
             @"alatoy_3.gif",
             @"alatoy_4.gif",
             @"alatoy_5.gif",
             @"alatoy_6.gif",
             @"alatoy_7.gif",
             @"alatoy_8.gif",
             @"alatoy_9.gif",
             @"alatoy_10.gif",
             @"alatoy_11.gif"
             
             ];
}

+(NSArray*)alatoy_ZH_names
{
    return @[
             
             @"[不]",
             @"[谢谢]",
             @"[发奖]",
             @"[奋斗者]",
             @"[加班中]",
             @"[雷]",
             @"[冷]",
             @"[求放假]",
             @"[求睡眠]",
             @"[求重点]",
             @"[下班啦]"
             
             ];
}

+ (NSDictionary *)alatoy_emojiForName
{
    static NSDictionary *dictionary = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                      @"alatoy_1",  @"[不]",
                      @"alatoy_2",  @"[谢谢]",
                      @"alatoy_3",  @"[发奖]",
                      @"alatoy_4",  @"[奋斗者]",
                      @"alatoy_5",  @"[加班中]",
                      @"alatoy_6",  @"[雷]",
                      @"alatoy_7",  @"[冷]",
                      @"alatoy_8",  @"[求放假]",
                      @"alatoy_9",  @"[求睡眠]",
                      @"alatoy_10", @"[求重点]",
                      @"alatoy_11", @"[下班啦]",nil];

    });

    return dictionary;
}

+ (NSArray *)alatoy_EN_names
{
    return @[
             
             @"[NO]",
             @"[Thank You]",
             @"[Bonus]",
             @"[Fighter]",
             @"[Working]",
             @"[Thunder]",
             @"[Cold]",
             @"[Holiday]",
             @"[Sleep]",
             @"[Stress]",
             @"[Off Duty]"
             
             ];
}


+ (BOOL)isAlatoyEmoji:(NSString *)text
{
    static NSString *const kJEmojiRegex = @"(\\[{1}[^\\[\\]]+\\]{1})";

    if(![text isKindOfClass:[NSString class]] || ![text hasPrefix:@"[阿拉兔]["] || !text || 7 > [text length]) return NO;

    NSError *error = nil;

    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kJEmojiRegex
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    NSArray *arrayOfAllMatches = [regex matchesInString:text
                                                options:0
                                                  range:NSMakeRange(0, [text length])];


    if (2 == [arrayOfAllMatches count])
    {
        NSTextCheckingResult *match = arrayOfAllMatches[1];

        if(match.range.location + match.range.length > [text length]) return NO;

        NSString *substringForMatch = [text substringWithRange:match.range];

        return [[self alatoy_ZH_names] containsObject:substringForMatch]
        || [[self alatoy_EN_names] containsObject:substringForMatch];
    }

    return NO;
}

@end
