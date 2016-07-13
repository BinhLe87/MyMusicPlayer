//
//  LBHomeNewVC.m
//  MyKeeng
//
//  Created by Le Van Binh on 7/12/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import "LBHomeNewVC.h"
#import "LBHomeNewSongCell.h"



@interface LBHomeNewVC () {
    
   
}


@end

@implementation LBHomeNewVC

int HOMENEW_CELL_WIDTH = 320;

#pragma mark - Constant variables
static const int HOMENEW_CELL_HEIGHT = 120;


#pragma mark - Load view

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HOMENEW_CELL_WIDTH = CGRectGetWidth(self.view.bounds);
    
    UINib *mediaCellNib = [UINib nibWithNibName:@"LBHomeNewSongCell" bundle:nil];
    [self.tableview registerNib:mediaCellNib forCellReuseIdentifier:@"SongCell"];
    
    //set seperator style
    [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
    
    _medias = [[NSMutableArray alloc] init];
    //load first page
    [self loadHomePage:1 size:10];
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
    LBHomeNewSongCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SongCell" forIndexPath:indexPath];
    
    LBMedia *media = [self.medias objectAtIndex:indexPath.row];
    
    // Configure the cell...

    [cell.SongImg setImageWithURL:[NSURL URLWithString:media.image]];
    
    cell.SongNameLbl.text = media.name;
    cell.SingerLbl.text = media.singer;
    cell.NumListenLbl.text = [NSString stringWithFormat:@"%d", [media.listen_no intValue]];
    
    cell.NumLikeLbl.text = [NSString stringWithFormat:@"Thích %d", [media.total_like intValue]];
    cell.NumCommentLbl.text = [NSString stringWithFormat:@"Bình luận %d", [media.number_comment intValue]];
    
    //display seperator image at the bottom of cell
    UIImageView *seperatorImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separator_cell.png"]];
    seperatorImgView.frame = CGRectMake(0, HOMENEW_CELL_HEIGHT - 1 , HOMENEW_CELL_WIDTH, 1);
    
    [cell.contentView addSubview:seperatorImgView];
    
    
    
    
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return HOMENEW_CELL_HEIGHT;
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
