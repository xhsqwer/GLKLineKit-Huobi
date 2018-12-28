//
//  WebSocketModel.h
//  GLKLineKit
//
//  Created by Hongshuo Xiao on 2018/12/28.
//  Copyright © 2018 walker. All rights reserved.
//

#import "BaseModel.h"
#import "KLineModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WebSocketModel : BaseModel

@property (nonatomic, strong) NSString *ping;
@property (nonatomic, strong) NSString *ch;

@property (nonatomic, assign) KLineModel *tick;

@end

NS_ASSUME_NONNULL_END
