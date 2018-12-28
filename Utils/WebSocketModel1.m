//
//  WebSocketModel1.m
//  GLKLineKit
//
//  Created by Hongshuo Xiao on 2018/12/28.
//  Copyright © 2018 walker. All rights reserved.
//

#import "WebSocketModel1.h"
#import "KLineModel.h"

@implementation WebSocketModel1

+ (Class)tick_class {
    return [KLineModel class];
}

+ (Class)data_class {
    return [KLineModel class];
}
@end
