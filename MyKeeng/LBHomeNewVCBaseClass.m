//
//  LBHomeNewVCBaseClass.m
//  MyKeeng
//
//  Created by Le Van Binh on 9/22/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import "LBHomeNewVCBaseClass.h"

@implementation LBHomeNewVCBaseClass 

-(void)showOverlayViewController:(UIViewController *)viewController completionBlock:(void (^)(void))completionBlock {
    
    if ([_delegate respondsToSelector:@selector(showOverlayViewController:completionBlock:)]) {
        
        [_delegate showOverlayViewController:viewController completionBlock:completionBlock];
    }
}

-(void)dismissOverlayViewController:(UIViewController *)viewController completionBlock:(void (^)(void))completionBlock {
    
    if ([_delegate respondsToSelector:@selector(dismissOverlayViewController:completionBlock:)]) {
        
        [_delegate dismissOverlayViewController:viewController completionBlock:completionBlock];
    }
}

@end
