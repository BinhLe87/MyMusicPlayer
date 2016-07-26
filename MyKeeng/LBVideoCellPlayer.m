//
//  LBVideoCellPlayer.m
//  MyKeeng
//
//  Created by Le Van Binh on 7/20/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import "LBVideoCellPlayer.h"

@interface LBVideoCellPlayer()

@property(nonatomic) ALMoviePlayerControls *_movieControls;

@end


@implementation LBVideoCellPlayer

@synthesize _movieControls = movieControls;

-(instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.moviePlayer = [[ALMoviePlayerController alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.moviePlayer.view.alpha = 0.f;
        self.moviePlayer.delegate = self; //IMPORTANT!
        
        //create the controls
        movieControls = [[ALMoviePlayerControls alloc] initWithMoviePlayer:self.moviePlayer style:ALMoviePlayerControlsStyleDefault];
        //[movieControls setAdjustsFullscreenImage:NO];
        [movieControls setBarColor:[UIColor colorWithRed:191.0/255.0 green:191.0/255.0 blue:191.0/255.0 alpha:0.1]];
        [movieControls setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [movieControls setNeedsLayout];
        
        
        [movieControls setTimeRemainingDecrements:YES];
        
        //assign controls
        [self.moviePlayer setControls:movieControls];
        [self addSubview:self.moviePlayer.view];
        
        
    }
    
    return self;
}




-(void)layoutSubviews {
    
    
    self.moviePlayer.view.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [movieControls setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}


-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    NSLog(@"%f", self.frame.size.height);
    
    id hitView = [super hitTest:point withEvent:event];
    if (hitView == self) return nil;
    else return hitView;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    NSLog(@" CHECKING CGPOINT %@", NSStringFromCGPoint(point));

}


-(void)setContentURL:(NSURL *)contentURL {
        
    [self.moviePlayer setContentURL:contentURL];
}

#pragma mark - Delegates
-(void)moviePlayerWillMoveFromWindow {
    
    //re-add movie player into this self.view after exit full mode
    if (![[self subviews] containsObject:self.moviePlayer.view]) {
        
        [self addSubview:self.moviePlayer.view];
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
}
@end
