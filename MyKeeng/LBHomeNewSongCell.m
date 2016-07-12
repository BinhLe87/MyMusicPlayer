//
//  LBHomeNewSongCell.m
//  MyKeeng
//
//  Created by Le Van Binh on 7/12/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import "LBHomeNewSongCell.h"

@implementation LBHomeNewSongCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
  
    _SongNameLbl.numberOfLines = 0;
    [_SongNameLbl sizeToFit];
    
    
 
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

@end
