//
//  NSString+JKHelper.h
//  jiankemall
//
//  Created by 郑喜荣 on 15/3/3.
//  Copyright (c) 2015年 jianke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(JKHelper)

- (NSString *)jk_trim;

- (BOOL)jk_isEmpty;

- (CGSize)jk_sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;//自适应大小方法

- (NSMutableAttributedString *)jk_strikethroughForString:(NSString *)strikeString strikestrColor:(UIColor *)strColor;//加删除线方法

- (NSString *)jk_substringWithPattern:(NSString *)pattern ofGroup:(NSInteger)group;

- (BOOL)jk_isUrlStr;

/*
 * 给一段字符串里面特定的字加上特定的颜色
 * sourceStr 是特定的字符
 * targetStr 需要加颜色的字符串
 * color 特定的颜色
 */
-(NSMutableAttributedString *)stringWithOriginalString:(NSString *)sourceStr targetString:(NSString *)targetStr color:(UIColor *)color;

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

/*
 * 根据天气的名字获取相应的天气图片String
 * weatherName 天气的名字
 */
-(NSString *) getWeatherImageNameWithWeatherName:(NSString *)weatherName;
-(NSString *) getWeatherBackgroundImageNameWithWeatherName:(NSString *)weatherName;

/*
 * 根据PM的数值返回响应的String
 * PMValue PM的数值
 */
-(NSString *)getPMStringFromPMValue:(NSString *)PMValue;
-(NSString *)getChinesePMStringFromPMValue:(NSString *)PMValue;

/*
 * 取出从某一个字符串开始到最后的String
 * beginString 开始的字符串
 * OriginalString 原来的字符串
 */
-(NSString *)getStringFromBeginStringToEnd:(NSString *)beginString byOriginalString:(NSString *)OriginalString;
/*
 * pragma mark 删除[product][/product]
 */
-(NSString *)deleteProductLabel:(NSString *)productStr;

/*
 * 根据HtmlString返回对应的string
 */
-(NSString *)dealWithHtmlString:(NSString *)str;
@end
