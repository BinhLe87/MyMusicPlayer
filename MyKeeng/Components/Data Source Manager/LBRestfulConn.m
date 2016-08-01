//
//  LBRestfulConn.m
//  MyKeeng
//
//  Created by Le Van Binh on 8/1/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import "LBRestfulConn.h"

@implementation LBRestfulConn




-(void)getHomeNewMedias:(int)page size:(int)size performWithCompletion:(void (^)(BOOL, NSError *, NSMutableArray<LBMedia *> *))completion {
    
    __block NSMutableArray<LBMedia *> *medias = [[NSMutableArray alloc] init];
    
    
    NSURL *url = [NSURL URLWithString:KEENG_WS_URL];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];


    [client getPath:KEENG_API_GET_HOME parameters:@{@"page" : [NSNumber numberWithInt:page],
            @"num": [NSNumber numberWithInt:size]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSError *error;
                
                NSDictionary *dic = (NSDictionary*) [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
                
                NSArray *results = (NSArray*)[dic objectForKey:@"data"];
                
                for (NSDictionary *mediaDic in results) {
                    
                    if ([[mediaDic valueForKey:@"item_type"] integerValue] == 1) { //song
                        
                        LBSong *song = (LBSong *)[MTLJSONAdapter modelOfClass:[LBSong class] fromJSONDictionary:mediaDic error:&error];
                        
                        if (song != nil) {
                            
                            [medias addObject:song];
                        } else {
                            
                            NSLog(@"Error: %@", error);
                        }
                    } else if ([[mediaDic valueForKey:@"item_type"] integerValue] == 3) { //video
                        
                        LBVideo *video = (LBVideo *)[MTLJSONAdapter modelOfClass:[LBVideo class] fromJSONDictionary:mediaDic error:&error];
                        
                        if (video != nil)
                        {
                            
                            [medias addObject:video];
                        } else {
                            
                            NSLog(@"Error: %@", error);
                        }
                    }
                }
                
                if (completion) {
                    completion(true, error, medias);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                
                if (completion) {
                    completion(false, error, medias);
                }
            }];
}

@end
