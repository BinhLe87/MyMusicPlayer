//
//  LBFloatingWindow.h
//  MyKeeng
//
//  Created by Le Van Binh on 9/10/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LBWindowTouchesHandling.h"

@interface LBFloatingWindow : UIWindow

/**
 Whenever we receive a touch event, window needs to ask delegate if this event should be captured.
 */
@property (nonatomic, weak, nullable) id<LBWindowTouchesHandling> touchesDelegate;

@end
