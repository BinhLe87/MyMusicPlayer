//
//  LBVideo.m
//  MyKeeng
//
//  Created by Le Van Binh on 7/14/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import "LBVideo.h"


@implementation LBVideo

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"id":@"id", @"name":@"name", @"singer":@"singer", @"listen_no":@"listen_no", @"image":@"image", @"image310":@"image310", @"url":@"url", @"media_url":@"media_url", @"locate_path":@"locate_path", @"download_url":@"download_url", @"price":@"price", @"item_type":@"item_type"};
}


@end
