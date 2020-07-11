//
//  CountryCodeTableViewCell.h
//  kreditbro
//
//  Created by 戴培琼 on 2019/3/26.
//  Copyright © 2019 lai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CountryCodeModel;
NS_ASSUME_NONNULL_BEGIN

@interface CountryCodeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab1;
@property (weak, nonatomic) IBOutlet UILabel *titleLaeb;
@property (nonatomic, strong) CountryCodeModel *model;

@end

NS_ASSUME_NONNULL_END
