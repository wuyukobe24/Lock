//
//  WXQ_NSLock.m
//  Lock
//
//  Created by WXQ on 2018/8/17.
//  Copyright © 2018年 JingBei. All rights reserved.
//

#import "WXQ_NSLock.h"

@interface WXQ_NSLock ()

@end

@implementation WXQ_NSLock
+ (instancetype)loadLockMethod {
    return [[self alloc]initLoadLockMethod];
}

- (instancetype)initLoadLockMethod {
    if (self = [super init]) {
        NSLock * lock = [[NSLock alloc]init];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"线程1 加锁");
            [lock lock];
            sleep(3);
            NSLog(@"线程1");
            [lock unlock];
            NSLog(@"线程1 解锁");
        });
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"线程2 加锁");
            [lock lock];
            NSLog(@"线程2");
            [lock unlock];
            NSLog(@"线程2 解锁");
        });
    }
    return self;
}
@end
