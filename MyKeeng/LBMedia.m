//
//  Media.m
//  MyKeeng
//
//  Created by Le Van Binh on 7/12/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import "LBMedia.h"

@implementation LBMedia

-(void)setImage:(NSString *)image {
    
    @try {
        
        _image = [image stringByReplacingOccurrencesOfString:@"vip\\.image\\.keeng\\.vn" withString:@"vip\\.img\\.cdn\\.keeng\\.vn" options:NSRegularExpressionSearch range:NSMakeRange(0, [image length])];
    } @catch (NSException *exception) {
        
        _image = @"";
        NSLog(@"%@", exception.reason);
    }
}

-(void)setImage310:(NSString *)newimage310 {
    
    @try {
        
        _image310 =  [newimage310 stringByReplacingOccurrencesOfString:@"vip\\.image\\.keeng\\.vn" withString:@"vip\\.img\\.cdn\\.keeng\\.vn" options:NSRegularExpressionSearch range:NSMakeRange(0, [newimage310 length])];
    } @catch(NSException *exception) {
        
        _image310 = @"";
        NSLog(@"%@", exception.reason);
        
    }
}

@end
