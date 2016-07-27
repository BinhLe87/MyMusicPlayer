//
//  LBVideoCellPlayer.h
//  MyKeeng
//
//  Created by Le Van Binh on 7/20/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALMoviePlayerController/ALMoviePlayerController.h"


@protocol LBVideoCellPlayerDelegate <NSObject>

-(void)exitVideoPlayer;

@end

@interface LBVideoCellPlayer : UIView <ALMoviePlayerControllerDelegate>

@property (nonatomic) ALMoviePlayerController *moviePlayer;
@property (nonatomic,weak) id<LBVideoCellPlayerDelegate> delegate;

-(void)setContentURL:(NSURL *)contentURL;


@end
