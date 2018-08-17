# iOS多种线程锁
### 多种线程锁性能图:
![iOS多种线程锁性能图](https://github.com/wuyukobe24/Lock/blob/master/iOSLock%E6%80%A7%E8%83%BD%E5%9B%BE.png)

 ### OSSpinLock 使用方式(iOS10之后废弃)：
 头文件：`#import <libkern/OSAtomic.h>`
 ```
        __block OSSpinLock lock = OS_SPINLOCK_INIT;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"线程一 加锁");
            OSSpinLockLock(&lock);
            sleep(3);
            NSLog(@"线程一");
            OSSpinLockUnlock(&lock);
            NSLog(@"线程一 解锁");
        });
 ```
  ### dispatch_semaphore GCD信号量使用方式：
 ```
        dispatch_semaphore_t signal = dispatch_semaphore_create(1);
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 3.0f*NSEC_PER_SEC);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"线程一 等待");
            dispatch_semaphore_wait(signal, time);
            NSLog(@"线程一");
            dispatch_semaphore_signal(signal);
            NSLog(@"线程一 结束");
        });
 ```
 * Dispatch Semaphore 提供了三个函数：
 * dispatch_semaphore_create：创建一个Semaphore并初始化信号的总量
 * dispatch_semaphore_signal：发送一个信号，让信号总量加1
 * dispatch_semaphore_wait：可以使总信号量减1，当信号总量为0时就会一直等待（阻塞所在线程），否则就可以正常执行。
 ### pthread_mutex 使用方式：
 头文件：`#import <pthread.h>` 
 ```
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
 ```
 ### pthread_mutex(recursive) 递归锁使用方式：
 头文件：`#import <pthread.h>` 
 ```
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
 ```
 ### NSLock 使用方式：
 ```
        NSLock * lock = [[NSLock alloc]init];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"线程1 加锁");
            [lock lock];
            sleep(3);
            NSLog(@"线程1");
            [lock unlock];
            NSLog(@"线程1 解锁");
        });
 ```
 ### NSCondition 使用方式：
 ```
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
```
* wait：进入等待状态
* waitUntilDate：让一个线程等待一定的时间
* signal：唤醒一个等待的线程
* broadcast：唤醒所有等待的线程
### NSRecursiveLock 递归锁使用方式：
```
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
```
### NSConditionLock 条件锁使用方式：
```
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
```
* 我们在初始化NSConditionLock对象时，给了他的标示为0;
* 执行tryLockWhenCondition:时，我们传入的条件标示也是0,所以线程1加锁成功;
* 执行unlockWithCondition:时，这时候会把condition由0修改为1;
* 因为condition 修改为了1，会先走到线程3，然后线程3又将condition修改为3;
* 最后走了线程2的流程.
### @synchronized 使用方式：
```
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @synchronized (self) {
                sleep(2);
                NSLog(@"线程1");
            }
        });
```
