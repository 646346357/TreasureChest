//
//  QWRuntimeViewController.m
//  ForOC
//
//  Created by qinwen on 2022/10/14.
//

#import "QWRuntimeViewController.h"
#import <objc/runtime.h>

@interface QWPerson : NSObject

@end

@implementation QWPerson

@end


@interface QWStudent : QWPerson

@end

@implementation QWStudent

- (instancetype)initSuperTest {
    if (self = [super init]) {
        NSLog(@"[self class] = %@", [self class]);
        NSLog(@"[super class] = %@", [super class]);
        NSLog(@"[self superclass] = %@", [self superclass]);
        NSLog(@"[super superclass] = %@", [super superclass]);
    }
    
    return self;
}

@end

@interface QWRuntimeViewController ()

@end

@implementation QWRuntimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)superTest {
    [[QWStudent alloc] initSuperTest];
}

- (void)kindsAndMemberTest {
    BOOL res1 = [[NSObject class] isKindOfClass:[NSObject class]];
    BOOL res2 = [[NSObject class] isMemberOfClass:[NSObject class]];
    BOOL res3 = [[QWPerson class] isKindOfClass:[QWPerson class]];
    BOOL res4 = [[QWPerson class] isMemberOfClass:object_getClass(QWPerson.class)];
    NSLog(@"%d %d %d %d", res1, res2, res3, res4);
}

- (void)nonpointerIsaTest {
    NSObject *o1 = [NSObject new];

    NSLog(@"%p", o1);
    NSLog(@"%p", [NSObject class]);
    
//    2022-10-14 12:32:54.172418+0800 ForOC[48762:4975757] 0x280ad80e0
//    2022-10-14 12:32:54.172593+0800 ForOC[48762:4975757] 0x1fa5e6f48
//    (lldb) x/1xg 0x280ad80e0  //查看对象的前8个字节，也就是isa
//    0x280ad80e0: 0x01000001fa5e6f49  //最低位为1说明是nonpointerIsa，中间有33位表示isa指向的类对象的地址
    
//    0x01000001fa5e6f49   isa
//   &0x0000000ffffffff8   mask
//    -------------------
//    0x00000001fa5e6f48   class
    
      
}

- (void)resolveInstanceMethodTest {
    [self performSelector:@selector(resolveInstanceMethodCallCount)];
}


+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == @selector(resolveInstanceMethodCallCount)) {
        static int i = 1;
        NSLog(@"调用第%d次", i);
        //
        if (i > 1) {
            class_addMethod(self, sel, imp_implementationWithBlock(^{
                NSLog(@"响应resolveInstanceMethodCallCount动态添加的方法实现");
            }), "v@:");
            
            return YES;
        }
        i++;
    }
    
    return [super resolveInstanceMethod:sel];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSLog(@"%s", __func__);
    return nil;
}

- (void)writeNote {
    [super writeNote];
    //resolveInstanceMethodTest
    [self.note appendString:@"resolveInstanceMethod:和forwardingTargetForSelector：在调用顺序和调用次数上有什么区别？\nresolveInstanceMethod:会在此方法返回后重走方法查找流程。有两种情况，一是resolveInstanceMethod:方法中动态添加了方法实现，那么方法会被存储在方法列表中，重走方法查找时会命中方法并调用，整个过程结束；二是resolveInstanceMethod:方法中没有动态添加方法实现，那么重走方法查找时会再次来到resolveInstanceMethod:，也就是说该方法会被调用两次,内部维护着该方法是否解析过一次的标志，如果已解析，直接走方法转发的流程。\nforwardingTargetForSelector：是直接调用objc_msgSend()函数，不会重走方法查找流程，只会调用一次。"];
}

@end
