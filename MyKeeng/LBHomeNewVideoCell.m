//
//  LBHomeNewVideoCell.m
//  MyKeeng
//
//  Created by Le Van Binh on 7/14/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import "LBHomeNewVideoCell.h"

@implementation LBHomeNewVideoCell



- (void)awakeFromNib {
    
    // Initialization code
  
    
    [super awakeFromNib];
    
    
   

}

-(void)layoutSubviews {
    
    self.infoView.layer.sublayers = nil;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame =  CGRectMake(0, 0 , _cellSize.width, self.infoView.bounds.size.height);
    
    gradient.colors = @ [(id)[[UIColor colorWithWhite:0 alpha:0.2] CGColor],
                         (id)[[UIColor clearColor] CGColor]];
    
    [self.infoView.layer insertSublayer:gradient atIndex:0];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(NSString *)reusableCellWithIdentifier {
    
    return @"VideoCellID";
}

@end
