//
//  LBHomeNewVC.m
//  MyKeeng
//
//  Created by Le Van Binh on 7/12/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import "LBHomeNewVC.h"
#import "LBHomeNewSongCell.h"
#import "LBVideoCell.h"
#import "LBVideoPlayerViewController.h"
#import "MyKeengUtilities.h"
#import <NSValueTransformer+MTLPredefinedTransformerAdditions.h>
#import "LBPhoto.h"
#import "LBPhotoDownloader.h"
#import "LBPhotoFiltration.h"


@interface LBHomeNewVC () {
    
    int curPageIdx;
}


@end

@implementation LBHomeNewVC

@synthesize managedObjectContext = _managedObjectContext;

int HOMENEW_CELL_WIDTH = 320;

#pragma mark - Constant variables
static const int HOMENEW_SONGCELL_HEIGHT = 120;

static const int NUM_ROW_PER_PAGE = 10;

#pragma mark - Initializers
-(NSMutableArray<LBMedia *> *)medias {
    
    if (!_medias) {
        
        _medias = [[NSMutableArray alloc] init];
    }
    
    return _medias;
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
    
    HOMENEW_CELL_WIDTH = CGRectGetWidth(self.view.bounds);
    
    //register LBHomeNewSongCell nib file
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
    [self loadDataAtPage:curPageIdx size:NUM_ROW_PER_PAGE completion:^(BOOL succeed, NSError *error) {
        
        if (succeed) {
            
            [self.tableview reloadData];
        }
    }];
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return _medias.count;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
         // do whatever
         
         switch (orientation) {
             case UIDeviceOrientationPortrait:
                 HOMENEW_CELL_WIDTH = CGRectGetWidth(self.view.bounds);
                 break;
                 
             case UIDeviceOrientationLandscapeLeft:
                 HOMENEW_CELL_WIDTH = CGRectGetWidth(self.view.bounds);
                 break;
                 
             default:
                 HOMENEW_CELL_WIDTH = CGRectGetWidth(self.view.bounds);
                 break;
         }
         
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
         [self.tableview reloadData];
     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LBMedia *media = [self.medias objectAtIndex:indexPath.row];
    LBPhoto *photo = media.image;
    
    if ([media isKindOfClass:[LBSong class]]) {
        
        //TODO: Song - load cell
        LBHomeNewSongCell *songCell;
        
        songCell = (LBHomeNewSongCell *)[tableView dequeueReusableCellWithIdentifier:[LBHomeNewSongCell reusableCellWithIdentifier] forIndexPath:indexPath];
        songCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicatorView.center = CGPointMake(CGRectGetMidX(songCell.SongImg.bounds), CGRectGetMidY(songCell.SongImg.bounds));
        
        
        songCell.SongImg.image = [UIImage imageNamed:@"image_placeholder.png"];
        [activityIndicatorView setTag:[media.id integerValue]];
        [songCell.SongImg addSubview:activityIndicatorView];
        
        if (photo) {
            
            if (photo.hasImage) {
                
                [activityIndicatorView stopAnimating];
                songCell.SongImg.image = photo.image;
            } else if (photo.isFailed) {
                
                [activityIndicatorView stopAnimating];
                songCell.SongImg.image = [UIImage imageNamed:@"image_unavailable.png"];
            } else { //photo is not yet downloaded
                
                [activityIndicatorView startAnimating];
                [self startOperationsAtIndexPath:photo indexPath:indexPath];
            }
        }
        
        songCell.SongNameLbl.text = media.name;
        songCell.SingerLbl.text = media.singer;
        songCell.NumListenLbl.text = [NSString stringWithFormat:@"%d", [media.listen_no intValue]];
        songCell.NumLikeLbl.text = @"New Song";
        songCell.NumCommentLbl.text = [NSString stringWithFormat:@"Giá %d", [media.price intValue]];
        
        //display seperator image at the bottom of cell
        UIImageView *seperatorImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separator_cell.png"]];
        seperatorImgView.frame = CGRectMake(0, HOMENEW_SONGCELL_HEIGHT - 1 , HOMENEW_CELL_WIDTH, 1);
        
        [songCell.contentView addSubview:seperatorImgView];
        
        
        
        return songCell;
    } else if ([media isKindOfClass:[LBVideo class]]) {
        
        //TODO: Video - load cell
        LBVideoCell *videoCell;
        
        videoCell = (LBVideoCell *)[tableView dequeueReusableCellWithIdentifier:[LBVideoCell reusableCellWithIdentifier] forIndexPath:indexPath];
        
        [videoCell setVideoInfo:(LBVideo *)media];
        
        videoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicatorView.center = CGPointMake(CGRectGetMidX(videoCell.VideoImg.bounds), CGRectGetMidY(videoCell.VideoImg.bounds));
        
        
        
        [videoCell.VideoImg addSubview:activityIndicatorView];
        
        
        if (photo) {
            
            if (photo.hasImage) {
                
                [activityIndicatorView stopAnimating];
                videoCell.VideoImg.image = photo.image;
            } else if (photo.isFailed) {
                
                [activityIndicatorView stopAnimating];
                videoCell.VideoImg.image = [UIImage imageNamed:@"image_unavailable.png"];
            } else { //photo is not yet downloaded
                
                videoCell.VideoImg.image = [UIImage imageNamed:@"image_placeholder.png"];
                [activityIndicatorView startAnimating];
                if (!self.tableview.isDragging && !self.tableview.decelerating) {
                    [self startOperationsAtIndexPath:photo indexPath:indexPath];
                }
            }
        }
        
        videoCell.VideoNameLbl.text = media.name;
        videoCell.SingerLbl.text = media.singer;
        videoCell.NumListenLbl.text = [NSString stringWithFormat:@"%d", [media.listen_no intValue]];
        videoCell.NumLikeLbl.text = @"New Video";
        videoCell.NumCommentLbl.text = [NSString stringWithFormat:@"Giá %d", [media.price intValue]];
        
        //display seperator image at the bottom of cell
        UIImageView *seperatorImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separator_cell.png"]];
        seperatorImgView.frame = CGRectMake(0, [LBVideoCell heightForVideoCell] - 1 , HOMENEW_CELL_WIDTH, 1);
        
        [videoCell.contentView addSubview:seperatorImgView];
        
        return videoCell;
        
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[_medias objectAtIndex:indexPath.row] isKindOfClass:[LBSong class]]) {
        
        return HOMENEW_SONGCELL_HEIGHT;
    } else {
        
        return [LBVideoCell heightForVideoCell];
    }
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
                    
                    int curRowCount = weakself.medias.count;
                    for (LBMedia *media in medias) {
                        
                        [weakself.medias addObject:media];
                    }
                    
                    NSMutableArray *insertIndexPaths = [[NSMutableArray alloc] init];
                    
                    for (int i =0; i < medias.count; i++) {
                        
                        [insertIndexPaths addObject:[NSIndexPath indexPathForRow:curRowCount+i inSection:0]];
                    }
                    
                    [weakself.tableview beginUpdates];
                    
                    [weakself.tableview insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
                    
                    [weakself.tableview endUpdates];
                    
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
    
    LBMedia *media = [_medias objectAtIndex:indexPath.row];
    
    if ([media isKindOfClass:[LBVideo class]]) {
        
        LBVideoPlayerViewController *videoPlayerVC = [[LBVideoPlayerViewController alloc] initWithNibName:@"LBVideoPlayerViewController" bundle:nil];
        videoPlayerVC.mainVideo = (LBVideo*) media;
        
        
        [self.navigationController pushViewController:videoPlayerVC animated:YES];
    }
}

#pragma mark - Scroll view
//
//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    __weak LBHomeNewVC *myWeak = self;
//
//    if (indexPath.row % NUM_ROW_PER_PAGE == 1) { //when at the first row of every page, will load next page on background
//
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//
//            curPageIdx++;
//            //[self loadHomePage:curPageIdx size:NUM_ROW_PER_PAGE isFirstLoad:NO];
//            [connManager getHomeNewMedias:curPageIdx size:NUM_ROW_PER_PAGE performWithCompletion:^(BOOL succeed, NSError *error, NSMutableArray<LBMedia *> *medias) {
//
//                if (succeed) {
//
//                    for (LBMedia *media in medias) {
//
//                        [myWeak.medias addObject:media];
//                    }
//                }
//
//            }];
//        });
//    }
//}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self suspendAllOperations];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (!decelerate) {
        
        [self loadImagesForOnScreenCells];
        [self resumeAllOperations];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self loadImagesForOnScreenCells];
    [self resumeAllOperations];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGPoint contentOffset =[self.tableview contentOffset];
    NSIndexPath *scroolToIndexPath = [self.tableview indexPathForRowAtPoint:CGPointMake(contentOffset.x, self.tableview.bounds.size.height + contentOffset.y)];
    
    
    if ([scroolToIndexPath row] == [self.medias count] - 1 && (fetchDataState != FetchDataStateIsExecuting)) { //scroll reach last row
        
        // if (self.tableview.contentOffset.y > self.tableview.contentSize.height - self.tableview.bounds.size.height) {
        [self loadDataAtPage:curPageIdx+1 size:NUM_ROW_PER_PAGE completion:^(BOOL succeed, NSError *error) {
            
        }];
    }
}




#pragma mark - Operations: Image downloader and image filtration

-(void)loadImagesForOnScreenCells {
    
    NSSet *visibleRows = [NSSet setWithArray:[self.tableview indexPathsForVisibleRows]];
    
    NSMutableSet *pendingOperations = [NSMutableSet setWithArray:[self.photoOperations.downloadOperations allKeys]];
    [pendingOperations addObjectsFromArray:[self.photoOperations.filterOperations allKeys]];
    
    NSMutableSet *tobeCanceled = [pendingOperations mutableCopy];
    NSMutableSet *tobeStarted = [visibleRows mutableCopy];
    
    
    [tobeCanceled minusSet:visibleRows];
    [tobeStarted minusSet:pendingOperations];
    
    for (NSIndexPath *aIndexPath in tobeCanceled) {
        
        LBPhotoDownloader *downloader = [self.photoOperations.downloadOperations objectForKey:aIndexPath];
        
        //stop activity animation of this cell
        LBMedia *media = (LBMedia *)[self.medias objectAtIndex:aIndexPath.row];
        if ([media isKindOfClass:[LBSong class]]) {
            
            LBHomeNewSongCell *songCell = (LBHomeNewSongCell*)[self.tableview cellForRowAtIndexPath:aIndexPath];
            [((UIActivityIndicatorView*)[songCell.SongImg viewWithTag:[media.id integerValue]]) stopAnimating];
        } else if ([media isKindOfClass:[LBVideo class]]) {
            
            LBVideoCell *videoCell = (LBVideoCell*)[self.tableview cellForRowAtIndexPath:aIndexPath];
            [((UIActivityIndicatorView*)[videoCell.VideoImg viewWithTag:[media.id integerValue]]) stopAnimating];
        }
        
        if (downloader) {
            [downloader cancel];
            [self.photoOperations.downloadOperations removeObjectForKey:aIndexPath];
            
        }
        
        LBPhotoFiltration *filtration = [self.photoOperations.filterOperations objectForKey:aIndexPath];
        if (filtration) {
            [filtration cancel];
            [self.photoOperations.filterOperations removeObjectForKey:aIndexPath];
        }
    }
    tobeCanceled = nil;
    
    for (NSIndexPath *aIndexPath in tobeStarted) {
        
        LBPhoto* photo = [[self.medias objectAtIndex:aIndexPath.row] image];
        
        [self startOperationsAtIndexPath:photo indexPath:aIndexPath];
    }
    tobeStarted = nil;
    
}

-(void)startOperationsAtIndexPath:(LBPhoto *)iPhoto indexPath:(NSIndexPath *)iIndexPath {
    
    if (!iPhoto.hasImage) {
        
        [self startImageDownloadingAtIndexPath:iPhoto indexPath:iIndexPath];
    }
    
    if (!iPhoto.isFiltered) {
        
        [self startImageFiltrationAtIndexPath:iPhoto indexPath:iIndexPath];
    }
}

-(void)startImageDownloadingAtIndexPath:(LBPhoto *)iPhoto indexPath:(NSIndexPath *)iIndexPath {
    
    if (![self.photoOperations.downloadOperations.allKeys containsObject:iIndexPath]) {
        
        LBPhotoDownloader *downloader = [[LBPhotoDownloader alloc] initWithPhoto:iPhoto indexPath:iIndexPath delegate:self];
        
        [[self.photoOperations downloadOperations] setObject:downloader forKey:iIndexPath];
        [[self.photoOperations downloadQueue] addOperation:downloader];
    }
}

-(void)startImageFiltrationAtIndexPath:(LBPhoto *)iPhoto indexPath:(NSIndexPath *)iIndexPath {
    
    if (![self.photoOperations.filterOperations.allKeys containsObject:iIndexPath]) {
        
        LBPhotoFiltration *filtrator = [[LBPhotoFiltration alloc] initWithPhoto:iPhoto indexPath:iIndexPath delegate:self];
        
        //set dependency: filtration after downloading finished
        LBPhotoDownloader *dependency = [[self.photoOperations downloadOperations] objectForKey:iIndexPath];
        if (dependency) {
            
            [filtrator addDependency:dependency];
        }
        
        [[self.photoOperations filterOperations] setObject:filtrator forKey:iIndexPath];
        [[self.photoOperations filterQueue] addOperation:filtrator];
    }
}

-(void)suspendAllOperations {
    
    [self.photoOperations.downloadQueue setSuspended:YES];
    [self.photoOperations.filterQueue setSuspended:YES];
}

-(void)resumeAllOperations {
    
    [self.photoOperations.downloadQueue setSuspended:NO];
    [self.photoOperations.filterQueue setSuspended:NO];
}

-(void)cancellAllOperations {
    
    [self.photoOperations.downloadQueue cancelAllOperations];
    [self.photoOperations.filterQueue cancelAllOperations];
}


//TODO: implement delegates
-(void)photoDownloaderDidFinish:(LBPhotoDownloader *)downloader {
    
    NSIndexPath *indexPath = downloader.indexPathInTableView;
    
    [self.tableview reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.photoOperations.downloadOperations removeObjectForKey:indexPath];
    
    
}

-(void)LBPhotoFiltrationDidFinish:(LBPhotoFiltration *)filtrator {
    
    NSIndexPath *indexPath = filtrator.indexPathInTableView;
    
    [self.tableview reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.photoOperations.filterOperations removeObjectForKey:indexPath];
}


#pragma mark - Popup message
-(void)showMessageInPopup:(NSString *)message withTitle:(NSString *)title {
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        //do something when click button
    }];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}


@end
