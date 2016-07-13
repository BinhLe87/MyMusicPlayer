//
//  LBHomeNewSongCell.h
//  MyKeeng
//
//  Created by Le Van Binh on 7/12/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBHomeNewSongCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *SongNameLbl;

@property (weak, nonatomic) IBOutlet UILabel *SingerLbl;
@property (weak, nonatomic) IBOutlet UILabel *NumListenLbl;

@property (weak, nonatomic) IBOutlet UILabel *NumLikeLbl;


@property (weak, nonatomic) IBOutlet UILabel *NumCommentLbl;


@property (weak, nonatomic) IBOutlet UIImageView *SongImg;

@end
