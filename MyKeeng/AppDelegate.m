//
//  AppDelegate.m
//  MyKeeng
//
//  Created by Le Van Binh on 7/12/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import "AppDelegate.h"
#import "LBHomeNewVC.h"
#import "SDImageCache.h"
#import "LBHomeGeneralViewController.h"
#import "LBHomeNewFloatingWindowVC.h"


@interface AppDelegate () {
    
    CGRect originFrameInPortrait;
    LBHomeNewFloatingWindowVC *homeNewFloatingWindowVC;
}



@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //TODO: Enable FacebookMemoryProfiler
    homeNewFloatingWindowVC = [LBHomeNewFloatingWindowVC new];
    [homeNewFloatingWindowVC enable];
    
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    originFrameInPortrait = CGRectMake(0, 0, MIN(self.window.frame.size.height, self.window.frame.size.width), MAX(self.window.frame.size.height, self.window.frame.size.width));
    
//TODO: set cache configuration
    [[SDImageCache sharedImageCache] setMaxMemoryCost:KEENG_MAX_TOTAL_COST_MEM_CACHE];
    [[SDImageCache sharedImageCache] setMaxCacheSize:KEENG_MAX_DISK_CACHE];
    
    
    //
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:@"UIApplicationWillChangeStatusBarOrientationNotification" object:nil];
    
    //    if (isLandscape) {
    //
    //        if (SYSTEM_VERSION_GREATER_THAN(@"7.0")) {
    //
    //            CGRect frame = self.window.frame;
    //            frame.size.width -= 20.f;
    //            frame.origin.x += 20.f;
    //            self.window.frame = frame;
    //        }
    //    } else {
    //
    //        if (SYSTEM_VERSION_GREATER_THAN(@"7.0")) {
    //
    //            [application setStatusBarStyle:UIStatusBarStyleLightContent];
    //            CGRect frame = self.window.frame;
    //            frame.origin.y += 20.0f;
    //            frame.size.height -= 20.0f;
    //            self.window.frame = frame;
    //        }
    //    }
    
    
    LBHomeGeneralViewController *homeGeneralVC = [[LBHomeGeneralViewController alloc] init];
    
    //LBHomeNewVC *homeNewVC = [[LBHomeNewVC alloc] init];
    //homeNewVC.managedObjectContext = self.managedObjectContext;
    
    
    
    self.window.rootViewController = homeGeneralVC;
    [self.window makeKeyAndVisible];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMemoryWarning:) name: UIApplicationDidReceiveMemoryWarningNotification object:nil];
    
    return YES;
}


-(void) orientationChanged:(NSNotification *)notification {
    
    if (isPortrait) {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            
            CGRect viewFrame = originFrameInPortrait;
            viewFrame.origin.y += 20.0;
            viewFrame.size.height -= 20.0;
            
            self.window.frame = viewFrame;
        }
        
    } else { //is landscape mode
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            
            self.window.frame = originFrameInPortrait;
            
        }
        
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



#pragma mark - Processing Notifications
- (void) handleMemoryWarning:(NSNotification *)notification
{
    
    NSLog(@"WARNING: Device Low memory: %@", notification);
}

-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    
    NSLog(@"WARNING: Device Low memory: %@");

}


@end
