//
//  WXQ_NSRecursiveLock.m
//  Lock
//
//  Created by WXQ on 2018/8/17.
//  Copyright © 2018年 JingBei. All rights reserved.
//

#import "WXQ_NSRecursiveLock.h"

@implementation WXQ_NSRecursiveLock
+ (instancetype)loadRecursiveLockMethod {
    return [[self alloc]initLoadRecursiveLockMethod];
}

- (instancetype)initLoadRecursiveLockMethod {
    if (self = [super init]) {
        NSRecursiveLock * lock = [NSRecursiveLock new];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            static void (^RecursiveBlock)(int);
            RecursiveBlock = ^(int value) {
                [lock lock];
                if (value > 0) {
                    NSLog(@"线程%d", value);
                    RecursiveBlock(value - 1);
                }
                [lock unlock];
            };
            RecursiveBlock(4);
        });
    }
    return self;
}
@end
