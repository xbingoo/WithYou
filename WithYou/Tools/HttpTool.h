//
//  HttpTool.h
//  handhelddoctor
//
//  Created by jianke on 15/3/27.
//  Copyright (c) 2015年 jiankewang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^success)(id json);
typedef void(^failure)(NSError *error);

@interface HttpTool : NSObject
+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(success)success failure:(failure)failure;

+ (void) getWithURL:(NSString *)url params:(NSDictionary *)params success:(success)success failure:(failure)failure;

+(void)postWithURL:(NSString *)url params:(NSDictionary *)params image:(UIImage *)image success:(success)success failure:(failure)failure;

+(void)postWithURL:(NSString *)url params:(NSDictionary *)params image:(UIImage *)image fileName:(NSString *)fileName success:(success)success failure:(failure)failure;
@end
