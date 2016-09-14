//
//  LBHomeNewFloatingWindowVC.h
//  MyKeeng
//
//  Created by Le Van Binh on 9/10/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBPresentationModeDelegate.h"
#import "LBWindowTouchesHandling.h"

@interface LBHomeNewFloatingWindowVC : NSObject <LBPresentationModeDelegate, LBWindowTouchesHandling>

- (void)enable;
- (void)disable;

/**
 Presentation modes. It currently supports three presentation modes.
 It can be a small floating button, that we can keep around, or a full window for actual
 profiling, or it can simply be disabled.
 */
@property (nonatomic, assign) LBPresentationMode presentationMode;
@property (nonatomic, assign, getter=isEnabled) BOOL enabled;

@end
