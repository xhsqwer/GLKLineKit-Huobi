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

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

#import "SYYHuobiNetHandler.h"

#import "WebSocketModel.h"

#import "SocketManager.h"

#import "zlib.h"

@interface PortraitTestController ()
{
    SocketManager *_socketData;
    BOOL _sendStatus;
    BOOL _openStatus;
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
                                               if (self->_openStatus == 1) {
                                                   [self sendMessage];
                                               }
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
    _socketData= [SocketManager sharedInsatance];
    
    [_socketData webSocketOpen:@"wss://api.huobi.pro/ws" connect:^{
        NSLog(@"成功连接");
        self->_openStatus=YES;
        if (self->_sendStatus == 0) {
            [self sendMessage];
        }
    } receive:^(id message, SocketReceiveType type) {
        if (type == SocketReceiveTypeForMessage) {
            NSLog(@"接收 类型1--%@",message);
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
        else if (type == SocketReceiveTypeForPong){
            NSLog(@"接收 类型2--%@",message);
        }
    } failure:^(NSError *error) {
        NSLog(@"连接失败");
    }];
}

-(void)sendMessage{
    _sendStatus=YES;
    NSDictionary * dataDic = [NSDictionary dictionaryWithObjectsAndKeys:@"market.btcusdt.kline.1min",@"sub",@"id1",@"id", nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDic options:NSJSONWritingPrettyPrinted error:nil];

    [_socketData webSocketSend:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
}

-(void)dataWith:(WebSocketModel *)dicModel
{
    if (dicModel.ping != nil) {
        NSNumber *kk= [NSNumber numberWithLong:[dicModel.ping longLongValue]];
        NSDictionary * dataDic = [NSDictionary dictionaryWithObjectsAndKeys:kk,@"pong", nil];
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:dataDic options:NSJSONWritingPrettyPrinted error:nil];
        
        [_socketData webSocketSend:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];

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
