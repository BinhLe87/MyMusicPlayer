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
    
    NSDictionary *parameters = @{@"page": [NSNumber numberWithInteger:page], @"num": [NSNumber numberWithInteger:size]};
    
    
    NSLog(@"%@", KEENG_API_GET_HOME_FULLPATH);
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:KEENG_WS_URL]];
    [manager.responseSerializer setAcceptableContentTypes:[manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:[NSSet setWithObjects:@"text/html", @"text/plain",nil]]];
    manager.completionQueue = dispatch_queue_create("lb.mykeeng.AFCompletionQueue", DISPATCH_QUEUE_CONCURRENT);
    

    NSURLSessionDataTask *task = [manager GET:KEENG_API_GET_HOME parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"Get data done:%d-%d", page, size);
        
        NSError *error;

       
        NSArray *results = (NSArray*)[responseObject objectForKey:@"data"];
        
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
            completion(true, nil, medias);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        completion(false, error, nil);
        
    }];

    [task resume];
}

@end
