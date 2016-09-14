//
//  UIView+Extensions.m
//  MyKeeng
//
//  Created by Le Van Binh on 9/14/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import "UIView+Extensions.h"

@implementation UIView(Extensions)

- (id)findFirstResponder
{
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subView in self.subviews) {
        if ([subView isFirstResponder]) {
            return subView;
        }
    }
    return nil;
}

@end
