//
//  LBHomeNewVideoCell.h
//  MyKeeng
//
//  Created by Le Van Binh on 7/14/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBHomeNewVideoCell : UITableViewCell


+(NSString *)reusableCellWithIdentifier;

@property (strong, nonatomic) IBOutlet UILabel *VideoNameLbl;

@property (weak, nonatomic) IBOutlet UILabel *SingerLbl;
@property (weak, nonatomic) IBOutlet UILabel *NumListenLbl;

@property (weak, nonatomic) IBOutlet UILabel *NumLikeLbl;


@property (weak, nonatomic) IBOutlet UILabel *NumCommentLbl;


@property (weak, nonatomic) IBOutlet UIImageView *VideoImg;



@property CGSize cellSize;


@property (weak, nonatomic) IBOutlet UIView *infoView;


@end
