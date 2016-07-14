//
//  LBHomeNewVC.m
//  MyKeeng
//
//  Created by Le Van Binh on 7/12/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import "LBHomeNewVC.h"
#import "LBHomeNewSongCell.h"
#import "LBHomeNewVideoCell.h"


@interface LBHomeNewVC () {
    
    
}


@end

@implementation LBHomeNewVC

int HOMENEW_CELL_WIDTH = 320;

#pragma mark - Constant variables
static const int HOMENEW_SONGCELL_HEIGHT = 120;
static const int HOMENEW_VIDEOCELL_HEIGHT = 150;

static int curPageIdx = 0;
static const int NUM_ROW_PER_PAGE = 10;


#pragma mark - Load view

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HOMENEW_CELL_WIDTH = CGRectGetWidth(self.view.bounds);
    
    //register LBHomeNewSongCell nib file
    UINib *songCellNib = [UINib nibWithNibName:@"LBHomeNewSongCell" bundle:nil];
    [self.tableview registerNib:songCellNib forCellReuseIdentifier:[LBHomeNewSongCell reusableCellWithIdentifier]];
    
    //register LBHomeNewVideoCell nib file
    UINib *videoCellNib = [UINib nibWithNibName:@"LBHomeNewVideoCell" bundle:nil];
    [self.tableview registerNib:videoCellNib forCellReuseIdentifier:[LBHomeNewVideoCell reusableCellWithIdentifier]];
    
    //set seperator style
    [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
    
    _medias = [[NSMutableArray alloc] init];
    //load first page
    curPageIdx = 1;
    [self loadHomePage:curPageIdx size:NUM_ROW_PER_PAGE];
}

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
        
        LBHomeNewVideoCell *videoCell;
        
        videoCell = (LBHomeNewVideoCell *)[tableView dequeueReusableCellWithIdentifier:[LBHomeNewVideoCell reusableCellWithIdentifier] forIndexPath:indexPath];
        
        
        // Configure the cell...
        videoCell.cellSize = CGSizeMake(HOMENEW_CELL_WIDTH, HOMENEW_VIDEOCELL_HEIGHT);
  
        
        [videoCell.VideoImg setImageWithURL:[NSURL URLWithString:media.image]];
        
        videoCell.VideoNameLbl.text = media.name;
      //  videoCell.SingerLbl.text = media.singer;
     //   videoCell.NumListenLbl.text = [NSString stringWithFormat:@"%d", [media.listen_no intValue]];
        videoCell.NumLikeLbl.text = @"New Video";
        videoCell.NumCommentLbl.text = [NSString stringWithFormat:@"Giá %d", [media.price intValue]];
        
        //display seperator image at the bottom of cell
        UIImageView *seperatorImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separator_cell.png"]];
        seperatorImgView.frame = CGRectMake(0, HOMENEW_VIDEOCELL_HEIGHT - 1 , HOMENEW_CELL_WIDTH, 1);
        
        [videoCell.contentView addSubview:seperatorImgView];
        
        return videoCell;
        
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[_medias objectAtIndex:indexPath.row] isKindOfClass:[LBSong class]]) {
        
        return HOMENEW_SONGCELL_HEIGHT;
    } else {
        
        return HOMENEW_VIDEOCELL_HEIGHT;
    }
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
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

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
            
            [self.medias addObject:media];
        }
    }
}


@end
