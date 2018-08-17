//
//  ViewController.m
//  Lock
//
//  Created by WXQ on 2018/8/17.
//  Copyright © 2018年 JingBei. All rights reserved.
//

#import "ViewController.h"
#import "WXQOSSpinLock.h"
#import "WXQ_dispatch_semaphore.h"
#import "WXQ_pthread_mutex.h"
#import "WXQ_NSLock.h"
#import "WXQ_NSCondition.h"
#import "WXQ_NSRecursiveLock.h"
#import "WXQ_NSConditionLock.h"
#import "WXQ_synchronized.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,copy)NSArray * titleArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"lock";
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const cellID = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.textLabel.text = self.titleArray[indexPath.row];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: [WXQOSSpinLock loadOSSpinLockMethod]; break;
        case 1: [WXQ_dispatch_semaphore loadSemaphoreMethod]; break;
        case 2: [WXQ_pthread_mutex loadPthreadMethod];break;
        case 3: [WXQ_NSLock loadLockMethod]; break;
        case 4: [WXQ_NSCondition loadConditionMethod]; break;
        case 5: [WXQ_pthread_mutex loadPthreadRecursiveMethod]; break;
        case 6: [WXQ_NSRecursiveLock loadRecursiveLockMethod]; break;
        case 7: [WXQ_NSConditionLock loadConditionLockMethod]; break;
        case 8: [WXQ_synchronized loadSynchronizedMethod]; break;
            
        default:
            break;
    }
}

#pragma mark - 初始化数据
- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"OSSpinLock(iOS10以后已经抛弃)",@"dispatch_semaphoreGCD信号量",@"pthread_mutex",@"NSLock",@"NSCondition",@"pthread_mutex(recursive)递归锁",@"NSRecursiveLock递归锁",@"NSConditionLock条件锁",@"@synchronized"];
    }
    return _titleArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
