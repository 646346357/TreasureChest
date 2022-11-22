//
//  QWUIViewController.m
//  ForOC
//
//  Created by qinwen on 2022/10/22.
//

#import "QWUIViewController.h"
#import <YYKit/YYKit.h>

@interface QWUIViewController ()

@end

@implementation QWUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self labelOffScreenTest];
}

- (void)alphaOffscreenTest {
    UIView *supView = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 200, 200)];
    supView.backgroundColor = [UIColor redColor];
//    supView.layer.opacity = 0.5;
    supView.alpha = 0.5;
    supView.layer.allowsGroupOpacity = NO;
    [self.view addSubview:supView];
    
    UIView *subView = [[UIView alloc] initWithFrame:supView.bounds];
    subView.backgroundColor = [UIColor blueColor];
    [supView addSubview:subView];
    
}

- (void)imageViewBackgroundColorOffScreenTest {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 200, 200, 200)];
    imageView.backgroundColor = [UIColor redColor];
    imageView.image = [UIImage imageWithColor:[UIColor clearColor]];
    imageView.layer.cornerRadius = 15;
    imageView.layer.masksToBounds = YES;
    [self.view addSubview:imageView];
}

- (void)labelOffScreenTest {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 200, 200, 100)];
    label.backgroundColor = [UIColor redColor];
    label.numberOfLines = 0;
    label.text = @"123asdasdasdasdasdassssssssssssss3asdasdasdasdasdassssssssssssss3asdasdasdasdasdassssssssssssss3asdasdasdasdasdassssssssssssssssssssssssssss";
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = 50;
    label.layer.masksToBounds = YES;
    [self.view addSubview:label];
    
    UIView *sub = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    sub.backgroundColor = [UIColor whiteColor];
    [label addSubview:sub];
}

- (void)writeNote {
    
}

@end
