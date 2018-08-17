//
//  WXQOSSpinLock.h
//  Lock
//
//  Created by WXQ on 2018/8/17.
//  Copyright © 2018年 JingBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXQOSSpinLock : NSObject

+ (instancetype)loadOSSpinLockMethod;

@end
