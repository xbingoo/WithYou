//
//  ProgressBtn.m
//  WithYou
//
//  Created by jianke-mbp on 16/2/24.
//  Copyright © 2016年 少先队. All rights reserved.
//

#import "ProgressBtn.h"
#define degreesToRadians(x) (M_PI*(x)/180.0)

#define kProgressLineWidth 8


@interface ProgressBtn()

@property (nonatomic ,strong) CAShapeLayer *background;

@end

@implementation ProgressBtn

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius =  self.frame.size.width/2.0;
        [self setSelected:YES];
        [self setImage:[UIImage imageNamed:@"Pause"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"Play"] forState:UIControlStateSelected];
        
        CGFloat radius = frame.size.width/2.0-1;
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:radius-kProgressLineWidth startAngle:degreesToRadians(-90) endAngle:degreesToRadians(270) clockwise:YES];
        
        [self drawRoundBackgroundWithPath:path frame:CGRectMake(1, 0, frame.size.width-2, frame.size.width)];
        [self addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)drawRoundBackgroundWithPath:(UIBezierPath *)path frame:(CGRect)frame{
    _background = [CAShapeLayer layer];
    _background.frame = frame;
    _background.fillColor =  [[UIColor clearColor] CGColor];
    _background.strokeColor  = [[ReuseTool colorWithHexString:@"#EAEAEA"] CGColor];
    _background.lineCap = kCALineCapRound;
    _background.lineWidth = kProgressLineWidth;
    _background.path = [path CGPath];
    _background.strokeEnd = _percent;
    _background.opacity = 0.5;
    
    CALayer *gradientLayerTemp = [CALayer layer];
    CAGradientLayer *gradientLayer1Temp =  [CAGradientLayer layer];
    gradientLayer1Temp.frame = frame;
    [gradientLayer1Temp setColors:[NSArray arrayWithObjects:
                                   (id)[[[UIColor yellowColor] colorWithAlphaComponent:1] CGColor],
                                   (id)[[[UIColor yellowColor] colorWithAlphaComponent:1] CGColor],nil]];
    [gradientLayer1Temp setLocations:[NSArray arrayWithObjects:
                                      [NSNumber numberWithFloat:0.0],
                                      [NSNumber numberWithFloat:1],nil]];
    [gradientLayerTemp addSublayer:gradientLayer1Temp];
    [gradientLayerTemp setMask:_background]; //用progressLayer来截取渐变层
    [self.layer addSublayer:gradientLayerTemp];
}


-(void)setPercent:(double)percent{
    
    _percent = percent;
    
    _background.strokeEnd = percent;
    
}

-(void)click:(ProgressBtn *)sender{
    
    if ([self.delegate respondsToSelector:@selector(progressBtnClick:)]) {
        [self.delegate progressBtnClick:self];
    }
    
}


@end
