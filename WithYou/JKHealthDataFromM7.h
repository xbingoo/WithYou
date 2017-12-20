//
//  JKHealthDataForM7.h
//  HealthDemo
//
//  Created by jianke-mbp on 15/11/17.
//  Copyright © 2015年 少先队. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HealthDateModel.h"
//@class JKHealthDataFromM7;
typedef enum{
    SportDataTypeStepCount,
    SportDataTypeDistance,
} SportDataType;

@interface JKHealthDataFromM7 : NSObject
/**
 *  设备是否支持使用计步器
 */
@property(nonatomic,assign,readonly) BOOL isDeviceSupport;
@property(nonatomic,assign,readonly) BOOL isActive;

/**
 *  获取任意天数的运动数据（最大为7天）
 *
 *  @param sportDataType （SportDataTypeStepCount/SportDataTypeDistance）
 *  @param days          需要获取的天数（最大7天）
 *  @param block         回调得到数组类型的结果和错误提示
 */
-(void)requestStepCountAndDistanceWithDays:(NSInteger)days and:(void(^)(NSArray *result,NSError *error,NSArray *startTimeArr))block;
/**
 *  即时的获取步数变化
 *
 *  @param block 回调得到步数变化、时间戳、错误原因
 */
-(void)requestImmediateStepCount:(void(^)(NSInteger numberOfSteps, NSDate *timestamp,NSError *error))block;


@end

@interface JKHealthDataFromM7 (HealthDateDBTool)

/**
 *  创建数据库并创建数据库表
 */
-(void)createDB;

/**
 *  保存数据到数据库
 *
 *  @param healthDateModel 一条记录所包含的所有元素
 */
-(void)saveHealthDataWithHealthDateModel:(HealthDateModel *)healthDateModel;

/**
 *  更新当天的运动数据
 *
 *  @param healthDateModel 数据模型
 */
-(void)updateHealthDataWithHealthDataModel:(HealthDateModel *)healthDateModel;

/**
 *  查询数据库中是否存在该记录
 *
 *  @param healthDateModel 数据模型
 */
-(NSString *)searchHealthDataByHealthDataModel:(HealthDateModel *)healthDateModel;

/**
 *  通过日期升序的方式获取数据库中所有数据
 *
 *  @return 包含所有数据的数组
 */
-(NSMutableArray *)getAllHealthDataByDateWithASC;
/**
 *  获取总路程
 *
 *  @return 总路程
 */
-(NSString *)getTotalDistance;

@end
