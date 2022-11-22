//
//  QWBlockViewController.m
//  ForOC
//
//  Created by qinwen on 2022/10/13.
//

#import "QWBlockViewController.h"

@interface QWBlockViewController ()

@end

@implementation QWBlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self __blockForWeak];
}

//2022-10-13 23:50:24.810003+0800 ForOC[13904:377242] i = 1
//2022-10-13 23:50:24.810117+0800 ForOC[13904:377242] j = 2
- (void)__blockTest{
    NSInteger i = 1;
    void (^block)(void) = ^{
        NSLog(@"i = %ld", i);
    };
    i = 2;
    block();
    
    __block NSInteger j = 1;
    void (^block2)(void) = ^{
        NSLog(@"j = %ld", j);
    };
    j = 2;
    block2();
}

- (void)__blockForWeak{
    void (^block)(void);
    {
        NSObject *obj = [NSObject new];
        __block __weak NSObject *blockWeakObj = obj;
        block = ^{
            NSLog(@"blockWeakObj = %@", blockWeakObj);
        };
    }
    
    block();
}

- (void)writeNote {
    [super writeNote];
    [self.note appendString:@"1. 只有堆block才会对自动变量产后强引用，栈block不会对自动变量产后强引用\n"];
    //__blockForWeak
    [self.note appendString:@"2. __block修饰的自动变量是否被block强引用跟不带__block的普通自动变量一样\n"];
}

@end
