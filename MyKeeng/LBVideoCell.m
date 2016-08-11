//
//  LBVideoCell.m
//  MyKeeng
//
//  Created by Le Van Binh on 7/14/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import "LBVideoCell.h"
#import "LBVideo.h"

@implementation LBVideoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    NSLog(@"init video cell");
    return [super initWithStyle:style reuseIdentifier:reuseIdentifier];
}

- (void)awakeFromNib {
    
    // Initialization code
    [super awakeFromNib];
}

-(void)layoutSubviews {
    
    self.infoView.layer.sublayers = nil;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    gradient.colors = @ [(id)[[UIColor clearColor] CGColor],(id)[[UIColor colorWithWhite:0.3 alpha:0.1] CGColor],
                         (id)[[UIColor clearColor] CGColor], (id)[[UIColor colorWithWhite:0.3 alpha:0.1] CGColor], (id)[[UIColor clearColor] CGColor]];
    gradient.locations = @ [@0.1,@0.3,@0.5,@0.7,@0.9];
    gradient.startPoint = CGPointMake(0.0, 0.0);
    gradient.endPoint = CGPointMake(0.5, 1.0);
    
    [self.infoView.layer insertSublayer:gradient atIndex:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(NSString *)reusableCellWithIdentifier {
    
    return @"VideoCellID";
}

+(CGFloat)heightForVideoCell {
    
    return 200;
}

-(void)setupUI {
    
    
}


@end
