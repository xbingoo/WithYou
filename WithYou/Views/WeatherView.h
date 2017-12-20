//
//  WeatherView.h
//  weather
//
//  Created by jianke on 15/6/18.
//  Copyright (c) 2015年 jianke. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WeatherView;

@protocol WeatherViewDelegate <NSObject>
@optional
-(void)WeatherViewCityViewTap:(WeatherView *)weatherView;
-(void)WeatherViewRefreshViewTap:(WeatherView *)weatherView;

@end

@interface WeatherView : UIView
@property (nonatomic, strong) NSDictionary *weatherDict;
@property (nonatomic, weak) id<WeatherViewDelegate> delegate;
@end
