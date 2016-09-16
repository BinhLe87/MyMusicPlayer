//
//  LBHomeNewWithFavouriteVC.m
//  MyKeeng
//
//  Created by Le Van Binh on 7/12/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import "LBHomeNewWithFavouriteVC.h"
#import "LBHomeNewSongCell.h"
#import "LBVideoCell.h"
#import "LBVideoPlayerViewController.h"
#import "MyKeengUtilities.h"
#import <NSValueTransformer+MTLPredefinedTransformerAdditions.h>
#import "LBPhoto.h"
#import "LBPhotoDownloader.h"
#import "LBPhotoFiltration.h"
#import "UIImageView+WebCache.h"
#import "LBMediaCoreDataOperation.h"
#import "LBCoreDataConn.h"
#import "LBMenuView.h"
#import "UIView+Extensions.h"
#import "UIResponder+Extensions.h"
#import "LBFavouriteCell.h"

typedef NS_ENUM(NSUInteger, TableSectionType) {
    
    TableSectionTypeVideo = 0,
    TableSectionTypeSong = 2,
    TableSectionTypeFavourite = 1
};


@interface LBHomeNewWithFavouriteVC () {
    
    int curPageIdx;
    LBMenuView *menuPopupView;
}
@end

@implementation LBHomeNewWithFavouriteVC

@synthesize managedObjectContext = _managedObjectContext;

int HOMENEW_CELL_WIDTH_NEW = 320;

#pragma mark - Constant variables


static const int NUM_ROW_PER_PAGE_NEW = 10;

#pragma mark - Initializers

-(NSMutableArray<LBSong *> *)songs {
    
    if (!_songs) {
        _songs = [NSMutableArray array];
    }
    
    return _songs;
}

-(NSMutableArray<LBVideo *> *)videos {
    
    if (!_videos) {
        _videos = [NSMutableArray array];
    }
    
    return _videos;
}

-(NSMutableArray<LBMedia *> *)favourites {
    
    if (!_favourites) {
        _favourites = [NSMutableArray array];
    }
    
    return _favourites;
}

-(NSOperationQueue *)LBMediaCoreDataQueue {
    
    if (!_LBMediaCoreDataQueue) {
        _LBMediaCoreDataQueue = [[NSOperationQueue alloc] init];
        _LBMediaCoreDataQueue.name = @"LBMediaCoreData Queue";
        _LBMediaCoreDataQueue.maxConcurrentOperationCount = 10;
    }
    
    return _LBMediaCoreDataQueue;
}

#pragma mark - Load view

-(LBPhotoOperations *)photoOperations {
    
    if (!_photoOperations) {
        
        _photoOperations = [[LBPhotoOperations alloc] init];
    }
    
    return _photoOperations;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HOMENEW_CELL_WIDTH_NEW = CGRectGetWidth(self.view.bounds);
    
    //register LBHomeNewSongCell nib file
    _tableview = [[LBTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    [self.view addSubview:_tableview];
    
    UINib *songCellNib = [UINib nibWithNibName:@"LBHomeNewSongCell" bundle:nil];
    [self.tableview registerNib:songCellNib forCellReuseIdentifier:[LBHomeNewSongCell reusableCellWithIdentifier]];
    
    //register LBVideoCell nib file
    UINib *videoCellNib = [UINib nibWithNibName:@"LBVideoCell" bundle:nil];
    [self.tableview registerNib:videoCellNib forCellReuseIdentifier:[LBVideoCell reusableCellWithIdentifier]];
    
    //set seperator style
    [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    connManager = [[LBConnManager alloc] init];
    
    //set status bar
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars=NO;
    self.automaticallyAdjustsScrollViewInsets=YES;
    
    //load first page
    curPageIdx = 1;
    [self loadDataAtPage:curPageIdx size:NUM_ROW_PER_PAGE_NEW completion:^(BOOL succeed, NSError *error) {
        
        if (succeed) {
            
            [self.tableview reloadData];
        }
    }];
    
    
    //clear cache
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDisk];
    
    //initiate menu popup view
    NSMutableArray<LBMenuItem *> *menuitems = [NSMutableArray array];
    LBMenuItem *menuItemShare = [[LBMenuItem alloc] initMenuItem:@"Chia sẻ" target:self action:@selector(tapMenuShare:)];
    LBMenuItem *menuItemAddFavourite = [[LBMenuItem alloc] initMenuItem:@"Lưu vào danh sách Yêu thích" target:self action:@selector(tapMenuAddFavourite:)];
    
    [menuitems addObjectsFromArray:@[menuItemShare, menuItemAddFavourite]];
    
    menuPopupView = [[LBMenuView alloc] initWithMenuItems:menuitems];
}

-(BOOL)prefersStatusBarHidden {
    
    return YES;
}



-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}

//-(void)viewWillDisappear:(BOOL)animated {
//
//    [self.navigationController setNavigationBarHidden:NO];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    
    if (section == TableSectionTypeSong) {
        return _songs.count;
    } else if (section == TableSectionTypeVideo) {
        return 5;
    } else if (section == TableSectionTypeFavourite) {
        return 1;
    }
    
    return 0;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
         // do whatever
         
         switch (orientation) {
             case UIDeviceOrientationPortrait:
                 HOMENEW_CELL_WIDTH_NEW = CGRectGetWidth(self.view.bounds);
                 break;
                 
             case UIDeviceOrientationLandscapeLeft:
                 HOMENEW_CELL_WIDTH_NEW = CGRectGetWidth(self.view.bounds);
                 break;
                 
             default:
                 HOMENEW_CELL_WIDTH_NEW = CGRectGetWidth(self.view.bounds);
                 break;
         }
         
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
         [self.tableview reloadData];
     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LBMedia *media = indexPath.section == TableSectionTypeSong ? [_songs objectAtIndex:indexPath.row
                                                                  ] : [_videos objectAtIndex:indexPath.row];
    LBPhoto *photo = media.image;
    
    if (indexPath.section == TableSectionTypeSong) {
        
        //TODO: Song - load cell
        LBHomeNewSongCell *songCell;
        
        songCell = (LBHomeNewSongCell *)[tableView dequeueReusableCellWithIdentifier:[LBHomeNewSongCell reusableCellWithIdentifier] forIndexPath:indexPath];
        songCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        SDWebImageOptions songDownloadOptions = SDWebImageProgressiveDownload | SDWebImageContinueInBackground | SDWebImageTransformAnimatedImage;
        
        
        [songCell.SongImg sd_setImageWithURL:photo.url placeholderImage:[UIImage imageNamed:@"image_placeholder.png"] options:songDownloadOptions];
        
        [songCell.SongImg setShowActivityIndicatorView:YES];
        
        
        songCell.SongNameLbl.text = media.name;
        songCell.SingerLbl.text = media.singer;
        songCell.NumListenLbl.text = [NSString stringWithFormat:@"%d", [media.listen_no intValue]];
        songCell.NumLikeLbl.text = @"New Song";
        songCell.NumCommentLbl.text = [NSString stringWithFormat:@"Giá %d", [media.price intValue]];
        songCell.song = (LBSong*)media;
        
        //display seperator image at the bottom of cell
        UIImageView *seperatorImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separator_cell.png"]];
        seperatorImgView.frame = CGRectMake(0, [LBHomeNewSongCell heightForSongCell] - 1 , HOMENEW_CELL_WIDTH_NEW, 1);
        
        [songCell.contentView addSubview:seperatorImgView];
        
        
        return songCell;
    } else if (indexPath.section == TableSectionTypeVideo) {
        
        //TODO: Video - load cell
        LBVideoCell *videoCell;
        
        videoCell = (LBVideoCell *)[tableView dequeueReusableCellWithIdentifier:[LBVideoCell reusableCellWithIdentifier] forIndexPath:indexPath];
        
        SDWebImageOptions videoDownloadOptions = SDWebImageProgressiveDownload | SDWebImageContinueInBackground | SDWebImageTransformAnimatedImage;
        
        [videoCell.VideoImg sd_setImageWithURL:photo.url placeholderImage:[UIImage imageNamed:@"image_placeholder.png"] options:videoDownloadOptions progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
            //  NSLog(@"%@:%@:%d/%d", media.name, media.image.url, receivedSize, expectedSize);
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        [videoCell.VideoImg setShowActivityIndicatorView:YES];
        
        [videoCell setVideoInfo:(LBVideo *)media];
        [videoCell setupUI];
        
        //display seperator image at the bottom of cell
        UIImageView *seperatorImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separator_cell.png"]];
        seperatorImgView.frame = CGRectMake(0, [LBVideoCell heightForVideoCell] - 1 , HOMENEW_CELL_WIDTH_NEW, 1);
        
        [videoCell.contentView addSubview:seperatorImgView];
        
        return videoCell;
        
    } else if (indexPath.section == TableSectionTypeFavourite) {
        
        CGRect favouriteCellFrame = CGRectMake(0, 0, self.tableview.bounds.size.width, [LBFavouriteCell heightForFavouriteCell] - [LBFavouriteCell marginY]*2);
        
        CGSize favouriteCellContentSize = CGSizeMake(self.tableview.bounds.size.width * 2, [LBFavouriteCell heightForFavouriteCell] - [LBFavouriteCell marginY]*2);
        
        LBFavouriteCell *favouriteCell = [[LBFavouriteCell alloc] initWithFrameAndContentSize: favouriteCellFrame contentSize:favouriteCellContentSize];
        
        [favouriteCell setFavourites:_favourites];
        
        //display seperator image at the bottom of cell
        UIImageView *seperatorImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separator_cell.png"]];
        seperatorImgView.frame = CGRectMake(0, [LBFavouriteCell heightForFavouriteCell] - 1 , HOMENEW_CELL_WIDTH_NEW, 1);
        
        [favouriteCell.contentView addSubview:seperatorImgView];
        
        return favouriteCell;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == TableSectionTypeSong) {
        
        return [LBHomeNewSongCell heightForSongCell];
    } else if (indexPath.section == TableSectionTypeVideo) {
        
        return [LBVideoCell heightForVideoCell];
    } else if (indexPath.section == TableSectionTypeFavourite) {
        
        return [LBFavouriteCell heightForFavouriteCell];
    }
    
    return 0;
}

-(void)loadDataAtPage:(int)iPage size:(int)iSize completion:(void (^)(BOOL, NSError *))iCompletion {
    
    fetchDataState = FetchDataStateNotStarted;
    
    curPageIdx = iPage;
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        fetchDataState = FetchDataStateIsExecuting;
        
        [connManager getHomeNewMedias:iPage size:iSize performWithCompletion:^(BOOL succeed, NSError *error, NSMutableArray<LBMedia *> *medias) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (succeed) {
                    
                    for (LBMedia *media in medias) {
                        
                        if ([media isKindOfClass:[LBSong class]]) {
                            
                            [weakself.songs addObject:(LBSong*)media];
                        } else if ([media isKindOfClass:[LBVideo class]]) {
                            
                            [weakself.videos addObject:(LBVideo*)media];
                        }
                        
                        [weakself.favourites addObject:media];
                        
                        
                        //insert row into core data
                        LBMediaCoreDataOperation *mediaCoreDataOperation = [[LBMediaCoreDataOperation alloc] initWithMedia:media coreDataAction:LBMediaCoreDataActionInsert];
                        
                        [self.LBMediaCoreDataQueue addOperation:mediaCoreDataOperation];
                    }
                    
                    /*NSMutableArray *insertIndexPaths = [[NSMutableArray alloc] init];
                    
                    for (int i =0; i < medias.count; i++) {
                        
                        [insertIndexPaths addObject:[NSIndexPath indexPathForRow:curRowCount+i inSection:0]];
                    }
                    
                    //  [weakself.tableview beginUpdates];
                    
                    [weakself.tableview insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
                    
                    //   [weakself.tableview endUpdates];*/
                    
                    fetchDataState = FetchDataStateDone;
                    
                    iCompletion(true, nil);
                } else {
                    
                    [weakself showMessageInPopup:(error ? error.localizedDescription : @"Error fetching data from server!") withTitle:@"Warning!"];
                    
                    iCompletion(false, error);
                }});
        }];
    });
    
}

#pragma mark - Table view Delegates
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*LBMedia *media = [_medias objectAtIndex:indexPath.row];
    
    if ([media isKindOfClass:[LBVideo class]]) {
        
        LBVideoPlayerViewController *videoPlayerVC = [[LBVideoPlayerViewController alloc] initWithNibName:@"LBVideoPlayerViewController" bundle:nil];
        videoPlayerVC.mainVideo = (LBVideo*) media;
        
        
        [self.navigationController pushViewController:videoPlayerVC animated:YES];
    }*/
}


#pragma mark - LBHomeNewSongCellDelegate
-(void)tapOnMenuPopup:(UITapGestureRecognizer *)tapGesture fromTouchPoint:(CGPoint)fromTouchPoint {
    
    NSLog(@"Da tap menupopup");
    CGPoint point = (tapGesture ? [tapGesture locationInView:self.view] : fromTouchPoint);
    
    [menuPopupView showMenuInView:self.view fromOwnerRect:(CGRect){point, CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height)}];
}

#pragma mark - Gestures
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    //TODO: Expand touch area for menu icon in table cell if exists
    CGPoint locationInTableView = [touch locationInView:self.tableview];
    NSIndexPath *tappedIndexPath = [self.tableview indexPathForRowAtPoint:locationInTableView];
    
    UITableViewCell *tappedCell = [self.tableview cellForRowAtIndexPath:tappedIndexPath];
    if ([tappedCell isKindOfClass:[LBHomeNewSongCell class]]) {
        
        LBHomeNewSongCell *songCell = (LBHomeNewSongCell*)tappedCell;
        CGPoint pointTappedInMenuIconRect = [songCell.menuMoreImg convertPoint:locationInTableView fromView:self.tableview];
        
        CGRect extendedMenuIconRect = CGRectInset(songCell.menuMoreImg.bounds, -10, -10);
        
        if (CGRectContainsPoint(extendedMenuIconRect, pointTappedInMenuIconRect)) {
            
            CGRect menuIconRectInCellView = songCell.menuMoreImg.frame;
            
            [self tapOnMenuPopup:nil fromTouchPoint:[songCell.contentView convertPoint:CGPointMake(menuIconRectInCellView.origin.x, menuIconRectInCellView.origin.y) toView:self.view]];
        }
    }
    
    [super touchesBegan:touches withEvent:event];
}



#pragma mark - Menu popup actions
-(void)tapMenuShare:(id)sender {
    
    NSLog(@"Da tap 'Chia sẻ'");
}

-(void)tapMenuAddFavourite:(id)sender {
    
    NSLog(@"Da tap 'Lưu vào danh sách Yêu thích'");
}



@end
