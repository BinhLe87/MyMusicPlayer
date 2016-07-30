//
//  AppDelegate.m
//  MyKeeng
//
//  Created by Le Van Binh on 7/12/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import "AppDelegate.h"
#import "LBRestKitConn.h"
#import "LBHomeNewVC.h"

@interface AppDelegate () {
    
    CGRect originFrameInPortrait;
}



@end

@implementation AppDelegate

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    originFrameInPortrait = CGRectMake(0, 0, MIN(self.window.frame.size.height, self.window.frame.size.width), MAX(self.window.frame.size.height, self.window.frame.size.width));
    
    
    
    
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
    
    
    
    
    
    [LBRestKitConn configureRestKit];
    
    LBHomeNewVC *homeNewVC = [[LBHomeNewVC alloc] initWithNibName:@"LBHomeNew" bundle:nil];
    homeNewVC.managedObjectContext = self.managedObjectContext;
    
    UINavigationController *navigationCtrl = [[UINavigationController alloc] initWithRootViewController:homeNewVC];
    
    
    
    self.window.rootViewController = navigationCtrl;
    
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

#pragma mark - Core Data stack
-(NSManagedObjectContext *)managedObjectContext {
    
    if (__managedObjectContext != nil) {
        
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        
        __managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return __managedObjectContext;
}

-(NSManagedObjectModel *)managedObjectModel {
    
    if (__managedObjectModel != nil) {
        
        return __managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MyKeeng" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return __managedObjectModel;
}

-(NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (__persistentStoreCoordinator != nil) {
        
        return __persistentStoreCoordinator;
    }
    
    //NSURL *storeURL = [self getPersistSQLFilePath];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MyKeeng.sqlite"];
    
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return __persistentStoreCoordinator;
    
}

- (void)saveContext {
    
    NSError *error = nil; NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        { NSLog(@"Unresolved error %@, %@", error, [error userInfo]); abort(); } }
    
}

#pragma mark - Application's Documents directory

- (NSData*)bookmarkForURL:(NSURL*)url {
    NSError* theError = nil;
    NSData* bookmark = [url bookmarkDataWithOptions:NSURLBookmarkCreationSuitableForBookmarkFile
                     includingResourceValuesForKeys:nil
                                      relativeToURL:nil
                                              error:&theError];
    if (theError || (bookmark == nil)) {
        // Handle any errors.
        return nil;
    }
    return bookmark;
}

- (NSURL*)urlForBookmark:(NSData*)bookmark {
    BOOL bookmarkIsStale = NO;
    NSError* theError = nil;
    NSURL* bookmarkURL = [NSURL URLByResolvingBookmarkData:bookmark
                                                   options:NSURLBookmarkResolutionWithoutUI
                                             relativeToURL:nil
                                       bookmarkDataIsStale:&bookmarkIsStale
                                                     error:&theError];
    
    if (bookmarkIsStale || (theError != nil)) {
        // Handle any errors
        return nil;
    }
    return bookmarkURL;
}


-(NSURL *)applicationDocumentsDirectory {
    
    NSArray<NSURL *> *documentDirs = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    
    return [documentDirs lastObject];
}

-(NSURL*) getPersistSQLFilePath {
    
    //read SqlFile location that was bookmarked from NSUserDefault
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *bookmarkDocURL = [defaults objectForKey:@"bookmarkSqlFile"];
    NSURL *docURL = nil;
    
    if (!bookmarkDocURL) { //not yet existing url bookmark
        
        docURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MyKeeng.sqlite"];
        
        //convert to nsdata bookmark
        bookmarkDocURL = [self bookmarkForURL:docURL];
        
        //save into NSUserDefault
        if (bookmarkDocURL) {
            [defaults setObject:bookmarkDocURL forKey:@"bookmarkSqlFile"];
        }
    } else { //extract bookmark into NSURL
        
        docURL = [self urlForBookmark:bookmarkDocURL];
    }
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[docURL path]];
    
    return docURL;

}




@end
