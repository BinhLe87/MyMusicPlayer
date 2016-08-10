//
//  LBPhotoOperations.h
//  MyKeeng
//
//  Created by Le Van Binh on 8/9/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBPhotoOperations : NSObject

@property (nonatomic) NSMutableDictionary *downloadOperations;
@property (nonatomic) NSOperationQueue *downloadQueue;

@property (nonatomic) NSMutableDictionary *filterOperations;
@property (nonatomic) NSOperationQueue *filterQueue;
@end
