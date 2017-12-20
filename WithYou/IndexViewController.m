//
//  ViewController.m
//  WithYou
//
//  Created by jianke-mbp on 15/11/27.
//  Copyright © 2015年 少先队. All rights reserved.
//

#import "IndexViewController.h"
#import "EarthView.h"
#import "LittieWeatherView.h"
#import "WeatherView.h"
#import "WeatherCollectionView.h"
#import "mostImage.h"
#import <CoreLocation/CoreLocation.h>
#import "ProgressScrollView.h"
#import "RunningImageView.h"
#import "StepCountView.h"
#import "ADTickerLabel.h"
#import "OperateBtn.h"
#import "JKHealthDataFromM7.h"
#import "StepCountView.h"
#import "CatImageView.h"

#import "HoneyAndMeView.h"

//天气相关参数
#define weatherViewH 130
#define barViewH 20
#define weatherCollVY 65
//操作按钮相关参数
#define OperateBtnSpace 30
#define OperateBtnSpaceWidth 50
#define OperateBtnCenterY kScreenH-50
#define OperateBtnCenterX kScreenW-50

@interface IndexViewController ()<WeatherViewDelegate,CLLocationManagerDelegate,OperateBtnDelegate,UIScrollViewDelegate>


@property (nonatomic ,strong) UIScrollView *scrollView;
@property (nonatomic ,strong) UIImageView *wordImageView;
@property (nonatomic ,strong) CatImageView *catImageView;
/**
 *  控件
 */
@property (nonatomic, weak) WeatherView *weatherView;//天气View
@property (nonatomic, weak) LittieWeatherView *littleWeatherView;
@property (nonatomic, weak) WeatherCollectionView *weatherCollV;
@property (nonatomic, strong) ProgressScrollView *progress;
@property (nonatomic, strong) RunningImageView *runningGirl;
@property (nonatomic, strong) StepCountView *stepCountView;
@property (nonatomic, strong) UILabel *distanceLabel;

@property (nonatomic, strong) ADTickerLabel *tickerLabel;
@property (nonatomic, strong) EarthView *earthView;
@property (nonatomic, strong) OperateBtn *operateBtn1;
@property (nonatomic, strong) OperateBtn *operateBtn2;
@property (nonatomic, strong) OperateBtn *operateBtn3;

@property (nonatomic, strong) UIImageView *background;

@property (nonatomic, strong) UIView *shaddowView;
@property (nonatomic, strong) UIView *iconChangeView;
@property (strong, nonatomic) UIImagePickerController *imagePicker;

@property (nonatomic ,strong) HoneyAndMeView *honeyAndMeView;

/**
 *  数据
 */
@property (nonatomic, strong) NSDictionary *currentWeather;
@property (nonatomic, assign) BOOL isOpenOperateBtn;

/**
 *  工具
 */
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic ,strong) JKHealthDataFromM7 *healthDataFromM7;

@property (nonatomic ,assign) BOOL isNeedProgressAnimation;

@end

@implementation IndexViewController

- (void) viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    self.isNeedProgressAnimation = YES;

    self.view.backgroundColor = [UIColor colorWithRed:1 green:0.92 blue:1 alpha:1];
    //隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    //进入后台事的远程控制事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    //获取最近7天运动协调处理器的运动数据
    [self.healthDataFromM7 createDB];
    
    //更新总进度
    [self updateTotalProgress];
    
    //注册通知
    
    NSNotificationCenter *center1 = [NSNotificationCenter defaultCenter];
    [center1 addObserver:self selector:@selector(removeEarth) name:@"removeEarth" object:nil];
    NSNotificationCenter *center2 = [NSNotificationCenter defaultCenter];
    [center2 addObserver:self selector:@selector(startEarth) name:@"setUpEarth" object:nil];
}

-(void)removeEarth{
    
    self.earthView.isStopLoop = YES;
}

-(void)startEarth{
    self.earthView.isStopLoop = NO;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self deleteBack];
    
    [self setUpScrollview];
    //设置背景
    [self setUpBackgroundImage];
    //设置天气View
//    [self setupWeatherView];
    //获取当前位置
    [self requestCurrentLocation];
    //设置进度
    [self setUpProgressView];
    //设置地球
    [self setUpEarthView];
    //设置步数视图
    [self setUpStepCountView];
    //设置奔跑动画
//    [self setUpRunningImageView];
    //设置操作按钮
    [self setUpOperateBtns];
    //是否允许使用m7
    [self isAllowUseM7];
}

-(void)setUpScrollview{
    //设置scrollview后的背景
    [self setDeepBackground];
    
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.contentSize = CGSizeMake(kScreenW, kScreenH+1);
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
}

-(void)setDeepBackground{
    self.wordImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, kScreenH, kScreenW, 230)];
    [self.view addSubview:self.wordImageView];
    
//    NSArray *imageArr = [[NSArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16", nil];
//    CatImageView *catImageView = [[CatImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 393/(700/kScreenW)) andImageNameArr:imageArr andAnimationDuration:3];
//    [self.view addSubview:catImageView];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSLog(@"%f",scrollView.contentOffset.y);
    
    if (scrollView.contentOffset.y < 0) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }else{
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    }
    
    
    if (scrollView.contentOffset.y< -kScreenH/2.0) {
        self.wordImageView.image = [UIImage imageNamed:@"me.jpg"];
        CGFloat y = scrollView.contentOffset.y+kScreenH/2.0;
        
        self.wordImageView.frame = CGRectMake(0, kScreenH/2.0 +y, kScreenW, 230);
    }else{
        self.wordImageView.image = [UIImage imageNamed:@""];
    }
}

/**
 *  是否允许使用M7
 */
-(void)isAllowUseM7{
    __weak typeof(self) weakSelf = self;
    [self.healthDataFromM7 requestStepCountAndDistanceWithDays:1 and:^(NSArray *result,NSError *error,NSArray *startTimeArr) {
        // 如果允许
        if (error == nil) {
            
            [self getStepData];
            
        }else if(error.code == 105){
            
            dispatch_async(dispatch_get_main_queue(), ^{

                [weakSelf showAlert];
            });
            
        }else{
            
            NSLog(@"%@",error);
            
        }
    }];
}

-(void)showAlert{
    NSString *msg = @"糟糕~您忘记打开运动与健康权限~去设置吧~.~";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"授权"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"知道了"
                                          otherButtonTitles:@"去设置", nil];
    [alert show];
}

-(void)getStepData{
    __weak typeof(self) weakSelf = self;
    [self.healthDataFromM7 requestStepCountAndDistanceWithDays:7 and:^(NSArray *result,NSError *error,NSArray *startTimeArr) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        //遍历M7接口中最近7天的日期
        for (int i = 0; i < startTimeArr.count; i++) {
            //查询数据库中是否有该日期的相关数据（有，则忽略；无，则插入改天的记录）
            HealthDateModel *healthDataModel = [[HealthDateModel alloc]init];
            healthDataModel.date = [dateFormatter stringFromDate:startTimeArr[i]];
            healthDataModel.stepCount = result[i][@"stepCount"];
            healthDataModel.distance = result[i][@"distance"];
            //获取maxStepCount
            NSInteger maxStepCount = [JKUserDefaults sharedInstance].maxStepCount;
            if (maxStepCount<[healthDataModel.stepCount integerValue]) {
                [JKUserDefaults sharedInstance].maxStepCount = [healthDataModel.stepCount integerValue];
                self.stepCountView.maxStepCount = healthDataModel.stepCount;
            }
            [weakSelf.healthDataFromM7 saveHealthDataWithHealthDateModel:healthDataModel];
        }
        

        //通过M7的接口，实时更新当天数据
        [weakSelf.healthDataFromM7 requestImmediateStepCount:^(NSInteger numberOfSteps, NSDate *timestamp,NSError *error) {
            
            [weakSelf.healthDataFromM7 requestStepCountAndDistanceWithDays:1 and:^(NSArray *result, NSError *error, NSArray *startTimeArr) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //步数
                    [weakSelf changeStepCountViewWithStepCount:[[result lastObject][@"stepCount"] intValue]];
                    
                    if ([JKUserDefaults sharedInstance].maxStepCount < [[result lastObject][@"stepCount"] integerValue]) {
                        
                        [JKUserDefaults sharedInstance].maxStepCount = [[result lastObject][@"stepCount"] integerValue];
//                        self.stepCountView.percent = @"1";
                        
                        [self.stepCountView setPercent:@"1" animation:weakSelf.isNeedProgressAnimation];
                        self.isNeedProgressAnimation = NO;
                        
                    }else{
                        
                        double percent = [[result lastObject][@"stepCount"] doubleValue]/[[NSString stringWithFormat:@"%ld",(long)[JKUserDefaults sharedInstance].maxStepCount] doubleValue];
                        NSString *percentStr = [NSString stringWithFormat:@"%f",percent];
                        
                        
                        [weakSelf.stepCountView setPercent:percentStr animation:weakSelf.isNeedProgressAnimation];
                        weakSelf.isNeedProgressAnimation = NO;
                        
                    }
                    
                    weakSelf.tickerLabel.text = [NSString stringWithFormat:@"%@",[result lastObject][@"stepCount"]];
                    //路程
                    float distance = [[result lastObject][@"distance"] floatValue]/1000;
                    weakSelf.distanceLabel.text = [NSString stringWithFormat:@"😱 ≈ %.2f公里",distance];
                    weakSelf.tickerLabel.changeTextAnimationDuration = 0.3;
                    
                });
                
            }];
            
        }];
    }];
}

-(void)setUpBackgroundImage{
    self.background = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH+2)];
    if ([JKUserDefaults sharedInstance].backgroundImageArr.count>1) {
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *documentsDirectory=[paths objectAtIndex:0];
        //创建一个文件夹保存背景图片
        NSString *documentPath = [documentsDirectory  stringByAppendingPathComponent:@"BackgroundImage"];
        
        NSString *savedImagePath=[documentPath stringByAppendingPathComponent:[JKUserDefaults sharedInstance].backgroundImageArr.lastObject];
        
        NSData *imageDate = [NSData dataWithContentsOfFile:savedImagePath];
        
        self.background.image = [UIImage imageWithData:imageDate];
        
    }else{
        self.background.image = [UIImage imageNamed:@"background"];
    }
    [self.scrollView addSubview:self.background];
}

//-(void)deleteBack{
//    
//    for (int i = 0; i< [JKUserDefaults sharedInstance].backgroundImageArr.count; i++) {
//     
//        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//        NSString *documentsDirectory=[paths objectAtIndex:0];
//        //创建一个文件夹保存背景图片
//        NSString *documentPath = [documentsDirectory  stringByAppendingPathComponent:@"BackgroundImage"];
//        
//        NSString *savedImagePath=[documentPath stringByAppendingPathComponent:[JKUserDefaults sharedInstance].backgroundImageArr.lastObject];
//        NSFileManager *fileManager = [[NSFileManager alloc]init];
//        
//        [fileManager removeItemAtPath:savedImagePath error:nil];
//    }
//}

-(void)setUpOperateBtns{
    
    CGPoint defaultCenter = CGPointMake(OperateBtnCenterX, OperateBtnCenterY);
    
    self.operateBtn1 = [[OperateBtn alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.operateBtn1.center = defaultCenter;
    [self.operateBtn1 setTitle:@"循环" forState:UIControlStateNormal];
    self.operateBtn1.titleLabel.font = [UIFont systemFontOfSize:12];
    self.operateBtn1.delegate = self;
    self.operateBtn1.tag = 1;
    [self.scrollView addSubview:self.operateBtn1];
    
    self.operateBtn2 = [[OperateBtn alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.operateBtn2.center = defaultCenter;
    self.operateBtn2.delegate = self;
    [self.operateBtn2 setTitle:@"2" forState:UIControlStateNormal];
    self.operateBtn2.tag = 2;
    [self.scrollView addSubview:self.operateBtn2];
    
    self.operateBtn3 = [[OperateBtn alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.operateBtn3.center = defaultCenter;
    self.operateBtn3.delegate = self;
    [self.operateBtn3 setTitle:@"背景" forState:UIControlStateNormal];
    self.operateBtn3.titleLabel.font = [UIFont systemFontOfSize:12];
    self.operateBtn3.tag = 3;
    [self.scrollView addSubview:self.operateBtn3];
    self.isOpenOperateBtn = NO;
}

-(void)setUpStepCountView{
    
    //步数
    UIFont *font = [UIFont boldSystemFontOfSize: 50];
    self.tickerLabel = [[ADTickerLabel alloc] initWithFrame: CGRectMake(0, 0, 0, font.lineHeight+200)];
    self.tickerLabel.font = font;
    self.tickerLabel.characterWidth = 30;
    self.tickerLabel.changeTextAnimationDuration = 3;
//    self.tickerLabel.textColor = [ReuseTool colorWithHexString:@"1dca9f"];
    self.tickerLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
    self.tickerLabel.alpha = 1;
    self.tickerLabel.backgroundColor = [UIColor redColor];
    [self.scrollView addSubview: self.tickerLabel];
    //约束
    [self.tickerLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.scrollView withOffset:-98];
    
    //进度
    self.stepCountView = [[StepCountView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    self.stepCountView.center = CGPointMake(kScreenW/2.0, 265);
    [self.scrollView addSubview:self.stepCountView];
    
    //路程
    self.distanceLabel = [[UILabel alloc]init];
    self.distanceLabel.textAlignment = NSTextAlignmentCenter;
    self.distanceLabel.font = [UIFont systemFontOfSize:18];
//    self.distanceLabel.textColor = [ReuseTool colorWithHexString:@"ACADAE"];
    self.distanceLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
    self.distanceLabel.text = @"😱 ≈ 10.3公里";
    [self.scrollView addSubview:self.distanceLabel];
    //约束
    [self.distanceLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.distanceLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.stepCountView withOffset:20];
    [self.distanceLabel autoSetDimensionsToSize:CGSizeMake(200, 21)];
    

}

-(void)changeStepCountViewWithStepCount:(int)stepCount{
    
    if (stepCount < 10) {
        [self setStepCountViewContractWithOffset:30/2.0];
    }
    
    if (stepCount >=10 && stepCount<100) {
        [self setStepCountViewContractWithOffset:30 * 2 / 2.0];
    }
    
    if (stepCount >=100 && stepCount<1000) {
        [self setStepCountViewContractWithOffset:30 * 3 / 2.0];
    }
    
    if (stepCount >=1000 && stepCount<10000) {
        [self setStepCountViewContractWithOffset:30 * 4 / 2.0];
    }
    
    if (stepCount >=10000 && stepCount<100000) {
        [self setStepCountViewContractWithOffset:30 * 5 / 2.0];
    }
    
    if (stepCount >=100000 && stepCount<1000000) {
        [self setStepCountViewContractWithOffset:30 * 6 / 2.0];
    }
    
    
}
-(void)setStepCountViewContractWithOffset:(CGFloat)offset{
    [self.tickerLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view withOffset:- offset];
}


-(void)setUpRunningImageView{
//    self.runningGirl = [[RunningImageView alloc]initWithFrame:CGRectMake(10, 200, 101, 95) andSexType:SexTypeGirl andAnimationDuration:1];
//    [self.view addSubview:self.runningGirl];
    
    self.honeyAndMeView = [[HoneyAndMeView alloc]initWithFrame:CGRectMake(0, kScreenH - 210 - 60 + 15, kScreenW, 60)];
    [self.scrollView addSubview:self.honeyAndMeView];
}

-(void)setUpEarthView{
    
    self.earthView = [[EarthView alloc]initWithFrame:CGRectMake(kScreenW - 100 - 10, kScreenH - 100 - 10, 100, 100)];
    [self.scrollView addSubview:self.earthView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click)];
    [self.earthView addGestureRecognizer:tap];
}

-(void)setUpProgressView{
    
//    self.progress.totalDistance = @"0";
    self.progress.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:self.progress];
}

-(void)updateTotalProgress{
    self.progress.totalDistance = [self.healthDataFromM7 getTotalDistance];
}

-(void)setupWeatherView {
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WeatherView" owner:self options:nil];
    WeatherView *weatherView = [nib objectAtIndex:0];
    weatherView.delegate = self;
    weatherView.frame = CGRectMake(0, barViewH, self.view.bounds.size.width, weatherViewH);
    [self.scrollView addSubview:weatherView];
    self.weatherView = weatherView;
    
    CGFloat jiange = 10;
    CGFloat weatherCollVW = kScreenW - 2*jiange;
    CGFloat weatherCollVH = weatherViewH - weatherCollVY;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0.01;
    layout.minimumLineSpacing = 0.01;
    
    layout.itemSize = CGSizeMake(weatherCollVW / 3.0 , weatherCollVH);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    WeatherCollectionView *weatherCollV = [[WeatherCollectionView alloc] initWithFrame:CGRectMake(jiange, weatherCollVY, weatherCollVW, weatherCollVH) collectionViewLayout:layout];
    [weatherView addSubview:weatherCollV];
    self.weatherCollV = weatherCollV;
}

#pragma mark 读取天气数据
-(void) requestLocalWeatherData:(CLLocation *)currentLocation {
    
    NSString *weatherUrl = [NSString stringWithFormat:@"http://api.map.baidu.com/telematics/v3/weather"];
    NSString *location = [NSString stringWithFormat:@"%f,%f",currentLocation.coordinate.longitude,currentLocation.coordinate.latitude];
    NSDictionary *weatherDict = @{@"location":location, @"output": @"json", @"ak":kBaiDuAK, @"mcode":@"com.xiaobing.WithYou"};
        [HttpTool getWithURL:weatherUrl params:weatherDict success:^(id json) {
            self.currentWeather = json[@"results"][0];
            self.weatherView.weatherDict = self.currentWeather;
            self.weatherCollV.weatherDict = self.currentWeather;
            
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            
        }];
    }

#pragma mark 获取当前城市
-(void) requestCurrentLocation {

    self.locationManager = [[CLLocationManager alloc] init];
    if ([[JKSystemHelper systemVersion] doubleValue] >= 8.0) {
        [self.locationManager requestAlwaysAuthorization];
    }
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}

#pragma mark 获取地址成功
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *location = locations[0];
    [self requestLocalWeatherData:location];
    [self.locationManager stopUpdatingLocation];
}

#pragma mark 获取地址失败
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
    [self.locationManager stopUpdatingLocation];
    
}
/**
 *  获取当前城市
 *
 *  @param currentLocation 当前经纬度
 */
-(void)getcurrentCity:(CLLocation *)currentLocation{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count > 0) {
            //                CLPlacemark *placeMark  = [placemarks firstObject];
            //                self.city = [placeMark.addressDictionary objectForKey:@"City"];
            //                [self requestWeatherData];
        } else {
            //                [self.loading hide];
        }
    }];
}

#pragma mark 点击地点
-(void)WeatherViewCityViewTap:(WeatherView *)weatherView{
    NSLog(@"cityView");
}
#pragma mark 点击刷新
-(void)WeatherViewRefreshViewTap:(WeatherView *)weatherView{
    
    [self.locationManager startUpdatingLocation];
}

-(void)click{
    
    if (self.isOpenOperateBtn) {
        
        [self closeOperateBtn];
    }else{
        
        [self openOperateBtn];
    }
}

-(void)openOperateBtn{
    [UIView animateWithDuration:1 animations:^{
        self.operateBtn1.center = CGPointMake(OperateBtnSpace+OperateBtnSpaceWidth/2.0, OperateBtnCenterY);
        self.operateBtn1.alpha = 1;
        self.operateBtn2.center = CGPointMake(2 * OperateBtnSpace+OperateBtnSpaceWidth/2.0 * 3, OperateBtnCenterY);
        self.operateBtn2.alpha = 1;
        self.operateBtn3.center = CGPointMake(3 * OperateBtnSpace+OperateBtnSpaceWidth/2.0 * 5, OperateBtnCenterY);
        self.operateBtn3.alpha = 1;
    }];
    self.isOpenOperateBtn = !self.isOpenOperateBtn;
}

-(void)closeOperateBtn{
    CGPoint defaultCenter = CGPointMake(OperateBtnCenterX, OperateBtnCenterY);
    [UIView animateWithDuration:0.5 animations:^{
        self.operateBtn1.center = defaultCenter;
        self.operateBtn1.alpha = 0;
        
        self.operateBtn2.center = defaultCenter;
        self.operateBtn2.alpha = 0;
        
        self.operateBtn3.center = defaultCenter;
        self.operateBtn3.alpha = 0;
    }];
    self.isOpenOperateBtn = !self.isOpenOperateBtn;
}

-(void)operateBtnClick:(OperateBtn *)operateBtn{
    //收回操作按钮
    [self closeOperateBtn];
    //通过tag做不同的响应操作
    NSInteger tag = operateBtn.tag;
    switch (tag) {
        case 1:
        {
            [self.progress playAllUnlockMusic];
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            [self changeBackground];
        }
            break;
            
        default:
            break;
    }
}

-(NSDictionary *)currentWeather {
    if (!_currentWeather) {
        _currentWeather = [NSDictionary dictionary];
    }
    return _currentWeather;
}

-(JKHealthDataFromM7 *)healthDataFromM7{
    if (!_healthDataFromM7) {
        _healthDataFromM7 = [[JKHealthDataFromM7 alloc]init];
    }
    return _healthDataFromM7;
}

#pragma mark -进入后台时的远程控制事件





- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        switch (receivedEvent.subtype) {
                
            case UIEventSubtypeRemoteControlTogglePlayPause:
                //                [self playAndStopSong:self.playButton];
                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack:
                //                [self playLastButton:self.lastButton];
                break;
                
            case UIEventSubtypeRemoteControlNextTrack:
                //                [self playNextSong:self.nextButton];
                break;
                
            case UIEventSubtypeRemoteControlPlay:
                //                [self playAndStopSong:self.playButton];
                break;
                
            case UIEventSubtypeRemoteControlPause:
                //                [self playAndStopSong:self.playButton];
                break;
                
            default:
                break;
        }
    }
}


#pragma mark -- 选取背景

#pragma mark 头像点击方法
-(void)changeBackground
{
    //直接修改照片
    UIView *shaddowView = [[UIView alloc] init];
    shaddowView.frame = self.view.bounds;
    shaddowView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.7];
    [shaddowView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shaddowViewTap)]];
    self.shaddowView = shaddowView;
    [self.view addSubview:shaddowView];
    
    UIView *iconChangeView = [[UIView alloc] init];
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    iconChangeView.frame = CGRectMake(screenW * 0.15, -screenH * 0.25 , screenW * 0.7, screenH * 0.25);
    iconChangeView.backgroundColor = [UIColor whiteColor];
    iconChangeView.layer.cornerRadius = 5;
    iconChangeView.layer.masksToBounds = YES;
    [self.view addSubview:iconChangeView];
    self.iconChangeView = iconChangeView;
    
    UILabel *iconChangeViewLable = [[UILabel alloc] init];
    iconChangeViewLable.frame = CGRectMake(0, 0, iconChangeView.frame.size.width, iconChangeView.frame.size.height * 0.2);
    iconChangeViewLable.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    iconChangeViewLable.text = @"更改背景";
    iconChangeView.alpha = 0.8;
    iconChangeViewLable.textAlignment = NSTextAlignmentCenter;
    iconChangeViewLable.font = [UIFont systemFontOfSize:12];
    iconChangeViewLable.textColor = [UIColor grayColor];
    [iconChangeView addSubview:iconChangeViewLable];
    
    UIView *cameraView = [[UIView alloc] init];
    cameraView.frame = CGRectMake(iconChangeView.frame.size.width * 0.15, iconChangeView.frame.size.height * 0.35,iconChangeView.frame.size.width * 0.25, iconChangeView.frame.size.height * 0.6);
    cameraView.backgroundColor = [UIColor clearColor];
    cameraView.userInteractionEnabled = YES;
    [cameraView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openCamera)]];
    
    UIView *picsView = [[UIView alloc] init];
    picsView.frame = CGRectMake(iconChangeView.frame.size.width * 0.6, iconChangeView.frame.size.height * 0.35,iconChangeView.frame.size.width * 0.25, iconChangeView.frame.size.height * 0.6);
    picsView.backgroundColor = [UIColor clearColor];
    picsView.userInteractionEnabled = YES;
    [picsView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openPics)]];
    
    UIImageView *cameraImage = [[UIImageView alloc] init];
    cameraImage.image = [UIImage imageNamed:@"accout_camera"];
    cameraImage.layer.cornerRadius = 5;
    cameraImage.layer.masksToBounds = YES;
    cameraImage.frame = CGRectMake(0, 0, cameraView.frame.size.width, cameraView.frame.size.width);
    [cameraView addSubview:cameraImage];
    
    UILabel *cameraLable = [[UILabel alloc] init];
    cameraLable.frame = CGRectMake(0, cameraView.frame.size.width, cameraView.frame.size.width, cameraView.frame.size.height - cameraView.frame.size.width);
    cameraLable.text = @"拍照";
    cameraLable.font = [UIFont systemFontOfSize:12];
    cameraLable.textColor = [UIColor grayColor];
    cameraLable.textAlignment = NSTextAlignmentCenter;
    [cameraView addSubview:cameraLable];
    
    UIImageView *picsImage = [[UIImageView alloc] init];
    picsImage.image = [UIImage imageNamed:@"accout_pics"];
    picsImage.layer.cornerRadius = 5;
    picsImage.layer.masksToBounds = YES;
    picsImage.frame = CGRectMake(0, 0, picsView.frame.size.width, picsView.frame.size.width);
    [picsView addSubview:picsImage];
    
    UILabel *picsLable = [[UILabel alloc] init];
    picsLable.frame = CGRectMake(0, cameraView.frame.size.width, picsView.frame.size.width, picsView.frame.size.height - picsView.frame.size.width);
    picsLable.text = @"相册";
    picsLable.font = [UIFont systemFontOfSize:12];
    picsLable.textColor = [UIColor grayColor];
    picsLable.textAlignment = NSTextAlignmentCenter;
    [picsView addSubview:picsLable];
    
    
    [iconChangeView addSubview:cameraView];
    [iconChangeView addSubview:picsView];
    
    [UIImageView animateWithDuration:0.3 animations:^{
        iconChangeView.frame = CGRectMake(screenW * 0.15, screenH * 0.4 , screenW * 0.7, screenH * 0.25);
    }];
    
}

-(void)shaddowViewTap
{
    [self.shaddowView removeFromSuperview];
    [self.iconChangeView removeFromSuperview];
}

// 打开相机
- (void)openCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        if (self.imagePicker == nil) {
            self.imagePicker =  [[UIImagePickerController alloc] init];
        }
        self.imagePicker.delegate = (id)self;
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        self.imagePicker.showsCameraControls = YES;
//        self.imagePicker.allowsEditing = YES;
        [self.navigationController presentViewController:self.imagePicker animated:YES completion:nil];
    }
}

// 打开相册
- (void)openPics {
    if (self.imagePicker == nil) {
        self.imagePicker = [[UIImagePickerController alloc] init];
    }
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    self.imagePicker.allowsEditing = YES;
    self.imagePicker.delegate = (id)self;
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
}

// 选中照片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    [self.imagePicker dismissViewControllerAnimated:YES completion:NULL];
    self.imagePicker = nil;
    
    [self shaddowViewTap];
    
    // 判断获取类型：图片
    if ([mediaType isEqualToString:@"public.image"]){
        UIImage *theImage = nil;
        
        // 判断，图片是否允许修改
        if ([picker allowsEditing]){
            //获取用户编辑之后的图像
            theImage = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            // 照片的元数据参数
            theImage = [info objectForKey:UIImagePickerControllerOriginalImage] ;
        }
        
        theImage = [self scaleImage:theImage toScale:0.5];

        self.background.image = theImage;
        //将背景图片保存到沙盒中
        [self keepBackgroundImage:theImage];
 
    }
}

-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

// 判断设备是否有摄像头
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

#pragma mark - 相册文件选取相关
// 相册是否可用
- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma mark -- 将背景图片保存在沙盒中

-(void)keepBackgroundImage:(UIImage *)image{
    NSData *imagedata=UIImagePNGRepresentation(image);
    //获取沙盒路径
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];
    //创建一个文件夹保存背景图片
    NSString *documentPath = [documentsDirectory  stringByAppendingPathComponent:@"BackgroundImage"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDirectory ;
    
    BOOL isExist = [fileManager fileExistsAtPath:documentPath isDirectory:&isDirectory];
    
    if (!isExist) {
        [fileManager createDirectoryAtPath:documentPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    //不保存之前的背景
    if ([JKUserDefaults sharedInstance].backgroundImageArr.count >1) {
        
        [fileManager removeItemAtPath:[documentPath stringByAppendingPathComponent:[[JKUserDefaults sharedInstance].backgroundImageArr lastObject]] error:nil];
        
        [JKUserDefaults sharedInstance].backgroundImageArr = nil;
    }
    
//    NSInteger count = [JKUserDefaults sharedInstance].backgroundImageArr.count;
    //设置新背景图名字
    NSString *newBackgroundImageName = [NSString stringWithFormat:@"background%d.png",2];
    
    NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:[JKUserDefaults sharedInstance].backgroundImageArr];
    [arr addObject:newBackgroundImageName];
    
    [JKUserDefaults sharedInstance].backgroundImageArr = [[NSArray alloc]initWithArray:arr];
    
    NSString *savedImagePath=[documentPath stringByAppendingPathComponent:newBackgroundImageName];
    
    [imagedata writeToFile:savedImagePath atomically:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -- 懒加载

-(ProgressScrollView *)progress{
    if (!_progress) {
        _progress = [[ProgressScrollView alloc]initWithFrame:CGRectMake(0, kScreenH - 210, kScreenW, 100)];
    }
    return _progress;
}

@end
