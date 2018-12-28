//
//  NetWorkDefine.h
//
//  Created by 似云悠 on 16/7/23.
//  Copyright © 2016年 oyf. All rights reserved.
//

#ifndef NetWorkDefine_h
#define NetWorkDefine_h

#import <UIKit/UIKit.h>
#import "SYYHuobiConstant.h"


typedef NS_ENUM(NSUInteger,NetWorkType) {
    GET = 0,
    POST
};


typedef void (^requestSuccess)( id respondObject );
typedef void (^requestFailure)( id error );


//下载
typedef void (^downloadSuccess)( id targetUrl);
typedef void (^downloadProgress)( CGFloat progressValue);


#endif /* NetWorkDefine_h */
