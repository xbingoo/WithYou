//
//  StepCountView.h
//  WithYou
//
//  Created by jianke-mbp on 15/12/2.
//  Copyright © 2015年 少先队. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StepCountView : UIView

@property (strong ,nonatomic) NSString *maxStepCount;
//@property (strong ,nonatomic) NSString *percent;

-(void)setPercent:(NSString *)percent animation:(BOOL)yesOrNo;


@end
