//
//  LBPhotoDownloader.h
//  MyKeeng
//
//  Created by Le Van Binh on 8/10/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol LBPhotoDownloaderDelegate;
@class LBPhoto;

@interface LBPhotoDownloader : NSOperation {
    
    LBPhoto *_photo;
    NSIndexPath *_indexPathInTableView;
}

@property (nonatomic, readonly) LBPhoto *photo;
@property (nonatomic, readonly) NSIndexPath *indexPathInTableView;
@property (nonatomic) id<LBPhotoDownloaderDelegate> delegate;

-(instancetype)initWithPhoto:(LBPhoto *)iPhoto indexPath:(NSIndexPath *)iIndexPath delegate:(id<LBPhotoDownloaderDelegate>)iDelegate;
@end


@protocol LBPhotoDownloaderDelegate <NSObject>

-(void)photoDownloaderDidFinish:(LBPhotoDownloader *)downloader;

@end