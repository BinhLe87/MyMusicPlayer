//
//  Song.h
//  KeengVN
//
//  Created by TranQuangSon on 9/9/15.
//  Copyright (c) 2015 Viettel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "LBMedia.h"



@interface LBSong : LBMedia

@property (nonatomic, retain) NSString * media_url;
@property (nonatomic, retain) NSString * media_url_mono;
@property (nonatomic, retain) NSString * media_url_pre;
@property (nonatomic, retain) NSString * locate_path;
@property (nonatomic, retain) NSNumber * total_like;
@property (nonatomic, retain) NSNumber * number_comment;
@property (nonatomic, retain) NSNumber * is_like;
@property (nonatomic, retain) NSString * download_url;



@end


