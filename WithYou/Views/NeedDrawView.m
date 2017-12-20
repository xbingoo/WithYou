
//
//  NeedDrawView.m
//  DrayPointTest
//
//  Created by xun on 14-3-25.
//  Copyright (c) 2014年 xun. All rights reserved.
//

#import "NeedDrawView.h"

@interface NeedDrawView ()

@property (nonatomic, strong) NSMutableArray *allPoints;
@property (nonatomic, strong) NSMutableArray *curPoints;
@property (nonatomic, assign) int titleFlag;
@end

@implementation NeedDrawView

#pragma mark ---------
#pragma mark LifeCycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    //清除上一次的画板
    CGContextRef ctxxx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctxxx, rect);
    
    [self drawString:_needDrawString withPoint:_curPoint];
    
    //前面已经显示的条目清空后直接重新划在上面
    
    if (_chargeIndex) {
        for (int i = 0; i < _chargeIndex; i++) {
            [self drawString:[self.titles objectAtIndex:i] withPoint:[[self.titlePoints objectAtIndex:i] CGPointValue]];
        }
    }
}

#pragma mark ---------
#pragma mark CustormAPI

- (void)setData:(NSArray *)array andTitieFlag:(int)flag
{
    _titleFlag = flag;
    //假数据（每列最多支持字体大小为14时，iPhone6屏，每列最多支持34汉字、符号）
    if (array == nil) {
        return;
    }

    self.titles = [self handleArrayAllObjectWithNewlineCharacters:array];
    
    NSMutableArray *tempArr = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < array.count; i++) {
        
        int x = 22 * i;
        
        int y = 0;
        
        [tempArr addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
    }
    
    self.titlePoints = [NSArray arrayWithArray:tempArr];
    [self showTitlesAnimationBegin];//显示title动画

}

- (NSArray *)handleArrayAllObjectWithNewlineCharacters:(NSArray *)array
{
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:[array count]];
    for (int i = 1; i <= [array count]; i++) {
        NSString *titlesString = [array objectAtIndex:i-1];
        NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:[titlesString length]];
        for (int m = 0; m < [titlesString length]; m++) {
            NSString *charS = [titlesString substringWithRange:NSMakeRange(m, 1)];
            [tempArray addObject:charS];
        }
        NSString *string = [tempArray componentsJoinedByString:@"\n"];
        [titles addObject:string];
    }
    return [titles copy];
}

- (void)showTitlesAnimationBegin
{
    if (_titleIndex == [self.titles count]) {
        _chargeIndex = 0;
        _titleIndex = 0;
        
        NSNotification *notice = [NSNotification notificationWithName:@"finishSay" object:nil userInfo:@{@"flag":[NSNumber numberWithInt:_titleFlag+1]}];
        
        [[NSNotificationCenter defaultCenter] postNotification:notice];
        
        return;
    }
    _curPoint = [[self.titlePoints objectAtIndex:_titleIndex] CGPointValue];
    _curString = [self.titles objectAtIndex:_titleIndex];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateCurrentString) userInfo:nil repeats:YES];
    _titleIndex++;
}

/*
 *改变当前需要显示的那个String
 */
- (void)updateCurrentString
{
    
    static int m = 1;
    if (m == [_curString length]+1) {
        [self.timer invalidate];
        self.timer = nil;
        m = 1;
        ++_chargeIndex;
        [self showTitlesAnimationBegin];
        return;
    } else {
        _needDrawString  = [_curString substringWithRange:NSMakeRange(0,m)];
        m++;
        [self setNeedsDisplay];
    }
    
}

- (void)drawString:(NSString *)text withPoint:(CGPoint)point
{
    //设置字体大小
    UIFont *font = [UIFont systemFontOfSize:14];
//    UIFont *font = [UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:14];
    
//    NSLog(@"%@",[UIFont familyNames]);
    //设置文本颜色
    UIColor *redColor = [UIColor whiteColor];
    //设置文本字体属性
    NSDictionary *dic = @{NSFontAttributeName: font,NSForegroundColorAttributeName:redColor};
    [text drawAtPoint:point withAttributes:dic];
}


@end
