//
//  JKUserDefaults.h
//  jiankemall
//
//  Created by 郑喜荣 on 15/4/2.
//  Copyright (c) 2015年 jianke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKUserDefaults : NSObject

- (instancetype)init __attribute__((unavailable("init is not available in JKUserDefaults, Use sharedInstance"))) NS_DESIGNATED_INITIALIZER;

@property (nonatomic, assign) BOOL isUsedApp;
/**
 *  计步器用户资料
 */
@property (nonatomic, strong) NSDictionary *stepDic;
/**
 *  用户解锁的歌曲
 */
@property (nonatomic, assign) NSInteger numberOfSongs;
/**
 *  所有歌曲
 */
@property (nonatomic ,strong) NSArray *allMusicNameArr;

//已使用过的背景图片
@property (nonatomic ,strong) NSArray *backgroundImageArr;


@property (nonatomic,assign) NSInteger maxStepCount;



+ (instancetype)sharedInstance;

@end
