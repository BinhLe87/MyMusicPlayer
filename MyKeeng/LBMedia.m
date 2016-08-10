//
//  Media.m
//  MyKeeng
//
//  Created by Le Van Binh on 7/12/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import "LBMedia.h"
#import <MTLValueTransformer.h>

@implementation LBMedia

//-(void)setImage:(NSString *)image {
//    
//    @try {
//        
//        _image = [image stringByReplacingOccurrencesOfString:@"vip\\.image\\.keeng\\.vn" withString:@"vip\\.img\\.cdn\\.keeng\\.vn" options:NSRegularExpressionSearch range:NSMakeRange(0, [image length])];
//    } @catch (NSException *exception) {
//        
//        _image = @"";
//        NSLog(@"%@", exception.reason);
//    }
//}
//
//-(void)setImage310:(NSString *)newimage310 {
//    
//    @try {
//        
//        _image310 =  [newimage310 stringByReplacingOccurrencesOfString:@"vip\\.image\\.keeng\\.vn" withString:@"vip\\.img\\.cdn\\.keeng\\.vn" options:NSRegularExpressionSearch range:NSMakeRange(0, [newimage310 length])];
//    } @catch(NSException *exception) {
//        
//        _image310 = @"";
//        NSLog(@"%@", exception.reason);
//        
//    }
//}

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"id":@"id", @"name":@"name", @"singer":@"singer", @"listen_no":@"listen_no", @"image":@"image", @"image310":@"image310", @"url":@"url", @"price":@"price", @"item_type":@"item_type"};
}

+(NSValueTransformer*) imageJSONTransformer {
    
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        
        NSString *imgUrlStr = (NSString*)value;
        return [[LBPhoto alloc] initWithURL:[NSURL URLWithString:imgUrlStr]];
        
    }];
}

+(NSValueTransformer*) image310JSONTransformer {
    
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        
        NSString *imgUrlStr = (NSString*)value;
        
        return [[LBPhoto alloc] initWithURL:[NSURL URLWithString:imgUrlStr]];
        
    }];
}

+(NSValueTransformer*) idJSONTransformer {

    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        
        return [value stringValue];
    }];

}




@end
