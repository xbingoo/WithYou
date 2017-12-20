//
//  ProgressScrollView.m
//  handhelddoctor
//
//  Created by jianke-mbp on 15/9/23.
//  Copyright © 2015年 jiankewang. All rights reserved.
//

#import "ProgressScrollView.h"
#import "MusicTool.h"
#import "FoodBtn.h"
#import "RunningImageView.h"


#define kTotalDistance 700
#define kContentViewWidth 880//kScreenW
#define kPointDistance kContentViewWidth/22
#define kLineY 70
#define kPointCenterY kLineY+1.5
#define kContentViewStart 200

@interface ProgressScrollView()
@property (nonatomic ,strong) UIView *contentView;

@property (nonatomic ,strong) NSMutableArray *greyImagesArr;  //灰色图片
@property (nonatomic ,strong) NSMutableArray *blueImagesArr;  //蓝色图片
@property (nonatomic ,strong) NSMutableArray *tipsArr;        //提示语

@property (nonatomic ,strong) UIImageView *leftBlueManIV;      //蓝色小人
@property (nonatomic ,strong) UIImageView *rightBlueManIV;
@property (nonatomic ,strong) UIView *leftCoverBaseLineView;   //蓝色覆盖线
@property (nonatomic ,strong) UIView *rightCoverBaseLineView;  //
@property (nonatomic ,strong) UIImageView *flagImageView;  //倒三角形
@property (nonatomic ,strong) FoodBtn *foodImageIV;       //卡路里对应的食品
@property (nonatomic ,strong) UILabel *tipLabel;           //提示语

//@property (nonatomic ,strong) MusicTool *musicTool;

@property (nonatomic ,strong) NSTimer *timer;


@property(nonatomic,strong) RunningImageView *runningGirlView;



@end

@implementation ProgressScrollView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self setContentView];
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.contentSize = CGSizeMake(kContentViewWidth, 100);
    //注册通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeFoodBtnAnimation:) name:kChangeFoodBtnAnimation object:nil];
    return self;
}

-(void)changeFoodBtnAnimation:(NSNotification *)notice{
    // 获取当前播放的音乐
    int index = [notice.userInfo[@"beginIndex"] intValue];
    
    if (index == 0) {
        
        FoodBtn *foodBtn = [self.contentView viewWithTag:1000 + [JKUserDefaults sharedInstance].numberOfSongs];
        [foodBtn stopAnimation];
        
        FoodBtn *currentFoodBtn = [self.contentView viewWithTag:1+1000];
        [currentFoodBtn startAnimation];
        
    }else{
        
        FoodBtn *foodBtn = [self.contentView viewWithTag:1000 + index];
        [foodBtn stopAnimation];
        
        FoodBtn *currentFoodBtn = [self.contentView viewWithTag:index+1+1000];
        [currentFoodBtn startAnimation];
        
    }
    
    
}


-(void)setContentView{
    
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kContentViewWidth, 100)];
    UIView *baseLineView = [[UIView alloc]initWithFrame:CGRectMake(-kContentViewStart, kLineY, kContentViewWidth+kContentViewStart+kContentViewStart, 3)];
    baseLineView.backgroundColor = [ReuseTool colorWithHexString:@"#e1e2e3"];
    [self.contentView addSubview:baseLineView];
    for (int i = 1; i <= 22; i++) {
        //食品标识
        FoodBtn *foodIV = [[FoodBtn alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
        foodIV.userInteractionEnabled = NO;
        [foodIV setImage:[UIImage imageNamed:self.greyImagesArr[i-1]] forState:UIControlStateNormal];
        foodIV.center = CGPointMake(kPointDistance * i , 73+10+5);
        foodIV.tag = 1000 + i;
        [foodIV addTarget:self action:@selector(foodClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:foodIV];
    }
    [self addSubview:self.contentView];
}
//当前已经完成的
-(void)coverContentViewWithCalorie:(CGFloat)calorie{
    
    //honey
    _leftBlueManIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 25, 40)];
    _leftBlueManIV.center = CGPointMake(calorie-3,  kLineY - 21);
    _leftBlueManIV.image = [UIImage imageNamed:@"runMan_blue.png"];
    [self.contentView addSubview:_leftBlueManIV];
    //me
    _rightBlueManIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 25, 40)];
    _rightBlueManIV.center = CGPointMake(kContentViewWidth-calorie-3,  kLineY - 21);
    _rightBlueManIV.image = [UIImage imageNamed:@"runMan_blue.png"];
    [self.contentView addSubview:_rightBlueManIV];
    
    //两个人相遇后，从右向左的人移到从左向右的人后面跟着跑
    if (calorie >= kContentViewWidth/2.0) {
        _rightBlueManIV.center = CGPointMake(calorie-3-20,  kLineY - 21);
    }
    
    
//    self.runningGirlView = [[RunningImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20) andSexType:SexTypeGirl andAnimationDuration:1];
//    self.runningGirlView.center = CGPointMake(calorie-3,  kLineY - 21);
//    [self.contentView addSubview:self.runningGirlView];
    
    //从右向左覆盖
    _rightCoverBaseLineView = [[UIView alloc]initWithFrame:CGRectMake(kContentViewWidth-calorie, kLineY, calorie+kContentViewStart, 3)];
    _rightCoverBaseLineView.backgroundColor = [ReuseTool colorWithHexString:@"#fd9f9a"];
    [self.contentView addSubview:_rightCoverBaseLineView];
    //从左向右覆盖
    _leftCoverBaseLineView = [[UIView alloc]initWithFrame:CGRectMake(-kContentViewStart, kLineY, calorie+kContentViewStart, 3)];
    _leftCoverBaseLineView.backgroundColor = [ReuseTool colorWithHexString:@"#ffb8db"];
    [self.contentView addSubview:_leftCoverBaseLineView];
    
//    //使honey的位置处于屏幕中间
//    if (calorie > kScreenW/2.0) {
//        self.contentOffset = CGPointMake(calorie - kScreenW/2.0, 0);
//    }
    
    int temp = kPointDistance;
    int flagCount = calorie/temp;
    [JKUserDefaults sharedInstance].numberOfSongs = flagCount;
    //卡路里对应食品图标变蓝
    
    if (flagCount > 0) {
        for (int i = 1; i <= flagCount ; i++) {
            _foodImageIV = (FoodBtn *)[self.contentView viewWithTag:1000 + i];
            _foodImageIV.userInteractionEnabled = YES;
            [_foodImageIV setImage:[UIImage imageNamed:self.blueImagesArr[i - 1]] forState:UIControlStateNormal];
        }
    }
}

-(void)foodClick:(FoodBtn *)button{
    
    NSString *fileName = [NSString stringWithFormat:@"Test%ld.mp3",button.tag - 1000];
    
    if ([fileName isEqual:[MusicTool shareInstance].currentFileName]) {
        [[MusicTool shareInstance] pausePlayer];
        [MusicTool shareInstance].currentFileName = nil;
        [button stopAnimation];
        
    }else{
        if ([MusicTool shareInstance].currentFileName) {
            
            NSMutableString *str = [NSMutableString stringWithString:[MusicTool shareInstance].currentFileName];
            NSInteger length = str.length;
            int num =  [[str substringWithRange:NSMakeRange(4, length-8)] intValue] + 1000;
            FoodBtn *foodBtn = [self.contentView viewWithTag:num];
            [foodBtn stopAnimation];
        }
        [[MusicTool shareInstance] startPlayerWith:fileName];
        [button startAnimation];
    }
}

-(void)playAllUnlockMusic{
    [[MusicTool shareInstance] playMusicByCycle];
}


//设置目标
-(void)setTargetWithTargetCalorie:(CGFloat)targetCalorie{
    
    UIImageView *targetIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 16, 47)];
    targetIV.center = CGPointMake(targetCalorie+5,  90 - 23);
    targetIV.image = [UIImage imageNamed:@"flag3x.png"];
    [self.contentView addSubview:targetIV];
    
}

-(NSMutableArray *)greyImagesArr{
    if (!_greyImagesArr) {
        _greyImagesArr = [NSMutableArray arrayWithObjects:
                          @"tangGuo_grey.png",
                          @"xueLi_grey.png",
                          @"huoLongGuo_grey.png",
                          @"douJiang_grey.png",
                          @"mianBao_grey.png",
                          @"apple_grey.png",
                          @"coke_grey.png",
                          @"rouBao_grey.png",
                          @"diGua_grey.png",
                          @"chaShao_grey.png",
                          @"tianDouJiang_grey.png",
                          @"whiteRice_grey.png",
                          @"youTiao_grey.png",
                          @"chouDouFu_grey.png",
                          @"suanLaFen_grey.png",
                          @"paiGu_grey.png",
                          @"gaLiFan_grey.png",
                          @"jiTuiFan_grey.png",
                          @"jiTuiBianDang_grey.png",
                          @"paiGuFan_grey.png",
                          @"paiGuBianDang_grey.png",
                          @"",
                          nil];
    }
    return _greyImagesArr;
}

-(NSMutableArray *)blueImagesArr{
    if (!_blueImagesArr) {
        _blueImagesArr = [NSMutableArray arrayWithObjects:
                          @"tangGuo_blue.png",
                          @"xueLi_blue.png",
                          @"huoLongGuo_blue.png",
                          @"douJiang_blue.png",
                          @"mianBao_blue.png",
                          @"apple_blue.png",
                          @"coke_blue.png",
                          @"rouBao_blue.png",
                          @"diGua_blue.png",
                          @"chaShao_blue.png",
                          @"tianDouJiang_blue.png",
                          @"whiteRice_blue.png",
                          @"youTiao_blue.png",
                          @"chouDouFu_blue.png",
                          @"suanLaFen_blue.png",
                          @"paiGu_blue.png",
                          @"gaLiFan_blue.png",
                          @"jiTuiFan_blue.png",
                          @"jiTuiBianDang_blue.png",
                          @"paiGuFan_blue.png",
                          @"paiGuBianDang_blue.png",
                          @"",
                          nil];
    }
    return _blueImagesArr;
}

-(NSMutableArray *)tipsArr{
    if (!_tipsArr) {
        _tipsArr = [NSMutableArray arrayWithObjects:
                    @"≈ 1颗糖果",
                    @"≈ 1个雪梨",
                    @"≈ 1个火龙果",
                    @"≈ 1杯豆浆",
                    @"≈ 1片白面包",
                    @"≈ 1个青苹果",
                    @"≈ 1杯可乐",
                    @"≈ 1个小肉包",
                    @"≈ 1个烤地瓜",
                    @"≈ 1个叉烧包",
                    @"≈ 1杯甜豆浆",
                    @"≈ 1碗白米饭",
                    @"≈ 1根油条",
                    @"≈ 1份炸臭豆腐",
                    @"≈ 1碗四川酸辣粉",
                    @"≈ 1份糖醋排骨",
                    @"≈ 1份咖哩饭",
                    @"≈ 1份炸鸡腿饭",
                    @"≈ 1份鸡腿便当",
                    @"≈ 1份炸排骨饭",
                    @"≈ 1份排骨便当",
                    nil];
    }
    return _tipsArr;
}

//-(MusicTool *)musicTool{
//    if (!_musicTool) {
//        _musicTool = [[MusicTool shareInstance];
//    }
//    return _musicTool;
//}

-(void)setTotalDistance:(NSString *)totalDistance{
    _totalDistance = totalDistance;
    CGFloat finishCalorie = [totalDistance floatValue]/1000/kTotalDistance*kContentViewWidth;
    [self coverContentViewWithCalorie:finishCalorie];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
