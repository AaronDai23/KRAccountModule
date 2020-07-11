//
//  RegNextViewController.h
//  kreditbro
//
//  Created by 戴培琼 on 2019/3/24.
//  Copyright © 2019 lai. All rights reserved.
//

#import "BasicViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RegNextViewController : BasicViewController
// 手机号
@property (nonatomic, copy) NSString *phone;
// 用户名
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign)  int inviteCodeStatus;
// 验证码
@property (nonatomic, copy) NSString *verifyCode;
@end

NS_ASSUME_NONNULL_END
