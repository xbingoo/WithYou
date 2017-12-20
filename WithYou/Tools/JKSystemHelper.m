//
//  JKSystemHelper.m
//  jiankemall
//
//  Created by 郑喜荣 on 15/6/24.
//  Copyright (c) 2015年 jianke. All rights reserved.
//

#import "JKSystemHelper.h"
#import <sys/utsname.h>
#import <UIKit/UIKit.h>

@implementation JKSystemHelper


+ (NSString *)systemVersion {
    return [UIDevice currentDevice].systemVersion;
}

+ (NSString *)appVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)model {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *machineString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    static NSDictionary *modelDict;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        modelDict = @{
                      @"i386"     : @"iPhone Simulator",
                      @"x86_64"   : @"iPhone Simulator",
                      @"iPhone1,1": @"iPhone 2G",
                      @"iPhone1,2": @"iPhone 3G",
                      @"iPhone2,1": @"iPhone 3GS",
                      @"iPhone3,1": @"iPhone 4(GSM)",
                      @"iPhone3,2": @"iPhone 4(GSM Rev A)",
                      @"iPhone3,3": @"iPhone 4(CDMA)",
                      @"iPhone4,1": @"iPhone 4S",
                      @"iPhone5,1": @"iPhone 5(GSM)",
                      @"iPhone5,2": @"iPhone 5(GSM+CDMA)",
                      @"iPhone5,3": @"iPhone 5c(GSM)",
                      @"iPhone5,4": @"iPhone 5c(Global)",
                      @"iPhone6,1": @"iphone 5s(GSM)",
                      @"iPhone6,2": @"iphone 5s(Global)",
                      @"iPod1,1"  : @"iPod Touch 1G",
                      @"iPod2,1"  : @"iPod Touch 2G",
                      @"iPod3,1"  : @"iPod Touch 3G",
                      @"iPod4,1"  : @"iPod Touch 4G",
                      @"iPod5,1"  : @"iPod Touch 5G",
                      @"iPad1,1"  : @"iPad",
                      @"iPad2,1"  : @"iPad 2(WiFi)",
                      @"iPad2,2"  : @"iPad 2(GSM)",
                      @"iPad2,3"  : @"iPad 2(CDMA)",
                      @"iPad2,4"  : @"iPad 2(WiFi + New Chip)",
                      @"iPad3,1"  : @"iPad 3(WiFi)",
                      @"iPad3,2"  : @"iPad 3(GSM+CDMA)",
                      @"iPad3,3"  : @"iPad 3(GSM)",
                      @"iPad3,4"  : @"iPad 4(WiFi)",
                      @"iPad3,5"  : @"iPad 4(GSM)",
                      @"iPad3,6"  : @"iPad 4(GSM+CDMA)",
                      @"iPad2,5"  : @"iPad mini (WiFi)",
                      @"iPad2,6"  : @"iPad mini (GSM)",
                      @"iPad2,7"  : @"ipad mini (GSM+CDMA)"
                      };
    });
    
    NSString *model = modelDict[machineString];
    
    
    return model == nil ? machineString : model;
}

@end
