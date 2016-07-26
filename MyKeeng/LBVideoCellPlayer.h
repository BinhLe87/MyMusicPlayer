//
//  LBVideoCellPlayer.h
//  MyKeeng
//
//  Created by Le Van Binh on 7/20/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALMoviePlayerController/ALMoviePlayerController.h"

@interface LBVideoCellPlayer : UIView <ALMoviePlayerControllerDelegate>

@property (nonatomic, strong) ALMoviePlayerController *moviePlayer;

-(void)setContentURL:(NSURL *)contentURL;

@end
