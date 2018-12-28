//
//  NetWorkSession.h
//
//  Created by 似云悠 on 16/7/23.
//  Copyright © 2016年 oyf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetWorkDefine.h"
#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"

@interface NetWorkSession : NSObject

+(NSURLSessionDataTask *)requestWithManager:(AFHTTPSessionManager *) manager
                      url:(NSString *) url
                   params:(NSDictionary *) params
                     type:(NetWorkType) type
             successBlock:(requestSuccess) successBlock
             failureBlock:(requestFailure) failureBlock;

@end
