/**
 * Copyright (c) 2016-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the LICENSE file in
 * the root directory of this source tree.
 */

#import <UIKit/UIKit.h>

@protocol LBMovableViewController;

/**
 Contains child view controller with given sizes, let's it being draggable all around within
 the window it was created in.
 */
@interface LBContainerViewController : UIViewController

- (void)presentViewController:(nonnull UIViewController<LBMovableViewController> *)viewController
                     withSize:(CGSize)size;

- (void)dismissCurrentViewController;

@end
