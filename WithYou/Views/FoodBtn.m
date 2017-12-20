//
//  FoodBtn.m
//  WithYou
//
//  Created by jianke-mbp on 15/12/6.
//  Copyright © 2015年 少先队. All rights reserved.
//

#import "FoodBtn.h"

@interface FoodBtn()
@property (nonatomic ,assign) float change;
@property (nonatomic ,assign) BOOL isSmallToBig;
@property (nonatomic ,strong) NSTimer *timer;
@end

@implementation FoodBtn

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

-(void)startAnimation{

    self.change = 0.5;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(setNeedsDisplay) userInfo:nil repeats:YES];
}

-(void)drawRect:(CGRect)rect{
    
    if (!self.isSmallToBig) {
        if (self.frame.size.width <= 25 ) {
            CGRect frame = CGRectMake(self.frame.origin.x-self.change/2.0, self.frame.origin.y-self.change/2.0, self.frame.size.width+self.change, self.frame.size.height+self.change);
            self.frame = frame;
        }else{
            self.isSmallToBig = !self.isSmallToBig;
        }
    }else{
        if (self.frame.size.width >= 5 ) {
            CGRect frame = CGRectMake(self.frame.origin.x+self.change/2.0, self.frame.origin.y+self.change/2.0, self.frame.size.width-self.change, self.frame.size.height-self.change);
            self.frame = frame;
        }else{
            self.isSmallToBig = !self.isSmallToBig;
        }
    }
}

-(void)stopAnimation{
    self.change = 0;
    CGPoint center = self.center;
    self.frame = CGRectMake(0, 0, 15, 15);
    self.center = center;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
