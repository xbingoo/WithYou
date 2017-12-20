//
//  JKHealthDataForM7.m
//  HealthDemo
//
//  Created by jianke-mbp on 15/11/17.
//  Copyright © 2015年 少先队. All rights reserved.
//

#import "JKHealthDataFromM7.h"
#import <CoreMotion/CoreMotion.h>
#import <UIKit/UIKit.h>
#import <FMDB.h>
#define kHealthDateTable @"health_date_table"

@interface JKHealthDataFromM7()

@property (nonatomic, strong) CMStepCounter *stepCounter;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) CMPedometer *pedometer;
@property(nonatomic, strong) FMDatabase *fmDataBase;

@end

@implementation JKHealthDataFromM7

/**
 *  当天的数据需要即时更新，启动内置M7记步
 */
-(void)requestImmediateStepCount:(void(^)(NSInteger numberOfSteps, NSDate *timestamp,NSError *error))block{
    
        if ([CMStepCounter isStepCountingAvailable]) {
            
            __block NSInteger lastNumberOfSteps = 0;
            
            [self.stepCounter startStepCountingUpdatesToQueue:self.operationQueue
                                                     updateOn:1
                                                  withHandler:
             ^(NSInteger numberOfSteps, NSDate *timestamp, NSError *error) {
                 //每秒的产生的步数
                 NSInteger count = numberOfSteps-lastNumberOfSteps;
                 lastNumberOfSteps = numberOfSteps;
                 if (block) {
                     block(count,timestamp,error);
                 }
             }];
        }
}

-(void)requestStepCountAndDistanceWithDays:(NSInteger)days and:(void(^)(NSArray *result,NSError *error,NSArray *startTimeArr))block{
    
    NSArray *endTimeArr = [self getEndTimeArrByDays:days];
    NSArray *startTimeArr = [self getStartTimeArrByDays:days];
    
    NSMutableArray *resultArr = [[NSMutableArray alloc]init];
    
    for (NSInteger i = 0; i < days; i++) {
        
        [self.pedometer queryPedometerDataFromDate:startTimeArr[i] toDate:endTimeArr[i] withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
            
            if (error) {
                
//                [resultArr addObject:[NSString stringWithFormat:@"%ld",error.code]];
                if (block) {
                    block(resultArr,error,startTimeArr);
                }
                
            }else{
            
                NSDictionary *dic = @{@"stepCount":[NSString stringWithFormat:@"%@",pedometerData.numberOfSteps],
                                      @"distance":[NSString stringWithFormat:@"%@",pedometerData.distance]};
                [resultArr addObject:dic];
            
                if (i == days-1) {
                    if (block) {
                        block(resultArr,error,startTimeArr);
                    }
                }
            }
        }];
    }
}

-(NSArray*)getEndTimeArrByDays:(NSInteger)days{
    
    if (days == 0) {
        return nil;
    }
    
    NSMutableArray *resultArr = [[NSMutableArray alloc]init];
    
    NSDate *lastEndTime = [[NSDate alloc]init];
    
    [resultArr addObject:lastEndTime];
    
    if (days == 1) {
        return resultArr;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSMutableString *lastEndTimeStr = [NSMutableString stringWithString:[dateFormatter stringFromDate:lastEndTime]];
    [lastEndTimeStr replaceCharactersInRange:NSMakeRange(8,6) withString:@"000000"];
    NSDate *lastDate = [dateFormatter dateFromString:lastEndTimeStr];
    [resultArr addObject:lastDate];
    
    if (days == 2) {
        return resultArr;
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    for (NSInteger i = 0; i < days-2; i++) {
        NSDate *startDate = [calendar
                             dateByAddingUnit:NSCalendarUnitDay
                             value:-i-1
                             toDate:lastDate
                             options:0];
        [resultArr addObject:startDate];
    }
    return resultArr;
}

-(NSArray*)getStartTimeArrByDays:(NSInteger)days{
    if (days == 0) {
        return nil;
    }
    NSMutableArray *resultArr = [[NSMutableArray alloc]init];
    NSDate *currentDate = [[NSDate alloc]init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSMutableString *currentDateStr = [NSMutableString stringWithString:[dateFormatter stringFromDate:currentDate]];
    [currentDateStr replaceCharactersInRange:NSMakeRange(8,6) withString:@"000000"];
    NSDate *lastDate = [dateFormatter dateFromString:currentDateStr];
    [resultArr addObject:lastDate];
    if (days == 1) {
        return resultArr;
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    for (NSInteger i = 0; i < days-1; i++) {
        NSDate *startDate = [calendar
                             dateByAddingUnit:NSCalendarUnitDay
                             value:-i-1
                             toDate:lastDate
                             options:0];
        [resultArr addObject:startDate];
    }
    return resultArr;
}

-(CMStepCounter *)stepCounter{
    if (!_stepCounter) {
        _stepCounter = [[CMStepCounter alloc]init];
    }
    return _stepCounter;
}

-(NSOperationQueue *)operationQueue{
    if (!_operationQueue) {
        _operationQueue = [[NSOperationQueue alloc]init];
    }
    return _operationQueue;
}

-(CMPedometer *)pedometer{
    if (!_pedometer) {
        _pedometer = [[CMPedometer alloc]init];
    }
    return _pedometer;
}

-(BOOL)isDeviceSupport{
    return [CMStepCounter isStepCountingAvailable];
}

-(BOOL)isActive{
    return [CMMotionActivityManager isActivityAvailable];
}


@end



@implementation JKHealthDataFromM7 (HealthDateDBTool)


-(void)createDB{
    
//    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/health_date_table.db"];
//    self.fmDataBase = [FMDatabase databaseWithPath:path];
//    NSLog(@"%@",path);
    
    if ([self.fmDataBase open]) {
        NSLog(@"打开数据库成功");
        [self createTable];
    } else {
        NSLog(@"打开数据库失败");
        return;
    }
    
}

-(void)createTable{
    
    NSString *sql = [NSString stringWithFormat:@"create table if not exists %@(date varchar primary key,stepcount varchar, distance double)",kHealthDateTable];
    BOOL res = [self.fmDataBase executeUpdate:sql];//执行sql语句
    
    if (res == NO) {
        NSLog(@"创建表失败");
        [self.fmDataBase close];//关闭数据库
        return;
    }else if(res==YES){
        NSLog(@"创建表成功");
    }
}

-(void)saveHealthDataWithHealthDateModel:(HealthDateModel *)healthDateModel{

    BOOL openResult = [self.fmDataBase open];
    
    if (!openResult) {
        return;
    }
    
    NSString *sql = [NSString stringWithFormat:@"insert or ignore into %@ (date,stepcount,distance) values (\"%@\",\"%@\",\"%f\")",kHealthDateTable,healthDateModel.date,healthDateModel.stepCount,[healthDateModel.distance doubleValue]];
    
    BOOL result = [self.fmDataBase executeUpdate:sql];
    if (result == NO) {
        NSLog(@"插入记录失败");
    } else {
        NSLog(@"插入记录成功");
    }
}

-(void)updateHealthDataWithHealthDataModel:(HealthDateModel *)healthDateModel{
    
    BOOL openResult = [self.fmDataBase open];
    
    if (!openResult) {
        return;
    }
    
    NSString *sql = [NSString stringWithFormat:@"update %@ set stepcount=\"%@\", distance=\"%f\" where date=\"%@\"",kHealthDateTable,healthDateModel.stepCount,[healthDateModel.distance doubleValue] ,healthDateModel.date];
    BOOL result = [self.fmDataBase executeUpdate:sql];
    
    if (result == NO) {
        NSLog(@"更新记录失败");
    }else{
        NSLog(@"更新记录成功");
    }
    
}

-(NSString *)searchHealthDataByHealthDataModel:(HealthDateModel *)healthDateModel{
    
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where date=\"%@\"",kHealthDateTable,healthDateModel.date];
    
    FMResultSet *rs = [self.fmDataBase executeQuery:sql];
    
    NSString *dic = nil;
    
    while (rs.next) {
        dic = [rs stringForColumn:@"stepcount"];
    }
    
    return dic;
}

-(NSMutableArray *)getAllHealthDataByDateWithASC{
    
    NSString *sql = [NSString stringWithFormat:@"select * from %@ order by date DESC",kHealthDateTable];
    
    FMResultSet *rs = [self.fmDataBase executeQuery:sql];
    
    NSMutableArray *healthDataArr = [NSMutableArray array];
    
    while (rs.next) {
        
        HealthDateModel *healthDataModel = [[HealthDateModel alloc]init];
        healthDataModel.date = [rs stringForColumn:@"date"];

        healthDataModel.stepCount = [rs stringForColumn:@"stepcount"];

        healthDataModel.distance = [NSString stringWithFormat:@"%f",[rs doubleForColumn:@"distance"]];

        [healthDataArr addObject:healthDataModel];
        
    }
    NSLog(@"____%lu",(unsigned long)healthDataArr.count);
    return healthDataArr;
}

-(NSString *)getTotalDistance{
    NSString *totalDistance = nil;
    NSString *sql = [NSString stringWithFormat:@"select sum(cast(distance as double)) as distance from (select distance from %@ group by date) as temp",kHealthDateTable];
    
    FMResultSet *rs = [self.fmDataBase executeQuery:sql];
    
    while (rs.next) {
       totalDistance = [NSString stringWithFormat:@"%f",[rs doubleForColumn:@"distance"]];
        
    }
    
    return totalDistance;
}

-(FMDatabase *)fmDataBase{
    if (!_fmDataBase) {
       NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/health_date_table.db"];
        _fmDataBase = [FMDatabase databaseWithPath:path];
    }
    return _fmDataBase;
}


@end
