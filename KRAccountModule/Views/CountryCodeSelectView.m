//
//  CountryCodeSelectView.m
//  kreditbro
//
//  Created by 戴培琼 on 2019/3/26.
//  Copyright © 2019 lai. All rights reserved.
//

#import "CountryCodeSelectView.h"
#import "CountryCodeTableViewCell.h"
#import "CountryCodeModel.h"
#import "Masonry.h"

#define CELL_ID         @"CountryCodeTableViewCell"
@interface CountryCodeSelectView()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CountryCodeSelectView
- (instancetype)initWithFrame:(CGRect)frame datas:(NSArray *)datas {
    if (self = [super initWithFrame:frame]) {
        self.datas = [NSMutableArray array];
        [self.datas addObjectsFromArray:datas];
        [self initUI];
        [self.tableView reloadData];
    }
    return self;
}

- (void)initUI {
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(self);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CountryCodeTableViewCell *cell  = [_tableView dequeueReusableCellWithIdentifier:CELL_ID];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CountryCodeModel *model = self.datas[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     CountryCodeModel *model = self.datas[indexPath.row];
    if (self.selected) {
        self.selected(model);
    }
    
}

#pragma mark - getter/setter
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundView = nil;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.sectionHeaderHeight = 0.1f;
        _tableView.sectionFooterHeight = 0.1f;
        [_tableView registerNib:[UINib nibWithNibName:CELL_ID bundle:nil] forCellReuseIdentifier:CELL_ID];
    }
    return _tableView;
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
