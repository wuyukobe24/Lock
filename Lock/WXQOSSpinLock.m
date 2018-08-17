//
//  WXQOSSpinLock.m
//  Lock
//
//  Created by WXQ on 2018/8/17.
//  Copyright © 2018年 JingBei. All rights reserved.
//

#import "WXQOSSpinLock.h"
#import <libkern/OSAtomic.h>

@implementation WXQOSSpinLock

+ (instancetype)loadOSSpinLockMethod {
    return [[self alloc]initLoadOSSpinLockMtthod];
}

- (instancetype)initLoadOSSpinLockMtthod {
    if (self = [super init]) {
        __block OSSpinLock lock = OS_SPINLOCK_INIT;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"线程一 加锁");
            OSSpinLockLock(&lock);
            sleep(3);
            NSLog(@"线程一");
            OSSpinLockUnlock(&lock);
            NSLog(@"线程一 解锁");
        });
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"线程二 加锁");
            OSSpinLockLock(&lock);
            sleep(3);
            NSLog(@"线程二");
            OSSpinLockUnlock(&lock);
            NSLog(@"线程二 解锁");
        });
    }
    return self;
}

/**
 1.iOS10以后已经抛弃。
 2.当我们锁住线程1时，在同时锁住线程2的情况下，线程2会一直等待（自旋锁不会让等待的进入睡眠状态），直到线程1的任务执行完且解锁完毕，线程2会立即执行。
 */
@end
