//
//  RestKitConn.m
//  MyKeeng
//
//  Created by Le Van Binh on 7/12/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import "LBRestKitConn.h"
#import <RestKit/RestKit.h>
#import <RestKit/ObjectMapping/RKDynamicMapping.h>



@implementation LBRestKitConn

#pragma mark - configureRestKit
+(void)configureRestKit {
    
    // initialize AFNetworking HTTPClient
    NSURL *baseURL = [NSURL URLWithString:KEENG_WS_URL];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // initialize RestKit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
//TODO: API GET_HOME
    // setup object mappings
    RKObjectMapping *songMapping = [RKObjectMapping mappingForClass:[LBSong class]];
    [songMapping addAttributeMappingsFromArray:@[@"name", @"singer", @"listen_no", @"image", @"image310", @"url", @"media_url", @"locate_path", @"download_url", @"price", @"media_url_mono", @"media_url_pre", @"item_type"]];
    
    
    RKObjectMapping *videoMapping = [RKObjectMapping mappingForClass:[LBVideo class]];
    [videoMapping addAttributeMappingsFromArray:@[@"name", @"singer", @"listen_no", @"image", @"image310", @"url", @"media_url", @"locate_path", @"download_url", @"price", @"item_type"]];


    
     // Connect a response descriptor for our dynamic mapping
     RKDynamicMapping *dynamicMapping =  [RKDynamicMapping new];
    
    [dynamicMapping setObjectMappingForRepresentationBlock:^RKObjectMapping *(id representation) {
       
        if ([[representation valueForKey:@"item_type"] integerValue] == 1) {
            return songMapping;
        } else if ([[representation valueForKey:@"item_type"] integerValue] == 3) {
            return videoMapping;
        }
        
        return nil;
    }];
    
    RKResponseDescriptor *mediaResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:dynamicMapping
                                                 method:RKRequestMethodGET
                                            pathPattern: KEENG_API_GET_HOME
                                                keyPath: @"data"
                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
 
    
    [objectManager addResponseDescriptor:mediaResponseDescriptor];
    
    

//    
//    //---------------------------API_GET_MESSAGE_PROGRESS: smsProgList
//    // Create our new smsProg entity mapping
//    RKObjectMapping* smsProgMapping = [RKObjectMapping mappingForClass:[smsProg class]];
//    // NOTE: When your source and destination key paths are symmetrical, you can use addAttributesFromArray: as a shortcut instead of addAttributesFromDictionary:
//    [smsProgMapping addAttributeMappingsFromArray:@[ @"prog_id", @"prog_code", @"alias", @"status", @"created_date",
//                                                     @"content", @"progType", @"totalSub", @"totalSuccess", @"totalFail"]];
//    
//    // Now configure the Article mapping
//    RKObjectMapping* smsProgListMapping = [RKObjectMapping mappingForClass:[smsProgList class] ];
//    [smsProgListMapping addAttributeMappingsFromDictionary:@{
//                                                             @"errorCode": @"errorCode",
//                                                             @"message": @"message",
//                                                             @"pageTotal": @"pageTotal"
//                                                             }];
//    
//    // Define the relationship mapping
//    [smsProgListMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"data"
//                                                                                       toKeyPath:@"smsProgs"
//                                                                                     withMapping:smsProgMapping]];
//    
//    RKResponseDescriptor *smsProgListresponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:smsProgListMapping method:RKRequestMethodAny pathPattern:API_GET_MESSAGE_PROGRESS
//                                                                                                      keyPath:nil
//                                                                                                  statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
//    //---------------------
//    
//    [objectManager addResponseDescriptor:userResponseDescriptor];
//    [objectManager addResponseDescriptor:smsProgListresponseDescriptor];
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
}


@end
