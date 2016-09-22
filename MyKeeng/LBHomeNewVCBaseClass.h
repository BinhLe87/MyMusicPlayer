//
//  LBHomeNewVCBaseClass.h
//  MyKeeng
//
//  Created by Le Van Binh on 9/22/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LBHomeNewVCDelegate <NSObject>

-(void)showOverlayViewController:(UIViewController*)viewController completionBlock:(void (^)(void))completionBlock;
-(void)dismissOverlayViewController:(UIViewController*)viewController completionBlock:(void (^)(void))completionBlock;

@end

@interface LBHomeNewVCBaseClass : UIViewController <LBHomeNewVCDelegate>

@property(nonatomic) id<LBHomeNewVCDelegate> delegate;


@end
