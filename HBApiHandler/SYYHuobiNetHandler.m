//
//  SYYHuobiNetHandler.m
//
//  Created by 似云悠 on 2017/12/5.
//  Copyright © 2017年 syy. All rights reserved.
//

#import "SYYHuobiNetHandler.h"
#import "NetWorkManager.h"
#import "SYYEncryptionUtils.h"
#import "SYYHuobiUrlInfo.h"


#import "SYYUtils.h"

@implementation SYYHuobiNetHandler

#pragma mark - 行情API

+ (void)requestHistoryKlineWithTag:(id)tag
                            symbol:(NSString *)symbol
                            period:(NSString *)period
                              size:(NSString *)size
                           succeed:(requestSuccess)succeed
                            failed:(requestFailure)failed{
    NSString *method = @"/market/history/kline";
    NSString *url = [NSString stringWithFormat:@"%@%@",kBaseUrl,method];
    NSDictionary *params = @{@"symbol":symbol,
                             @"period":period,
                             @"size":size
                             };
    
    [NetWorkManager getWithUrl:url params:params tag:self successBlock:succeed failureBlock:failed];

}

+ (void)requestMergedWithTag:(id)tag
                      symbol:(NSString *)symbol
                     succeed:(requestSuccess)succeed
                      failed:(requestFailure)failed{
    
    NSString *method = @"/market/detail/merged";
    NSString *url = [NSString stringWithFormat:@"%@%@",kBaseUrl,method];
    NSDictionary *params = @{@"symbol":symbol,
                             };
    
    [NetWorkManager getWithUrl:url params:params tag:self successBlock:succeed failureBlock:failed];
    
}

+ (void)requestDepthWithTag:(id)tag
                     symbol:(NSString *)symbol
                       type:(NSString *)type
                    succeed:(requestSuccess)succeed
                     failed:(requestFailure)failed{
    
    NSString *method = @"/market/depth";
    NSString *url = [NSString stringWithFormat:@"%@%@",kBaseUrl,method];
    NSDictionary *params = @{@"symbol":symbol,
                             @"type":type
                             };
    
   [NetWorkManager getWithUrl:url params:params tag:self successBlock:succeed failureBlock:failed];
}

+ (void)requestTradeWithTag:(id)tag
                     symbol:(NSString *)symbol
                    succeed:(requestSuccess)succeed
                     failed:(requestFailure)failed{
    
    NSString *method = @"/market/trade";
    NSString *url = [NSString stringWithFormat:@"%@%@",kBaseUrl,method];
    NSDictionary *params = @{@"symbol":symbol,
                             };
    
    [NetWorkManager getWithUrl:url params:params tag:self successBlock:succeed failureBlock:failed];

}

+ (void)requestHistoryTradeWithTag:(id)tag
                            symbol:(NSString *)symbol
                              size:(NSString *)size
                           succeed:(requestSuccess)succeed
                            failed:(requestFailure)failed{
    
    NSString *method = @"/market/history/trade";
    NSString *url = [NSString stringWithFormat:@"%@%@",kBaseUrl,method];
    NSDictionary *params = @{@"symbol":symbol,
                             @"size":size
                             };
    
    [NetWorkManager getWithUrl:url params:params tag:self successBlock:succeed failureBlock:failed];
}

+ (void)requestDetailWithTag:(id)tag
                      symbol:(NSString *)symbol
                     succeed:(requestSuccess)succeed
                      failed:(requestFailure)failed{
    
    NSString *method = @"/market/detail";
    NSString *url = [NSString stringWithFormat:@"%@%@",kBaseUrl,method];
    NSDictionary *params = @{@"symbol":symbol
                             };
    
    [NetWorkManager getWithUrl:url params:params tag:self successBlock:succeed failureBlock:failed];
    
}

#pragma mark - 公共API

+ (void)requestSymbolsWithTag:(id)tag
                      succeed:(requestSuccess)succeed
                       failed:(requestFailure)failed{
    
    NSString *method = @"/v1/common/symbols";
    NSString *url = [NSString stringWithFormat:@"%@%@",kBaseUrl,method];
    
    
    [NetWorkManager getWithUrl:url params:nil tag:self successBlock:succeed failureBlock:failed];
}

+ (void)requestCurrencysWithTag:(id)tag
                        succeed:(requestSuccess)succeed
                         failed:(requestFailure)failed;
{
    NSString *method = @"/v1/common/currencys";
    NSString *url = [NSString stringWithFormat:@"%@%@",kBaseUrl,method];
    
    [NetWorkManager getWithUrl:url params:nil tag:self successBlock:succeed failureBlock:failed];
}

+ (void)requestTimestampWithTag:(id)tag
                        succeed:(requestSuccess)succeed
                         failed:(requestFailure)failed{
    
    NSString *method = @"/v1/common/timestamp";
    NSString *url = [NSString stringWithFormat:@"%@%@",kBaseUrl,method];
    
    [NetWorkManager getWithUrl:url params:nil tag:self successBlock:succeed failureBlock:failed];
}

#pragma mark - 用户资产API

+ (void)requestAccountsWithTag:(id)tag succeed:(requestSuccess)succeed  failed:(requestFailure)failed{
    
    
    NSString *path = @"/v1/account/accounts";

    SYYHuobiUrlInfo *urlInfo = [SYYHuobiUrlInfo getUrlInfoWithRequeseMethod:@"GET" host:kBaseUrl path:path params:nil];
    
    [NetWorkManager getWithUrl:urlInfo.url params:urlInfo.parames tag:self successBlock:succeed failureBlock:failed];
    
    
    
}

+ (void)requestAccountBalanceWithTag:(id)tag
                           accountId:(NSString *)accountId
                             succeed:(requestSuccess)succeed
                              failed:(requestFailure)failed{
    
    NSString *path = [NSString stringWithFormat:@"/v1/account/accounts/%@/balance",accountId];
    
    SYYHuobiUrlInfo *urlInfo = [SYYHuobiUrlInfo getUrlInfoWithRequeseMethod:@"GET" host:kBaseUrl path:path params:nil];
    [NetWorkManager getWithUrl:urlInfo.url params:urlInfo.parames tag:self successBlock:succeed failureBlock:failed];
    
}

#pragma mark - 交易API

+ (void)requestCreatOrderWithTag:(id)tag
                       accountId:(NSString *)accountId
                          amount:(NSString *)amount
                           price:(NSString *)price
                          source:(NSString *)source
                          symbol:(NSString *)symbol
                            type:(NSString *)type
                         succeed:(requestSuccess)succeed
                          failed:(requestFailure)failed{
    
    
    NSString *path = @"/v1/order/orders/place";
    
    NSMutableDictionary *originalParams = [[NSMutableDictionary alloc] initWithDictionary:@{@"account-id":accountId,
                                                                                            @"amount":amount,
                                                                                            @"symbol":symbol,
                                                                                            @"type":type
                                                                                            }];
    
    if(![type hasSuffix:@"market"]){//市价单不传
        [originalParams setValue:price forKey:@"price"];
    }
    if(source){
        [originalParams setValue:source forKey:@"source"];
    }

    SYYHuobiUrlInfo *urlInfo = [SYYHuobiUrlInfo getUrlInfoWithRequeseMethod:@"POST" host:kBaseUrl path:path params:originalParams];
    
    [NetWorkManager postWithUrl:urlInfo.url params:urlInfo.parames tag:tag successBlock:succeed failureBlock:failed];
}

+ (void)requestSubmitcancelWithTag:(id)tag
                           orderId:(NSString *)orderId
                           succeed:(requestSuccess)succeed
                            failed:(requestFailure)failed{
    
    NSString *path = [NSString stringWithFormat:@"/v1/order/orders/%@/submitcancel",orderId];
    
    SYYHuobiUrlInfo *urlInfo = [SYYHuobiUrlInfo getUrlInfoWithRequeseMethod:@"POST" host:kBaseUrl path:path params:nil];
    [NetWorkManager postWithUrl:urlInfo.url params:nil tag:tag successBlock:succeed failureBlock:failed];
}

+ (void)requstBatchcancelWithTag:(id)tag
                        orderIds:(NSString *)orderIds
                         succeed:(requestSuccess)succeed
                          failed:(requestFailure)failed{
    
    NSString *path = @"/v1/order/orders/batchcancel";
    
    SYYHuobiUrlInfo *urlInfo = [SYYHuobiUrlInfo getUrlInfoWithRequeseMethod:@"POST" host:kBaseUrl path:path params:nil];
    [NetWorkManager postWithUrl:urlInfo.url params:nil tag:tag successBlock:succeed failureBlock:failed];
}

+ (void)requestOrderDetailWithTag:(id)tag
                          orderId:(NSString *)orderId
                          succeed:(requestSuccess)succeed
                           failed:(requestFailure)failed{
    
    NSString *path = [NSString stringWithFormat:@"/v1/order/orders/%@",orderId];
    
    SYYHuobiUrlInfo *urlInfo = [SYYHuobiUrlInfo getUrlInfoWithRequeseMethod:@"GET" host:kBaseUrl path:path params:nil];
    [NetWorkManager postWithUrl:urlInfo.url params:nil tag:tag successBlock:succeed failureBlock:failed];
}

+ (void)requestMatchresultsWithTag:(id)tag
                           orderId:(NSString *)orderId
                           succeed:(requestSuccess)succeed
                            failed:(requestFailure)failed{
    
    NSString *path = [NSString stringWithFormat:@"/v1/order/orders/{%@/matchresults",orderId];
    
    SYYHuobiUrlInfo *urlInfo = [SYYHuobiUrlInfo getUrlInfoWithRequeseMethod:@"GET" host:kBaseUrl path:path params:nil];
    [NetWorkManager postWithUrl:urlInfo.url params:nil tag:tag successBlock:succeed failureBlock:failed];
}

+ (void)requestOrdersWithTag:(id)tag
                      symbol:(NSString *)symbol
                       types:(NSString *)types
                   startDate:(NSString *)startDate
                     endDate:(NSString *)endDate
                      states:(NSString *)states
                        from:(NSString *)from
                      direct:(NSString *)direct
                        size:(NSString *)size
                     succeed:(requestSuccess)succeed
                      failed:(requestFailure)failed{
    
    NSString *path = @"/v1/order/orders";
    NSMutableDictionary *params = @{@"symbol":symbol,
                                    @"states":states
                                    }.mutableCopy;
    if(types){
        [params setValue:types forKey:@"types"];
    }
    if(startDate){
        [params setValue:startDate forKey:@"start-date"];
    }
    if(endDate){
        [params setValue:endDate forKey:@"end-date"];
    }
    if(from){
        [params setValue:from forKey:@"from"];
    }
    if(direct){
        [params setValue:direct forKey:@"direct"];
    }
    if(size){
        [params setValue:size forKey:@"size"];
    }
    
    SYYHuobiUrlInfo *urlInfo = [SYYHuobiUrlInfo getUrlInfoWithRequeseMethod:@"GET" host:kBaseUrl path:path params:params];
    [NetWorkManager postWithUrl:urlInfo.url params:nil tag:tag successBlock:succeed failureBlock:failed];
}

+ (void)requestOrderMatchresultsWithTag:(id)tag
                                 symbol:(NSString *)symbol
                                  types:(NSString *)types
                              startDate:(NSString *)startDate
                                endDate:(NSString *)endDate
                                   from:(NSString *)from
                                 direct:(NSString *)direct
                                   size:(NSString *)size
                                succeed:(requestSuccess)succeed
                                 failed:(requestFailure)failed{
    
    NSString *path = @"/v1/order/matchresults";
    NSMutableDictionary *params = @{@"symbol":symbol                                }.mutableCopy;
    if(types){
        [params setValue:types forKey:@"types"];
    }
    if(startDate){
        [params setValue:startDate forKey:@"start-date"];
    }
    if(endDate){
        [params setValue:endDate forKey:@"end-date"];
    }
    if(from){
        [params setValue:from forKey:@"from"];
    }
    if(direct){
        [params setValue:direct forKey:@"direct"];
    }
    if(size){
        [params setValue:size forKey:@"size"];
    }
    
    SYYHuobiUrlInfo *urlInfo = [SYYHuobiUrlInfo getUrlInfoWithRequeseMethod:@"GET" host:kBaseUrl path:path params:params];
    [NetWorkManager postWithUrl:urlInfo.url params:nil tag:tag successBlock:succeed failureBlock:failed];
}

#pragma mark - 借贷交易API
+ (void)requestDWTransferInMarginWithTag:(NSString *)tag
                                  symbol:(NSString *)symbol
                                currency:(NSString *)currency
                                  amount:(NSString *)amount
                                 succeed:(requestSuccess)succeed
                                  failed:(requestFailure)failed{
    
    NSString *path = @"/v1/dw/transfer-in/margin";
    NSDictionary *params = @{@"symbol":symbol,
                             @"currency":currency,
                             @"amount":amount
                             };
    
    SYYHuobiUrlInfo *urlInfo = [SYYHuobiUrlInfo getUrlInfoWithRequeseMethod:@"POST" host:kBaseUrl path:path params:params];
    [NetWorkManager postWithUrl:urlInfo.url params:urlInfo.parames tag:tag successBlock:succeed failureBlock:failed];
}

+ (void)requestDWTransferOutMarginWithTag:(NSString *)tag
                                   symbol:(NSString *)symbol
                                 currency:(NSString *)currency
                                   amount:(NSString *)amount
                                  succeed:(requestSuccess)succeed
                                   failed:(requestFailure)failed{
    NSString *path = @"/v1/dw/transfer-out/margin";
    NSDictionary *params = @{@"symbol":symbol,
                             @"currency":currency,
                             @"amount":amount
                             };
    
    SYYHuobiUrlInfo *urlInfo = [SYYHuobiUrlInfo getUrlInfoWithRequeseMethod:@"POST" host:kBaseUrl path:path params:params];
    [NetWorkManager postWithUrl:urlInfo.url params:urlInfo.parames tag:tag successBlock:succeed failureBlock:failed];
}

+ (void)requestMarginOrdersWithTag:(id)tag
                            symbol:(NSString *)symbol
                          currency:(NSString *)currency
                            amount:(NSString *)amount
                           succeed:(requestSuccess)succeed
                            failed:(requestFailure)failed{
    
    NSString *path = @"/v1/margin/orders";
    NSDictionary *params = @{@"symbol":symbol,
                             @"currency":currency,
                             @"amount":amount
                             };
    
    SYYHuobiUrlInfo *urlInfo = [SYYHuobiUrlInfo getUrlInfoWithRequeseMethod:@"POST" host:kBaseUrl path:path params:params];
    [NetWorkManager postWithUrl:urlInfo.url params:urlInfo.parames tag:tag successBlock:succeed failureBlock:failed];
}

+ (void)requestRepayWithTag:(id)tag
                    orderId:(NSString *)orderId
                     amount:(NSString *)amount
                    succeed:(requestSuccess)succeed
                     failed:(requestFailure)failed{
 
    NSString *path = [NSString stringWithFormat:@"/v1/margin/orders/%@/repay",orderId];
    NSDictionary *params = @{@"amount":amount};
    
    SYYHuobiUrlInfo *urlInfo = [SYYHuobiUrlInfo getUrlInfoWithRequeseMethod:@"POST" host:kBaseUrl path:path params:params];
    [NetWorkManager postWithUrl:urlInfo.url params:urlInfo.parames tag:tag successBlock:succeed failureBlock:failed];
}

+ (void)requestLoanOrdersWithTag:(id)tag
                          symbol:(NSString *)symbol
                        currency:(NSString *)currency
                       startDate:(NSString *)startDate
                         endDate:(NSString *)endDate
                          states:(NSString *)states
                            from:(NSString *)from
                          direct:(NSString *)direct
                            size:(NSString *)size
                         succeed:(requestSuccess)succeed
                          failed:(requestFailure)failed{
    
    NSString *path = @"/v1/margin/loan-orders";
    NSMutableDictionary *params = @{@"symbol":symbol,
                                    @"currency":currency,
                                    @"states":states
                                    }.mutableCopy;
    if(startDate){
        [params setValue:startDate forKey:@"start-date"];
    }
    if(endDate){
        [params setValue:endDate forKey:@"endDate"];
    }
    if(from){
        [params setValue:from forKey:@"from"];
    }
    if(direct){
        [params setValue:direct forKey:@"direct"];
    }
    if(size){
        [params setValue:size forKey:@"size"];
    }
    
    SYYHuobiUrlInfo *urlInfo = [SYYHuobiUrlInfo getUrlInfoWithRequeseMethod:@"GET" host:kBaseUrl path:path params:params];
    [NetWorkManager postWithUrl:urlInfo.url params:urlInfo.parames tag:tag successBlock:succeed failureBlock:failed];
    
}

+ (void)requestmarginAccountsBalanceWithTag:(NSString *)tag
                                     symbol:(NSString *)symbol
                                    succeed:(requestSuccess)succeed
                                     failed:(requestFailure)failed{
    
    NSString *path = @"/v1/margin/accounts/balance";
    NSMutableDictionary *params = @{}.mutableCopy;
    if(symbol){
        [params setValue:symbol forKey:@"symbol"];
    }
    
    SYYHuobiUrlInfo *urlInfo = [SYYHuobiUrlInfo getUrlInfoWithRequeseMethod:@"GET" host:kBaseUrl path:path params:params];
    [NetWorkManager postWithUrl:urlInfo.url params:urlInfo.parames tag:tag successBlock:succeed failureBlock:failed];
}

#pragma mark - 虚拟币提现API (ps.仅支持提现到【Pro站的提币地址列表中的提币地址】)

+ (void)requestDWWithdrawWithTag:(id)tag
                         address:(NSString *)address
                          amount:(NSString *)amount
                        currency:(NSString *)currency
                             fee:(NSString *)fee
                         addrTag:(NSString *)addrTag
                         succeed:(requestSuccess)succeed
                          failed:(requestFailure)failed{
    
    NSString *path = @"/v1/dw/withdraw/api/create";
    NSMutableDictionary *params = @{@"address":address,
                                    @"amount":amount,
                                    @"currency":currency
                                    }.mutableCopy;
    if(fee){
        [params setValue:fee forKey:@"fee"];
    }
    if(addrTag){
        [params setValue:addrTag forKey:@"addr-tag"];
    }
    
    SYYHuobiUrlInfo *urlInfo = [SYYHuobiUrlInfo getUrlInfoWithRequeseMethod:@"POST" host:kBaseUrl path:path params:params];
    [NetWorkManager postWithUrl:urlInfo.url params:urlInfo.parames tag:tag successBlock:succeed failureBlock:failed];
    
}

+ (void)requestCancelWithdrawWithTag:(id)tag
                          withdrawId:(NSString *)withdrawId
                             succeed:(requestSuccess)succeed
                              failed:(requestFailure)failed{
    
    NSString *path = [NSString stringWithFormat:@"/v1/dw/withdraw-virtual/%@/cancel",withdrawId];
    
    SYYHuobiUrlInfo *urlInfo = [SYYHuobiUrlInfo getUrlInfoWithRequeseMethod:@"POST" host:kBaseUrl path:path params:nil];
    [NetWorkManager postWithUrl:urlInfo.url params:urlInfo.parames tag:tag successBlock:succeed failureBlock:failed];
}



@end
