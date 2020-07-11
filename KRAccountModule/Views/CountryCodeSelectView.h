//
//  CountryCodeSelectView.h
//  kreditbro
//
//  Created by 戴培琼 on 2019/3/26.
//  Copyright © 2019 lai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CountryCodeModel;

NS_ASSUME_NONNULL_BEGIN

@interface CountryCodeSelectView : UIView
@property (nonatomic,copy) void(^selected) (CountryCodeModel *selectedItem);
@property (nonatomic, strong) NSMutableArray *datas;
- (instancetype)initWithFrame:(CGRect)frame datas:(NSArray *)datas;
@end

NS_ASSUME_NONNULL_END
