//
//  NetWorkManager.m
//
//  Created by 似云悠 on 16/12/13.
//  Copyright © 2016年 SC. All rights reserved.
//

#import "NetWorkManager.h"
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetExportSession.h>
#import <AVFoundation/AVMediaFormat.h>




static NetWorkManager *sharedInstance = nil;

@interface NetWorkManager()

@end


@implementation NetWorkManager

#pragma mark - sharedInstanceMethod

+ (NetWorkManager *)sharedInstanceMethod
{
    if(sharedInstance == nil){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedInstance = [[super allocWithZone:NULL]init];
        });
    }
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        sharedInstance.taskDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [NetWorkManager sharedInstanceMethod];
}

- (id)copy
{
    return [NetWorkManager sharedInstanceMethod];
}


#pragma mark - 网络请求的get方法

+ (NSURLSessionDataTask *)getWithUrl:(NSString *)url
            params:(id)params
               tag:(id)tag
      successBlock:(requestSuccess)successBlock
      failureBlock:(requestFailure)failureBlock
{
    AFHTTPSessionManager *session = [NetWorkManager getSessionManager];
    
    NSURLSessionDataTask *task = [NetWorkSession requestWithManager:session url:url params:params type:GET successBlock:^(NSDictionary *dictObject) {
        if(successBlock){
            successBlock(dictObject);
        }
    } failureBlock:^(NSError *error) {
        if(failureBlock){
            failureBlock(error);
            NSLog(@"error.userInfo=%@",error.userInfo);
        }
    }];
    
    
    return task;
    
}

#pragma mark - 网络请求的post方法

+ (NSURLSessionDataTask *)postWithUrl:(NSString *)url
             params:(id)params
                tag:(id)tag
       successBlock:(requestSuccess)successBlock
       failureBlock:(requestFailure)failureBlock
{
    NSURLSessionDataTask *task = [NetWorkSession requestWithManager:[NetWorkManager getSessionManager] url:url params:params type:POST successBlock:^(NSDictionary *dictObject) {
        if(successBlock){
            successBlock(dictObject);
        }
    } failureBlock:^(NSError *error) {
        if(failureBlock){
            failureBlock(error);
            NSLog(@"error.userInfo = %@",error.userInfo);
        }
    }];
    
    return task;
    
}

+ (AFHTTPSessionManager *)getSessionManager
{
    static AFHTTPSessionManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
         manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", nil];
//        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//        [manager.requestSerializer setValue:@"zh-cn" forHTTPHeaderField:@"Accept-Language"];
//        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//        [manager.requestSerializer setValue:@"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.71 Safari/537.36" forHTTPHeaderField:@"User-Agent"];
        manager.requestSerializer.timeoutInterval = 10;
        //[manager.requestSerializer setValue:@"multipart/form-data;" forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setHTTPShouldHandleCookies:YES];
    });
    
    return manager;
    
}


#pragma mark - 取消网络请求
//取消所有的网络请求
+ (void)cancelAll
{
    [[NetWorkManager getSessionManager].operationQueue cancelAllOperations];
}

@end
