//
//  RestKitConn.m
//  MyKeeng
//
//  Created by Le Van Binh on 7/12/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import "LBRestKitConn.h"
#import <RestKit/RestKit.h>



@implementation LBRestKitConn

#pragma mark - configureRestKit
+(void)configureRestKit {
    
    // initialize AFNetworking HTTPClient
    NSURL *baseURL = [NSURL URLWithString:KEENG_WS_URL];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // initialize RestKit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
#pragma mark - API GET_HOME
    // setup object mappings
    RKObjectMapping *mediaMapping = [RKObjectMapping mappingForClass:[LBSong class]];
    [mediaMapping addAttributeMappingsFromArray:@[@"number_comment", @"total_like", @"name", @"singer", @"listen_no", @"image", @"image310", @"url", @"media_url", @"locate_path"]];
    
    
    RKResponseDescriptor *mediaResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:mediaMapping
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
