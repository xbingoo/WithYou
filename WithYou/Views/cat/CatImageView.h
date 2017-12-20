//
//  CatImageView.h
//  WithYou
//
//  Created by jianke-mbp on 16/1/10.
//  Copyright © 2016年 少先队. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CatImageView : UIImageView

/**
 *  初始化奔跑动画
 *
 *  @param frame             frame
 *  @param sexType           性别枚举类型
 *  @param animationDuration 完成一组动画的时间
 *
 *  @return 初始化的结果
 */
-(instancetype)initWithFrame:(CGRect)frame andImageNameArr:(NSArray *)imageNameArr andAnimationDuration:(double)animationDuration;

@end
