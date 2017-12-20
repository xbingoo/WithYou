//
//  LittieWeatherView.m
//  handhelddoctor
//
//  Created by jianke on 15/6/19.
//  Copyright (c) 2015年 jiankewang. All rights reserved.
//

#import "LittieWeatherView.h"
#import "NSString+JKHelper.h"
#import "UIFont+JKUI.h"

@interface LittieWeatherView()
@property (nonatomic, weak) UILabel *temperatureLable;
@property (nonatomic, weak) UILabel *pmLable;
@property (nonatomic, weak) UILabel *cityLabel;
@property (nonatomic, weak) UIImageView *weatherImage;

@end

@implementation LittieWeatherView

-(instancetype)init {
    if (self = [super init]) {
        BOOL weatherOpen = [[NSUserDefaults standardUserDefaults] boolForKey:@"weatherOpen"];
        if (weatherOpen) {
            [self setupWeatherSubView];
        } else {
            [self setupOpenSubView];
        }
    }
    return self;
}

-(void)setupWeatherSubView {
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(littieWeatherViewTap)]];
    
    UILabel *temperatureLable = [[UILabel alloc] init];
    temperatureLable.backgroundColor = [UIColor clearColor];
    temperatureLable.font = [UIFont jk_normalFont];
    temperatureLable.textColor = [UIColor whiteColor];
    [self addSubview:temperatureLable];
    self.temperatureLable = temperatureLable;
    
    UILabel *pmLable = [[UILabel alloc] init];
    pmLable.textAlignment = NSTextAlignmentCenter;
    pmLable.backgroundColor = [UIColor greenColor];
    pmLable.font = [UIFont jk_normalBoldFont];
    pmLable.layer.cornerRadius = 2.0;
    pmLable.layer.masksToBounds = YES;
    pmLable.textColor = [UIColor whiteColor];
    [self addSubview:pmLable];
    self.pmLable = pmLable;
    
    UILabel *cityLabel = [[UILabel alloc] init];
    cityLabel.backgroundColor = [UIColor clearColor];
    cityLabel.font = [UIFont jk_normalFont];
    cityLabel.textColor = [UIColor whiteColor];
    [self addSubview:cityLabel];
    self.cityLabel = cityLabel;
    
    UIImageView *weatherImage = [[UIImageView alloc] init];
    weatherImage.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:weatherImage];
    self.weatherImage = weatherImage;
    
    //约束
    CGFloat top = 7;
    CGFloat temperatureLableX = 30;
    CGFloat labelH = 15;
    CGFloat weatherImageW = 23;
    [temperatureLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:top];
    [temperatureLable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:temperatureLableX];
    [temperatureLable autoSetDimension:ALDimensionHeight toSize:labelH];
    
    [pmLable autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:temperatureLable];
    [pmLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:temperatureLable];
    [pmLable autoSetDimension:ALDimensionHeight toSize:labelH];
    
    [weatherImage autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:temperatureLableX];
    [weatherImage autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [weatherImage autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [weatherImage autoSetDimension:ALDimensionWidth toSize:weatherImageW];
    
    [cityLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:weatherImage withOffset:-5.0];
    [cityLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:temperatureLable];
    [cityLabel autoSetDimension:ALDimensionHeight toSize:labelH];
}

-(void)setupOpenSubView {
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(littieWeatherViewTap)]];
    
    UILabel *mentionLabel = [[UILabel alloc] init];
    mentionLabel.text = @"点击这里开启天气提示哦！开启";
    mentionLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.6];
    mentionLabel.font = [UIFont jk_normalFont];
    NSMutableAttributedString *couponAtr = [[NSMutableAttributedString alloc] initWithString:mentionLabel.text];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = [UIFont jk_normalBoldFont];
    dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [couponAtr addAttributes:dict range:NSMakeRange(12, 2)];
    mentionLabel.attributedText = couponAtr;
    [self addSubview:mentionLabel];
    
    UIImageView *weatherImageView = [[UIImageView alloc]init];
    weatherImageView.image = [UIImage imageNamed:@"sunshine_weather"];
    weatherImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:weatherImageView];
    
    CGFloat weatherImageViewW = 25;
    
    [mentionLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [mentionLabel autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [mentionLabel autoConstrainAttribute:ALAttributeVertical toAttribute:ALAttributeVertical ofView:self withOffset:weatherImageViewW* 0.5];
    
    [weatherImageView autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:mentionLabel];
    [weatherImageView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [weatherImageView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [weatherImageView autoSetDimension:ALDimensionWidth toSize:weatherImageViewW];
}

-(void)setWeatherDict:(NSDictionary *)weatherDict {
    _weatherDict = weatherDict;
    NSArray *weatherArr = weatherDict[@"weather_data"];
    NSDictionary *currentDic = weatherArr[0];
    
    NSString *currentDate = currentDic[@"date"];
    NSRange rangeBegin = [currentDate rangeOfString:@"实时："];
    NSString *currentTem = [currentDate substringWithRange:NSMakeRange(rangeBegin.location + rangeBegin.length, currentDate.length - (rangeBegin.location + rangeBegin.length) - 1)];
    NSLog(@"%@",currentTem);
    self.temperatureLable.text = currentTem;
    
    NSString *PMValue = weatherDict[@"pm25"];
    self.pmLable.text = [PMValue getChinesePMStringFromPMValue:PMValue];
    
    self.cityLabel.text = weatherDict[@"currentCity"];
    
    NSString *weatherStr = currentDic[@"weather"];
    self.weatherImage.image = [UIImage imageNamed:[weatherStr getWeatherImageNameWithWeatherName:weatherStr]];
}

-(void)littieWeatherViewTap {
    if ([self.delegate respondsToSelector:@selector(LittieWeatherViewTap:)]) {
        [self.delegate LittieWeatherViewTap:self];
    }
}

@end
