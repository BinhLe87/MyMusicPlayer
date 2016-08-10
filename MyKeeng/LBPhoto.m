//
//  LBPhoto.m
//  MyKeeng
//
//  Created by Le Van Binh on 8/9/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import "LBPhoto.h"

@implementation LBPhoto


-(instancetype)initWithURL:(NSURL *)iURL {
    
    if (self = [self init]) {
        
        self.URL = iURL;
    }
    
    return self;
}

-(instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        _failed = NO;
        _filtered = NO;
    }
    
    return self;
}

-(BOOL)hasImage {
    
    return _image != nil;
}



@end
