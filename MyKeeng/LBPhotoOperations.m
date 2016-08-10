//
//  LBPhotoOperations.m
//  MyKeeng
//
//  Created by Le Van Binh on 8/9/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import "LBPhotoOperations.h"

@implementation LBPhotoOperations

-(NSMutableDictionary *)downloadOperations {
    
    if (!_downloadOperations) {
        
        _downloadOperations = [[NSMutableDictionary alloc] init];
    }
    
    return _downloadOperations;
}

-(NSOperationQueue *)downloadQueue {
    
    if (!_downloadQueue) {
        
        _downloadQueue = [[NSOperationQueue alloc] init];
        _downloadQueue.name = @"Download Queue";
        _downloadQueue.maxConcurrentOperationCount = 10;
    }
    
    return _downloadQueue;
}

-(NSMutableDictionary *)filterOperations {
    
    if(!_filterOperations) {
        
        _filterOperations = [[NSMutableDictionary alloc] init];
    }
    
    return _filterOperations;
}

-(NSOperationQueue *)filterQueue {
    
    if (!_filterQueue) {
        
        _filterQueue = [[NSOperationQueue alloc] init];
        _filterQueue.name = @"Image Filtration Queue";
        _filterQueue.maxConcurrentOperationCount = 10;
    }
    
    return _filterQueue;
}

@end
