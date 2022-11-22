//
//  QWThreadViewController.m
//  ForOC
//
//  Created by qinwen on 2022/10/18.
//

#import "QWThreadViewController.h"


@interface QWThreadViewController ()

@property (nonatomic, strong) NSThread *thread;

@end

@implementation QWThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self threadTest];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __func__);
    //1. 给已经退出的线程派发任务会导致崩溃 2. runloop会注册一个source0事件监听
    [self performSelector:@selector(_threadTest) onThread:self.thread withObject:nil waitUntilDone:YES];
}

void observeRunLoopActivities(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    switch (activity) {
        case kCFRunLoopEntry:
            NSLog(@"kCFRunLoopEntry");
            break;
        case kCFRunLoopBeforeTimers:
            NSLog(@"kCFRunLoopBeforeTimers");
            break;
        case kCFRunLoopBeforeSources:
            NSLog(@"kCFRunLoopBeforeSources");
            break;
        case kCFRunLoopBeforeWaiting:
            NSLog(@"kCFRunLoopBeforeWaiting");
            break;
        case kCFRunLoopAfterWaiting:
            NSLog(@"kCFRunLoopAfterWaiting");
            break;
        case kCFRunLoopExit:
            NSLog(@"kCFRunLoopExit");
            break;
        default:
            NSLog(@"default");
            break;
    }
}

- (void)threadTest {
    NSThread *thread = [[NSThread alloc] initWithBlock:^{
        [[NSRunLoop currentRunLoop] addPort:[NSPort new] forMode:NSRunLoopCommonModes];
        // 创建observer
        CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, observeRunLoopActivities, NULL);
        // 添加observer到Runloop中
        CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopCommonModes);
        // 释放
        CFRelease(observer);
        while (1) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantFuture]];
        }
    }];

    [thread start];
    self.thread = thread;
}

- (void)_threadTest {
    NSLog(@"_threadTest");
    NSLog(@"%@", [[NSRunLoop currentRunLoop] observationInfo]);
}


- (void)writeNote {
    [super writeNote];
    [self.note appendString:@"使用dispatch_barrier实现多度单写方案时，读（getter方法）应该使用sync的方式，因为getter方法需要同步得到返回结果。这里容易产生一个误解：sync是不会开启线程的，如何保证多读呢？这里需要考虑使用场景，getter方法本身就是在不同线程中调用的，而任务执行队列又是并发队列，所以多个读操作之间依然是并发的"];
}

@end
