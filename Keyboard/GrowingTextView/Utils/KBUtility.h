//
//  KBUtility.h
//  Keyboard
//
//  Created by Thomson on 15/11/25.
//  Copyright © 2015年 Kemi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define kScreenWidth  ([UIScreen mainScreen].bounds.size.width)

@interface KBUtility : NSObject

/**
 *  Convert a string value to UIColor.
 *
 *  @param hexColorString A color Hex String. eg. #e5e5e5
 *
 *  @return Converted color.
 */
+ (UIColor *)HexColorToRedGreenBlue:(NSString *)hexColorString;

@end
