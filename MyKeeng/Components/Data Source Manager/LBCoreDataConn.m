//
//  LBCoreDataConn.m
//  MyKeeng
//
//  Created by Le Van Binh on 8/13/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import "LBCoreDataConn.h"
#import "LBPhotoToDataTransformer.h"

@implementation LBCoreDataConn
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;


-(instancetype)init {
    
    if (self = [super init]) {
        
        [self setupCoreDataConfig];
    }
    
    return self;
}

+(LBCoreDataConn *)sharedLBDataConnection {
    
    static dispatch_once_t once;
    static id instance;
    
    dispatch_once(&once, ^{
        
        instance = [self new];
    });
    
    return instance;
}

-(void)setupCoreDataConfig {
    
    LBPhotoToDataTransformer *photoToDataTransformer = [[LBPhotoToDataTransformer alloc] init];
    [NSValueTransformer setValueTransformer:photoToDataTransformer forName:@"LBPhotoToDataTransformer"];
}


#pragma mark - Business operations
-(void)getHomeNewMedias:(int)page size:(int)size performWithCompletion:(void (^)(BOOL, NSError *, NSMutableArray<LBMedia *> *))completion {
    
    
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
    
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:KEENG_CORE_DATA_MODEL_NAME withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return __managedObjectModel;
}

-(NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (__persistentStoreCoordinator != nil) {
        
        return __persistentStoreCoordinator;
    }
    
    //NSURL *storeURL = [self getPersistSQLFilePath];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:KEENG_CORE_DATA_FILE_NAME(@".sqlite")];
    
    
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
-(NSURL *)applicationDocumentsDirectory {
    
    NSArray<NSURL *> *documentDirs = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    
    NSLog(@"DocumentDir: %@", [documentDirs lastObject]);
    
    return [documentDirs lastObject];
}

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
