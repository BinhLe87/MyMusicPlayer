//
//  LBFloatingWindow.m
//  MyKeeng
//
//  Created by Le Van Binh on 9/10/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import "LBFloatingWindow.h"

@implementation LBFloatingWindow

-(instancetype)initWithFrame:(CGRect)frame {
    
    if (!(self = [super initWithFrame:frame])) return nil;
    
    self.backgroundColor = [UIColor clearColor];
    self.windowLevel = UIWindowLevelStatusBar + 100;
    
    return self;
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    if ([self.touchesDelegate window:self shouldReceiveTouchAtPoint:point]) {
        
        return [super pointInside:point withEvent:event];
    }
    
    return NO;
}

#if _INTERNAL_IMP_ENABLED

- (BOOL)_canAffectStatusBarAppearance
{
    return NO;
}

- (BOOL)_canBecomeKeyWindow
{
    return NO;
}

#endif // _INTERNAL_IMP_ENABLED

@end
