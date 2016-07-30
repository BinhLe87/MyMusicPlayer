//
//  Song.m
//  KeengVN
//
//  Created by TranQuangSon on 9/9/15.
//  Copyright (c) 2015 Viettel. All rights reserved.
//

#import "LBSong.h"




@implementation LBSong

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"id":@"id", @"name":@"name", @"singer":@"singer", @"listen_no":@"listen_no", @"image":@"image", @"image310":@"image310", @"url":@"url", @"media_url":@"media_url", @"locate_path":@"locate_path", @"download_url":@"download_url", @"price":@"price", @"item_type":@"item_type", @"media_url_mono":@"media_url_mono", @"media_url_pre":@"media_url_pre"};
}



@end
