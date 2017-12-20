//
//  JKSystemHelper.h
//  jiankemall
//
//  Created by 郑喜荣 on 15/6/24.
//  Copyright (c) 2015年 jianke. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 系统信息帮助类
 */
@interface JKSystemHelper : NSObject

/**
 * 系统版本
 */
+ (NSString *)systemVersion;

/**
 * 应用版本号
 */
+ (NSString *)appVersion;

/**
 * 手机型号
 */
+ (NSString *)model;

@end
