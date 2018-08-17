//
//  WXQ_dispatch_semaphore.m
//  Lock
//
//  Created by WXQ on 2018/8/17.
//  Copyright © 2018年 JingBei. All rights reserved.
//

#import "WXQ_dispatch_semaphore.h"

@implementation WXQ_dispatch_semaphore

+ (instancetype)loadSemaphoreMethod {
    return [[self alloc]initLoadSemaphoreMethod];
}

- (instancetype)initLoadSemaphoreMethod {
    if (self = [super init]) {
        dispatch_semaphore_t signal = dispatch_semaphore_create(1);
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 3.0f*NSEC_PER_SEC);
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"线程一 等待");
            dispatch_semaphore_wait(signal, time);
            NSLog(@"线程一");
            dispatch_semaphore_signal(signal);
            NSLog(@"线程一 结束");
        });
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"线程二 等待");
            dispatch_semaphore_wait(signal, time);
            NSLog(@"线程二");
            dispatch_semaphore_signal(signal);
            NSLog(@"线程二 结束");
        });
    }
    return self;
}
/**
 Dispatch Semaphore 提供了三个函数：
 dispatch_semaphore_create：创建一个Semaphore并初始化信号的总量
 dispatch_semaphore_signal：发送一个信号，让信号总量加1
 dispatch_semaphore_wait：可以使总信号量减1，当信号总量为0时就会一直等待（阻塞所在线程），否则就可以正常执行。
 
 信号量就是一种可用来控制访问资源的数量的标识，设定了一个信号量，在线程访问之前，加上信号量的处理，则可告知系统按照我们指定的信号量数量来执行多个线程。
 类似锁机制，只不过信号量都是系统帮助我们处理了，我们只需要在执行线程之前，设定一个信号量值，并且在使用时，加上信号量处理方法就行了。
 */
@end
