//
//  WeatherCollectionView.m
//  weather
//
//  Created by jianke on 15/6/19.
//  Copyright (c) 2015年 jianke. All rights reserved.
//

#import "WeatherCollectionView.h"
#import "NSString+JKHelper.h"

#define jiange 10
#define cellW (MAINSCREEN_WIDTH - jiange)/3.0
#define cellH 80

#define weatherFont 11.0

//@interface WeatherCollectionView()<UICollectionViewDataSource, UICollectionViewDelegate>
//
//@end

@implementation WeatherCollectionView
static NSString * const kWeatherCollectionViewCell = @"WeatherCollectionViewCell";

-(void)layoutSubviews {
    [super layoutSubviews];
    [self setup];
}

-(void)setup {
    
    self.backgroundColor = [UIColor clearColor];
    
    [self registerClass:WeatherCollectionViewCell.class forCellWithReuseIdentifier:kWeatherCollectionViewCell];
    
    self.dataSource = self;
    self.delegate = self;
}

#pragma mark - UICollectionViewDataSource methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return self.weatherArr.count;
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WeatherCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kWeatherCollectionViewCell forIndexPath:indexPath];
    
    NSDictionary *weatherDic = self.weatherArr[indexPath.row];
    NSString *weatherStr = weatherDic[@"weather"];
    cell.weatherImageView.image = [UIImage imageNamed:[weatherStr getWeatherImageNameWithWeatherName:weatherStr]];
    cell.dayLabel.text = @"今天";
    cell.temperatureLabel.text =weatherDic[@"temperature"];
    if (indexPath.row == 0) {
        cell.dayLabel.text = @"明天";
    } else if (indexPath.row == 1) {
        cell.dayLabel.text = @"后天";
    } else {
        NSString *weatherDay = weatherDic[@"date"];
        NSString *day = [NSString stringWithFormat:@"星期%@", [weatherDay substringWithRange:NSMakeRange(weatherDay.length - 1, 1)]];
        cell.dayLabel.text =day;
    }
    
    return cell;
}

-(void)setWeatherArr:(NSArray *)weatherArr {
    _weatherArr = weatherArr;
    [self reloadData];
}

-(void)setWeatherDict:(NSDictionary *)weatherDict {
    _weatherDict = weatherDict;
    NSArray *weatherArr = weatherDict[@"weather_data"];
    NSMutableArray *weatherMArr = [NSMutableArray array];
    for (int i = 0; i < weatherArr.count; i++) {
        if (i != 0) {
            [weatherMArr addObject:weatherArr[i]];
        }
    }
    self.weatherArr = weatherMArr;
}

@end

@implementation WeatherCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubView];
    }
    return self;
}

-(void)setupSubView {
    
    self.backgroundColor = [UIColor clearColor];
    
    UIImageView *weatherImageView = [[UIImageView alloc] init];
    weatherImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:weatherImageView];
    self.weatherImageView = weatherImageView;
    
    UILabel *dayLabel = [[UILabel alloc] init];
    [self addSubview:dayLabel];
    dayLabel.textAlignment = NSTextAlignmentCenter;
    dayLabel.font = [UIFont systemFontOfSize:weatherFont];
    dayLabel.textColor = [UIColor whiteColor];
    self.dayLabel = dayLabel;
    
    UILabel *temperatureLabel = [[UILabel alloc] init];
    [self addSubview:temperatureLabel];
    temperatureLabel.textAlignment = NSTextAlignmentCenter;
    temperatureLabel.font = [UIFont systemFontOfSize:weatherFont];
    temperatureLabel.textColor = [UIColor whiteColor];
    self.temperatureLabel = temperatureLabel;
    
    //约束
    CGFloat weatherImageViewH = self.frame.size.height * 0.4;
    [weatherImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [weatherImageView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [weatherImageView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [weatherImageView autoSetDimension:ALDimensionHeight toSize:weatherImageViewH];
    
    CGFloat dayLabelH = self.frame.size.height * 0.15;
    [dayLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [dayLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [dayLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:weatherImageView];
    [dayLabel autoSetDimension:ALDimensionHeight toSize:dayLabelH];
    
    CGFloat temperatureLabelH = dayLabelH;
    [temperatureLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:dayLabel withOffset:2];
    [temperatureLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [temperatureLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [temperatureLabel autoSetDimension:ALDimensionHeight toSize:temperatureLabelH];
}

@end