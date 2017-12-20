//
//  GuidePageVC.m
//  WithYou
//
//  Created by jianke-mbp on 16/2/22.
//  Copyright © 2016年 少先队. All rights reserved.
//

#import "GuidePageVC.h"
#import "MusicTool.h"
#import "ProgressBtn.h"

#import "NeedDrawView.h"


#import "IndexViewController.h"

@interface GuidePageVC ()<UIScrollViewDelegate,ProgressBtnDelegate>

@property(nonatomic ,strong) UIImageView *bgImageView;
@property(nonatomic ,strong) UIScrollView *scrollView;
@property(nonatomic ,strong) ProgressBtn *progressBtn;
@property(nonatomic ,assign) double totalTime;//音乐总时间长度
@property(nonatomic ,assign) double playTime;//已播放时间
@property(nonatomic ,strong) NSTimer *progressTimer;
@property (nonatomic ,strong) MusicTool *musicTool;

@property (nonatomic ,strong) NeedDrawView *pathBuilderView;

@property (nonatomic ,strong) NSMutableArray *allWordsArr;

@property (nonatomic ,assign) int flag;

@property (nonatomic ,assign) BOOL isShowUseBtn;

@end

@implementation GuidePageVC

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}
-(void)viewDidDisappear:(BOOL)animated{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
    [self.musicTool stopMusic];
    [self.pathBuilderView setData:nil andTitieFlag:-1];
    
    [self.bgImageView removeFromSuperview];
    self.bgImageView = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotice:) name:@"finishSay" object:nil];

    [self setUpBackground:@"background"];
    
    [self setUpSnow];
    
    [self setUpFire];
    
    [self setUpProgressBtn];
    
    [self startBackgroundMusic];
    
    [self SetUpWritableBoard];
    
//    [self setUpScrollView];
}

-(void)getNotice:(NSNotification *)notice{
    
    _flag = [notice.userInfo[@"flag"] intValue];
    
    if ([self.musicTool isPlaying]) {
        
        if (_flag < self.allWordsArr.count) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.pathBuilderView setData:self.allWordsArr[_flag] andTitieFlag:_flag];
            });
        }
    }
}

-(void)SetUpWritableBoard{
    
    
    
    self.pathBuilderView = [[NeedDrawView alloc] initWithFrame:CGRectMake(kScreenW / 2.0 + 60, 50, kScreenW / 2.0 - 60, kScreenH - 50)];
    self.pathBuilderView.contentMode =UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.pathBuilderView];
    [self.pathBuilderView setData:self.allWordsArr[0] andTitieFlag:0];
}

-(void)startBackgroundMusic{
    [self.musicTool playMusicWith:@"guidePage.mp3"];
    [self.progressBtn setSelected:NO];
    self.totalTime = self.musicTool.totalTime;
    self.playTime = self.musicTool.currentTime;
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
}

-(void)setUpProgressBtn{
    
    self.progressBtn = [[ProgressBtn alloc]initWithFrame:CGRectMake(20, kScreenH - 56 -20, 56, 56)];
    self.progressBtn.delegate = self;
    [self.view addSubview:self.progressBtn];
}
                          
                          
-(void)updateProgress{
    
    self.playTime = self.musicTool.currentTime;
    
    self.progressBtn.percent = self.playTime/self.totalTime;
    
    
    if (![self.musicTool isPlaying]) {
        
        if (!self.isShowUseBtn) {
            
            self.isShowUseBtn = !self.isShowUseBtn;
            [self showButton];
            [JKUserDefaults sharedInstance].isUsedApp = YES;
        }
        
        _flag = -1;
        self.progressTimer.fireDate = [NSDate distantFuture];
        [self.progressBtn setSelected:YES];
        self.progressBtn.percent = 1.0;
    }
}

-(void)showButton{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    
    [button addTarget:self action:@selector(goToIndexVC) forControlEvents:UIControlEventTouchUpInside];
    button.center = CGPointMake(kScreenW / 2.0, kScreenH + button.frame.size.height / 2.0);
    button.layer.cornerRadius = 5;
    button.alpha = 0.8;
    button.backgroundColor = [ReuseTool colorWithHexString:@"0ea7ff"];
    [button setTitle:@"立即使用" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    [UIView animateWithDuration:1.5 animations:^{
        button.center = CGPointMake(kScreenW / 2.0, kScreenH - 30 - button.frame.size.height / 2.0);
    }];
}

-(void)goToIndexVC{
    
    IndexViewController *indexVC = [[IndexViewController alloc]init];
    [self presentViewController:indexVC animated:YES completion:nil];
}


-(void)setUpScrollView{
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    self.scrollView.delegate = self;
    
    self.scrollView.contentSize = CGSizeMake(kScreenW * 4, kScreenH);
    self.scrollView.backgroundColor = [UIColor yellowColor];
    self.scrollView.alpha = 0.5;
    
    [self.view addSubview:self.scrollView];
}


-(void)setUpBackground:(NSString *)imageName{
    
    [self.bgImageView removeFromSuperview];
    
    self.bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(-1, -1, kScreenW+2, kScreenH+2)];

    self.bgImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@".png"]];

    [self.view addSubview:self.bgImageView];
    
}


#pragma mark - ProgressBtnDelegate

-(void)progressBtnClick:(ProgressBtn *)progressBtn{
    if (!progressBtn.isSelected) {
        self.playTime = self.musicTool.currentTime;
        [self musicPause];
        self.pathBuilderView.timer.fireDate = [NSDate distantFuture];
        self.progressTimer.fireDate = [NSDate distantFuture];
    }else{
        [self musicGoOn];
        
        if (_flag == -1) {
            _flag = 0;
            [self.pathBuilderView setData:self.allWordsArr[_flag] andTitieFlag:_flag];
        }
        
        self.pathBuilderView.timer.fireDate = [NSDate distantPast];
        self.progressTimer.fireDate = [NSDate distantPast];
    }
    
    [progressBtn setSelected:!progressBtn.isSelected];
}
-(void)musicPause{
    [self.musicTool pausePlayer];
}

-(void)musicGoOn{
    [self.musicTool playPlayer];
}

-(void)setUpSnow{
    // Configure the particle emitter to the top edge of the screen
    CAEmitterLayer *snowEmitter = [CAEmitterLayer layer];
    snowEmitter.emitterPosition = CGPointMake(self.view.bounds.size.width / 2.0, -30);
    snowEmitter.emitterSize		= CGSizeMake(self.view.bounds.size.width * 2.0, 0.0);;
    
    // Spawn points for the flakes are within on the outline of the line
    snowEmitter.emitterMode		= kCAEmitterLayerOutline;
    snowEmitter.emitterShape	= kCAEmitterLayerLine;
    
    // Configure the snowflake emitter cell
    CAEmitterCell *snowflake = [CAEmitterCell emitterCell];
    
    //    随机颗粒的大小
    snowflake.scale = 0.2;
    snowflake.scaleRange = 0.5;
    
    //    缩放比列速度
    //        snowflake.scaleSpeed = 0.1;
    
    //    粒子参数的速度乘数因子；
    snowflake.birthRate		= 5.0;
    
    //生命周期
    snowflake.lifetime		= 30.0;
    
    //    粒子速度
    snowflake.velocity		= 10;				// falling down slowly
    snowflake.velocityRange = 10;
    //    粒子y方向的加速度分量
    snowflake.yAcceleration = 2;
    snowflake.xAcceleration = -1.5;
    snowflake.zAcceleration = -2;
    
    //    周围发射角度
    snowflake.emissionRange = 0.5 * M_PI;		// some variation in angle
    //    自动旋转
    snowflake.spinRange		= 0.25 * M_PI;		// slow spin
    
    snowflake.contents		= (id) [[UIImage imageNamed:@"snow"] CGImage];
    snowflake.color			= [[UIColor colorWithRed:0.600 green:0.658 blue:0.743 alpha:1.000] CGColor];
    
    // Make the flakes seem inset in the background
    snowEmitter.shadowOpacity = 1.0;
    snowEmitter.shadowRadius  = 0.0;
    snowEmitter.shadowOffset  = CGSizeMake(0.0, 1.0);
    snowEmitter.shadowColor   = [[UIColor whiteColor] CGColor];
    
    // Add everything to our backing layer below the UIContol defined in the storyboard
    snowEmitter.emitterCells = [NSArray arrayWithObject:snowflake];
    [self.view.layer addSublayer:snowEmitter];
}

-(void)setUpFire{
        // Cells spawn in the bottom, moving up
    CAEmitterLayer *fireworksEmitter = [CAEmitterLayer layer];
    CGRect viewBounds = self.view.layer.bounds;
    fireworksEmitter.emitterPosition = CGPointMake(viewBounds.size.width/2.0, viewBounds.size.height);
    fireworksEmitter.emitterSize	= CGSizeMake(viewBounds.size.width/2.0, 0.0);
    fireworksEmitter.emitterMode	= kCAEmitterLayerOutline;
    fireworksEmitter.emitterShape	= kCAEmitterLayerLine;
    fireworksEmitter.renderMode		= kCAEmitterLayerAdditive;
    fireworksEmitter.seed = (arc4random()%100)+1;
    
        // Create the rocket
    CAEmitterCell* rocket = [CAEmitterCell emitterCell];
    rocket.birthRate		= 3.0;
    rocket.emissionRange	= 0.1 * M_PI;  // some variation in angle
    rocket.velocity			= kScreenH-200;
    rocket.velocityRange	= kScreenH-300;
    rocket.yAcceleration	= 55;
    rocket.lifetime			= 1.02;	// we cannot set the birthrate < 1.0 for the burst
    
    rocket.contents			= (id) [[UIImage imageNamed:@"ball"] CGImage];
    rocket.scale			= 0.2;
    //    rocket.color			= [[UIColor colorWithRed:1 green:0 blue:0 alpha:1] CGColor];
    rocket.greenRange		= 1.0;		// different colors
    rocket.redRange			= 1.0;
    rocket.blueRange		= 1.0;
    
    
    CAEmitterCell* burst = [CAEmitterCell emitterCell];
    
    burst.birthRate			= 1.0;		// at the end of travel
    burst.velocity			= 0;
    burst.scale				= 2.5;
    burst.redSpeed			=-1.5;		// shifting
    burst.blueSpeed			=+1.5;		// shifting
    burst.greenSpeed		=+1.0;		// shifting
    burst.lifetime			= 0.35;
    
    
    CAEmitterCell* spark = [CAEmitterCell emitterCell];
    
    spark.birthRate			= 400;
    spark.velocity			= 125;
    spark.emissionRange		= 2* M_PI;	// 360 deg
    spark.yAcceleration		= 75;		// gravity
    spark.lifetime			= 60;
    
    spark.contents			= (id) [[UIImage imageNamed:@"fire"] CGImage];
    spark.scale		        =0.5;
    spark.scaleSpeed		=-0.2;
    spark.greenSpeed		=-0.1;
    spark.redSpeed			= 0.4;
    spark.blueSpeed			=-0.1;
    spark.alphaSpeed		=-0.5;
    spark.spin				= 2 * M_PI;
    spark.spinRange			= 2 * M_PI;
    
    fireworksEmitter.emitterCells = [NSArray arrayWithObject:rocket];
    rocket.emitterCells	= [NSArray arrayWithObject:burst];
    burst.emitterCells = [NSArray arrayWithObject:spark];
    
    [self.view.layer addSublayer:fireworksEmitter];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(MusicTool *)musicTool{
    if (_musicTool == nil) {
        _musicTool = [MusicTool shareInstance];
    }
    
    return _musicTool;
}

-(NSMutableArray *)allWordsArr{
    if (_allWordsArr == nil) {
        _allWordsArr = [[NSMutableArray alloc]init];
        
        NSArray *titlesArray1 = [NSArray arrayWithObjects:
                                @"你是一封信我是邮差",
                                @"最后一双脚惹尽尘埃",
                                @"忙着去护送 来不及拆开",
                                nil];
        NSArray *titlesArray2 = [NSArray arrayWithObjects:
                                @"薄雾浓云愁永昼，瑞脑消金兽。",
                                @"佳节又重阳，玉枕纱厨，半夜凉初透。",
                                @"东篱把酒黄昏后，有暗香盈袖。",
                                @"莫道不消魂。帘卷西风，人比黄花瘦。",
                                nil];
        NSArray *titlesArray3 = [NSArray arrayWithObjects:
                                 @"床前明月光",
                                 @"疑是地上霜",
                                 @"举头望明月",
                                 @"低头思故乡",
                                 nil];
        NSArray *titlesArray4 = [NSArray arrayWithObjects:
                                 @"风住尘香花已尽 日晚倦梳头",
                                 @"物是人非事事休 欲语泪先流",
                                 @"闻说双溪春尚好 也拟泛轻舟",
                                 @"只恐双溪舴艋舟 载不动 许多愁",
                                 nil];
        
//        NSArray *titlesArray5 = [NSArray arrayWithObjects:
//                                 @"青虬卧雪藏雅志",
//                                 @"玄鹤排云引诗情",
//                                 @"仙乡久在红尘里",
//                                 @"唯余一山月色清",
//                                 nil];
       
        
        [_allWordsArr addObject:titlesArray1];
        [_allWordsArr addObject:titlesArray2];
        [_allWordsArr addObject:titlesArray3];
        [_allWordsArr addObject:titlesArray4];
//        [_allWordsArr addObject:titlesArray5];
//        [_allWordsArr addObject:titlesArray6];
//        [_allWordsArr addObject:titlesArray7];
//        [_allWordsArr addObject:titlesArray8];
//        [_allWordsArr addObject:titlesArray9];
//        [_allWordsArr addObject:titlesArray10];
//        [_allWordsArr addObject:titlesArray11];
//        [_allWordsArr addObject:titlesArray12];
//        [_allWordsArr addObject:titlesArray13];
//        [_allWordsArr addObject:titlesArray14];
//        [_allWordsArr addObject:titlesArray15];
//        [_allWordsArr addObject:titlesArray16];
//        [_allWordsArr addObject:titlesArray17];
        
    }
    return _allWordsArr;
}


@end
