//
//  EarthView.m
//  WithYou
//
//  Created by jianke-mbp on 15/11/27.
//  Copyright © 2015年 少先队. All rights reserved.
//

#import "EarthView.h"

#define kMyRoadWidth 20

@interface EarthView()
@property(nonatomic, assign) CGFloat honeySpeed; //地球速度
@property(nonatomic, assign) CGFloat mySpeed;    //火箭速度
@property(nonatomic, assign) double angleEarth;
@property(nonatomic, assign) double angle;
@property(nonatomic, assign) NSInteger value;
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UIImageView *imageViewEarth;
@end

@implementation EarthView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //初始速度
        _honeySpeed=1;
        _mySpeed=1;
        _value=1;
        //设置自身背景颜色
        self.backgroundColor=[UIColor clearColor];
        //初始化地球
        self.imageViewEarth = [[UIImageView alloc]initWithFrame:CGRectMake(kMyRoadWidth, kMyRoadWidth, frame.size.width-kMyRoadWidth, frame.size.width-kMyRoadWidth)];
        self.imageViewEarth.image=[UIImage imageNamed:@"earth@3x"];
        [self addSubview:self.imageViewEarth];
        //开始地球动画
        [self startAnimationEarth];
        //初始化火箭
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kMyRoadWidth + 0.5*(frame.size.width-kMyRoadWidth)-0.05*(frame.size.width-kMyRoadWidth), kMyRoadWidth + 0.4*(frame.size.width-kMyRoadWidth), 0.1*(frame.size.width-kMyRoadWidth), 0.2*(frame.size.width-kMyRoadWidth))];
        [self addSubview:self.imageView];
        self.imageView.image=[UIImage imageNamed:@"fire2@3X(1)"];
        //开始火箭动画
        [self startAnimation];
        
    }
    return self;
}

-(void) startAnimation
{
    NSString *imageName;
    if (_value>=3) {
        
        _value=1;
    }
    imageName = [NSString stringWithFormat:@"fire%ld@3X(1)",_value];
    
    self.imageView.image = [UIImage imageNamed:imageName];
    _value++;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endAnimation)];
    
    self.imageView.transform = CGAffineTransformMakeRotation(_angle * (M_PI / 180.0f));
    self.imageView.layer.anchorPoint=CGPointMake(6, 0.5);
    [UIView commitAnimations];
    
    
    
}
-(void)endAnimation
{
    if (!_isStopLoop) {
        
    _angle += 1*_mySpeed;
    [self startAnimation];
        
    }
    //换图片
    
}

-(void) startAnimationEarth
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endAnimationEarth)];
    self.imageViewEarth.transform = CGAffineTransformMakeRotation(_angleEarth * (M_PI / 180.0f));
    [UIView commitAnimations];
}
-(void)endAnimationEarth
{
    if (!_isStopLoop) {
        _angleEarth += 1*_honeySpeed;
        [self startAnimationEarth];
    }
    
}

-(void)setHoneySpeed:(CGFloat)honeySpeed andMySpeed:(CGFloat)mySpeed{
    _honeySpeed = honeySpeed;
    _mySpeed = mySpeed;
}

-(void)setIsStopLoop:(BOOL)isStopLoop{
    _isStopLoop = isStopLoop;
    
    if (!isStopLoop) {
        [self startAnimation];
        [self startAnimationEarth];
    }
}



@end
