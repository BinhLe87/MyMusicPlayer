//
//  LBHomeNewFloatingWindowVC.m
//  MyKeeng
//
//  Created by Le Van Binh on 9/10/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import "LBHomeNewFloatingWindowVC.h"
#import "LBFloatingWindow.h"
#import "LBFloatingButtonViewController.h"
#import "LBContainerViewController.h"

static const NSUInteger kFBFloatingButtonSize = 52.0;

@interface LBHomeNewFloatingWindowVC () {
    
    LBFloatingButtonViewController *_floatingButtonController;
    LBContainerViewController *_containerViewController;
}

@property (nonatomic, strong) LBFloatingWindow *floatingWindow;


@end

@implementation LBHomeNewFloatingWindowVC

-(instancetype)init {
    
    if (!(self = [super init])) return nil;
    
    _presentationMode = LBPresentationModeFullWindow;
    
    return self;
}

-(void)enable {
    
    _enabled = YES;
    
    _containerViewController = [LBContainerViewController new];
    
    _floatingWindow = [[LBFloatingWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _floatingWindow.touchesDelegate = self;
    _floatingWindow.rootViewController = _containerViewController;
    _floatingWindow.hidden = NO;
    
    self.presentationMode = LBPresentationModeCondensed;
}

-(void)disable {
    
    self.presentationMode = LBPresentationModeDisabled;
    _enabled = NO;
}

#pragma mark - Popover attaching
- (void)_instanceAttachToWindow {
    
    
}

- (void)_instanceDetachFromWindow
{
    [_containerViewController dismissCurrentViewController];
}

- (void)setPresentationMode:(LBPresentationMode)presentationMode
{
    if (_presentationMode != presentationMode) {
        switch (presentationMode) {
            case LBPresentationModeFullWindow:
                [self _hideFloatingButton];
                [self _instanceAttachToWindow];
                break;
            case LBPresentationModeCondensed:
                [self _instanceDetachFromWindow];
                [self _showFloatingButton];
                break;
            case LBPresentationModeDisabled:
                [self _hideFloatingButton];
                [self _instanceDetachFromWindow];
                break;
        }
    }
    
    _presentationMode = presentationMode;
}

#pragma mark - Floating button presentation

- (void)_showFloatingButton
{
    _floatingButtonController = [LBFloatingButtonViewController new];
    _floatingButtonController.presentationModeDelegate = self;
    
    [_containerViewController presentViewController:_floatingButtonController
                                           withSize:CGSizeMake(kFBFloatingButtonSize,
                                                               kFBFloatingButtonSize)];
}

- (void)_hideFloatingButton
{
    [_containerViewController dismissCurrentViewController];
    _floatingButtonController = nil;
}


#pragma mark - LBPresentationModeDelegate

- (void)presentationDelegateChangePresentationModeToMode:(LBPresentationMode)mode
{
    self.presentationMode = mode;
}

#pragma mark - LBWindowTouchesHandling

- (BOOL)window:(UIWindow *)window shouldReceiveTouchAtPoint:(CGPoint)point
{
    switch (_presentationMode) {
        case LBPresentationModeFullWindow:
            return NO;
        case LBPresentationModeCondensed:
            return CGRectContainsPoint(_floatingButtonController.view.bounds,
                                       [_floatingButtonController.view convertPoint:point
                                                                           fromView:window]);
        case LBPresentationModeDisabled:
            return NO;
    }
}


@end
