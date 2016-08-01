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


@interface LBHomeNewVC () {
    
    
}


@end

@implementation LBHomeNewVC

@synthesize managedObjectContext = _managedObjectContext;

int HOMENEW_CELL_WIDTH = 320;

#pragma mark - Constant variables
static const int HOMENEW_SONGCELL_HEIGHT = 120;

static int curPageIdx = 0;
static const int NUM_ROW_PER_PAGE = 10;


#pragma mark - Load view


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
    _medias = [[NSMutableArray alloc] init];
    //load first page
    curPageIdx = 1;
    
    
    [connManager getHomeNewMedias:curPageIdx size:NUM_ROW_PER_PAGE performWithCompletion:^(BOOL succeed, NSError *error, NSMutableArray<LBMedia *> *medias) {
        
        NSLog(@"Error: %@", error);
        
        
        if (succeed) {
            
            for (LBMedia *media in medias) {
                
                [self.medias addObject:media];
                [self.tableview reloadData];
            }
        }
    }];
    
    
    
    //set status bar
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars=NO;
    self.automaticallyAdjustsScrollViewInsets=YES;
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
         NSLog(@"Xoay hoan tat");
         
         [self.tableview reloadData];
     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LBMedia *media = [self.medias objectAtIndex:indexPath.row];
    
    if ([media isKindOfClass:[LBSong class]]) {
        
        LBHomeNewSongCell *songCell;
        
        songCell = (LBHomeNewSongCell *)[tableView dequeueReusableCellWithIdentifier:[LBHomeNewSongCell reusableCellWithIdentifier] forIndexPath:indexPath];
        
        
        // Configure the cell...
        
        [songCell.SongImg setImageWithURL:[NSURL URLWithString:media.image]];
        
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
        
        LBVideoCell *videoCell;
        
        videoCell = (LBVideoCell *)[tableView dequeueReusableCellWithIdentifier:[LBVideoCell reusableCellWithIdentifier] forIndexPath:indexPath];
        
        
        // Configure the cell...
        videoCell.cellSize = CGSizeMake(HOMENEW_CELL_WIDTH, [LBVideoCell heightForVideoCell]);
        
        [videoCell.VideoImg setImageWithURL:[NSURL URLWithString:media.image]];
        
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

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row % NUM_ROW_PER_PAGE == 1) { //when at the first row of every page, will load next page on background
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            
            curPageIdx++;
            //[self loadHomePage:curPageIdx size:NUM_ROW_PER_PAGE isFirstLoad:NO];
            [connManager getHomeNewMedias:curPageIdx size:NUM_ROW_PER_PAGE performWithCompletion:^(BOOL succeed, NSError *error, NSMutableArray<LBMedia *> *medias) {
                
                
                for (LBMedia *media in medias) {
                    
                    [self.medias addObject:media];
                }
            }];
            
        });
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.tableview.contentOffset.y > self.tableview.contentSize.height - self.tableview.bounds.size.height) {
        
        [self.tableview reloadData];
    }
}



@end
