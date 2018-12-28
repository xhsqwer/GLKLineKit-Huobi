//
//  SYYHuobiUrlInfo.m
//
//  Created by 似云悠 on 2017/12/13.
//  Copyright © 2017年 syy. All rights reserved.
//

#import "SYYHuobiUrlInfo.h"

#import "SYYEncryptionUtils.h"
#import "SYYUtils.h"
#import "SYYHuobiConstant.h"

@implementation SYYHuobiUrlInfo

+ (SYYHuobiUrlInfo *)getUrlInfoWithRequeseMethod:(NSString *)requestMethod
                                            host:(NSString *)host
                                          path:(NSString *)path
                                          params:(NSDictionary *)params{
    //需要签名(需要拼接在url上的参数)
    NSMutableDictionary *signatureParamsDic = [self requiredParams];
    //不需要签名(在body上的参数)
       NSMutableDictionary *noSignatureParamsDic = [[NSMutableDictionary alloc] init];
    
    if([requestMethod isEqualToString:@"GET"]){
        [signatureParamsDic setValuesForKeysWithDictionary:params];
    }else if([requestMethod isEqualToString:@"POST"]){
        [noSignatureParamsDic setValuesForKeysWithDictionary:params];
    }
    
    NSString *signatureVaule = [self signatureWithRequeseMethod:requestMethod host:host path:path params:signatureParamsDic];
    
    
    [signatureParamsDic setValue:signatureVaule forKey:@"Signature"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",host,path];
    
    SYYHuobiUrlInfo *urlInfo = [[SYYHuobiUrlInfo alloc] init];
    urlInfo.url = [SYYUtils getGetUrlWithUrl:url params:signatureParamsDic];
    urlInfo.parames = noSignatureParamsDic;
    
    return urlInfo;
    
}


+ (NSString *)signatureWithRequeseMethod:(NSString *)requestMethod
                                    host:(NSString *)host
                                  path:(NSString *)path
                                  params:(NSDictionary *)params{
    
    
    host = [host stringByReplacingOccurrencesOfString:@"https://" withString:@""];
    host = [host stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    
    NSString *signature = @"";
    //加密前先将值进行url转码
    params = [SYYUtils encodeParameterWithDictionary:params];
    //需要加密的参数名称（ascii排过序的）
    NSArray *paramsSortArray = [SYYUtils ASCIISortedArray:params.allKeys];
    NSMutableString *signatureOriginalStr = [[NSMutableString alloc] initWithString:@""];
    [signatureOriginalStr appendFormat:@"%@\n",requestMethod];
    [signatureOriginalStr appendFormat:@"%@\n",host];
    [signatureOriginalStr appendFormat:@"%@\n",path];
    
    for(int i=0; i<paramsSortArray.count; i++){
        NSString *key = paramsSortArray[i];
        if(i == 0){
            [signatureOriginalStr appendFormat:@"%@=%@",key,params[key]];
        }else{
            [signatureOriginalStr appendFormat:@"&%@=%@",key,params[key]];
        }
    }
    
    signature = [SYYEncryptionUtils hmac:signatureOriginalStr withKey:kHBSecretKey];
    
    return signature;
}


#pragma mark - Private

/**
 签名必选参数
 */
+ (NSMutableDictionary *)requiredParams{
    
    NSMutableDictionary *params = @{@"AccessKeyId":
                                        kHBAccessKey,
                                    @"SignatureMethod":
                                        @"HmacSHA256",
                                    @"SignatureVersion":
                                        @"2",
                                    @"Timestamp":[SYYUtils dateTransformToTimeString:@"yyyy-MM-dd'T'HH:mm:ss"]
                                    }.mutableCopy;
    return params;
}

@end
