//
//  QWMemoryViewController.m
//  ForOC
//
//  Created by qinwen on 2022/10/21.
//

#import "QWMemoryViewController.h"

@interface QWMemoryViewController ()

@end

@implementation QWMemoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tagedPointerBoundaryTest];
}

void FuncOutputBin(uintptr_t input)
{
    uint8_t temp[65] = {0};
        int i = 0;
        printf("短除法得到的二进制为：");
        while(input)
        {
            temp[i] = input % 2;    //取余数存放到数组中，此为得到的二进制数
            input = (uintptr_t)input / 2;  //短除，while中判断是否除尽
            i++;  //存储了一个二进制数，自加存储下一个
        }
        for(i--; i>=0; i--)  //由于最后一次input为0无效，i还是自加了，因此最后一次自加的值是无用的，所以先自减，然后将余数从后往前读取
        {
            printf("%d",temp[i]);
        }
        printf("\r\n");
}


- (BOOL)isTagedPointer:(id)obj {
    NSLog(@"%p %lx", obj, (uintptr_t)obj);
    uint64_t maskForIos = (1ul << 63);
    NSLog(@"%llx", maskForIos);
    if (((uintptr_t)obj & maskForIos) == maskForIos) {
        NSLog(@"是标签指针");
        FuncOutputBin((uintptr_t)obj);
        return YES;
    } else {
        NSLog(@"不是标签指针");
        return NO;
    }
}

- (void)tagedPointerTest {
    NSString *string = [NSString stringWithFormat:@"%@", @"123"];
    [self isTagedPointer:string];
}

- (void)tagedPointerBoundaryTest {
    NSString *num1 = [NSString stringWithFormat:@"%@", @"}}}}}}}"];//7个}为taggedPointer
    NSString *num2 = [NSString stringWithFormat:@"%@", @"}}}}}}}}"];//8个}不为taggedPointer
    NSString *num3 = [NSString stringWithFormat:@"%@", @"00000000000"];//11个0为taggedPointer
    NSString *num4 = [NSString stringWithFormat:@"%@", @"000000000000"];//12个0不为taggedPointer
    [self isTagedPointer:num1];
    [self isTagedPointer:num2];
    [self isTagedPointer:num3];
    [self isTagedPointer:num4];
}

- (void)writeNote {
    [super writeNote];
    //tagedPointerTest
    [self.note appendString:@"判断一个指针是否是标签指针：\n1、对于iOS平台，最高有效位是1（第64位）\n2、对于macOS平台，最低有效位是1\n"];
    //tagedPointerBoundaryTest
    [self.note appendString:@"对于一个字符串是否为taggerPointer，不能简单的通过字符长度来判断。具体存储规则不明"];
}

@end
