//
//  JKUserDefaults.m
//  jiankemall
//
//  Created by 郑喜荣 on 15/4/2.
//  Copyright (c) 2015年 jianke. All rights reserved.
//

#import "JKUserDefaults.h"


@interface JKUserDefaults()

@property (nonatomic, strong) NSUserDefaults *defaults;

@end

@implementation JKUserDefaults

static NSString * const kIsUsedApp = @"isUsedApp";
static NSString * const kStepDicKey = @"stepDic";
static NSString * const kNumberOfSongs = @"numberOfSongs";
static NSString * const kAllMusicNameArr = @"allMusicNameArr";
static NSString * const kBackgroundImageArr = @"backgroundImageArr";
static NSString * const kMaxStepCount = @"maxStepCount";

@synthesize isUsedApp = _isUsedApp;
@synthesize stepDic = _stepDic;
@synthesize numberOfSongs = _numberOfSongs;
@synthesize allMusicNameArr = _allMusicNameArr;
@synthesize backgroundImageArr = _backgroundImageArr;
@synthesize maxStepCount = _maxStepCount;



+ (instancetype)sharedInstance {
    static dispatch_once_t predicate;
    static JKUserDefaults *sharedInstance;
    
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}


-(BOOL)isUsedApp{
    if (!_isUsedApp) {
        _isUsedApp = [self.defaults boolForKey:kIsUsedApp];
    }
    
    return _isUsedApp;
}

-(void)setIsUsedApp:(BOOL)isFirstUseApp{
    _isUsedApp = isFirstUseApp;
    [self.defaults setBool:isFirstUseApp forKey:kIsUsedApp];
    [self.defaults synchronize];
}

-(NSDictionary *)stepDic{
    if (!_stepDic) {
        _stepDic = [self.defaults objectForKey:kStepDicKey];
    }
    return _stepDic;
}

-(void)setStepDic:(NSDictionary *)stepDic{
    _stepDic = stepDic;
    [self.defaults setObject:stepDic forKey:kStepDicKey];
    [self.defaults synchronize];
}

-(NSInteger)numberOfSongs{
    if (!_numberOfSongs) {
        _numberOfSongs = [self.defaults integerForKey:kNumberOfSongs];
    }
    return _numberOfSongs;
}

-(void)setNumberOfSongs:(NSInteger)numberOfSongs{
    _numberOfSongs = numberOfSongs;
    [self.defaults setInteger:numberOfSongs forKey:kNumberOfSongs];
    [self.defaults synchronize];
}

-(NSInteger)maxStepCount{
    if (!_maxStepCount) {
        _maxStepCount = [self.defaults integerForKey:kMaxStepCount];
    }
    return _maxStepCount;
}

-(void)setMaxStepCount:(NSInteger)maxStepCount{
    _maxStepCount = maxStepCount;
    [self.defaults setInteger:maxStepCount forKey:kMaxStepCount];
    [self.defaults synchronize];
}

-(NSArray *)allMusicNameArr{
    if (!_allMusicNameArr) {
        _allMusicNameArr = [NSArray arrayWithObjects:@"Test1.mp3",@"Test2.mp3",@"Test3.mp3",@"Test4.mp3",@"Test5.mp3",@"Test6.mp3",@"Test7.mp3",@"Test8.mp3",@"Test9.mp3",@"Test10.mp3",@"Test11.mp3",@"Test12.mp3",@"Test13.mp3",@"Test14.mp3",@"Test15.mp3",@"Test16.mp3",@"Test17.mp3",@"Test18.mp3",@"Test19.mp3",@"Test20.mp3",@"Test21.mp3",@"Test22.mp3", nil];
    }
    return _allMusicNameArr;
}

-(NSArray *)backgroundImageArr{
    if (!_backgroundImageArr) {
        _backgroundImageArr = [self.defaults objectForKey:kBackgroundImageArr];
        if (_backgroundImageArr.count>0) {
            
        }
        else{
            _backgroundImageArr = [NSArray arrayWithObjects:@"background", nil];
        }
    }
    return _backgroundImageArr;
}
-(void)setBackgroundImageArr:(NSArray *)backgroundImageArr{
    _backgroundImageArr = backgroundImageArr;
    [self.defaults setObject:backgroundImageArr forKey:kBackgroundImageArr];
    [self.defaults synchronize];
}

- (NSUserDefaults *)defaults {
    if (!_defaults){
        _defaults = [NSUserDefaults  standardUserDefaults];
    }
    return _defaults;
}
@end
