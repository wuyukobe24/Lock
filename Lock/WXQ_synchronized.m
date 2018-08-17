//
//  WXQ_synchronized.m
//  Lock
//
//  Created by WXQ on 2018/8/17.
//  Copyright © 2018年 JingBei. All rights reserved.
//

#import "WXQ_synchronized.h"

@implementation WXQ_synchronized
+ (instancetype)loadSynchronizedMethod {
    return [[self alloc]initLoadSynchronizedMethod];
}

- (instancetype)initLoadSynchronizedMethod {
    if (self = [super init]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @synchronized (self) {
                sleep(2);
                NSLog(@"线程1");
            }
        });
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @synchronized (self) {
                NSLog(@"线程2");
            }
        });
    }
    return self;
}
@end
