//
//  LBDataConnection.h
//  MyKeeng
//
//  Created by Le Van Binh on 8/1/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LBMedia.h"
#import "LBSong.h"
#import "LBVideo.h"

@protocol LBDataOperating

@required
-(void) getHomeNewMedias:(int)page size:(int)size performWithCompletion:(void(^)(BOOL succeed, NSError *error, NSMutableArray<LBMedia*> *medias))completion;

@end

@interface LBDataConnection : NSObject <LBDataOperating>



@end
