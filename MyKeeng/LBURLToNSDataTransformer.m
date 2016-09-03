//
//  LBURLToStringTransformer.m
//  MyKeeng
//
//  Created by Le Van Binh on 8/16/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import "LBURLToNSDataTransformer.h"

@implementation LBURLToNSDataTransformer

+(Class)transformedValueClass {
    
    return [NSData class];
}

+(BOOL)allowsReverseTransformation {
    
    return YES;
}

/**
 *transform URL to String
 */
-(id)transformedValue:(id)value {
    
    return [NSData dataWithContentsOfURL:value];
}

/**
 *transform String to URL
 */
-(id)reverseTransformedValue:(id)value {
    
    NSString *urlString = [[NSString alloc] initWithData:value encoding:NSUTF8StringEncoding]; // Or any other appropriate encoding
    return [[NSURL alloc] initWithString:urlString];
}

@end
