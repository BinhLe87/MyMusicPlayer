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


- (void)awakeFromNib {
    
    // Initialization code
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
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

#pragma mark - Observing value change of properties
-(void)setVideoInfo:(LBVideo *)videoInfo {
 
    _videoInfo = videoInfo;
    [self addObserver:self forKeyPath:@"videoInfo.image.hasImage" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:self forKeyPath:@"videoInfo.image.failed" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"videoInfo.image.hasImage"] || [keyPath isEqualToString:@"videoInfo.image.failed"]) {
        
        [self setupUI];
    }
    

}


#pragma mark - Interal methods

-(void)setupUI {
  
    self.VideoNameLbl.text = _videoInfo.name;
    self.SingerLbl.text = _videoInfo.singer;
    self.NumListenLbl.text = [NSString stringWithFormat:@"%d", [_videoInfo.listen_no intValue]];
    self.NumLikeLbl.text = @"New Video";
    self.NumCommentLbl.text = [NSString stringWithFormat:@"Giá %d", [_videoInfo.price intValue]];
    
    if (self.videoInfo.image.hasImage) {
        
        //return font color to white
        [self.VideoNameLbl setTextColor:[UIColor whiteColor]];
        [self.SingerLbl setTextColor:[UIColor whiteColor]];
        [self.NumListenLbl setTextColor:[UIColor whiteColor]];
        
        [self.activityIndicatorView stopAnimating];
        self.VideoImg.image = self.videoInfo.image.image;
    } else if (self.videoInfo.image.isFailed) {
        
        [self.activityIndicatorView stopAnimating];
        self.VideoImg.image = [UIImage imageNamed:@"image_unavailable.png"];
    } else { //photo is not yet downloaded
        
        //set font color is back for displaying on white background of placeholder image
        [self.VideoNameLbl setTextColor:[UIColor blackColor]];
         [self.SingerLbl setTextColor:[UIColor blackColor]];
        [self.NumListenLbl setTextColor:[UIColor blackColor]];
        
        
        [self.activityIndicatorView startAnimating];
        self.VideoImg.image = [UIImage imageNamed:@"default_video.png"];
    }
}

#pragma mark - dealloc
-(void)dealloc {
    
    [self removeObserver:self forKeyPath:@"videoInfo.image.hasImage"];
    [self removeObserver:self forKeyPath:@"videoInfo.image.failed"];
}


@end
