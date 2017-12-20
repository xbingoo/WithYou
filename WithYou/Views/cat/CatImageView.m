//
//  CatImageView.m
//  WithYou
//
//  Created by jianke-mbp on 16/1/10.
//  Copyright © 2016年 少先队. All rights reserved.
//

#import "CatImageView.h"

@implementation CatImageView

-(instancetype)initWithFrame:(CGRect)frame andImageNameArr:(NSArray *)imageNameArr andAnimationDuration:(double)animationDuration{
    
    if (self = [super initWithFrame:frame]) {
        
        NSMutableArray *images = [[NSMutableArray alloc]initWithCapacity:imageNameArr.count];
        
        for (int i = 0; i < imageNameArr.count; i++) {
            [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"cat%@.jpg",imageNameArr[i]]]];
        }
            
        self.animationImages = images;
        self.animationDuration = animationDuration;
        [self startAnimating];
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
