//
//  LBDataConnection.m
//  MyKeeng
//
//  Created by Le Van Binh on 8/1/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import "LBDataConnection.h"


@implementation LBDataConnection

-(void)getHomeNewMedias:(int)page size:(int)size performWithCompletion:(void (^)(BOOL, NSError *, NSMutableArray<LBMedia *> *))completion{
    
    mustOverride();
}

@end
