//
//  LBPhotoToDataTransformer.m
//  MyKeeng
//
//  Created by Le Van Binh on 8/13/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import "LBPhotoToDataTransformer.h"
#import "LBPhoto.h"

@implementation LBPhotoToDataTransformer

+(Class)transformedValueClass {
    
    return [NSString class];
}

+(BOOL)allowsReverseTransformation {
    
    return YES;
}

-(id)transformedValue:(id)value {
    
    LBPhoto *photo = (LBPhoto *)value;
    return [[photo.url absoluteString] dataUsingEncoding:NSUTF8StringEncoding];
}

-(id)reverseTransformedValue:(id)value {
    
    NSString *urlString = (NSString*)value;
    
    return [[LBPhoto alloc] initWithURL:[NSURL URLWithString:urlString]];
}

@end
