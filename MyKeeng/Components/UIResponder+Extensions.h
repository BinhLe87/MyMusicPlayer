//
//  UIResponder+Extensions.h
//  MyKeeng
//
//  Created by Le Van Binh on 9/14/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIResponder(Extensions)

+(id)currentFirstResponder;
-(void)findFirstResponder:(id)sender;
@end
