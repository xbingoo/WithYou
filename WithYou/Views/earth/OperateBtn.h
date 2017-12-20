//
//  OperateBtn.h
//  WithYou
//
//  Created by jianke-mbp on 15/12/3.
//  Copyright © 2015年 少先队. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OperateBtn;

@protocol OperateBtnDelegate <NSObject>

-(void)operateBtnClick:(OperateBtn *)operateBtn;

@end

@interface OperateBtn : UIButton

@property (nonatomic ,weak) id<OperateBtnDelegate> delegate;

@end
