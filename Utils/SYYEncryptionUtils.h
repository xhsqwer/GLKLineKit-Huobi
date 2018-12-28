//
//  SYYEncryptionUtils.h
//
//  Created by 似云悠 on 2017/12/1.
//  Copyright © 2017年 syy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYYEncryptionUtils : NSObject



/**
 加密方式,MAC算法: HmacSHA256 (ps.Data经base64转码)

 @param plaintext   要加密的文本
 @param key         秘钥
 @return            加密后经base64转码的字符串
 */
+ (NSString *)hmac:(NSString *)plaintext withKey:(NSString *)key;


/**
 加密方式,Base64

 @param string  要加密的文本
 @return        加密后的字符串
 */
+ (NSString *)base64EncodeString:(NSString *)string;


/**
 URL参数转码 (ps.多次转码后值不一样)

 @param originalPara 要转码的参数
 @return 转码后的字符串
 */
+ (NSString *)encodeParameter:(NSString *)originalPara;



@end
