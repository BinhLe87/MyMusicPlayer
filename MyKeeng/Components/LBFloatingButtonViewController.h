//
//  LBFloatingButtonViewController.h
//  MyKeeng
//
//  Created by Le Van Binh on 9/10/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBMovableViewController.h"

@protocol LBPresentationModeDelegate;
/**
 Floating button mode view controller. If current mode is condensed, this is the view controller that will
 own it. It represents a small button that can be dragged and dropped wherever, showing current resident memory.
 It will expand to full size profiler on tap.
 */
@interface LBFloatingButtonViewController : UIViewController <LBMovableViewController>

/**
 Delegate that can change presentation mode, will be used on tap.
 */
@property(nonatomic) id<LBPresentationModeDelegate> presentationModeDelegate;

@end
