//
//  MusicTool.m
//  WithYou
//
//  Created by jianke-mbp on 15/12/5.
//  Copyright © 2015年 少先队. All rights reserved.
//

#import "MusicTool.h"
#import <AudioToolbox/AudioToolbox.h>

@interface MusicTool()<AVAudioPlayerDelegate>

@property (nonatomic,strong) AVAudioPlayer *audioPlayer;
@property (nonatomic,assign) NSInteger beginIndex;
@property (nonatomic,assign) NSInteger numberOfLoops;
@property (nonatomic,strong) NSMutableArray *allMusics;

@end

@implementation MusicTool


//-(instancetype)init{
//    
//    if (self = [super init]) {
//        [self makeMusicCanPlayInBackground];
//        self.beginIndex = 0;
//        self.numberOfLoops = -1;
//    }
//    
//    return self;
//}

+(instancetype)shareInstance{
    
    static dispatch_once_t predicate;
    static MusicTool *shareInstance;
    dispatch_once(&predicate, ^{
        
        //后台播放音频设置
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        //监听app打断事件
        AudioSessionInitialize(NULL, NULL, interruptionListenner, (__bridge void*)self);
        //让app支持接受远程控制事件
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        
        shareInstance = [[self alloc]init];
    });
    return shareInstance;
}

-(void)playMusicWith:(NSString *)musicName{
    NSURL *url=[[NSBundle mainBundle]URLForResource:musicName withExtension:nil];
    if (url==nil) return;
    
    NSError *error=nil;
    self.audioPlayer = nil;
    
    self.audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
    if (error)
    {
        NSLog(@"%@",[error localizedDescription]);
    }
    
//    self.audioPlayer.delegate=self;
    self.audioPlayer.numberOfLoops = 0;
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
    
}

-(void)startPlayerWith:(NSString *)fileName{
    
    self.currentFileName = fileName;
    NSURL *url=[[NSBundle mainBundle]URLForResource:fileName withExtension:nil];
    if (url==nil) return;

    NSError *error=nil;
    self.audioPlayer = nil;
//    self.audioPlayer = [[AVAudioPlayer alloc]initWithData:[NSData dataWithContentsOfURL:url] error:&error];
    self.audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
    if (error)
        {
            NSLog(@"%@",[error localizedDescription]);
        }
        
    self.audioPlayer.delegate=self;
    self.audioPlayer.numberOfLoops = self.numberOfLoops;
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
    
    NSDictionary *dic = @{@"beginIndex":[NSString stringWithFormat:@"%ld",(long)[self getIndexByFileName:self.currentFileName]]};
    NSNotification *notice = [NSNotification notificationWithName:kChangeFoodBtnAnimation object:nil userInfo:dic];
    [[NSNotificationCenter defaultCenter] postNotification:notice];
}

-(void)pausePlayer{
        [self.audioPlayer pause];
}

-(void)playPlayer{
    [self.audioPlayer play];
}

-(void)stopMusic{
    [self.audioPlayer stop];
    self.audioPlayer = nil;
}

-(BOOL)isPlaying{
    return [self.audioPlayer isPlaying];
}

-(double)totalTime{
    if ([self isPlaying]) {
        return self.audioPlayer.duration;
    }
    return 0;
}



-(double)currentTime{
    if ([self isPlaying]) {
        return self.audioPlayer.currentTime;
    }
    return 0;
}

-(void)playMusicByCycle{
    
    if ([JKUserDefaults sharedInstance].numberOfSongs == 0) {
        [ReuseTool showTipsWithHUD:@"还没有解锁的音乐哦~.~" showTime:1.5];
        return;
    }
    
    self.numberOfLoops = 0;
    self.beginIndex = [self getIndexByFileName:self.currentFileName];
    [self startPlayerWith:self.allMusics[self.beginIndex]];
    
}

-(NSInteger)getIndexByFileName:(NSString *)fileName{
    NSArray *allMusics = [JKUserDefaults sharedInstance].allMusicNameArr;
    for (int i = 0; i < allMusics.count; i++) {
        if ([fileName isEqualToString:allMusics[i]]) {
            return i;
        }
    }
    return 0;
}

-(void)makeMusicCanPlayInBackground{
    //后台播放音频设置
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    //监听app打断事件
     AudioSessionInitialize(NULL, NULL, interruptionListenner, (__bridge void*)self);
    //让app支持接受远程控制事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];

}

void interruptionListenner(void* inClientData, UInt32 inInterruptionState){
    
        MusicTool* m = (__bridge MusicTool*)inClientData;
        if (kAudioSessionBeginInterruption == inInterruptionState) {
            NSLog(@"Begin interruption");
            [m pausePlayer];
        }
        else
        {
            NSLog(@"Begin end interruption");
            [m playPlayer];
        }
    
    
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (self.beginIndex + 1 < self.allMusics.count) {
        self.beginIndex++;
    }else{
        self.beginIndex = 0;
    }
    [self startPlayerWith:self.allMusics[self.beginIndex]];
}


-(NSArray *)allMusics{
    if (!_allMusics) {
        _allMusics = [[NSMutableArray alloc]init];
        for (int i = 0; i < [JKUserDefaults sharedInstance].numberOfSongs; i++) {
            [_allMusics addObject:[JKUserDefaults sharedInstance].allMusicNameArr[i]];
        }
    }
    return _allMusics;
}

-(NSInteger)beginIndex{
    if (!_beginIndex) {
        _beginIndex = 0;
    }
    return _beginIndex;
}

@end
