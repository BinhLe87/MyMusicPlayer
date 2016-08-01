//
//  LBConnManager.h
//  MyKeeng
//
//  Created by Le Van Binh on 8/1/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LBDataConnection.h"

typedef enum {
    
    LBNetworkStateNoReachable,
    LBNetworkStateReachableViaWifi,
    LBNetworkStateReachableVia3G
    
} LBNetworkState;


@interface LBConnManager : NSObject <LBDataOperating>  {
    
   
    
}



    


@end
