//
//  WXQ_pthread_mutex.m
//  Lock
//
//  Created by WXQ on 2018/8/17.
//  Copyright © 2018年 JingBei. All rights reserved.
//

#import "WXQ_pthread_mutex.h"
#import <pthread.h>

@implementation WXQ_pthread_mutex

+ (instancetype)loadPthreadMethod {
    return [[self alloc]initLoadPthreadMethod];
}

- (instancetype)initLoadPthreadMethod {
    if (self = [super init]) {
        static pthread_mutex_t lock;
        pthread_mutex_init(&lock, NULL);
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"线程一 加锁");
            pthread_mutex_lock(&lock);
            NSLog(@"线程一");
            sleep(3);
            pthread_mutex_unlock(&lock);
            NSLog(@"线程一 解锁");
        });
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"线程二 加锁");
            pthread_mutex_lock(&lock);
            NSLog(@"线程二");
            pthread_mutex_unlock(&lock);
            NSLog(@"线程二 解锁");
        });
    }
    return self;
}

+ (instancetype)loadPthreadRecursiveMethod {
    return [[self alloc]initLoadPthreadRecursiveMethod];
}

- (instancetype)initLoadPthreadRecursiveMethod {
    if (self = [super init]) {
        static pthread_mutex_t pLock;
        pthread_mutexattr_t attr;
        pthread_mutexattr_init(&attr); //初始化attr并且给它赋予默认
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE); //设置锁类型，这边是设置为递归锁
        pthread_mutex_init(&pLock, &attr);
        pthread_mutexattr_destroy(&attr); //销毁一个属性对象，在重新进行初始化之前该结构不能重新使用
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            static void (^RecursiveBlock)(int);
            RecursiveBlock = ^(int value) {
                pthread_mutex_lock(&pLock);
                if (value > 0) {
                    NSLog(@"value: %d", value);
                    RecursiveBlock(value - 1);
                }
                pthread_mutex_unlock(&pLock);
            };
            RecursiveBlock(5);
        });
    }
    return self;
}
/**
 上面的代码如果我们用 pthread_mutex_init(&pLock, NULL) 初始化会出现死锁的情况，递归锁能很好的避免这种情况的死锁；
 */
@end
