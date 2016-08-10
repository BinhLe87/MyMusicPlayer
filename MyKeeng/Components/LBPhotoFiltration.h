//
//  LBPhotoFiltration.h
//  MyKeeng
//
//  Created by Le Van Binh on 8/10/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol LBPhotoFiltrationDelegate;
@class LBPhoto;

@interface LBPhotoFiltration : NSOperation

@property (nonatomic, readonly) LBPhoto *photo;
@property (nonatomic, readonly) NSIndexPath *indexPathInTableView;
@property (nonatomic) id<LBPhotoFiltrationDelegate> delegate;


-(instancetype)initWithPhoto:(LBPhoto *)iPhoto indexPath:(NSIndexPath *)iIndexPath delegate:(id<LBPhotoFiltrationDelegate>)iDelegate;

@end

@protocol LBPhotoFiltrationDelegate <NSObject>

-(void) LBPhotoFiltrationDidFinish:(LBPhotoFiltration *)filtrator;
@end
