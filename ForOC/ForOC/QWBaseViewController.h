//
//  QWBaseViewController.h
//  ForOC
//
//  Created by qinwen on 2022/10/5.
//

#import <UIKit/UIKit.h>

@interface QWBaseViewController : UIViewController

//实例变量
{
    @private NSString *nameprivate;
    @protected NSString *nameprotected;
    @package NSString *namepackage;
    @public NSString *namepublic;
    NSString *nameDefault;//package
}

@property (nonatomic, assign) NSInteger test;
@property (nonatomic, strong, readonly) NSMutableString *note;

- (void)writeNote;

@end

