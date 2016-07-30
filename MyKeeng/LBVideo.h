//
//  LBVideo.h
//  MyKeeng
//
//  Created by Le Van Binh on 7/14/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LBMedia.h"


@interface LBVideo : LBMedia

@property (nonatomic, retain) NSString * media_url;
@property (nonatomic, retain) NSString * download_url;
@property (nonatomic, retain) NSString * locate_path;

@end
