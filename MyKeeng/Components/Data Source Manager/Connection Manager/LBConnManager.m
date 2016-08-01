//
//  LBConnManager.m
//  MyKeeng
//
//  Created by Le Van Binh on 8/1/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import "LBConnManager.h"
#import "LBRestfulConn.h"


@interface LBConnManager() {
    
    LBRestfulConn *_restfulConn;
    BOOL networkReachable;
    
}

@property (nonatomic) LBNetworkState networkState;
@property (nonatomic) LBDataConnection *dataConn;

@end

@implementation LBConnManager


-(void)setNetworkState:(LBNetworkState)networkState {
    
    switch (networkState) {
        case LBNetworkStateNoReachable:
            networkReachable = NO;
            break;
            
        case LBNetworkStateReachableVia3G:
            networkReachable = YES;
            break;
            
        case LBNetworkStateReachableViaWifi:
            networkReachable = YES;
            break;
            
        default:
            break;
    }
}

-(LBDataConnection *)dataConn {
    
    if (networkReachable) {
        
        return _restfulConn;
    } else {
        
        return nil;
    }
}

-(instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        _restfulConn = [[LBRestfulConn alloc] init];
        networkReachable = YES;
    }
    
    return self;
}

-(void) getHomeNewMedias:(int)page size:(int)size performWithCompletion:(void (^)(BOOL, NSError *, NSMutableArray<LBMedia *> *))completion {
    
    return [self.dataConn getHomeNewMedias:page size:size performWithCompletion:completion];
}

@end
