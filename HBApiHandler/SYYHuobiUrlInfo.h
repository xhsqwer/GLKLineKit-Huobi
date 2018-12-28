//
//  SYYHuobiUrlInfo.h
//  VirtualCoinMove
//
//  Created by 似云悠 on 2017/12/13.
//  Copyright © 2017年 syy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYYHuobiUrlInfo : NSObject

@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) NSDictionary *parames;


/**
 获取请求所需要并且已经处理过的信息（url，签名等）

 @param requestMethod 请求方法（eg.GET,POST）
 @param host 小写的访问地址(eg.be.huobi.com)
 @param path 访问方法的路径(eg.v1/order/orders)
 @param params 方法所需自带的参数
 @return 完场签名后的所需信息对象
 */
+ (SYYHuobiUrlInfo *)getUrlInfoWithRequeseMethod:(NSString *)requestMethod
                                            host:(NSString *)host
                                            path:(NSString *)path
                                          params:(NSDictionary *)params;

@end
