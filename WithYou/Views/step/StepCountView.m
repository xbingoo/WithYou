//
//  StepCountView.m
//  WithYou
//
//  Created by jianke-mbp on 15/12/2.
//  Copyright © 2015年 少先队. All rights reserved.
//

#import "StepCountView.h"

//每天的进度相关参数
#define kCycleRadius 200/2.0
#define kProgressLineWidth 10
#define degreesToRadians(x) (M_PI*(x)/180.0) //把角度转换成PI的方式

@interface StepCountView()

@property (nonatomic ,strong) CAShapeLayer  *progressLayer;
@property (nonatomic ,strong) UILabel *highestLabel;

@end

@implementation StepCountView


-(instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, frame.size.width, 20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
//        label.textColor = [ReuseTool colorWithHexString:@"ACADAE"];
        label.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
        label.text = @"今日步数";
        [self addSubview:label];
        
        _highestLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 130, frame.size.width, 20)];
        _highestLabel.textAlignment = NSTextAlignmentCenter;
        _highestLabel.font = [UIFont systemFontOfSize:14];
//        _highestLabel.textColor = [ReuseTool colorWithHexString:@"ACADAE"];
        _highestLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
        _highestLabel.text = [NSString stringWithFormat:@"最高%ld步",(long)[JKUserDefaults sharedInstance].maxStepCount];
        [self addSubview:_highestLabel];
        
        [self drawRoundWithFrame:CGRectMake(0, 0, 2 * kCycleRadius, 2 * kCycleRadius)];
    }
    
    return self;
}

#pragma mark -- 每天的进度

-(void)drawRoundWithFrame:(CGRect)frame{
    
    CGFloat radius = kCycleRadius;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:radius-kProgressLineWidth startAngle:degreesToRadians(-90) endAngle:degreesToRadians(270) clockwise:YES];
    /**
     *  这里是画的背景，可让美工切图做背景
     */
    [self drawRoundBackgroundWithPath:path frame:frame];
    /**
     *  这里是画进度
     */
    [self drawRoundProgressWithPath:path frame:frame];
    
}

-(void)drawRoundBackgroundWithPath:(UIBezierPath *)path frame:(CGRect)frame{
    CAShapeLayer *background = [CAShapeLayer layer];
    background.frame = frame;
    background.fillColor =  [[UIColor clearColor] CGColor];
    background.strokeColor  = [[ReuseTool colorWithHexString:@"#EAEAEA"] CGColor];
    background.lineCap = kCALineCapRound;
    background.lineWidth = kProgressLineWidth;
    background.path = [path CGPath];
    background.strokeEnd = 1;
    background.opacity = 0.5;
    
    CALayer *gradientLayerTemp = [CALayer layer];
    CAGradientLayer *gradientLayer1Temp =  [CAGradientLayer layer];
    gradientLayer1Temp.frame = frame;
    [gradientLayer1Temp setColors:[NSArray arrayWithObjects:
                                   (id)[[[ReuseTool colorWithHexString:@"#f3f4f5"] colorWithAlphaComponent:1] CGColor],
                                   (id)[[[ReuseTool colorWithHexString:@"#f3f4f5"] colorWithAlphaComponent:1] CGColor],nil]];
    [gradientLayer1Temp setLocations:[NSArray arrayWithObjects:
                                      [NSNumber numberWithFloat:0.0],
                                      [NSNumber numberWithFloat:1],nil]];
    [gradientLayerTemp addSublayer:gradientLayer1Temp];
    [gradientLayerTemp setMask:background]; //用progressLayer来截取渐变层
    [self.layer addSublayer:gradientLayerTemp];
}

-(void)drawRoundProgressWithPath:(UIBezierPath *)path frame:(CGRect)frame{
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.frame = frame;
    _progressLayer.fillColor =  [[UIColor clearColor] CGColor];
    _progressLayer.strokeColor  = [[ReuseTool colorWithHexString:@"#EAEAEA"] CGColor];
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.lineWidth = kProgressLineWidth;
    _progressLayer.path = [path CGPath];
    _progressLayer.strokeEnd = 0;
    _progressLayer.opacity = 0.8;
    
    CALayer *gradientLayer = [CALayer layer];
    CAGradientLayer *gradientLayer1 =  [CAGradientLayer layer];
    gradientLayer1.frame = frame;
    [gradientLayer1 setColors:[NSArray arrayWithObjects:
                               (id)[[[ReuseTool colorWithHexString:@"#OCAAFA"] colorWithAlphaComponent:1] CGColor],
                               (id)[[[ReuseTool colorWithHexString:@"#02E044"] colorWithAlphaComponent:1] CGColor],nil]];
    [gradientLayer1 setLocations:[NSArray arrayWithObjects:
                                  [NSNumber numberWithFloat:0.0],
                                  [NSNumber numberWithFloat:1],nil]];
    [gradientLayer addSublayer:gradientLayer1];
    [gradientLayer setMask:_progressLayer]; //用progressLayer来截取渐变层
    [self.layer addSublayer:gradientLayer];
}

-(void)setMaxStepCount:(NSString *)maxStepCount{
    _maxStepCount = maxStepCount;
    _highestLabel.text = [NSString stringWithFormat:@"最高%@步",maxStepCount];
}

-(void)setPercent:(NSString *)percent animation:(BOOL)yesOrNo{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        _progressLayer.strokeEnd = [percent doubleValue];
        
    });

    
    
//    CGFloat radius = kCycleRadius;
//    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:radius-kProgressLineWidth startAngle:degreesToRadians(-90) endAngle:degreesToRadians(270) clockwise:YES];
//    [self drawRoundProgressWithPath:path frame:CGRectMake(0, 0, 2 * kCycleRadius, 2 * kCycleRadius)];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
