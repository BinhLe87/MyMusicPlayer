//
//  LBHomeNewSongCell.h
//  MyKeeng
//
//  Created by Le Van Binh on 7/12/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBSong.h"

@protocol LBHomeNewSongCellDelegate <NSObject>

-(void)tapOnMenuPopup:(LBSong*)song;

@end


@interface LBHomeNewSongCell : UITableViewCell

+(NSString *)reusableCellWithIdentifier;

@property (strong, nonatomic) IBOutlet UILabel *SongNameLbl;

@property (weak, nonatomic) IBOutlet UILabel *SingerLbl;
@property (weak, nonatomic) IBOutlet UILabel *NumListenLbl;

@property (weak, nonatomic) IBOutlet UILabel *NumLikeLbl;


@property (weak, nonatomic) IBOutlet UILabel *NumCommentLbl;


@property (weak, nonatomic) IBOutlet UIImageView *SongImg;


@property (nonatomic) NSString *songname;

@property (nonatomic, weak) LBSong *song;

@property (weak, nonatomic) IBOutlet UIImageView *menuMoreImg;

@property (nonatomic) id<LBHomeNewSongCellDelegate> delegate;


@end
