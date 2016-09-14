/**
 * Copyright (c) 2016-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the LICENSE file in
 * the root directory of this source tree.
 */

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LBPresentationMode) {
  // Overlay window with main memory profiler interface
  LBPresentationModeFullWindow,
  // Small translucent button that can be dragged and dropped around
  LBPresentationModeCondensed,
  LBPresentationModeDisabled,
};

/**
 Presentation mode delegate owns memory profiler presentation and it can change it if requested.
 */
@protocol LBPresentationModeDelegate <NSObject>

- (void)presentationDelegateChangePresentationModeToMode:(LBPresentationMode)mode;

@end
