//
//  QWSDViewController.m
//  ForOC
//
//  Created by qinwen on 2022/11/15.
//

#import "QWSDViewController.h"
#import <SDWebImage.h>

@interface QWSDViewController ()

@end

@implementation QWSDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self downloadSameImageMeanwhile];
}

- (void)downloadSameImageMeanwhile {
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
    UIImageView *view1 = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:view1];
    
    UIImageView *view2 = [[UIImageView alloc] initWithFrame:CGRectMake(100, 300, 100, 100)];
    [self.view addSubview:view2];
    
    [view1 sd_setImageWithURL:[NSURL URLWithString:@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Flmg.jj20.com%2Fup%2Fallimg%2F1114%2F010421142927%2F210104142927-13-1200.jpg&refer=http%3A%2F%2Flmg.jj20.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1671033967&t=8f62e72a761b4496c4f9b858124b4bb1"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        NSLog(@"111");
    }];
    [view2 sd_setImageWithURL:[NSURL URLWithString:@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Flmg.jj20.com%2Fup%2Fallimg%2F1114%2F010421142927%2F210104142927-13-1200.jpg&refer=http%3A%2F%2Flmg.jj20.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1671033967&t=8f62e72a761b4496c4f9b858124b4bb1"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        NSLog(@"222");
    }];
}

@end
