//
//  UIFont+JKUI.m
//  jiankemall
//
//  Created by 郑喜荣 on 15/4/10.
//  Copyright (c) 2015年 jianke. All rights reserved.
//

#import "UIFont+JKUI.h"

@implementation UIFont(JKUI)

static CGFloat const kNormalFontSize = 12.0f;
static CGFloat const kLargerFontSize = 14.0f;
static CGFloat const kSmallerFontSize = 10.0f;
static CGFloat const kLargestFontSize = 16.0f;

+ (instancetype)jk_normalFont {
    return [UIFont systemFontOfSize:kNormalFontSize];
}

+ (instancetype)jk_largFont {
    return [UIFont systemFontOfSize:kLargerFontSize];
}

+ (instancetype)jk_largerFont {
    return [UIFont systemFontOfSize:kLargestFontSize];
}

+ (instancetype)jk_smallFont {
    return [UIFont systemFontOfSize:kSmallerFontSize];
}

+ (instancetype)jk_normalBoldFont {
    return [UIFont boldSystemFontOfSize:kNormalFontSize];
}

+ (instancetype)jk_largBoldFont {
    return [UIFont boldSystemFontOfSize:kLargerFontSize];
}

+ (instancetype)jk_smallBoldFont {
    return [UIFont boldSystemFontOfSize:kSmallerFontSize];
}


@end
