//
//  SYYHuobiNetHandler.h
//
//  Created by 似云悠 on 2017/12/5.
//  Copyright © 2017年 syy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetWorkDefine.h"


/**
 火币接口
 */
@interface SYYHuobiNetHandler : NSObject

#pragma mark - 行情API

/**
 GET /market/depth 获取 Market Depth 数据

 @param symbol 交易对 (eg.btcusdt, ethusdt, ltcusdt, etcusdt, bccusdt, bccbtc, ethbtc, ltcbtc, etcbtc, kncbtc, zrxbtc, astbtc, rcnbtc, rcneth)
 @param type Depth 类型(eg.step0, step1, step2, step3, step4, step5（合并深度0-5）；step0时，不合并深度)
 */
+ (void)requestDepthWithTag:(id)tag
                     symbol:(NSString *)symbol
                       type:(NSString *)type
                    succeed:(requestSuccess)succeed
                     failed:(requestFailure)failed;


/**
 GET /market/detail/merged 获取聚合行情(Ticker)

 @param symbol 交易对 (eg.btcusdt, ethusdt)
 */
+ (void)requestMergedWithTag:(id)tag
                      symbol:(NSString *)symbol
                     succeed:(requestSuccess)succeed
                      failed:(requestFailure)failed;



/**
 GET /market/history/kline 获取K线数据

 @param symbol 交易对（eg.btcusdt, ethusdt）
 @param period K线类型(eg.1min, 5min, 15min, 30min, 60min, 1day, 1mon, 1week, 1year)
 @param size 获取数量(ps.范围[1,2000])
 */
+ (void)requestHistoryKlineWithTag:(id)tag
                            symbol:(NSString *)symbol
                            period:(NSString *)period
                              size:(NSString *)size
                           succeed:(requestSuccess)succeed
                            failed:(requestFailure)failed;


/**
 GET /market/trade 获取 Trade Detail 数据

 @param symbol 交易对（eg.btcusdt, ethusdt）
 */
+ (void)requestTradeWithTag:(id)tag
                     symbol:(NSString *)symbol
                    succeed:(requestSuccess)succeed
                     failed:(requestFailure)failed;


/**
 GET /market/history/trade 批量获取最近的交易记录

 @param symbol 交易对（eg.btcusdt, ethusdt）
 @param size 获取交易记录的数量
 */
+ (void)requestHistoryTradeWithTag:(id)tag
                            symbol:(NSString *)symbol
                              size:(NSString *)size
                           succeed:(requestSuccess)succeed
                            failed:(requestFailure)failed;


/**
 GET /market/detail 获取 Market Detail 24小时成交量数据

 @param symbol 交易对（eg.btcusdt, ethusdt）
 */
+ (void)requestDetailWithTag:(id)tag
                      symbol:(NSString *)symbol
                     succeed:(requestSuccess)succeed
                      failed:(requestFailure)failed;

#pragma mark - 公共API

/**
 GET /v1/common/symbols 查询系统支持的所有交易对
 */
+ (void)requestSymbolsWithTag:(id)tag
                      succeed:(requestSuccess)succeed
                       failed:(requestFailure)failed;


/**
 GET /v1/common/currencys 查询系统支持的所有币种
 */
+ (void)requestCurrencysWithTag:(id)tag
                        succeed:(requestSuccess)succeed
                         failed:(requestFailure)failed;


/**
 GET /v1/common/timestamp 查询系统当前时间
 */
+ (void)requestTimestampWithTag:(id)tag
                        succeed:(requestSuccess)succeed
                         failed:(requestFailure)failed;


#pragma mark - 用户资产API
//GET /v1/account/accounts 查询当前用户的所有账户(即account-id)
+ (void)requestAccountsWithTag:(id)tag succeed:(requestSuccess)succeed  failed:(requestFailure)failed;


//GET /v1/account/accounts/{account-id}/balance 查询指定账户的余额
+ (void)requestAccountBalanceWithTag:(id)tag
                           accountId:(NSString *)accountId
                             succeed:(requestSuccess)succeed
                              failed:(requestFailure)failed;

#pragma mark - 交易API

/**
 POST /v1/order/orders/place 创建并执行一个新订单

 @param accountId 账户 ID
 @param amount 限价单表示下单数量，市价买单时表示买多少钱，市价卖单时表示卖多少币
 @param price 下单价格，市价单不传该参数
 @param source 订单来源(ps.api，如果使用借贷资产交易，请填写‘margin-api’)
 @param symbol 交易对(eg.btcusdt, ethusdt, ltcusdt, etcusdt, bccusdt, bccbtc, ethbtc, ltcbtc, etcbtc, kncbtc, zrxbtc, astbtc, rcnbtc, rcneth)
 @param type 订单类型(eg.buy-market：市价买, sell-market：市价卖, buy-limit：限价买, sell-limit：限价卖)
 */
+ (void)requestCreatOrderWithTag:(id)tag
                       accountId:(NSString *)accountId
                          amount:(NSString *)amount
                           price:(NSString *)price
                          source:(NSString *)source
                          symbol:(NSString *)symbol
                            type:(NSString *)type
                         succeed:(requestSuccess)succeed
                          failed:(requestFailure)failed;

//POST /v1/order/orders/{order-id}/submitcancel 申请撤销一个订单请求
+ (void)requestSubmitcancelWithTag:(id)tag
                           orderId:(NSString *)orderId
                           succeed:(requestSuccess)succeed
                            failed:(requestFailure)failed;

//POST /v1/order/orders/batchcancel 批量撤销订单
+ (void)requstBatchcancelWithTag:(id)tag
                        orderIds:(NSString *)orderIds
                         succeed:(requestSuccess)succeed
                          failed:(requestFailure)failed;


//GET /v1/order/orders/{order-id} 查询某个订单详情
+ (void)requestOrderDetailWithTag:(id)tag
                          orderId:(NSString *)orderId
                          succeed:(requestSuccess)succeed
                           failed:(requestFailure)failed;



//GET /v1/order/orders/{order-id}/matchresults 查询某个订单的成交明细
+ (void)requestMatchresultsWithTag:(id)tag
                           orderId:(NSString *)orderId
                           succeed:(requestSuccess)succeed
                            failed:(requestFailure)failed;


/**
 GET /v1/order/orders 查询当前委托、历史委托

 @param symbol 交易对
 @param types 查询的订单类型组合，使用','分割
 @param startDate 查询开始日期, 日期格式yyyy-mm-dd
 @param endDate 查询结束日期, 日期格式yyyy-mm-dd
 @param states 查询的订单状态组合，使用','分割
 @param from 查询起始 ID
 @param direct 查询方向
 @param size 查询记录大小
 */
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
                      failed:(requestFailure)failed;

/**
 GET /v1/order/matchresults 查询当前成交、历史成交
 
 @param symbol 交易对
 @param types 查询的订单类型组合，使用','分割
 @param startDate 查询开始日期, 日期格式yyyy-mm-dd
 @param endDate 查询结束日期, 日期格式yyyy-mm-dd
 @param from 查询起始 ID
 @param direct 查询方向
 @param size 查询记录大小
 */
+ (void)requestOrderMatchresultsWithTag:(id)tag
                                 symbol:(NSString *)symbol
                                  types:(NSString *)types
                              startDate:(NSString *)startDate
                                endDate:(NSString *)endDate
                                   from:(NSString *)from
                                 direct:(NSString *)direct
                                   size:(NSString *)size
                                succeed:(requestSuccess)succeed
                                 failed:(requestFailure)failed;


#pragma mark - 借贷交易API

//POST /v1/dw/transfer-in/margin 现货账户划入至借贷账户
+ (void)requestDWTransferInMarginWithTag:(NSString *)tag
                                  symbol:(NSString *)symbol
                                currency:(NSString *)currency
                                  amount:(NSString *)amount
                                 succeed:(requestSuccess)succeed
                                  failed:(requestFailure)failed;


//POST /v1/dw/transfer-out/margin 借贷账户划出至现货账户
+ (void)requestDWTransferOutMarginWithTag:(NSString *)tag
                                   symbol:(NSString *)symbol
                                 currency:(NSString *)currency
                                   amount:(NSString *)amount
                                  succeed:(requestSuccess)succeed
                                   failed:(requestFailure)failed;

//POST /v1/margin/orders 申请借贷
+ (void)requestMarginOrdersWithTag:(id)tag
                            symbol:(NSString *)symbol
                          currency:(NSString *)currency
                            amount:(NSString *)amount
                           succeed:(requestSuccess)succeed
                            failed:(requestFailure)failed;


//POST /v1/margin/orders/{order-id}/repay 归还借贷
+ (void)requestRepayWithTag:(id)tag
                    orderId:(NSString *)orderId
                     amount:(NSString *)amount
                    succeed:(requestSuccess)succeed
                     failed:(requestFailure)failed;


//GET /v1/margin/loan-orders 借贷订单
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
                          failed:(requestFailure)failed;


//GET /v1/margin/accounts/balance?symbol={symbol} 借贷账户详情
+ (void)requestmarginAccountsBalanceWithTag:(NSString *)tag
                                     symbol:(NSString *)symbol
                                    succeed:(requestSuccess)succeed
                                     failed:(requestFailure)failed;

#pragma mark - 虚拟币提现API (ps.仅支持提现到【Pro站的提币地址列表中的提币地址】)


/**
 POST /v1/dw/withdraw/api/create 申请提现虚拟币

 @param address 提现地址
 @param amount 提币数量
 @param currency 资产类型
 @param fee 转账手续费
 @param addrTag 虚拟币共享地址tag，XRP特有(ps.格式, "123"类的整数字符串)
 */
+ (void)requestDWWithdrawWithTag:(id)tag
                         address:(NSString *)address
                          amount:(NSString *)amount
                        currency:(NSString *)currency
                             fee:(NSString *)fee
                         addrTag:(NSString *)addrTag
                         succeed:(requestSuccess)succeed
                          failed:(requestFailure)failed;


/**
 POST /v1/dw/withdraw-virtual/{withdraw-id}/cancel 申请取消提现虚拟币

 @param withdrawId 提现ID
 */
+ (void)requestCancelWithdrawWithTag:(id)tag
                          withdrawId:(NSString *)withdrawId
                             succeed:(requestSuccess)succeed
                              failed:(requestFailure)failed;

@end
