//
//  MusicTool.h
//  WithYou
//
//  Created by jianke-mbp on 15/12/5.
//  Copyright © 2015年 少先队. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface MusicTool : NSObject

- (instancetype)init __attribute__((unavailable("init is not available in JKUserDefaults, Use sharedInstance"))) NS_DESIGNATED_INITIALIZER;

@property(nonatomic ,assign ,readonly) BOOL isPlaying;
@property(nonatomic ,strong) NSString *currentFileName;
@property(nonatomic ,assign) double currentTime;
@property(nonatomic ,assign) double totalTime;

-(void)startPlayerWith:(NSString *)fileName;

-(void)pausePlayer;

-(void)stopMusic;

-(void)playMusicByCycle;

-(void)playPlayer;

-(void)playMusicWith:(NSString *)musicName;

//-(double)totalTime;

//-(double)currentTime;

+(instancetype)shareInstance;


@end
