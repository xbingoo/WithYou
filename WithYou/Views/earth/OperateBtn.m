//
//  OperateBtn.m
//  WithYou
//
//  Created by jianke-mbp on 15/12/3.
//  Copyright © 2015年 少先队. All rights reserved.
//

#import "OperateBtn.h"

@implementation OperateBtn


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = self.frame.size.width/2.0;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [ReuseTool colorWithHexString:@"39b9fb"].CGColor;
        self.alpha = 0;
        
        [self addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

-(void)click{
    if ([self.delegate respondsToSelector:@selector(operateBtnClick:)]) {
        [self.delegate operateBtnClick:self];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
