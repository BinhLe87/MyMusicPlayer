//
//  LBVideoCell.h
//  MyKeeng
//
//  Created by Le Van Binh on 7/14/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LBVideo;

@interface LBVideoCell : UITableViewCell

+(NSString *)reusableCellWithIdentifier;
+(CGFloat) heightForVideoCell;

@property (strong, nonatomic) IBOutlet UILabel *VideoNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *SingerLbl;
@property (weak, nonatomic) IBOutlet UILabel *NumListenLbl;
@property (weak, nonatomic) IBOutlet UILabel *NumLikeLbl;
@property (weak, nonatomic) IBOutlet UILabel *NumCommentLbl;
@property (weak, nonatomic) IBOutlet UIImageView *VideoImg;
@property (weak, nonatomic) IBOutlet UIStackView *footerView;
@property (weak, nonatomic) IBOutlet UIView *infoView;

@property (weak, nonatomic) LBVideo *videoInfo;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;


-(void)setupUI;


@end
