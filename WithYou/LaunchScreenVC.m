//
//  LaunchScreenVC.m
//  WithYou
//
//  Created by jianke-mbp on 16/2/22.
//  Copyright © 2016年 少先队. All rights reserved.
//

#import "LaunchScreenVC.h"
#import "GuidePageVC.h"

@interface LaunchScreenVC ()

@property (nonatomic ,strong) UIView *launchView;
@property (nonatomic ,strong) NSString *launchName;

@end

@implementation LaunchScreenVC


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
    
    [self.launchView removeFromSuperview];
    UIImageView *animationImage = (UIImageView *)[self.view viewWithTag:1111];
    
    NSMutableArray *images =  [[NSMutableArray alloc] init];
    for (int i = 1 ; i < 15; i++) {
        if (i < 10) {
            [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"sp000%d",i]]];
        }else {
            [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"sp00%d",i]]];
        }
    }
    animationImage.animationImages = images;
    animationImage.animationDuration = 3.0f;
    animationImage.animationRepeatCount = 1;
    [animationImage startAnimating];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [animationImage stopAnimating];
        animationImage.image = [UIImage imageNamed:@"sp0014"];
        
        UIWindow *window = [[UIApplication sharedApplication].delegate window];
        
        if (![JKUserDefaults sharedInstance].isUsedApp) {
            
            GuidePageVC *guidePageVC = [[GuidePageVC alloc]init];
            
            UINavigationController *rootController = [[UINavigationController alloc]initWithRootViewController:guidePageVC];
        
            window.rootViewController = rootController;
            
        }else{
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"IndexViewController"];
            
            UINavigationController *rootController = [[UINavigationController alloc]initWithRootViewController:vc];
            
            [self presentViewController:rootController animated:YES completion:nil];
        }
                
    });
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    UIApplication *app = [UIApplication sharedApplication];

    self.view = [[UINib nibWithNibName:self.launchName bundle:nil] instantiateWithOwner:self options:nil].firstObject;
    self.view.frame = app.keyWindow.bounds;
    [self.view layoutIfNeeded];
    [app.keyWindow addSubview:self.launchView];
    [app.keyWindow bringSubviewToFront:self.launchView];

}


-(UIView *)launchView{
    if (_launchView == nil) {
     
        UIView *viewCopy = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self.view]];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:viewCopy];
        viewCopy.frame = window.bounds;
        
        UIGraphicsBeginImageContextWithOptions([UIScreen mainScreen].bounds.size, YES, 0.0);
        [viewCopy.layer renderInContext:UIGraphicsGetCurrentContext()];
        [viewCopy removeFromSuperview];
        
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        _launchView = [[UIImageView alloc] initWithImage:img];
        _launchView.frame = [UIScreen mainScreen].bounds;
        
        
    }
    return _launchView;
}


-(NSString *)launchName{
    
//    NSLog(@"%@",[[NSBundle mainBundle] infoDictionary]);
    return [[NSBundle mainBundle] infoDictionary][@"UILaunchStoryboardName"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
