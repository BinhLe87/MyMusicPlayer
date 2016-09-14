//
//  LBFloatingButtonViewController.m
//  MyKeeng
//
//  Created by Le Van Binh on 9/10/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import "LBFloatingButtonViewController.h"
#import "LBPresentationModeDelegate.h"


static NSInteger countInTimer;
@interface LBFloatingButtonViewController ()

@end



@implementation LBFloatingButtonViewController {
    
    UIButton *_floatingButton;
    NSTimer *_timer;
    
}

-(instancetype)init {
    
    if (!(self = [super init])) return nil;
    
    countInTimer = 0;
    
    return self;
}

- (void)loadView
{
    _floatingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.view = _floatingButton;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _floatingButton.backgroundColor = [UIColor lightGrayColor];
    _floatingButton.titleLabel.font = [UIFont systemFontOfSize:11];
    _floatingButton.titleLabel.textColor = [UIColor whiteColor];
    _floatingButton.layer.borderWidth = 1.0;
    _floatingButton.layer.borderColor = [UIColor grayColor].CGColor;
    _floatingButton.alpha = 0.8;
    [_floatingButton setTitle:@"IMP" forState:UIControlStateNormal];
    
    [_floatingButton addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    [self _update];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                              target:self
                                            selector:@selector(_update)
                                            userInfo:nil
                                             repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [_timer invalidate];
    _timer = nil;
}

- (void)_update
{
    countInTimer++;
    [_floatingButton setTitle:[NSString stringWithFormat:@"%ld", (long)countInTimer] forState:UIControlStateNormal];
}

- (void)buttonTapped
{
    [self.presentationModeDelegate presentationDelegateChangePresentationModeToMode:LBPresentationModeFullWindow];
    
    NSLog(@"Da click floating button!");
}

#pragma mark FBMemoryProfilerMovableViewController

- (void)containerWillMove:(UIViewController *)container
{
    // No extra behavior
}

- (BOOL)shouldStretchInMovableContainer
{
    return YES;
}

- (CGFloat)minimumHeightInMovableContainer
{
    return 0;
}

@end
