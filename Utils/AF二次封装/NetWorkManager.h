//
//  NetWorkManager.h
//
//  Created by 似云悠 on 16/12/13.
//  Copyright © 2016年 SC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetWorkDefine.h"
#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"
#import "NetWorkSession.h"


@interface NetWorkManager : NSObject

/**
 *  实例化
 *
 *  @return 实例化
 */
+ (NetWorkManager *)sharedInstanceMethod;

/**
 *  网络请求的实例方法--get
 *
 *  @param url          请求的地址
 *  @param params       请求的参数
 *  @param tag          标示
 *  @param successBlock 请求成功的回调
 *  @param failureBlock 请求失败的回调
 */

+ (NSURLSessionDataTask *)getWithUrl:(NSString *) url
            params:(id) params
               tag:(id)tag
        successBlock:(requestSuccess) successBlock
        failureBlock:(requestFailure) failureBlock;

/**
 *  网络请求的实例方法--post
 *
 *  @param url    请求的地址
 *  @param params    请求的参数
 *  @param tag          标示
 *  @param successBlock 请求成功的回调
 *  @param failureBlock 请求失败的回调
 */
+ (NSURLSessionDataTask *)postWithUrl:(NSString *) url
             params:(id) params
                tag:(id)tag
     successBlock:(requestSuccess) successBlock
     failureBlock:(requestFailure) failureBlock;



/**
 *  取消全部网络请求
 */
+ (void)cancelAll;


@end
