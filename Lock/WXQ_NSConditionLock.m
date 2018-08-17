//
//  WXQ_NSConditionLock.m
//  Lock
//
//  Created by WXQ on 2018/8/17.
//  Copyright © 2018年 JingBei. All rights reserved.
//

#import "WXQ_NSConditionLock.h"

@implementation WXQ_NSConditionLock
+ (instancetype)loadConditionLockMethod {
    return [[self alloc]initLoadConditionLockMethod];
}

- (instancetype)initLoadConditionLockMethod {
    if (self = [super init]) {
        NSConditionLock *cLock = [[NSConditionLock alloc] initWithCondition:0];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if([cLock tryLockWhenCondition:0]){
                NSLog(@"线程1");
                [cLock unlockWithCondition:1];
            }else{
                NSLog(@"失败");
            }
        });
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [cLock lockWhenCondition:3];
            NSLog(@"线程2");
            [cLock unlockWithCondition:2];
        });
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [cLock lockWhenCondition:1];
            NSLog(@"线程3");
            [cLock unlockWithCondition:3];
        });
    }
    return self;
}

/**
 我们在初始化 NSConditionLock 对象时，给了他的标示为 0;
 执行 tryLockWhenCondition:时，我们传入的条件标示也是 0,所 以线程1 加锁成功;
 执行 unlockWithCondition:时，这时候会把condition由 0 修改为 1;
 因为condition 修改为了  1， 会先走到 线程3，然后 线程3 又将 condition 修改为 3;
 最后 走了 线程2 的流程.
 */
@end
