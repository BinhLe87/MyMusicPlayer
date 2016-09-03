//
//  LBCoreDataConn.h
//  MyKeeng
//
//  Created by Le Van Binh on 8/13/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LBDataConnection.h"

@interface LBCoreDataConn : LBDataConnection

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(void)saveContext;
-(NSURL*) applicationDocumentsDirectory;
-(void)setupCoreDataConfig;

+ (LBCoreDataConn*)sharedLBDataConnection;


@end
