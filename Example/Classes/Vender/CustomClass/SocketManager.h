//
//  SocketManager.h
//  WebSocketDemo
//  gitHub https://github.com/angletiantang
//  QQ 871810101
//  Created by guojianheng on 2018/4/2.
//  Copyright © 2018年 guojianheng. All rights reserved.
//

#import <Foundation/Foundation.h>

// socket 状态
typedef NS_ENUM(NSInteger,SocketStatus){
    SocketStatusConnected,      // 已连接
    SocketStatusFailed,         // 连接失败
    SocketStatusClosedByServer, // 系统关闭
    SocketStatusClosedByUser,   // 用户关闭
    SocketStatusReceived        // 接收消息
};
// 消息类型
typedef NS_ENUM(NSInteger,SocketReceiveType){
    SocketReceiveTypeForMessage,
    SocketReceiveTypeForPong
};
// 连接成功回调
typedef void(^SocketDidConnectBlock)(void);
// 失败回调
typedef void(^SocketDidFailBlock)(NSError *error);
// 关闭回调
typedef void(^SocketDidCloseBlock)(NSInteger code,NSString *reason,BOOL wasClean);
// 消息接收回调
typedef void(^SocketDidReceiveBlock)(id message ,SocketReceiveType type);

@interface SocketManager : NSObject
// 连接回调
@property (nonatomic,copy)SocketDidConnectBlock connectBlock;
// 接受消息的回调
@property (nonatomic,copy)SocketDidReceiveBlock receiveBlock;
// 失败回调
@property (nonatomic,copy)SocketDidFailBlock failureBlock;
// 关闭回调
@property (nonatomic,copy)SocketDidCloseBlock closeBlock;
// 当前的socket状态
@property (nonatomic,assign,readonly)SocketStatus socketStatus;
// 超时重连,默认1秒
@property (nonatomic,assign)NSTimeInterval overtime;
// 重连次数,默认10次
@property (nonatomic, assign)NSInteger reconnectCount;

// 单例调用
+ (instancetype)sharedInsatance;
/**
 *  开启socket
 *  @param urlStr       服务器地址
 *  @param connectBlock 连接成功回调
 *  @param receiveBlock 接收消息回调
 *  @param failureBlock 失败回调
 */
- (void)webSocketOpen:(NSString *)urlStr
              connect:(SocketDidConnectBlock)connectBlock
              receive:(SocketDidReceiveBlock)receiveBlock
              failure:(SocketDidFailBlock)failureBlock;
/**
 *  关闭socket
 *  @param closeBlock 关闭回调
 */
- (void)webSocketClose:(SocketDidCloseBlock)closeBlock;
/**
 *  发送消息，NSString 或者 NSData
 *  @param data Send a UTF8 String or Data.
 */
- (void)webSocketSend:(id)data;
@end
