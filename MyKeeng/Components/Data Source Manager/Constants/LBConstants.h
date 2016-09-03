//
//  RPCommonDataSourceConstants.h
//  iOSArchitecture
//
//  Created by Rui Peres on 03/10/2013.
//  Copyright (c) 2013 Rui Peres. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Restful 
//#define KEENG_WS_URL @"http://vip.service.keeng.vn/KeengWSRestfulV3/ws/"
#define KEENG_WS_URL @"http://service.keeng.la.onbox.vn:8082/KeengWSRestful/ws/"
#define KEENG_API_GET_HOME @"common/getHome"
#define KEENG_API_GET_HOME_FULLPATH KEENG_WS_URL @"common/getHome"
static const int KEENG_MAX_TOTAL_COST_MEM_CACHE = 5*1024*1024; //mb
static const int KEENG_MAX_DISK_CACHE = 50 * 1024 * 1024; //mb


static NSString *const KEENG_CORE_DATA_MODEL_NAME = @"MyKeeng";
#define KEENG_CORE_DATA_FILE_NAME(extension) [NSString stringWithFormat:@"%@%@",KEENG_CORE_DATA_MODEL_NAME, extension]




