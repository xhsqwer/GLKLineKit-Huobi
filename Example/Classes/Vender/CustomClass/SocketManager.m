//
//  SocketManager.h
//  WebSocketDemo
//  gitHub https://github.com/angletiantang
//  QQ 871810101
//  Created by guojianheng on 2018/4/2.
//  Copyright © 2018年 guojianheng. All rights reserved.
//

#import "SocketManager.h"
#import <SRWebSocket.h>

@interface SocketManager ()<SRWebSocketDelegate>

// webSocket
@property (nonatomic,strong)SRWebSocket *webSocket;
// webSocketStatus
@property (nonatomic,assign)SocketStatus socketStatus;
// 定时器
@property (nonatomic,weak)NSTimer *timer;
// URL路径
@property (nonatomic,copy)NSString *urlString;

@end

@implementation SocketManager
{
    NSInteger _reconnectCounter;
}

+ (instancetype)sharedInsatance{
    static SocketManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance.overtime = 1;
        instance.reconnectCount = 10;
    });
    return instance;
}

- (void)webSocketOpen:(NSString *)urlStr
              connect:(SocketDidConnectBlock)connectBlock
              receive:(SocketDidReceiveBlock)receiveBlock
              failure:(SocketDidFailBlock)failureBlock
{
    [SocketManager sharedInsatance].connectBlock = connectBlock;
    [SocketManager sharedInsatance].receiveBlock = receiveBlock;
    [SocketManager sharedInsatance].failureBlock = failureBlock;
    [self openSocket:urlStr];
}

- (void)webSocketClose:(SocketDidCloseBlock)closeBlock
{
    [SocketManager sharedInsatance].closeBlock = closeBlock;
    [self closeSocket];
}

- (void)webSocketSend:(id)data
{
    switch ([SocketManager sharedInsatance].socketStatus) {
        case SocketStatusConnected:
        case SocketStatusReceived:{
            NSLog(@"发送中。。。");
            [self.webSocket send:data];
            break;
        }
        case SocketStatusFailed:
            NSLog(@"发送失败");
            break;
        case SocketStatusClosedByServer:
            NSLog(@"已经关闭");
            break;
        case SocketStatusClosedByUser:
            NSLog(@"已经关闭");
            break;
    }
}

#pragma mark -- private method
- (void)openSocket:(id)params{
    //    NSLog(@"params = %@",params);
    NSString *urlStr = nil;
    if ([params isKindOfClass:[NSString class]]) {
        urlStr = (NSString *)params;
    }
    else if([params isKindOfClass:[NSTimer class]]){
        NSTimer *timer = (NSTimer *)params;
        urlStr = [timer userInfo];
    }
    [SocketManager sharedInsatance].urlString = urlStr;
    [self.webSocket close];
    self.webSocket.delegate = nil;
    
    self.webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    self.webSocket.delegate = self;
    
    [self.webSocket open];
}

- (void)closeSocket
{
    [self.webSocket close];
    self.webSocket = nil;
    [self.timer invalidate];
    self.timer = nil;
}

- (void)reconnectSocket{
    // 计数+1
    if (_reconnectCounter < self.reconnectCount - 1) {
        _reconnectCounter ++;
        // 开启定时器
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.overtime target:self selector:@selector(openSocket:) userInfo:self.urlString repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        self.timer = timer;
    }
    else{
        NSLog(@"Websocket Reconnected Outnumber ReconnectCount");
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        return;
    }
}

#pragma mark -- SRWebSocketDelegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    NSLog(@"Websocket Connected");
    
    [SocketManager sharedInsatance].connectBlock ? [SocketManager sharedInsatance].connectBlock() : nil;
    [SocketManager sharedInsatance].socketStatus = SocketStatusConnected;
    // 开启成功后重置重连计数器
    _reconnectCounter = 0;
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    NSLog(@":( Websocket Failed With Error %@", error);
    [SocketManager sharedInsatance].socketStatus = SocketStatusFailed;
    [SocketManager sharedInsatance].failureBlock ? [SocketManager sharedInsatance].failureBlock(error) : nil;
    // 重连
    [self reconnectSocket];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    NSLog(@":( Websocket Receive With message %@", message);
    [SocketManager sharedInsatance].socketStatus = SocketStatusReceived;
    [SocketManager sharedInsatance].receiveBlock ? [SocketManager sharedInsatance].receiveBlock(message,SocketReceiveTypeForMessage) : nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    NSLog(@"Closed Reason:%@  code = %ld",reason,(long)code);
    if (reason) {
        [SocketManager sharedInsatance].socketStatus = SocketStatusClosedByServer;
        // 重连
        [self reconnectSocket];
    }
    else{
        [SocketManager sharedInsatance].socketStatus = SocketStatusClosedByUser;
    }
    [SocketManager sharedInsatance].closeBlock ? [SocketManager sharedInsatance].closeBlock(code,reason,wasClean) : nil;
    self.webSocket = nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload{
    [SocketManager sharedInsatance].receiveBlock ? [SocketManager sharedInsatance].receiveBlock(pongPayload,SocketReceiveTypeForPong) : nil;
}

- (void)dealloc{
    // Close WebSocket
    [self closeSocket];
}


@end
