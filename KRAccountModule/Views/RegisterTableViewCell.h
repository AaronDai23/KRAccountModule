//
//  RegisterTableViewCell.h
//  kreditbro
//
//  Created by 戴培琼 on 2019/3/24.
//  Copyright © 2019 lai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomTextField;

NS_ASSUME_NONNULL_BEGIN

@interface RegisterTableViewCell : UITableViewCell
// 手机号框
@property (nonatomic, strong) CustomTextField *phoneWindow;
@property (nonatomic, strong) CustomTextField *verifyWindow;
@property(nonatomic ,weak) UIViewController *deleagate;
@end

NS_ASSUME_NONNULL_END
