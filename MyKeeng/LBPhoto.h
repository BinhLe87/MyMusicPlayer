//
//  LBPhoto.h
//  MyKeeng
//
//  Created by Le Van Binh on 8/9/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBPhoto : NSObject



@property (nonatomic, strong) NSString *name;  // To store the name of image
@property (nonatomic, strong) UIImage *image; // To store the actual image
@property (nonatomic, strong) NSURL *URL; // To store the URL of the image
@property (nonatomic, readonly) BOOL hasImage; // Return YES if image is downloaded.
@property (nonatomic, getter=isFiltered) BOOL filtered; // Return YES if image is sepia-filtered
@property (nonatomic, getter = isFailed) BOOL failed; // Return Yes if image failed to be downloaded


-(instancetype)initWithURL:(NSURL *)iURL;

@end
