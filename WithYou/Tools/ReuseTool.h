//
//  ReuseTool.h
//  WithYou
//
//  Created by jianke-mbp on 15/11/28.
//  Copyright © 2015年 少先队. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ReuseTool : NSObject
/**
 *  颜色转换
 *
 *  @param color #000000形式的颜色描述
 *
 *  @return oc颜色类
 */
+(UIColor *) colorWithHexString: (NSString *)color;
/*
 * 计算字符串的Size
 * value 需要计算的字符串
 * font 字符串的字体
 * width 最大的宽度
 */
+ (CGSize) sizeForString:(NSString *)value font:(UIFont *)font andWidth:(float)width;
/*
 * 计算字符串的Size
 * value 需要计算的字符串
 * font 字符串的字体
 * height 最大的高度
 */
+ (CGSize) sizeForString:(NSString *)value font:(UIFont *)font andHeight:(float)height;
/**
 *  显示结果的提示框
 *
 *  @param labelText 结果描述
 *  @param time      显示的时间
 */
+ (void)showTipsWithHUD:(NSString *)labelText showTime:(CGFloat)time;
/**
 *  添加通讯框
 *
 *  @param title 通讯框标题文字描述
 */
+ (void)addHudMessageWithTitle:(NSString *)title;
/**
 *  隐藏通讯框
 */
+ (void)hideHudMessage;
@end
