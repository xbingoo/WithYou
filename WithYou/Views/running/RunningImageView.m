//
//  RunningImageView.m
//  WithYou
//
//  Created by jianke-mbp on 15/12/1.
//  Copyright © 2015年 少先队. All rights reserved.
//

#import "RunningImageView.h"

@implementation RunningImageView


-(instancetype)initWithFrame:(CGRect)frame andSexType:(SexType)sexType andAnimationDuration:(double)animationDuration{
    
    if (self = [super initWithFrame:frame]) {
        
        NSMutableArray *images = [[NSMutableArray alloc]initWithCapacity:8];
        if (sexType == SexTypeGirl) {
            for (int i = 0; i < 8; i++) {
                [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loading000%d", i]]];
            }
            
        }else{
            
            for (int i = 0; i < 8; i++) {
                [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loading000%d", i]]];
            }
        }
        self.animationImages = images;
        self.animationDuration = animationDuration;
        [self startAnimating];
    }
    
    return self;
}

-(void)resetRunningSpeed:(double)animationDuration{
    self.animationDuration = animationDuration;
    [self startAnimating];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
