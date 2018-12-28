//
//  SYYUtils.h
//
//  Created by 似云悠 on 2017/12/3.
//  Copyright © 2017年 syy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYYUtils : NSObject


/**
 ASCII码排序

 @param array 要排序的ASCII码字符串数组
 @return 排完序的ASCII码字符串数组
 */
+ (NSArray *)ASCIISortedArray:(NSArray *)array;


/**
 拼接GET方法url地址
 */
+ (NSString *)getGetUrlWithUrl:(NSString *)url params:(NSDictionary *)params;

/**
 将字典中的值进行url转码
 
 @param dic 需要转码的字典
 @return 转完码的字典
 */
+ (NSDictionary *)encodeParameterWithDictionary:(NSDictionary *)dic;

/**
 UTC时区时间
 */
+ (NSString *)dateTransformToTimeString:(NSString *)string;

@end
