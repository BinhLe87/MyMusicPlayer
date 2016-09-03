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
@synthesize executing = _executing;
@synthesize finished = _finished;


@synthesize indexPathInTableView = _indexPathInTableView;

-(instancetype)initWithPhoto:(LBPhoto *)iPhoto indexPath:(NSIndexPath *)iIndexPath delegate:(id<LBPhotoDownloaderDelegate>)iDelegate {
    
    if (self = [super init]) {
        
        _photo = iPhoto;
        self.delegate = iDelegate;
        _indexPathInTableView = iIndexPath;
    }
    
    return self;
}

-(void)start {
    
    @autoreleasepool {
        
        self.executing = YES;
        
        if (self.isCancelled) {
            self.executing = NO;
            self.finished = YES;
            return;
        }
        
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:self.photo.url];
        
        if (self.isCancelled) {
            self.executing = NO;
            self.finished = YES;
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
        
        if (self.isCancelled) {
            
            self.executing = NO;
            self.finished = YES;
            return;
        }
        
        if ([self.delegate respondsToSelector:@selector(photoDownloaderDidFinish:)]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.delegate photoDownloaderDidFinish:self];
            });
        }
        
        self.executing = NO;
        self.finished = YES;
    }
}


- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (BOOL)isConcurrent {
    return YES;
}

@end
