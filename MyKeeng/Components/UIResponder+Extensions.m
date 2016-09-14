//
//  UIResponder+Extensions.m
//  MyKeeng
//
//  Created by Le Van Binh on 9/14/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import "UIResponder+Extensions.h"

static __weak id currentFirstResponder;

@implementation UIResponder(Extensions)

+(id)currentFirstResponder {
    currentFirstResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:) to:nil from:nil forEvent:nil];
    return currentFirstResponder;
}

-(void)findFirstResponder:(id)sender {
    currentFirstResponder = self;
}

@end
