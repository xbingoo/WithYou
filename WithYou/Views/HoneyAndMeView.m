//
//  HoneyAndMeView.m
//  WithYou
//
//  Created by jianke-mbp on 16/1/9.
//  Copyright © 2016年 少先队. All rights reserved.
//

#import "HoneyAndMeView.h"
#import "RunningImageView.h"

@interface HoneyAndMeView()

@property (nonatomic ,strong) RunningImageView *honeyRunIV;
@property (nonatomic ,strong) RunningImageView *meRunIV;

@end


@implementation HoneyAndMeView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _honeyRunIV  = [[RunningImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.height) andSexType:SexTypeGirl andAnimationDuration:1];
        [self addSubview:_honeyRunIV];
        
        _meRunIV = [[RunningImageView alloc]initWithFrame:CGRectMake(kScreenW-frame.size.height, 0, frame.size.height, frame.size.height) andSexType:SexTypeBoy andAnimationDuration:1];
        [self addSubview:_meRunIV];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
