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
    [super awakeFromNib];
    
    NSLog(@"%f-%f", self.bounds.size.height, self.VideoImg.bounds.size.height);
    

    
    [self.infoView setTintColor:[UIColor redColor]];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame =  CGRectMake(0, 0, _cellSize.width, _cellSize.height * 0.8 - round(_cellSize.height * 0.8/2.0));
   
    gradient.colors = @ [(id)[[UIColor colorWithWhite:0 alpha:0.9] CGColor],
                         (id)[[UIColor clearColor] CGColor]];
    
    
    [self.infoView.layer insertSublayer:gradient atIndex:0];
    //self.infoView.alpha = 0.08;

    
    // Initialization code
}

-(void)layoutSubviews {
    


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(NSString *)reusableCellWithIdentifier {
    
    return @"VideoCellID";
}

@end
