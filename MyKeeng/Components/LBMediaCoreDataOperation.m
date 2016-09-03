//
//  LBMediaInsertCoreData.m
//  MyKeeng
//
//  Created by Le Van Binh on 8/13/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import "LBMediaCoreDataOperation.h"
#import "LBMedia.h"
#import "LBVideo.h"
#import "LBSong.h"
#import "LBCoreDataConn.h"
#import "HCDCoreDataStack.h"
#import "HCDCoreDataStackController.h"
#import <CoreData/CoreData.h>

@interface LBMediaCoreDataOperation() {

    HCDCoreDataStack *stack;
    HCDCoreDataStackController *controller;
    NSManagedObjectContext *moc;
    
}

@end


@implementation LBMediaCoreDataOperation
@synthesize finished = _finished;
@synthesize executing = _executing;
@synthesize media = _media;

-(instancetype)initWithMedia:(LBMedia *)media coreDataAction:(LBMediaCoreDataAction)iCoreDataAction {
    
    if ([super init]) {
        
        _media = media;
        _coreDataAction = iCoreDataAction;
        
        stack = [HCDCoreDataStack sqliteStackWithName:KEENG_CORE_DATA_MODEL_NAME];
        controller = [HCDCoreDataStackController controllerWithStack:stack];
        moc = [controller createChildContextWithType:NSPrivateQueueConcurrencyType];
        
    }
    
    return self;
}


-(void)start {
    
    if (self.isCancelled) {
        return;
    }
    
    if (_coreDataAction & LBMediaCoreDataActionInsert) {
        
        [self insertMediaToCoreData];
    }
    
    self.executing = NO;
    self.finished = YES;
  }


-(BOOL)isConcurrent {
    
    return YES;
}

- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

#pragma mark - operations in CoreData
-(void)insertMediaToCoreData {
    
    if ([self.media isKindOfClass:[LBVideo class]]) {
        
        __weak LBVideo *video = (LBVideo*)_media;
        
        
        [moc performBlock:^{
          
            LBPhoto* photoMO = (LBPhoto*)[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([LBPhoto class]) inManagedObjectContext:moc];
            
            [photoMO setUrl_string:[video.image.url absoluteString]];
            [photoMO setFailed:NO];
            [photoMO setFiltered:NO];
            
            
            LBVideo* videoMO =  (LBVideo*) [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([LBVideo class]) inManagedObjectContext:moc];
            
            [videoMO setId:video.id];
            [videoMO setName:video.name];
            [videoMO setImage:photoMO];
            [videoMO setImage310:photoMO];
            [videoMO setListen_no:video.listen_no];
            [videoMO setPrice:video.price];
            [videoMO setSinger:video.singer];
            [videoMO setUrl:video.url];
            [videoMO setFetch_datetime:[NSDate date]];
            [videoMO setMedia_url:video.media_url];
            [videoMO setLocate_path:video.locate_path];
            [videoMO setDownload_url:video.download_url];

            /*Save child context*/
            [moc save:nil];
            
            /*Save data to store*/
            
            dispatch_async(dispatch_get_main_queue(), ^{
            
                [controller save:^(BOOL success, NSError *error) {
                    
                    if (error) {
                        
                        for (NSMergeConflict* conflict in [error.userInfo valueForKey:@"conflictList"]) {
                            
                            NSLog(@"MyKeeng Conflicted: %@", conflict);
                        }
                    }
                }];
            });
            
            NSLog(@"Core data video: %@", photoMO.url_string);
        }];
    } else if ([self.media isKindOfClass:[LBSong class]]) {
        
        __weak LBSong *song = (LBSong*)_media;
        
        [moc performBlock:^{
            
            LBPhoto* photoMO = (LBPhoto*)[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([LBPhoto class]) inManagedObjectContext:moc];
            
            [photoMO setUrl_string:[song.image.url absoluteString]];
            [photoMO setFailed:NO];
            [photoMO setFiltered:NO];
            
            
            LBSong* songMO =  (LBSong*) [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([LBSong class]) inManagedObjectContext:moc];
            
            [songMO setId:song.id];
            [songMO setName:song.name];
            [songMO setImage:photoMO];
            [songMO setImage310:photoMO];
            [songMO setListen_no:song.listen_no];
            [songMO setPrice:song.price];
            [songMO setSinger:song.singer];
            [songMO setUrl:song.url];
            [songMO setFetch_datetime:[NSDate date]];
            [songMO setMedia_url:song.media_url];
            [songMO setLocate_path:song.locate_path];
            [songMO setDownload_url:song.download_url];
            [songMO setMedia_url_mono:song.media_url_mono];
            [songMO setMedia_url_pre:song.media_url_pre];
            
            /*Save child context*/
            [moc save:nil];
            
            /*Save data to store*/
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[HCDCoreDataStackController sharedInstanceWithSQLiteStore] save:^(BOOL success, NSError *error) {
                    
                    if (error) {
                        
                        for (NSMergeConflict* conflict in [error.userInfo valueForKey:@"conflictList"]) {
                            
                            NSLog(@"MyKeeng Conflicted: %@", conflict);
                        }
                        
                    }
                }];
            });
            
            NSLog(@"Core data song: %@", photoMO.url_string);
            }];
    }
}


@end
