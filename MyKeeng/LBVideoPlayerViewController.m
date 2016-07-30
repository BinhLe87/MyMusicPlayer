//
//  LBVideoPlayerViewController.m
//  MyKeeng
//
//  Created by Le Van Binh on 7/19/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import "LBVideoPlayerViewController.h"
#import "MyKeengUtilities.h"
#import "LBHomeNewVC.h"
#import "LBVideoCell.h"


@interface LBVideoPlayerViewController ()

enum SECTION_TYPE {
    VIDEO_SECTION = 1,
    COMMENT_SECTION = 2
};

-(void) addMediaIntoArray:(LBVideo *)video;

@end

@implementation LBVideoPlayerViewController
@synthesize managedObjectContext = _managedObjectContext;

static int HOMENEW_CELL_WIDTH = 320;

#pragma mark - Constant variables
static const int HOMENEW_SONGCELL_HEIGHT = 120;

static int curPageIdx = 0;
static const int NUM_ROW_PER_PAGE = 10;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //TODO: initialize video player
    _videoPlayer = [[LBVideoCellPlayer alloc] initWithFrame:CGRectMake(0, 0, _videoSectionView.bounds.size.width, _videoSectionView.bounds.size.height)];
    _videoPlayer.delegate = self;
    
    //_videoPlayer.moviePlayer.delegate = self;
    
    [self.videoSectionView addSubview:_videoPlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterFullScreen) name:@"MPMoviePlayerDidEnterFullscreenNotification" object:nil];
    
    //TODO: register NIB files of table cell
    
    HOMENEW_CELL_WIDTH = CGRectGetWidth(self.view.bounds);
    
    
    //register LBVideoCell nib file
    UINib *videoCellNib = [UINib nibWithNibName:@"LBVideoCell" bundle:nil];
    [self.tableview registerNib:videoCellNib forCellReuseIdentifier:[LBVideoCell reusableCellWithIdentifier]];
    
    //set seperator style
    [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    _medias = [[NSMutableArray alloc] init];
    //load first page
    curPageIdx = 1;
    [self loadHomePage:curPageIdx size:NUM_ROW_PER_PAGE];
    
    //TODO: register observer notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishPlayCurrentMovie) name:@"MPMoviePlayerPlaybackDidFinishNotification" object:_videoPlayer.moviePlayer];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [_videoPlayer setContentURL:[NSURL URLWithString:_mainVideo.media_url]];
    self.videoPlayer.moviePlayer.view.alpha = 1.f;
}

-(void)enterFullScreen {
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    [self.view setFrame:CGRectMake(0, 0, size.width, size.height)];
}

-(void)viewDidLayoutSubviews {
    
    _videoPlayer.frame = CGRectMake(0, 0, _videoSectionView.bounds.size.width, _videoSectionView.bounds.size.height);
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
    
    LBVideo *media = [self.medias objectAtIndex:indexPath.row];
    
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [LBVideoCell heightForVideoCell];
    
}

#pragma mark - Table view Delegates
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _mainVideo = (LBVideo*)[_medias objectAtIndex:indexPath.row];
    
    [_videoPlayer setContentURL:[NSURL URLWithString:_mainVideo.media_url]];
    
}

#pragma mark - Scroll view

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row % NUM_ROW_PER_PAGE == 1) { //when at the first row of every page, will load next page on background
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            
            curPageIdx++;
            [self loadHomePage:curPageIdx size:NUM_ROW_PER_PAGE];
        });
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.tableview.contentOffset.y > self.tableview.contentSize.height - self.tableview.bounds.size.height) {
        
        [self.tableview reloadData];
    }
}


#pragma mark - Load table data
-(void)loadHomePage:(int)page size:(int)size {
    
    
    NSDictionary *queryParams = @{@"page" : [NSNumber numberWithInt:page],
                                  @"num": [NSNumber numberWithInt:size]};
    
    
    RKObjectRequestOperation *operation = [[RKObjectManager sharedManager] appropriateObjectRequestOperationWithObject:nil method:RKRequestMethodGET path:KEENG_API_GET_HOME parameters:queryParams];
    
    [operation setCompletionBlockWithSuccess:nil failure:nil];
    // [[RKObjectManager sharedManager] enqueueObjectRequestOperation:operation];
    
    
    // [NSThread sleepForTimeInterval:10];
    [operation start];
    [operation waitUntilFinished];
    
    if (!operation.error) {
        
        for (LBMedia *media in operation.mappingResult.array) {
            
            if ([media isKindOfClass:[LBVideo class]]) {
                
                [self.medias addObject:media];
                //[self addMediaIntoArray:(LBVideo*)media];
            }
        }
    }
}

#pragma mark - Delegates

-(void)finishPlayCurrentMovie {
    
    //play next video has greater listen_no
    int nextVideoIndex = [self getIndexOfLeastGreaterObject:_mainVideo];
    
    if (nextVideoIndex >= 0) {
        
        _mainVideo = (LBVideo*)[_medias objectAtIndex:nextVideoIndex];
        [_videoPlayer setContentURL:[NSURL URLWithString:_mainVideo.media_url]];
        
        [self.tableview reloadData];
        
        [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:nextVideoIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    } else {
        
         NSLog(@"Already played all of videos!");
    }
}

-(void)exitVideoPlayer {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Internal methods

-(void)addMediaIntoArray:(LBVideo *)video {
    
    NSComparator comparator = ^(id obj1, id obj2) {
        NSNumber *id1 = [obj1 valueForKey:@"listen_no"];
        NSNumber *id2 = [obj2 valueForKey:@"listen_no"];
        
        return (NSComparisonResult)[id1 compare:id2];
        
    };
    
    NSUInteger newIndex = [_medias indexOfObject:video inSortedRange:(NSRange){0, [_medias count]} options:NSBinarySearchingInsertionIndex|NSBinarySearchingFirstEqual usingComparator:comparator];
    
    
    if ([_medias count] == 0) { //initialize first element
        
        [_medias insertObject:video atIndex:newIndex];
    }
    
    if (newIndex < [_medias count]) {
        
        if (video.listen_no != [[_medias objectAtIndex:newIndex] listen_no]) {
            
            [_medias insertObject:video atIndex:newIndex];
        } else {
            
            NSLog(@"da co bai hat co luot nghe nay!");
        }
    } else { //highest index means object not yet existed
        
        [_medias insertObject:video atIndex:newIndex];
    }
}


-(int)getIndexOfLeastGreaterObject:(LBVideo *)video {
    
    for (int i=0; i< _medias.count; i++) {
        
        if ([video.id intValue] == [[_medias objectAtIndex:i].id intValue]) {
            
            return i + 1 > [_medias count] - 1 ? 0 : i+1;
        }
    }
    
    
    return 0; //no videos has higher listen_no => play from the beginning of list
}

//-(int)getIndexOfLeastGreaterObject:(LBVideo *)video {
//    
//    for (int i=0; i< _medias.count; i++) {
//        
//        if ([video.listen_no intValue] <= [[[_medias objectAtIndex:i] listen_no] intValue]) {
//            
//            return [video.id isEqualToString:[[_medias objectAtIndex:i] id]] ? (i+1 >= [_medias count] ? -1 : i+1) : i;
//        }
//    }
//    
//    
//    return 0; //no videos has higher listen_no => play from the beginning of list
//}



/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Table view delegate
 
 // In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 // Navigation logic may go here, for example:
 // Create the next view controller.
 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
 
 // Pass the selected object to the new view controller.
 
 // Push the view controller.
 [self.navigationController pushViewController:detailViewController animated:YES];
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
