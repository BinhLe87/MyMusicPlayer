//
//  LBMediaInsertCoreData.h
//  MyKeeng
//
//  Created by Le Van Binh on 8/13/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LBMedia;
@class HCDCoreDataStackController;

typedef NS_OPTIONS(NSUInteger, LBMediaCoreDataAction) {
    
    LBMediaCoreDataActionInsert = 1 << 0, //insert
    LBMediaCoreDataActionUpdate = 1 << 1, //update
    LBMediaCoreDataActionDelete = 1 << 2 //delete
    
};
@interface LBMediaCoreDataOperation : NSOperation

@property (nonatomic, readonly) LBMedia *media;
@property (nonatomic) NSIndexPath *indexPath;
@property (nonatomic) LBMediaCoreDataAction coreDataAction;


-(instancetype)initWithMedia:(LBMedia*)media coreDataAction:(LBMediaCoreDataAction)iCoreDataAction;
-(void)insertMediaToCoreData;
-(void)updateMediaToCoreData;
-(void)deleteMediaToCoreData;

@end
