//
//  EarthView.h
//  WithYou
//
//  Created by jianke-mbp on 15/11/27.
//  Copyright © 2015年 少先队. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface EarthView : UIView
/**
 *  重新设置速度
 *
 *  @param honeySpeed 地球速度
 *  @param mySpeed    火箭速度
 */
-(void)setHoneySpeed:(CGFloat)honeySpeed andMySpeed:(CGFloat)mySpeed;

@property(nonatomic ,assign) BOOL isStopLoop;
@end
