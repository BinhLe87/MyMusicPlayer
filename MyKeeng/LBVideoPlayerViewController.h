//
//  LBVideoPlayerViewController.h
//  MyKeeng
//
//  Created by Le Van Binh on 7/19/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBVideo.h"
#import "LBVideoCell.h"
#import "LBVideoCellPlayer.h"

@interface LBVideoPlayerViewController : UIViewController <LBVideoCellPlayerDelegate> {
    
    NSManagedObjectContext *_managedObjectContext;
}

@property (nonatomic) LBVideo *mainVideo;
@property (nonatomic, retain) IBOutlet UITableView *tableview;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic) NSMutableArray <LBMedia *> *medias;


@property (weak, nonatomic) IBOutlet UIView *videoSectionView;

@property (nonatomic) LBVideoCellPlayer *videoPlayer;

-(void)loadHomePage:(int)page size:(int)size;

+(void)showVideoPlayer:(LBVideo *)video;

-(void)reloadData;

-(void)enterFullScreen;

-(void)finishPlayCurrentMovie;

-(int)getIndexOfLeastGreaterObject:(LBVideo *)video;

@end
