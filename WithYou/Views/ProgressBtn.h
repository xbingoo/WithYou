//
//  ProgressBtn.h
//  WithYou
//
//  Created by jianke-mbp on 16/2/24.
//  Copyright © 2016年 少先队. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProgressBtn;
@protocol ProgressBtnDelegate <NSObject>

-(void)progressBtnClick:(ProgressBtn *)progressBtn;

@end

@interface ProgressBtn : UIButton

@property (nonatomic ,assign) double percent;

@property (nonatomic ,weak) id<ProgressBtnDelegate> delegate;

@end
