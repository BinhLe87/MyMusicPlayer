//
//  LBFavouriteCell.m
//  MyKeeng
//
//  Created by Le Van Binh on 9/15/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import "LBFavouriteCell.h"
#import "UIImageView+WebCache.h"

@implementation LBFavouriteCell

-(instancetype)initWithFrameAndContentSize:(CGRect)frame contentSize:(CGSize)contentSize {
    
    if (!(self = [super init])) return nil;
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = frame;
    [self.contentView addSubview:_scrollView];
    
    _scrollView.contentSize = contentSize;
    
    return self;
}

-(void)setFavourites:(NSArray<LBMedia*> *)medias {
    
    __block CGFloat currentOffsetX = 5.0;
    __block CGFloat imageWidth = _scrollView.bounds.size.height;
    __block CGFloat imageHeight = _scrollView.bounds.size.height;
    
    [medias enumerateObjectsUsingBlock:^(LBMedia * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIImageView *imageFav = [[UIImageView alloc] init];
        SDWebImageOptions songDownloadOptions = SDWebImageProgressiveDownload | SDWebImageContinueInBackground | SDWebImageTransformAnimatedImage;
        
        [imageFav sd_setImageWithURL:obj.image.url placeholderImage:[UIImage imageNamed:@"image_placeholder.png"] options:songDownloadOptions];
        
        imageFav.frame = CGRectInset(CGRectMake(currentOffsetX, 0, imageWidth, imageHeight), 2, 2);
        
        [_scrollView addSubview:imageFav];
        
        currentOffsetX += imageWidth;
    }];
    
}

+(CGFloat)heightForFavouriteCell {
    
    return 70;
}

+(CGFloat)marginY {
    
    return 2;
}

@end
