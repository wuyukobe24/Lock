//
//  WXQ_NSCondition.m
//  Lock
//
//  Created by WXQ on 2018/8/17.
//  Copyright © 2018年 JingBei. All rights reserved.
//

#import "WXQ_NSCondition.h"

@implementation WXQ_NSCondition
+ (instancetype)loadConditionMethod {
    return [[self alloc]initLoadConditionMethod];
}

- (instancetype)initLoadConditionMethod {
    if (self = [super init]) {
        NSCondition * condi = [[NSCondition alloc]init];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [condi lock];
            NSLog(@"线程1加锁成功");
            [condi wait];
            NSLog(@"线程1");
            [condi unlock];
            NSLog(@"线程1 解锁");
        });
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [condi lock];
            NSLog(@"线程2加锁成功");
            [condi wait];
            NSLog(@"线程2");
            [condi unlock];
            NSLog(@"线程2 解锁");
        });
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            sleep(3);
            NSLog(@"唤醒一个等待的线程");
            [condi signal];
            
//            NSLog(@"唤醒所有等待的线程");
//            [condi broadcast];
        });
    }
    return self;
}

/**
 wait：进入等待状态
 waitUntilDate:：让一个线程等待一定的时间
 signal：唤醒一个等待的线程
 broadcast：唤醒所有等待的线程
 */
@end
