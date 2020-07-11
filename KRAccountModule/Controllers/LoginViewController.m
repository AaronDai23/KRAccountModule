//
//  LoginViewController.m
//  kreditbro
//
//  Created by 戴培琼 on 2019/3/22.
//  Copyright © 2019 lai. All rights reserved.
//

#import "LoginViewController.h"
#import <KRBaseComponents/BasicViewController.h>
#import "LoginTableViewCell.h"
#import <KRCommonComponents/Macros.h>
#import <KRCommonComponents/KRNotificationConstant.h>
#import <KRCommonComponents/ColorTools.h>
#import "Masonry.h"
//#import "TabViewController.h"
//#import "KRFindViewController.h"

#define CELL_ID         @"LoginTableViewCell"
@interface LoginViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
/// 产品数组
@property (nonatomic, strong) NSMutableArray *datas;
@end


@implementation LoginViewController

#pragma mark - left cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBar];
    [self initViews];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registeSuccess) name:MAIN_REGISTER_SUCCESS object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MAIN_REGISTER_SUCCESS object:nil];
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
    self.title = NSLocalizedString(@"tv_login", nil);
    
    self.view.backgroundColor = KbackgroundColor;
    
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:KBlackColor, NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:18.0], NSFontAttributeName, nil]];
    
//    // 导航条返回按钮
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
    return ScreenHeight;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LoginTableViewCell *cell  = [_tableView dequeueReusableCellWithIdentifier:CELL_ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    KRWeakSelf(self);
    cell.loginSuccess = ^{
        KRStrongSelf(self);
        if (self.loginSuccess) {
            self.loginSuccess();
        }
    };
    cell.findBlock = ^{
        KRStrongSelf(self);
        [self findMWD];
    };
    cell.deleagate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)findMWD {
    
}

//- (void)backClick {
//    if (self.backBlock) {
//        self.backBlock();
//    }
//}

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
        [_tableView registerClass:[LoginTableViewCell class] forCellReuseIdentifier:CELL_ID];
    }
    return _tableView;
}


- (void)backClick
{
    if (self.backBlock) {
        self.backBlock();
        return;
    }
//    [AppDelegateInstance toDeckVC];
//    AppDelegateInstance.tabVC.selectedIndex = 0;
}

- (void)registeSuccess {
    if (self.registerSuccess) {
        self.registerSuccess();
    }
}
@end
