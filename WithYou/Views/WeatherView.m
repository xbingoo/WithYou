//
//  WeatherView.m
//  weather
//
//  Created by jianke on 15/6/18.
//  Copyright (c) 2015年 jianke. All rights reserved.
// 背景尺寸640*321

#import "WeatherView.h"
#import "NSString+JKHelper.h"

@interface WeatherView()
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UIView *cityView;
@property (weak, nonatomic) IBOutlet UILabel *PMLabel;
@property (weak, nonatomic) IBOutlet UIView *refreshView;
@property (weak, nonatomic) IBOutlet UILabel *refreshTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureRangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *windLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherBackgroundImageView;

@end

@implementation WeatherView

-(void)layoutSubviews {
    [super layoutSubviews];
    self.PMLabel.layer.cornerRadius = 4.0;
    self.PMLabel.layer.masksToBounds = YES;
    
    [self.cityView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cityViewTap:)]];
    [self.refreshView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshViewTap:)]];
}

-(void)setWeatherDict:(NSDictionary *)weatherDict {
    _weatherDict = weatherDict;
    NSArray *weatherArr = weatherDict[@"weather_data"];
    NSDictionary *currentDic = weatherArr[0];
    
    //获取当前温度
    NSString *currentDate = currentDic[@"date"];
    NSRange rangeBegin = [currentDate rangeOfString:@"实时："];
    NSString *currentTem = [currentDate substringWithRange:NSMakeRange(rangeBegin.location + rangeBegin.length, currentDate.length - (rangeBegin.location + rangeBegin.length) - 1)];
    NSLog(@"%@",currentTem);
    self.temperatureLabel.text = currentTem;
    
    //PM25
    NSString *PMValue = weatherDict[@"pm25"];
    self.PMLabel.text = [PMValue getPMStringFromPMValue:PMValue];
    
    //当前城市
    self.cityLabel.text = weatherDict[@"currentCity"];
    
    //更新时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    self.refreshTimeLabel.text = [NSString stringWithFormat:@"%@", [formatter stringFromDate:[NSDate date]]];
    
    NSString *weatherStr = currentDic[@"weather"];
    self.weatherLabel.text = weatherStr;
    self.temperatureRangeLabel.text = currentDic[@"temperature"];
    self.windLabel.text = currentDic[@"wind"];
    
    self.weatherImageView.image = [UIImage imageNamed:[weatherStr getWeatherImageNameWithWeatherName:weatherStr]];
    
//    self.weatherBackgroundImageView.image = [UIImage imageNamed:[weatherStr getWeatherBackgroundImageNameWithWeatherName:weatherStr]];
//    self.weatherBackgroundImageView.alpha = 0.5;
}

-(void)cityViewTap:(UITapGestureRecognizer *)gesture {
    NSLog(@"cityViewTap:");
    if ([self.delegate respondsToSelector:@selector(WeatherViewCityViewTap:)]) {
        [self.delegate WeatherViewCityViewTap:self];
    }
}

-(void)refreshViewTap:(UITapGestureRecognizer *)gesture {
    NSLog(@"refreshViewTap:");
    if ([self.delegate respondsToSelector:@selector(WeatherViewRefreshViewTap:)]) {
        [self.delegate WeatherViewRefreshViewTap:self];
    }
}

@end
