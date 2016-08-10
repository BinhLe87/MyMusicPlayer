//
//  LBPhotoDownloader.m
//  MyKeeng
//
//  Created by Le Van Binh on 8/10/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import "LBPhotoDownloader.h"
#import "LBPhoto.h"



@implementation LBPhotoDownloader
@synthesize photo = _photo;
@synthesize indexPathInTableView = _indexPathInTableView;

-(instancetype)initWithPhoto:(LBPhoto *)iPhoto indexPath:(NSIndexPath *)iIndexPath delegate:(id<LBPhotoDownloaderDelegate>)iDelegate {
    
    if (self = [super init]) {
    
        _photo = iPhoto;
        self.delegate = iDelegate;
        _indexPathInTableView = iIndexPath;
    }
    
    return self;
}

-(void)main {
    
    @autoreleasepool {
        
        if (self.isCancelled)
            return;
        
        
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:self.photo.URL];
        
        if (self.isCancelled) {
            imageData = nil;
            return;
        }
        
        if (imageData) {
            
            UIImage *downloadedImage = [UIImage imageWithData:imageData];
            self.photo.image = downloadedImage;
        } else {
            
            self.photo.failed = YES;
        }
        
        imageData = nil;
        
        if (self.isCancelled)
            return;
        
        if ([self.delegate respondsToSelector:@selector(photoDownloaderDidFinish:)]) {
            
            [self.delegate photoDownloaderDidFinish:self];
        }
    }
}

@end
