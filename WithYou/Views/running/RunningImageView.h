//
//  RunningImageView.h
//  WithYou
//
//  Created by jianke-mbp on 15/12/1.
//  Copyright © 2015年 少先队. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    SexTypeGirl,
    SexTypeBoy,
} SexType;
@interface RunningImageView : UIImageView
/**
 *  初始化奔跑动画
 *
 *  @param frame             frame
 *  @param sexType           性别枚举类型
 *  @param animationDuration 完成一组动画的时间
 *
 *  @return 初始化的结果
 */
-(instancetype)initWithFrame:(CGRect)frame andSexType:(SexType)sexType andAnimationDuration:(double)animationDuration;
/**
 *  重新设置完成一组动画的时间
 *
 *  @param animationDuration 完成一组动画的时间
 */
-(void)resetRunningSpeed:(double)animationDuration;
@end
