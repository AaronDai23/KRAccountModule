//
//  LoginTableViewCell.h
//  kreditbro
//
//  Created by 戴培琼 on 2019/3/23.
//  Copyright © 2019 lai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCheckBox.h"
@class CustomTextField;

NS_ASSUME_NONNULL_BEGIN
@interface LoginTableViewCell : UITableViewCell<QCheckBoxDelegate, UITextFieldDelegate>
{
    BOOL _isLoading;
    int curr;
    BOOL _isRemember;
}

@property (nonatomic, strong) UITextField *loginView;
// 只用于 密码 输入框的又控件
@property (nonatomic, strong) UISwitch *rightSwitch;
// 密码框
@property (nonatomic, strong) CustomTextField *passWindow;
// 手机号框
@property (nonatomic, strong) CustomTextField *phoneWindow;

@property (nonatomic,strong) QCheckBox *check;
@property(nonatomic ,weak) UIViewController *deleagate;
@property (nonatomic, copy) void(^loginSuccess)(void);
@property (nonatomic, copy) void(^findBlock)(void);
@end

NS_ASSUME_NONNULL_END
