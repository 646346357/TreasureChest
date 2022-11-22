//
//  QWProxyViewController.m
//  ForOC
//
//  Created by qinwen on 2022/10/18.
//

#import "QWProxyViewController.h"
#import <objc/runtime.h>

@interface QWProxy : NSProxy

@property (nonatomic, weak) id target;
- (instancetype)initWithTarget:(id)target;

- (void)test2;

@end


@implementation QWProxy

- (instancetype)initWithTarget:(id)target {
    _target = target;
    
    return self;
}

- (void)test {
    NSLog(@"%s", __func__);
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSLog(@"%s", __func__);

    return YES;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return _target;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [_target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    [invocation setTarget:_target];
}

@end

@interface QWProxyViewController ()

@end

@implementation QWProxyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self proxyTest];
}

- (void)proxyTest {
    QWProxy *p = [[QWProxy alloc] initWithTarget:self];
    NSLog(@"%d", [p isKindOfClass:[NSProxy class]]);
    
//    [p test2];
}

- (void)test2 {
    NSLog(@"!!!!!!!");
}

- (void)writeNote {
    [super writeNote];
    [self.note appendString:@"关于NSProxy的误解：\n1. 对于NSProxy，接收 unknown selector后，直接回调-methodSignatureForSelector:/-forwardInvocation:，消息转发过程比class NSObject要简单得多。这个结论是有局限性的，具体来说，NSProxy对以下4个方法的实现是内部直接调用-methodSignatureForSelector:/-forwardInvocation:\nrespondsToSelector:\nconformsToProtocol:\nisKindOfClass:\nisMemberOfClass:\n除此之外的方法默认还是走NSObject那套方法转发流程（虽然NSObject Protocol没有定义resolveInstanceMethod:/forwardingTargetForSelector:,但是还是会走）。\n2. 基于第一点：NSProxy比NSObject做转发效率高也不成立，只能说基于NSProxy做转发api更加简洁明了，代码可读性更强。"];
}

@end
