//
//  mostImage.h
//  jianke
//
//  Created by dave on 14-9-12.
//
//

#import <UIKit/UIKit.h>

@interface mostImage : UIImage

-(UIColor*)mostColor;
-(UIColor*) getPixelColorAtLocation:(CGPoint)point inImage:(UIImage *)image;
@end
