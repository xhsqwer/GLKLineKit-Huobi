//
//  SYYEncryptionUtils.m
//  VirtualCoinMove
//
//  Created by 似云悠 on 2017/12/1.
//  Copyright © 2017年 syy. All rights reserved.
//

#import "SYYEncryptionUtils.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation SYYEncryptionUtils


+ (NSString *)hmac:(NSString *)plaintext withKey:(NSString *)key
{
    
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [plaintext cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMACData = [NSData dataWithBytes:cHMAC length:sizeof(cHMAC)];

    NSString *HMAC = nil;
    HMAC = [HMACData base64EncodedStringWithOptions:0];
    return HMAC;
}


+ (NSString *)base64EncodeString:(NSString *)string;
{
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

+ (NSString *)encodeParameter:(NSString *)originalPara {
    
    NSString *charactersToEscape = @"!*'();:@&=+$,/?%#[]";
    NSCharacterSet *encodeUrlSet = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSString *encodePara = [originalPara stringByAddingPercentEncodingWithAllowedCharacters:encodeUrlSet];

    return encodePara;
}


@end
