//
//  NetWorkSession.m
//
//  Created by 似云悠 on 16/7/23.
//  Copyright © 2016年 oyf. All rights reserved.
//

#import "NetWorkSession.h"

@implementation NetWorkSession

+(NSURLSessionDataTask *)requestWithManager:(AFHTTPSessionManager *) manager
                      url:(NSString *) url
                   params:(NSDictionary *) params
                     type:(NetWorkType) type
             successBlock:(requestSuccess) successBlock
             failureBlock:(requestFailure) failureBlock
{
    
    NSURLSessionDataTask *sessionDataTask;

    if(type == GET){
        
        sessionDataTask = [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSLog(@"================= %@ %@", url, responseObject);
            if(successBlock){
                successBlock((NSDictionary *)responseObject);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@", error);
            if(failureBlock){
                failureBlock(error);
            }
            
        }];
        
    }else if(type == POST){
        
      

        sessionDataTask = [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSLog(@"================= %@ %@", url, responseObject);
            if(successBlock){
                successBlock((NSDictionary *)responseObject);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if(failureBlock){
                failureBlock(error);
            }
            
        }];
        
        
    }
    
    return sessionDataTask;
    
}







@end
