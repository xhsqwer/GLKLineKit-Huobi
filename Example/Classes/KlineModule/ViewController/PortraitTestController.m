//
//  PortraitTestController.m
//  GLKLineKit
//
//  Created by walker on 2018/5/25.
//  Copyright © 2018年 walker. All rights reserved.
//

#import "PortraitTestController.h"
#import "SimpleKLineVolView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "KLineDataProcess.h"

#import "SocketRocket.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

#import "SYYHuobiNetHandler.h"

#import "WebSocketModel.h"

#import "zlib.h"

@interface PortraitTestController ()<SRWebSocketDelegate>
{
    NSTimer * heartBeat;//心跳
    NSTimeInterval reConnecTime;
    
    NSString * strHear;
}
/**
 简单行情视图
 */
@property (strong, nonatomic) SimpleKLineVolView *simpleKLineView;

/**
 分时切换按钮
 */
@property (strong, nonatomic) UIButton *timeBtn;

/**
 K线切换按钮
 */
@property (strong, nonatomic) UIButton *klineBtn;

@property(nonatomic,strong)SRWebSocket * webSocket;

@end

@implementation PortraitTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化
    [self p_initialize];
    // 设置UI
    [self p_setUpUI];
    // 获得K线数据
    [self p_getDataToKline];
    
    [self initSocket];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 控件事件 ---

- (void)btnAction:(UIButton *)btn {
    
    if (btn.tag == 8805) {
        // 分时
        [self.simpleKLineView switchKLineMainViewToType:KLineMainViewTypeTimeLine];
    }else if(btn.tag == 8806) {
        // K线
        [self.simpleKLineView switchKLineMainViewToType:KLineMainViewTypeKLine];
    }
}

#pragma  mark - 私有方法 ---

- (void)p_initialize {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = KLocalizedString(@"kline_demo_portrait", @"竖屏");
    
    if (@available(iOS 11.0, *)) {
        
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)p_setUpUI {
    
    [self.view addSubview:self.simpleKLineView];
    
    [self.view addSubview:self.klineBtn];
    [self.view addSubview:self.timeBtn];
}

- (void)p_getDataToKline {
    
    [self.simpleKLineView gl_startAnimating];
    
//    __weak typeof(self)weakSelf = self;
    
    [SYYHuobiNetHandler requestHistoryKlineWithTag:self
                                            symbol:@"btcusdt"
                                            period:@"1min"
                                              size:@"300"
                                           succeed:^(id respondObject) {
//                                               NSLog(@"-----%@",respondObject);
                                               NSArray *dataArray = [KLineDataProcess convertToKlineModelArrayWithJsonData:respondObject];
                                               [self.simpleKLineView.dataCenter addMoreDataWithArray:dataArray isMergeModel:^BOOL(KLineModel * _Nonnull firstModel, KLineModel * _Nonnull secondModel) {
                                                   // 如果返回YES表示需要合并，当前合并条件是两个元素的时间戳一致
                                                   return [KLineDataProcess checkoutIsInSameTimeSectionWithFirstTime:[firstModel.id integerValue] secondTime:[secondModel.id integerValue]];
                                               }];
                                               [self sendMessage];
                                               [self.simpleKLineView gl_stopAnimating];
                                           } failed:^(id error) {
                                               NSLog(@"-----%@",error);
                                           }];
    
}

#pragma mark - 懒加载 ----

- (SimpleKLineVolView *)simpleKLineView {
    if (!_simpleKLineView) {
        _simpleKLineView = [[SimpleKLineVolView alloc] initWithFrame:CGRectMake(10.0f, 100.0, SCREEN_WIDTH - 20.0f, 400.0f)];
        [_simpleKLineView switchKLineMainViewToType:KLineMainViewTypeKLineWithMA];
    }
    return _simpleKLineView;
}

- (UIButton *)timeBtn {
    
    if (!_timeBtn) {
        _timeBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, SCREEN_HEIGHT - 100, 100, 30)];
        [_timeBtn setTitle:KLocalizedString(@"kline_demo_timeLine", @"分时") forState:UIControlStateNormal];
        [_timeBtn setTag:8805];
        [_timeBtn setBackgroundColor:[UIColor grayColor]];
        [_timeBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _timeBtn;
}

- (UIButton *)klineBtn {
    
    if (!_klineBtn) {
        _klineBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, SCREEN_HEIGHT - 100, 100, 30)];
        [_klineBtn setTitle:KLocalizedString(@"kline_demo_Kline", @"k线") forState:UIControlStateNormal];
        [_klineBtn setTag:8806];
        [_klineBtn setBackgroundColor:[UIColor grayColor]];
        [_klineBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _klineBtn;
}

-(void)initSocket{
    //Url
    NSURL *url = [NSURL URLWithString:@"wss://api.huobi.pro/ws"];
    //    //请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
    //初始化请求`
    if (self.webSocket) {
        return;
    }
    _webSocket = [[SRWebSocket alloc] initWithURLRequest:request];
    //代理协议
    _webSocket.delegate = self;
    // 实现这个 SRWebSocketDelegate 协议啊
    //直接连接`
    [_webSocket open];    // open 就是直接连接了
}

-(void)sendMessage{

    NSDictionary * dataDic = [NSDictionary dictionaryWithObjectsAndKeys:@"market.btcusdt.kline.1min",@"sub",@"id1",@"id", nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDic options:NSJSONWritingPrettyPrinted error:nil];
    [_webSocket send: [[NSString alloc] initWithData:data
                                            encoding:NSUTF8StringEncoding]];

}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"连接成功，可以立刻登录你公司后台的服务器了，还有开启心跳");
}

-(void)initHearBeat
{
    if (@available(iOS 10.0, *)) {
        dispatch_main_async_safe((^{
            [self destoryHeartBeat];
            
            __weak typeof (self) weakSelf=self;
            //心跳设置为3分钟，NAT超时一般为5分钟
            self->heartBeat=[NSTimer scheduledTimerWithTimeInterval:60*3 repeats:YES block:^(NSTimer * _Nonnull timer) {
                
                NSNumber *kk= [NSNumber numberWithLong:[self->strHear longLongValue]];
//                self->strHear;
                
                NSDictionary * dataDic = [NSDictionary dictionaryWithObjectsAndKeys:kk,@"pong", nil];
                NSData *data = [NSJSONSerialization dataWithJSONObject:dataDic options:NSJSONWritingPrettyPrinted error:nil];
                //和服务端约定好发送什么作为心跳标识，尽可能的减小心跳包大小
                [self sendMsg:data];
            }];
            [[NSRunLoop currentRunLoop] addTimer:self->heartBeat forMode:NSRunLoopCommonModes];
        }))
    } else {
        // Fallback on earlier versions
    }
}

-(void)sendMsg:(id)msg
{
    [self.webSocket send:msg];
}

//   取消心跳
-(void)destoryHeartBeat
{
    dispatch_main_async_safe(^{
        if (self->heartBeat) {
            [self->heartBeat invalidate];
            self->heartBeat=nil;
        }
    })
}


-(void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"连接失败，这里可以实现掉线自动重连，要注意以下几点");
    NSLog(@"1.判断当前网络环境，如果断网了就不要连了，等待网络到来，在发起重连");
    NSLog(@"2.判断调用层是否需要连接，例如用户都没在聊天界面，连接上去浪费流量");
    //关闭心跳包
    [self reConnect];
}
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    //关闭心跳包
    //    [webSocket close];
    NSLog(@"连接断开，清空socket对象，清空该清空的东西，还有关闭心跳!");
    NSLog(@"%@",reason);
    //如果是被用户自己中断的那么直接断开连接，否则开始重连
    //    if (code == disConnectByUser) {
    //        [self disConnect];
    //    }else{
    
    [self reConnect];
    //    }
    //断开连接时销毁心跳
    [self destoryHeartBeat];
}

//  重连机制
-(void)reConnect
{
    [self disConnect];
    
    //  超过一分钟就不再重连   之后重连5次  2^5=64
    if (reConnecTime>64) {
        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(reConnecTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.webSocket = nil;
        [self initSocket];
    });
    
    //   重连时间2的指数级增长
    if (reConnecTime == 0) {
        reConnecTime =2;
    }else{
        reConnecTime *=2;
    }
}

//   断开连接
-(void)disConnect
{
    if (self.webSocket) {
        [self.webSocket close];
        self.webSocket = nil;
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message  {
    //收到数据代理方法
    // 收到数据后,你要给后台发送的数据.
    
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[self uncompressZippedData:message]
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
//
    NSLog(@"服务信息------:%@",[NSJSONSerialization JSONObjectWithData:[self uncompressZippedData:message]
                                                           options:NSJSONReadingMutableContainers
                                                             error:&err]);
    WebSocketModel *item = [WebSocketModel objectFromDictionary:dic];
    
    [self dataWith:item];
}

-(void)dataWith:(WebSocketModel *)dicModel
{
    if (dicModel.ping != nil) {
        NSNumber *kk= [NSNumber numberWithLong:[dicModel.ping longLongValue]];
        NSDictionary * dataDic = [NSDictionary dictionaryWithObjectsAndKeys:kk,@"pong", nil];
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:dataDic options:NSJSONWritingPrettyPrinted error:nil];
        

        [self.webSocket send:[[NSString alloc] initWithData:data
                                              encoding:NSUTF8StringEncoding]];
    }else if (dicModel.tick != nil){
        NSArray *dataArray = [NSArray arrayWithObject:dicModel.tick];
        
        [self.simpleKLineView.dataCenter addMoreDataWithArray:dataArray isMergeModel:^BOOL(KLineModel * _Nonnull firstModel, KLineModel * _Nonnull secondModel) {
            // 如果返回YES表示需要合并，当前合并条件是两个元素的时间戳一致
            return [KLineDataProcess checkoutIsInSameTimeSectionWithFirstTime:[firstModel.id integerValue] secondTime:[secondModel.id integerValue]];
        }];
    }
}

-(NSData *)uncompressZippedData:(NSData *)compressedData
{
    if ([compressedData length] == 0) return compressedData;
    
    unsigned full_length = [compressedData length];
    
    unsigned half_length = [compressedData length] / 2;
    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
    BOOL done = NO;
    int status;
    z_stream strm;
    strm.next_in = (Bytef *)[compressedData bytes];
    strm.avail_in = [compressedData length];
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    if (inflateInit2(&strm, (15+32)) != Z_OK) return nil;
    while (!done) {
        // Make sure we have enough room and reset the lengths.
        if (strm.total_out >= [decompressed length]) {
            [decompressed increaseLengthBy: half_length];
        }
        // chadeltu 加了(Bytef *)
        strm.next_out = (Bytef *)[decompressed mutableBytes] + strm.total_out;
        strm.avail_out = [decompressed length] - strm.total_out;
        // Inflate another chunk.
        status = inflate (&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END) {
            done = YES;
        } else if (status != Z_OK) {
            break;
        }
        
    }
    if (inflateEnd (&strm) != Z_OK) return nil;
    // Set real length.
    if (done) {
        [decompressed setLength: strm.total_out];
        return [NSData dataWithData: decompressed];
    } else {
        return nil;
    }
}



@end
