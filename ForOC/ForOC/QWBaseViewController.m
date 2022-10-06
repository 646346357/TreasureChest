//
//  QWBaseViewController.m
//  ForOC
//
//  Created by qinwen on 2022/10/5.
//

#import "QWBaseViewController.h"
#import <Masonry/Masonry.h>

@interface QWNoteViewController : UIViewController

@property (nonatomic, copy) NSString *note;
- (instancetype)initWithNote:(NSString *)note;

@end

@interface QWBaseViewController ()

@property (nonatomic, strong) NSMutableString *note;
@property (nonatomic, strong) UITextView *noteView;

@end

@implementation QWBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.note = [NSMutableString string];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"笔记" style:UIBarButtonItemStylePlain target:self action:@selector(openNote)];
    [self.note appendString:@"内容：\n"];

}

- (void)openNote {
    QWNoteViewController *noteVC = [[QWNoteViewController alloc] initWithNote:self.note];
    [self presentViewController:noteVC animated:YES completion:nil];
}

@end


@implementation QWNoteViewController

- (instancetype)initWithNote:(NSString *)note {
    if (self = [super init]) {
        _note = [note copy];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UITextView *noteView = [[UITextView alloc] init];
    noteView.text = self.note;
    noteView.font = [UIFont systemFontOfSize:15];
    noteView.editable = false;
    [self.view addSubview:noteView];
    [noteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

@end
