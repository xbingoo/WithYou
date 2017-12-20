//
//  WeatherCollectionView.h
//  weather
//
//  Created by jianke on 15/6/19.
//  Copyright (c) 2015年 jianke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherCollectionView : UICollectionView<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSArray *weatherArr;
@property (nonatomic, strong) NSDictionary *weatherDict;
@end

@interface WeatherCollectionViewCell : UICollectionViewCell
@property (nonatomic, weak) UIImageView *weatherImageView;
@property (nonatomic, weak) UILabel *dayLabel;
@property (nonatomic, weak) UILabel *temperatureLabel;

@end