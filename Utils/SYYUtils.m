//
//  SYYUtils.m
//
//  Created by 似云悠 on 2017/12/3.
//  Copyright © 2017年 syy. All rights reserved.
//

#import "SYYUtils.h"
#import "SYYEncryptionUtils.h"

@implementation SYYUtils

+ (NSArray *)ASCIISortedArray:(NSArray *)array{
    
   return [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
       return [obj1 compare:obj2];
    }];
}

+ (NSString *)getGetUrlWithUrl:(NSString *)url params:(NSDictionary *)params{
    NSDictionary *dic = [self encodeParameterWithDictionary:params];
    
    NSMutableString *string = [[NSMutableString alloc] initWithString:url];
    
    for(int i=0; i<dic.allKeys.count; i++){
        NSString *key = dic.allKeys[i];
        if(i == 0){
            [string appendFormat:@"?%@=%@",key,dic[key]];
        }else{
            [string appendFormat:@"&%@=%@",key,dic[key]];
        }
    }
    
    return string;
}


+ (NSDictionary *)encodeParameterWithDictionary:(NSDictionary *)dic{
    
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];;
    for(id key in dic.allKeys){
        NSString *resultVaule =[SYYEncryptionUtils encodeParameter:dic[key]];
        [resultDic setValue:resultVaule forKey:key];
    }
    return resultDic;
}

/**
 UTC时区时间
 */
+ (NSString *)dateTransformToTimeString:(NSString *)string
{
    NSDate *currentDate = [NSDate date];//获得当前时间为UTC时间 2014-07-16 07:54:36 UTC  (UTC时间比标准时间差8小时)
    NSDateFormatter*df = [[NSDateFormatter alloc]init];
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [df setTimeZone:timeZone];
    [df setDateFormat:string];
    NSString *timeString = [df stringFromDate:currentDate];
    return timeString;
}
@end
