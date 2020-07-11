//
//  RegisterViewController.m
//  kreditbro
//
//  Created by 戴培琼 on 2019/3/24.
//  Copyright © 2019 lai. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterTableViewCell.h"
#import <KRCommonComponents/ColorTools.h>
#import <KRCommonComponents/Macros.h>
#import "RegNextViewController.h"

#import "Masonry.h"

#define CELL_ID         @"RegisterTableViewCell"
@interface RegisterViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;


/// 产品数组
@property (nonatomic, strong) NSMutableArray *datas;
@end

@implementation RegisterViewController

#pragma mark - left cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBar];
    [self initViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [UIApplication sharedApplication].statusBarStyle =  UIStatusBarStyleLightContent;
    [self setStatusBarBackgroundColor:[UIColor blackColor]];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

// 设置状态栏背景颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    if (@available(iOS 13.0, *)) {
    
    UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].keyWindow.windowScene.statusBarManager;

    if([statusBarManager respondsToSelector:@selector(createLocalStatusBar)]) {

        UIView *localStatusBarView= [statusBarManager            performSelector:@selector(createLocalStatusBar)];

        UIView *statusBarView = [localStatusBarView performSelector:@selector(statusBar)];


       //根据当前状态栏的类型,重置状态栏颜色(否则截屏出来的都是默认颜色)
        UIColor *statusBarColor = color;

        UIStatusBarStyle statusBarStyle = self.preferredStatusBarStyle;//获取当前视图控制器的状态栏类型

        if(statusBarStyle ==UIStatusBarStyleLightContent) {
            [statusBarView performSelector:@selector(setForegroundColor:)withObject:statusBarColor];

        }
    }else{
        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
        if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
            statusBar.backgroundColor = color;
        }
    }
    }else {
        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
               if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
                   statusBar.backgroundColor = color;
               }
    }
}

#pragma mark - 初始化导航条
- (void)initNavigationBar
{
    self.title = NSLocalizedString(@"tv_register", nil);
    
    self.view.backgroundColor = KbackgroundColor;
    
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:KBlackColor, NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:18.0], NSFontAttributeName, nil]];

    
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = KBlackColor;
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    
}


#pragma mark - initview

- (void)initViews {
    
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(self.view);
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 500;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RegisterTableViewCell *cell  = [_tableView dequeueReusableCellWithIdentifier:CELL_ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    KRWeakSelf(self);
    cell.nextBlock = ^(NSDictionary * _Nonnull dict) {
        KRStrongSelf(self);
        RegNextViewController *vc = [[RegNextViewController alloc] init];
        vc.phone = dict[@"phone"];
        vc.name = dict[@"name"];
        vc.verifyCode = dict[@"verifyCode"];
        vc.inviteCodeStatus = [dict [@"inviteCodeStatus"] intValue];
        [self.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - getter/setter
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundView = nil;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.sectionHeaderHeight = 0.1f;
        _tableView.sectionFooterHeight = 0.1f;
        [_tableView registerClass:[RegisterTableViewCell class] forCellReuseIdentifier:CELL_ID];
    }
    return _tableView;
}


- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES ];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
