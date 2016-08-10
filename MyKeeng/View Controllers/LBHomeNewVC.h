//
//  LBHomeNewVC.h
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

@protocol LBPhotoDownloaderDelegate;
@protocol LBPhotoFiltrationDelegate;


@interface LBHomeNewVC : UIViewController <LBPhotoDownloaderDelegate, LBPhotoFiltrationDelegate> {
    
    NSManagedObjectContext *_managedObjectContext;
    LBConnManager *connManager;
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic) NSMutableArray <LBMedia *> *medias;
@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) LBPhotoOperations *photoOperations;

#pragma mark - Image downloader and image filtration
-(void)startOperationsAtIndexPath:(LBPhoto *)iPhoto indexPath:(NSIndexPath*)iIndexPath;
-(void)startImageDownloadingAtIndexPath:(LBPhoto *)iPhoto indexPath:(NSIndexPath*)iIndexPath;
-(void)startImageFiltrationAtIndexPath:(LBPhoto *)iPhoto indexPath:(NSIndexPath*)iIndexPath;

#pragma mark - Popup message
-(void)showMessageInPopup:(NSString*)message withTitle:(NSString*)title;

@end
