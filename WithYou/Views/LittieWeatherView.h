//
//  LittieWeatherView.h
//  handhelddoctor
//
//  Created by jianke on 15/6/19.
//  Copyright (c) 2015年 jiankewang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LittieWeatherView;

@protocol LittieWeatherViewDelegate <NSObject>
@optional
-(void)LittieWeatherViewTap:(LittieWeatherView *)littieWeatherView;
@end

@interface LittieWeatherView : UIView
@property (nonatomic, strong) NSDictionary *weatherDict;
@property (nonatomic, weak) id<LittieWeatherViewDelegate>delegate;
-(void)setupWeatherSubView;
-(void)setupOpenSubView;
@end
