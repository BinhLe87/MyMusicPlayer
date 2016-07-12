//
//  Media.h
//  MyKeeng
//
//  Created by Le Van Binh on 7/12/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBMedia : NSObject

@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * image310;
@property (nonatomic, retain) NSNumber * listen_no;
@property (nonatomic, retain) NSString * lyric;
@property (nonatomic, retain) NSString * media_url;
@property (nonatomic, retain) NSString * media_url_mono;
@property (nonatomic, retain) NSDate * modify_date;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * singer;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * locate_path;
@property (nonatomic, retain) NSNumber * total_like;
@property (nonatomic, retain) NSNumber * number_comment;
@property (nonatomic, retain) NSNumber * is_like;

@end
