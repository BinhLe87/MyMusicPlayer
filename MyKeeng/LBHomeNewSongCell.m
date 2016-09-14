//
//  LBHomeNewSongCell.m
//  MyKeeng
//
//  Created by Le Van Binh on 7/12/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import "LBHomeNewSongCell.h"
#import "UILabel+dynamicSizeMe.h"

@implementation LBHomeNewSongCell

- (void)awakeFromNib {
    
    [super awakeFromNib];

}

-(void)layoutSubviews {
    
    [_SongNameLbl sizeToFit];
    
  }

+(NSString *)reusableCellWithIdentifier {
    
    return @"SongCellID";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}



@end
