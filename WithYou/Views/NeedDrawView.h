//
//  NeedDrawView.h
//  DrayPointTest
//
//  Created by xun on 14-3-25.
//  Copyright (c) 2014年 xun. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NeedDrawView : UIView
{
    NSString *_curString;//当前要画得那个String
    CGPoint   _curPoint;
    NSString *_needDrawString;//需要DrawRect的String
    int       _titleIndex;//title的索引
    int       _chargeIndex;//一条title显示结束index+1;
}

@property (nonatomic, strong) NSArray *titlePoints;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSTimer *timer;

//- (void)setData:(NSArray *)array;
- (void)setData:(NSArray *)array andTitieFlag:(int)flag;
@end
