//
//  WXQ_pthread_mutex.h
//  Lock
//
//  Created by WXQ on 2018/8/17.
//  Copyright © 2018年 JingBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXQ_pthread_mutex : NSObject
+ (instancetype)loadPthreadMethod;
//递归锁
+ (instancetype)loadPthreadRecursiveMethod;
@end
