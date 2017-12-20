//
//  NSString+JKHelper.m
//  jiankemall
//
//  Created by 郑喜荣 on 15/3/3.
//  Copyright (c) 2015年 jianke. All rights reserved.
//

#import "NSString+JKHelper.h"

@implementation NSString(JKHelper)

- (NSString *)jk_trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)jk_isEmpty {
    return [[self jk_trim] isEqualToString:@""];
}

- (CGSize)jk_sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


- (NSMutableAttributedString *)jk_strikethroughForString:(NSString *)strikeString strikestrColor:(UIColor *)strColor
{
    NSUInteger length = [strikeString length];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:strikeString];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:strColor range:NSMakeRange(0, length)];
    return attri;
}

- (NSString *)jk_substringWithPattern:(NSString *)pattern ofGroup:(NSInteger)group {
    NSString *result = nil;
//    NSString *pattern = @"^channelId:(.+)$";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matches = [regex matchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length)];
    for (NSTextCheckingResult *match in matches){
        NSRange range = [match rangeAtIndex:1];
        result = [self substringWithRange:range];
        break;
    }
    
    return result;
}

- (BOOL)jk_isUrlStr {
    return [self hasPrefix:@"https://"] || [self hasPrefix:@"http://"];
}

-(NSMutableAttributedString *)stringWithOriginalString:(NSString *)sourceStr targetString:(NSString *)targetStr color:(UIColor *)color
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:sourceStr];
    NSString *target = nil;
    NSString *source = nil;
    if (sourceStr.length > 0 & targetStr.length > 0) {
        
        for(int i = 0; i < [sourceStr length]; i++)
        {
            source = [sourceStr substringWithRange:NSMakeRange(i, 1)];
            
            for(int j = 0; j < [targetStr length]; j++)
            {
                target = [targetStr substringWithRange:NSMakeRange(j, 1)];
                if ([target isEqualToString:source]) {
                    [str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(i,1)];
                }
            }
        }
    }
        return str;
}

#pragma mark 计算字体size
+ (CGSize) sizeForString:(NSString *)value font:(UIFont *)font andWidth:(float)width
{
    UITextView *detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, width, 0)];
    detailTextView.font = font;
    detailTextView.text = value;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width,CGFLOAT_MAX)];
    return deSize;
}
#pragma mark 计算字体大小size（宽度）
+ (CGSize) sizeForString:(NSString *)value font:(UIFont *)font andHeight:(float)height{
//    UITextView *detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 0, height)];
//    detailTextView.font = font;
//    detailTextView.text = value;
//    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(CGFLOAT_MAX,height)];
////    return deSize;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, height)];

    label.font =font;
    label.text = value;
    [label sizeToFit];
    
    NSLog(@"%@", NSStringFromCGRect(label.frame));
    
    return label.frame.size;
}

#pragma mark 根据天气的名字获取相应的天气图片String
-(NSString *) getWeatherImageNameWithWeatherName:(NSString *)weatherName {
    NSString *weatherImageStr = nil;
    if ([weatherName rangeOfString:@"晴"].location !=NSNotFound) {
        weatherImageStr = @"sunshine_weather";
    } else if ([weatherName rangeOfString:@"阴"].location !=NSNotFound) {
        weatherImageStr = @"cloudy_weather";
    } else if ([weatherName rangeOfString:@"多云"].location !=NSNotFound) {
        weatherImageStr = @"cloudytoshunshine_weather";
    } else if ([weatherName rangeOfString:@"雾"].location !=NSNotFound) {
        weatherImageStr = @"fog_weather";
    } else if ([weatherName rangeOfString:@"大雨"].location !=NSNotFound) {
        weatherImageStr = @"heavy_rain_weather";
    } else if ([weatherName rangeOfString:@"冰雹"].location !=NSNotFound) {
        weatherImageStr = @"hail_wather";
    } else if ([weatherName rangeOfString:@"小雨"].location !=NSNotFound) {
        weatherImageStr = @"light_rain_weather";
    } else if ([weatherName rangeOfString:@"阵雨"].location !=NSNotFound) {
        weatherImageStr = @"shower_weather";
    } else if ([weatherName rangeOfString:@"雪"].location !=NSNotFound) {
        weatherImageStr = @"snow_weather";
    } else if ([weatherName rangeOfString:@"雷阵雨"].location !=NSNotFound) {
        weatherImageStr = @"thundershower_weather";
    }
    return weatherImageStr;
}

#pragma mark 根据天气的名字获取相应的天气背景图片String
-(NSString *) getWeatherBackgroundImageNameWithWeatherName:(NSString *)weatherName {
    NSString *weatherImageStr = nil;
    if ([weatherName rangeOfString:@"晴"].location !=NSNotFound) {
        weatherImageStr = @"weather_sunshine_bg.jpg";
    } else if ([weatherName rangeOfString:@"阴"].location !=NSNotFound || [weatherName rangeOfString:@"多云"].location !=NSNotFound) {
        weatherImageStr = @"weather_cloudy_bg";
    } else if ([weatherName rangeOfString:@"雨"].location !=NSNotFound) {
        weatherImageStr = @"weather_rain_bg";
    } else if ([weatherName rangeOfString:@"雪"].location !=NSNotFound || [weatherName rangeOfString:@"冰雹"].location !=NSNotFound) {
        weatherImageStr = @"weather_snow_bg";
    }
    return weatherImageStr;
}

#pragma mark 根据PM的数值返回相应的String
-(NSString *)getPMStringFromPMValue:(NSString *)PMValue {
    NSInteger pm = [PMValue integerValue];
    NSString *pmStr = nil;
    if (pm <= 35) {
        pmStr = [NSString stringWithFormat:@" PM%ld 优 ", (long)pm];
    } else if (pm <= 75) {
        pmStr = [NSString stringWithFormat:@" PM%ld 良 ", (long)pm];
    } else if (pm <= 115) {
        pmStr = [NSString stringWithFormat:@" PM%ld 轻度污染 ", (long)pm];
    } else if (pm <= 150) {
        pmStr = [NSString stringWithFormat:@" PM%ld 中度污染 ", (long)pm];
    } else if (pm <= 250) {
        pmStr = [NSString stringWithFormat:@" PM%ld 重度污染 ", (long)pm];
    } else {
        pmStr = [NSString stringWithFormat:@" PM%ld 严重污染 ", (long)pm];
    }
    return pmStr;
}

#pragma mark 根据PM的数值返回相应的中文
-(NSString *)getChinesePMStringFromPMValue:(NSString *)PMValue {
    NSInteger pm = [PMValue integerValue];
    NSString *pmStr = nil;
    if (pm <= 35) {
        pmStr = @"优 ";
    } else if (pm <= 75) {
        pmStr = @"良 ";
    } else if (pm <= 115) {
        pmStr = @"轻度污染 ";
    } else if (pm <= 150) {
        pmStr = @"中度污染 ";
    } else if (pm <= 250) {
        pmStr = @"重度污染 ";
    } else {
        pmStr = @"严重污染 ";
    }
    return pmStr;
}

#pragma mark 取出从某一个字符串开始到最后的String
-(NSString *)getStringFromBeginStringToEnd:(NSString *)beginString byOriginalString:(NSString *)OriginalString {
    NSRange newStrRange = [OriginalString rangeOfString:beginString];
    NSString *newStr = [NSString string];
    if (newStrRange.length > 0) {
        newStr = [OriginalString substringWithRange:NSMakeRange(newStrRange.location + newStrRange.length + 1, OriginalString.length - newStrRange.location - newStrRange.length - 1)];
    }
    return newStr;
}

#pragma mark 删除[product][/product]
-(NSString *)deleteProductLabel:(NSString *)productStr {
    NSString *newProductStr = productStr;
    if (newProductStr) {
        NSRange productRange = [productStr rangeOfString:@"[product"];
        while (productRange.length > 0) {
            NSString *productLaterStr = [newProductStr substringWithRange:NSMakeRange(productRange.location, newProductStr.length - productRange.location)];
            NSRange rightKuohaoRange = [productLaterStr rangeOfString:@"]"];
            NSRange productR = NSMakeRange(productRange.location, rightKuohaoRange.location + 1);
            newProductStr = [newProductStr stringByReplacingCharactersInRange:productR withString:@""];
            newProductStr = [newProductStr stringByReplacingOccurrencesOfString:@"[/product]" withString:@""];
            productRange = [newProductStr rangeOfString:@"[product"];
        }
    }
    return newProductStr;
}

-(NSString *)dealWithHtmlString:(NSString *)str {
    if (str.length > 0) {
        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        NSString *newStr = [attrStr.string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        return newStr;
    } else {
        return nil;
    }
}
@end
