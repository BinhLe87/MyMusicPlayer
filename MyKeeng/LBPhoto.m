//
//  LBPhoto.m
//  MyKeeng
//
//  Created by Le Van Binh on 8/9/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import "LBPhoto.h"


@implementation LBPhoto

//-(void)encodeWithCoder:(NSCoder *)aCoder {
//    
//    
//    [aCoder encodeObject:[self.url absoluteString] forKey:@"url"];
//    [aCoder encodeBool:self.filtered forKey:@"filtered"];
//    [aCoder encodeBool:self.failed forKey:@"failed"];
//}
//
//-(instancetype)initWithCoder:(NSCoder *)aDecoder {
//    
//    self = [super init];
//    if (self) {
//        
//        _url = [aDecoder decodeObjectForKey:@"url"];
//        _filtered = [aDecoder decodeBoolForKey:@"filtered"];
//        _failed = [aDecoder decodeBoolForKey:@"failed"];
//    }
//    
//    return self;
//}


-(instancetype)initWithURL:(NSURL *)iURL {
    
    if (self = [self init]) {
        
        _url = iURL;
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

-(void)setUrl:(NSURL *)url {
    
    _url = url;
}

-(NSString *)url_string {
    
    return [self.url absoluteString];
}

-(void)setUrl_string:(NSString *)url_string {
    
    self.url_string = url_string;
}


-(BOOL)hasImage {
    
    return _image != nil;
}

-(void)setFailed:(BOOL)failed {
    
    [self willChangeValueForKey:@"failed"];
    _failed = failed;
    [self didChangeValueForKey:@"failed"];
}





@end
