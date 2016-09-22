//
//  LBHomeNewWithFavouriteVC.h
//  MyKeeng
//
//  Created by Le Van Binh on 7/12/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBMedia.h"
#import "LBSong.h"
#import "LBVideo.h"
#import "LBConnManager.h"
#import "LBPhotoOperations.h"
#import "LBHomeNewVC.h"
#import "LBHomeNewVCBaseClass.h"

@protocol LBPhotoDownloaderDelegate;
@protocol LBPhotoFiltrationDelegate;
@protocol LBHomeNewSongCellDelegate;

@protocol LBHomePageMenuDelegate <NSObject>

-(void)dismissPageMenu;
-(void)regeneratePageMenu;

@end



@interface LBHomeNewWithFavouriteVC : LBHomeNewVCBaseClass <UITableViewDelegate, UITableViewDataSource, LBHomeNewSongCellDelegate> {
    
    NSManagedObjectContext *_managedObjectContext;
    LBConnManager *connManager;
    FetchDataState fetchDataState;
}

@property (nonatomic) UITableView *tableview;
@property (nonatomic) NSMutableArray <LBSong *> *songs;
@property (nonatomic) NSMutableArray <LBVideo *> *videos;
@property (nonatomic) NSMutableArray <LBMedia *> *favourites;
@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) LBPhotoOperations *photoOperations;


@property (nonatomic) NSOperationQueue *LBMediaCoreDataQueue;

-(void)loadDataAtPage:(int)iPage size:(int)iSize completion:(void(^)(BOOL succeed, NSError *error))iCompletion;

#pragma mark - Image downloader and image filtration
-(void)loadImagesForOnScreenCells;
-(void)startOperationsAtIndexPath:(LBPhoto *)iPhoto fromIndexPath:(NSIndexPath*)iIndexPath;
-(void)startImageDownloadingAtIndexPath:(LBPhoto *)iPhoto indexPath:(NSIndexPath*)iIndexPath;
-(void)startImageFiltrationAtIndexPath:(LBPhoto *)iPhoto indexPath:(NSIndexPath*)iIndexPath;
-(void)suspendAllOperations;
-(void)resumeAllOperations;
-(void)cancellAllOperations;

#pragma mark - Popup message
-(void)showMessageInPopup:(NSString*)message withTitle:(NSString*)title;

@end
