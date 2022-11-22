//
//  ViewController.m
//  ForOC
//
//  Created by qinwen on 2022/10/5.
//

#import "ViewController.h"
#import "QWBaseViewController.h"
#import "QWBlockViewController.h"
#import "QWRuntimeViewController.h"
#import "QWThreadViewController.h"
#import "QWProxyViewController.h"
#import "QWMemoryViewController.h"
#import "QWUIViewController.h"
#import "QWSDViewController.h"

static NSString* const ClassName = @"ClassName";
static NSString* const ClassDescription = @"ClassDescription";

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataList;

@end


@implementation ViewController


- (NSArray *)dataList {
    if (!_dataList) {
        _dataList = @[
            @{ClassName: QWBlockViewController.class, ClassDescription: @"block"},
            @{ClassName: QWRuntimeViewController.class, ClassDescription: @"runtime"},
            @{ClassName: QWThreadViewController.class, ClassDescription: @"多线程"},
            @{ClassName: QWProxyViewController.class, ClassDescription: @"proxy"},
            @{ClassName: QWMemoryViewController.class, ClassDescription: @"内存管理"},
            @{ClassName: QWUIViewController.class, ClassDescription: @"UI相关"},
            @{ClassName: QWSDViewController.class, ClassDescription: @"SD框架相关"},
        ];
    }

    return _dataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

#pragma mark - UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Class class = self.dataList[indexPath.row][ClassName];
    id instance = [class new];
    [self.navigationController pushViewController:instance animated:true];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"reuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = [UIColor darkTextColor];
    }
    cell.textLabel.text = self.dataList[indexPath.row][ClassDescription];
    
    return  cell;
}


@end
