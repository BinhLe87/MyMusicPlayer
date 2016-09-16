//
//  LBFavouriteCell.h
//  MyKeeng
//
//  Created by Le Van Binh on 9/15/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBMedia.h"

@interface LBFavouriteCell : UITableViewCell

@property (nonnull) UIScrollView *scrollView;

-(instancetype)initWithFrameAndContentSize:(CGRect)frame contentSize:(CGSize)contentSize;

-(void)setFavourites:(NSArray<LBMedia*> *)medias;
+(CGFloat)heightForFavouriteCell;
+(CGFloat)marginY;
@end
